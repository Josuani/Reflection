import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential?> appleSignIn() async {
  try {
    if (kIsWeb) {
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');

      return await FirebaseAuth.instance.signInWithPopup(provider);
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    if (appleCredential.identityToken == null) {
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_IDENTITY_TOKEN',
        message: 'No se pudo obtener el token de identidad de Apple',
      );
    }

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken!,
      rawNonce: rawNonce,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      oauthCredential,
    );

    if (userCredential.user != null) {
      final displayName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((name) => name != null && name.isNotEmpty).join(' ');

      if (displayName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName);
      }
    }

    return userCredential;
  } on SignInWithAppleAuthorizationException catch (e) {
    throw FirebaseAuthException(
      code: 'ERROR_APPLE_SIGN_IN',
      message: e.message,
    );
  } on FirebaseAuthException catch (e) {
    rethrow;
  } catch (e) {
    throw FirebaseAuthException(
      code: 'ERROR_UNKNOWN',
      message: e.toString(),
    );
  }
}
