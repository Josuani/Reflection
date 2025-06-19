import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DailyProgress extends StatefulWidget {
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
  State<DailyProgress> createState() => _DailyProgressState();
}

class _DailyProgressState extends State<DailyProgress> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _goalAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.completedTasks / widget.totalTasks,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _goalAnimation = Tween<double>(
      begin: 0.0,
      end: widget.completedTasks / widget.dailyGoal,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FlutterFlowTheme.of(context).secondaryBackground,
            FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Progreso Diario',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.pressStart2p(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                // Racha de días
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).warning.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: FlutterFlowTheme.of(context).warning,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${widget.streakDays} días',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.pressStart2p(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).warning,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Progreso de tareas
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tareas Completadas',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          '${widget.completedTasks}/${widget.totalTasks}',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 10.0,
                      percent: _progressAnimation.value,
                      backgroundColor: FlutterFlowTheme.of(context).accent1,
                      progressColor: FlutterFlowTheme.of(context).primary,
                      barRadius: const Radius.circular(5),
                      animation: false,
                      animateFromLastPercent: false,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Meta diaria
            AnimatedBuilder(
              animation: _goalAnimation,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Meta Diaria',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          '${widget.completedTasks}/${widget.dailyGoal}',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      lineHeight: 10.0,
                      percent: _goalAnimation.value,
                      backgroundColor: FlutterFlowTheme.of(context).accent1,
                      progressColor: FlutterFlowTheme.of(context).success,
                      barRadius: const Radius.circular(5),
                      animation: false,
                      animateFromLastPercent: false,
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Estadísticas adicionales
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Completadas',
                    '${widget.completedTasks}',
                    Icons.check_circle,
                    FlutterFlowTheme.of(context).success,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Pendientes',
                    '${widget.totalTasks - widget.completedTasks}',
                    Icons.pending,
                    FlutterFlowTheme.of(context).warning,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Porcentaje',
                    '${((widget.completedTasks / widget.totalTasks) * 100).round()}%',
                    Icons.percent,
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
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
          ),
        ],
      ),
    );
  }
} 