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
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isExpanded)
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  logoPath,
                  width: 200.0,
                  height: 40.0,
                  fit: BoxFit.cover,
                  alignment: Alignment(0.0, 0.0),
                ),
              ),
            ),
          if (!isExpanded)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                smallLogoPath,
                width: 45.0,
                height: 45.0,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
} 