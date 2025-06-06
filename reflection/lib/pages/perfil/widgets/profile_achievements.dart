import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAchievements extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const ProfileAchievements({
    Key? key,
    required this.achievements,
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
              'LOGROS',
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
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: achievements.map((achievement) {
                  return _buildAchievementItem(context, achievement);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(BuildContext context, Map<String, dynamic> achievement) {
    final bool isUnlocked = achievement['isUnlocked'] ?? false;
    final String title = achievement['title'] ?? '';
    final String description = achievement['description'] ?? '';
    final IconData icon = achievement['icon'] ?? Icons.star;
    final int xpReward = achievement['xpReward'] ?? 0;

    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: isUnlocked
            ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
            : FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isUnlocked
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  color: isUnlocked
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                    child: Text(
                      title,
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.pressStart2p(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                            ),
                            color: isUnlocked
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
              child: Text(
                description,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.pressStart2p(
                        fontWeight: FontWeight.w500,
                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                      color: isUnlocked
                          ? FlutterFlowTheme.of(context).secondaryText
                          : FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            if (isUnlocked)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  '+$xpReward XP',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.pressStart2p(
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        fontSize: 10.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 