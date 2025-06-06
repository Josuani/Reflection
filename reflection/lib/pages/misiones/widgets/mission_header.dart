import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionHeader extends StatelessWidget {
  const MissionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUEST LOG',
          style: FlutterFlowTheme.of(context).headlineLarge.override(
                font: GoogleFonts.pressStart2p(
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 32.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
              ),
        ),
      ],
    );
  }
} 