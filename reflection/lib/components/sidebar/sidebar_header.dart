import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarHeader extends StatelessWidget {
  final bool isExpanded;
  final String logoPath;
  final String smallLogoPath;

  const SidebarHeader({
    Key? key,
    required this.isExpanded,
    required this.logoPath,
    required this.smallLogoPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si no quieres mostrar ningún logo, simplemente retorna SizedBox.shrink()
    return SizedBox.shrink();
  }
} 