import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/pages/home_page/home_page_widget.dart';
import '/pages/misiones2/misiones2_widget.dart';
import '/pages/perfil/perfil_widget.dart';

class MainAppShellWidget extends StatefulWidget {
  const MainAppShellWidget({super.key});

  @override
  State<MainAppShellWidget> createState() => _MainAppShellWidgetState();
}

class _MainAppShellWidgetState extends State<MainAppShellWidget> {
  int _selectedIndex = 0;

  // List of pages to display directly
  final List<Widget> _pages = [
    HomePageWidget(),
    Misiones2Widget(),
    PerfilWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Use go_router for navigation
    switch (index) {
      case 0:
        context.go('/app/home');
        break;
      case 1:
        context.go('/app/misiones2');
        break;
      case 2:
        context.go('/app/perfil');
        break;
    }
  }

  // Method to get the current index based on the route
  int _getCurrentIndex(String path) {
    if (path.startsWith('/app/misiones2')) return 1;
    if (path.startsWith('/app/perfil')) return 2;
    return 0; // Default to Home
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index when the route changes externally
    final newIndex = _getCurrentIndex(GoRouterState.of(context).uri.path);
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('MainAppShellWidget build called'); // Debug print
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Placeholder (fixed width container)
          Container(
             width: 200, // Example width for sidebar, adjust as needed
             color: Colors.blue, // Blue color to distinguish
             child: const Center(
               child: Text(
                 'Sidebar Placeholder',
                 style: TextStyle(color: Colors.white),
               ),
             ),
          ),
          // Main Content (expanded to take remaining space)
          Expanded(
            child: SizedBox.expand(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages, // Use the list of direct widget instances
              ),
            ),
          ),
        ],
      ),
    );
  }
} 