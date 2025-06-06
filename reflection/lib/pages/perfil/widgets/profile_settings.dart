import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettings extends StatelessWidget {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onDarkModeChanged;
  final VoidCallback onLogout;

  const ProfileSettings({
    Key? key,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.onNotificationsChanged,
    required this.onDarkModeChanged,
    required this.onLogout,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AJUSTES',
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingItem(
                    context,
                    'Notificaciones',
                    'Recibir actualizaciones sobre tu progreso',
                    Icons.notifications,
                    notificationsEnabled,
                    onNotificationsChanged,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: _buildSettingItem(
                      context,
                      'Modo Oscuro',
                      'Cambiar entre tema claro y oscuro',
                      Icons.dark_mode,
                      darkModeEnabled,
                      onDarkModeChanged,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).error,
                          foregroundColor: FlutterFlowTheme.of(context).primaryBackground,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'CERRAR SESIÓN',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      width: double.infinity,
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              color: FlutterFlowTheme.of(context).primary,
              size: 24.0,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    Text(
                      description,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.pressStart2p(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: FlutterFlowTheme.of(context).primary,
              activeTrackColor: FlutterFlowTheme.of(context).primary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
} 