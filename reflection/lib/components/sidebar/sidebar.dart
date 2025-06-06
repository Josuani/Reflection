import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import 'sidebar_header.dart';
import 'sidebar_profile.dart';
import 'sidebar_menu.dart';
import 'sidebar_menu_item.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Color(0xFF08F9E7),
          width: 2.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SidebarHeader(
            isExpanded: true,
            logoPath: 'assets/images/Black_White_Creative_eCommerce_Line_Art_Logo__200_x_40_px_-removebg-preview.png',
            smallLogoPath: 'assets/images/Black_White_Creative_eCommerce_Line_Art_Logo-removebg-preview.png',
          ),
          SidebarProfile(
            isExpanded: true,
            profileImagePath: 'assets/images/me.jpg',
            userName: 'My Account',
            userEmail: 'user@example.com',
          ),
          SidebarMenu(
            isExpanded: true,
            items: [
              SidebarMenuItem(
                isExpanded: true,
                icon: Icons.home,
                label: 'Home',
                isSelected: widget.selectedIndex == 0,
                onTap: () => widget.onItemSelected(0),
              ),
              SidebarMenuItem(
                isExpanded: true,
                icon: Icons.assignment,
                label: 'Missions',
                isSelected: widget.selectedIndex == 1,
                onTap: () => widget.onItemSelected(1),
              ),
              SidebarMenuItem(
                isExpanded: true,
                icon: Icons.person,
                label: 'Profile',
                isSelected: widget.selectedIndex == 2,
                onTap: () => widget.onItemSelected(2),
              ),
              SidebarMenuItem(
                isExpanded: true,
                icon: Icons.settings,
                label: 'Settings',
                isSelected: widget.selectedIndex == 3,
                onTap: () => widget.onItemSelected(3),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 