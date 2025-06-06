import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickActions extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  final Function(String) onActionPressed;

  const QuickActions({
    Key? key,
    required this.actions,
    required this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCIONES RÁPIDAS',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      font: GoogleFonts.pressStart2p(
                        fontWeight: FontWeight.bold,
                        fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: actions.map((action) {
                      return _buildActionButton(context, action);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Map<String, dynamic> action) {
    final String title = action['title'] ?? '';
    final String description = action['description'] ?? '';
    final IconData icon = action['icon'] ?? Icons.star;
    final String actionId = action['id'] ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onActionPressed(actionId),
        child: Container(
          width: 160.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primary,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 4.0),
                  child: Text(
                    title,
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.pressStart2p(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.pressStart2p(
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 