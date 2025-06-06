import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyProgress extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final int streakDays;
  final int dailyGoal;

  const DailyProgress({
    Key? key,
    required this.completedTasks,
    required this.totalTasks,
    required this.streakDays,
    required this.dailyGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = completedTasks / totalTasks;
    final goalProgress = completedTasks / dailyGoal;

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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROGRESO DIARIO',
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        size: 16.0,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '$streakDays días',
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
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: SizedBox(
                height: 80.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tareas',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '$completedTasks/$totalTasks',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: LinearPercentIndicator(
                        percent: progress,
                        width: MediaQuery.of(context).size.width - 96.0,
                        lineHeight: 12.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).primary,
                        backgroundColor: FlutterFlowTheme.of(context).accent4,
                        barRadius: Radius.circular(6.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: SizedBox(
                height: 80.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Meta Diaria',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '$completedTasks/$dailyGoal',
                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: LinearPercentIndicator(
                        percent: goalProgress,
                        width: MediaQuery.of(context).size.width - 96.0,
                        lineHeight: 12.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).primary,
                        backgroundColor: FlutterFlowTheme.of(context).accent4,
                        barRadius: Radius.circular(6.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 