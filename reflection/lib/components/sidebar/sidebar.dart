import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'sidebar_model.dart';
import 'sidebar_header.dart';
import 'sidebar_profile.dart';
import 'sidebar_menu.dart';
import 'sidebar_menu_item.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  static const double minSidebarWidth = 56.0; // Suficiente para icono y badge
  static const double maxSidebarWidth = 280.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(
      begin: minSidebarWidth,
      end: maxSidebarWidth,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SidebarModel>(context);
    
    if (model.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Container(
          width: _widthAnimation.value,
          constraints: const BoxConstraints(minWidth: minSidebarWidth),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
            border: Border(
              right: BorderSide(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header with toggle button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SidebarHeader(
                        isExpanded: model.isExpanded,
                        logoPath: 'assets/images/Black_White_Creative_eCommerce_Line_Art_Logo__200_x_40_px_-removebg-preview.png',
                        smallLogoPath: 'assets/images/Black_White_Creative_eCommerce_Line_Art_Logo-removebg-preview.png',
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        model.isExpanded ? Icons.chevron_left : Icons.chevron_right,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      onPressed: () => model.toggleExpanded(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Profile section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: model.isExpanded && _widthAnimation.value > 150
                    ? SidebarProfile(
                        isExpanded: true,
                        userName: 'My Account',
                        userEmail: 'user@example.com',
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
              ),

              const Divider(height: 32),

              // Menu items
              Expanded(
                child: SingleChildScrollView(
                  child: SidebarMenu(
                    isExpanded: model.isExpanded,
                    items: [
                      SidebarMenuItem(
                        isExpanded: model.isExpanded,
                        icon: Icons.home,
                        label: 'Home',
                        isSelected: model.selectedIndex == 0,
                        badge: model.getBadge(0),
                        onTap: () => model.setSelectedIndex(0),
                      ),
                      SidebarMenuItem(
                        isExpanded: model.isExpanded,
                        icon: Icons.assignment,
                        label: 'Missions',
                        isSelected: model.selectedIndex == 1,
                        badge: model.getBadge(1),
                        onTap: () => model.setSelectedIndex(1),
                      ),
                      SidebarMenuItem(
                        isExpanded: model.isExpanded,
                        icon: Icons.person,
                        label: 'Profile',
                        isSelected: model.selectedIndex == 2,
                        badge: model.getBadge(2),
                        onTap: () => model.setSelectedIndex(2),
                      ),
                      SidebarMenuItem(
                        isExpanded: model.isExpanded,
                        icon: Icons.settings,
                        label: 'Settings',
                        isSelected: model.selectedIndex == 3,
                        badge: model.getBadge(3),
                        onTap: () => model.setSelectedIndex(3),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer with logout button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement logout
                    },
                    icon: const Icon(Icons.logout),
                    label: model.isExpanded ? const Text('Logout') : const SizedBox(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 