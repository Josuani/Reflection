import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reflection/main_app_shell/main_app_shell_widget.dart';
import 'package:reflection/pages/home_page/home_page_widget.dart';
import 'package:reflection/pages/misiones2/misiones2_widget.dart';
import 'package:reflection/pages/perfil/perfil_widget.dart';
import 'package:reflection/providers/auth_provider.dart';
import 'package:reflection/pages/auth/login_page.dart';
import 'package:reflection/pages/configuracion/configuracion_widget.dart';
import 'package:reflection/pages/editar_perfil/editar_perfil_widget.dart';
import 'package:reflection/pages/pag_carga/pag_carga_widget.dart';
import 'package:reflection/pages/cerrar_sesion/cerrar_sesion_widget.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login';

      // Si no está logueado y no está en una ruta de autenticación, redirigir al login
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // Si está logueado y está en una ruta de autenticación, redirigir al home
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainAppShellWidget(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePageWidget(),
          ),
          GoRoute(
            path: '/misiones',
            builder: (context, state) => const Misiones2Widget(),
          ),
          GoRoute(
            path: '/perfil',
            builder: (context, state) => const PerfilWidget(),
          ),
          GoRoute(
            path: '/configuracion',
            builder: (context, state) => const ConfiguracionWidget(),
          ),
          GoRoute(
            path: '/editar-perfil',
            builder: (context, state) => const EditarPerfilWidget(),
          ),
          GoRoute(
            path: '/pag-carga',
            builder: (context, state) => const PagCargaWidget(),
          ),
          GoRoute(
            path: '/cerrar-sesion',
            builder: (context, state) => const CerrarsesinonWidget(),
          ),
        ],
      ),
    ],
  );
} 