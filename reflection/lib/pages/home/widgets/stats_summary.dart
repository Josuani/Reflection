import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsSummary extends StatelessWidget {
  final int totalPoints;
  final int totalMissions;
  final int completedMissions;
  final int currentStreak;

  const StatsSummary({
    Key? key,
    required this.totalPoints,
    required this.totalMissions,
    required this.completedMissions,
    required this.currentStreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completionRate = totalMissions > 0 ? (completedMissions / totalMissions) : 0.0;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            FlutterFlowTheme.of(context).primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumen de Estadísticas',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.pressStart2p(
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Puntos Totales',
                    totalPoints.toString(),
                    Icons.star,
                    FlutterFlowTheme.of(context).warning,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Misiones',
                    '$completedMissions/$totalMissions',
                    Icons.flag,
                    FlutterFlowTheme.of(context).success,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Racha',
                    '${currentStreak} días',
                    Icons.local_fire_department,
                    FlutterFlowTheme.of(context).error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barra de progreso de completación
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasa de Completación',
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
                    Text(
                      '${(completionRate * 100).round()}%',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.pressStart2p(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: completionRate),
                  duration: Duration(milliseconds: 1000),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: FlutterFlowTheme.of(context).accent1,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                      minHeight: 8,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.pressStart2p(
                    fontWeight: FontWeight.w600,
                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: color,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            label,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 