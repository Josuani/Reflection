import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:reflection/backend/services/user_profile_service.dart';
import 'package:reflection/backend/services/user_progress_service.dart';
import 'package:reflection/backend/services/auth_service.dart';
import 'package:reflection/backend/services/sync_service.dart';
import 'package:reflection/backend/services/storage_service.dart';
import 'package:reflection/backend/services/error_monitoring_service.dart';
import 'package:reflection/backend/services/local_progress_service.dart';
import 'package:reflection/backend/config/sentry_config.dart';
import 'package:reflection/theme/app_theme.dart';
import 'package:reflection/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflection/constants/l10n.dart';
import 'package:reflection/providers/auth_provider.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/routes.dart';
import 'firebase_options.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    print('Failed to initialize Firebase: $e\n$stackTrace');
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  try {
    await initializeFirebase();
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(
              AuthService(FirebaseAuth.instance),
              UserProfileService(
                auth: FirebaseAuth.instance,
                firestore: FirebaseFirestore.instance,
                storage: FirebaseStorage.instance,
                progressService: UserProgressService(
                  firestore: FirebaseFirestore.instance,
                  prefs: await SharedPreferences.getInstance(),
                ),
              ),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    print('Error initializing app: $e\n$stackTrace');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reflection',
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      theme: AppTheme.of(context),
      routerConfig: createRouter(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppTheme.getBackground(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'REFLECTION',
                    style: AppTheme.titleStyle,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                    child: const Text('START'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
