import 'package:flutter/material.dart';
import 'sidebar_menu_item.dart';

class SidebarMenu extends StatelessWidget {
  final bool isExpanded;
  final List<SidebarMenuItem> items;

  const SidebarMenu({
    Key? key,
    required this.isExpanded,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: items,
      ),
    );
  }
} 