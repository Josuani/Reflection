import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/pages/home_page/home_page_widget.dart';
import '/pages/misiones2/misiones2_widget.dart';
import '/pages/perfil/perfil_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/components/sidebar/sidebar.dart';
import '/components/sidebar/sidebar_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/slack_sidebar.dart';

class NavigationDestination {
  final String name;
  final String route;
  final IconData icon;
  final String label;
  final String tooltip;
  final Widget Function()? pageBuilder;

  NavigationDestination({
    required this.name,
    required this.route,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.pageBuilder,
  });
}

final List<NavigationDestination> navigationDestinations = [
  NavigationDestination(
    name: 'homePage',
    route: '/app/home',
    icon: Icons.home_rounded,
    label: 'Inicio',
    tooltip: 'Ir a inicio',
    pageBuilder: () => HomePageWidget(),
  ),
  NavigationDestination(
    name: 'misiones',
    route: '/app/home/misiones',
    icon: Icons.flag_rounded,
    label: 'Misiones',
    tooltip: 'Ver misiones',
    pageBuilder: () => Misiones2Widget(),
  ),
  NavigationDestination(
    name: 'perfil',
    route: '/app/home/perfil',
    icon: Icons.person_rounded,
    label: 'Perfil',
    tooltip: 'Ver perfil',
    pageBuilder: () => PerfilWidget(),
  ),
];

class MainAppShellWidget extends StatefulWidget {
  const MainAppShellWidget({super.key});

  @override
  State<MainAppShellWidget> createState() => _MainAppShellWidgetState();
}

class _MainAppShellWidgetState extends State<MainAppShellWidget> {
  int _getCurrentIndex(String path) {
    for (int i = 0; i < navigationDestinations.length; i++) {
      if (path == navigationDestinations[i].route) {
        return i;
      }
      // Soporta rutas hijas (ej: /app/home/misiones/extra)
      if (path.startsWith(navigationDestinations[i].route + '/')) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(int index) {
    final name = navigationDestinations[index].name;
    context.goNamed(name);
  }

  bool get isDesktopOrWeb {
    return isWeb || (!isAndroid && !isiOS && !isMobileWidth(context));
  }

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;
    int selectedIndex = _getCurrentIndex(currentPath);
    final Widget child = navigationDestinations[selectedIndex].pageBuilder?.call() ?? Container();

    return Scaffold(
      body: Row(
        children: [
          if (isDesktopOrWeb)
            SlackSidebar(
              selectedIndex: selectedIndex,
              destinations: navigationDestinations,
              onItemSelected: _onItemTapped,
            ),
          Expanded(
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: !isDesktopOrWeb
          ? CustomBottomNavigationBar(
              selectedIndex: selectedIndex,
              destinations: navigationDestinations,
              onTap: _onItemTapped,
            )
          : null,
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationDestination> destinations;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.destinations,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              destinations.length,
              (index) => _buildNavItem(context, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final item = destinations[index];
    final isSelected = selectedIndex == index;
    return Tooltip(
      message: item.tooltip,
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: isSelected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText, size: 28),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                      color: isSelected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 