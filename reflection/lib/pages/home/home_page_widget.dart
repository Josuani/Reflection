import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_model.dart';
import 'widgets/home_header.dart';
import 'widgets/daily_progress.dart';
import 'widgets/recent_activities.dart';
import 'widgets/quick_actions.dart';
import '/backend/firebase/mission_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/misiones2/misiones2_widget.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for activities
  final List<Map<String, dynamic>> _activities = [
    {
      'title': 'Completed Daily Reflection',
      'description': 'You completed your daily reflection',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
      'icon': Icons.edit_note,
      'xpReward': 50,
    },
    {
      'title': 'New Achievement Unlocked',
      'description': 'Week Warrior - Complete 7 daily reflections',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'icon': Icons.emoji_events,
      'xpReward': 100,
    },
    {
      'title': 'Mission Completed',
      'description': 'You completed the "Morning Routine" mission',
      'timestamp': DateTime.now().subtract(Duration(hours: 5)),
      'icon': Icons.flag,
      'xpReward': 75,
    },
  ];

  // Mock data for quick actions
  final List<Map<String, dynamic>> _quickActions = [
    {
      'id': 'new_reflection',
      'title': 'New Reflection',
      'description': 'Start your daily reflection',
      'icon': Icons.edit_note,
    },
    {
      'id': 'view_missions',
      'title': 'View Missions',
      'description': 'Check your active missions',
      'icon': Icons.flag,
    },
    {
      'id': 'set_goal',
      'title': 'Set Goal',
      'description': 'Create a new goal',
      'icon': Icons.track_changes,
    },
    {
      'id': 'view_stats',
      'title': 'View Stats',
      'description': 'Check your progress',
      'icon': Icons.bar_chart,
    },
  ];

  @override
  void initState() {
    super.initState();
    print('Entrando a initState de HomePageWidget');
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleActionPressed(String actionId) {
    switch (actionId) {
      case 'new_reflection':
        print('New reflection pressed');
        break;
      case 'view_missions':
        context.pushNamed('misiones2');
        break;
      case 'set_goal':
        print('Set goal pressed');
        break;
      case 'view_stats':
        print('View stats pressed');
        break;
      case 'new_task':
        // Restaurar: Navegar a la página de misiones y abrir el formulario ahí (o dejar sin acción temporalmente)
        break;
    }
  }

  void _showAddMissionDialog(BuildContext context) {
    final categoriasMision = [
      {
        'nombre': 'Fuerza física',
        'img': 'assets/images/pixel_dumbbell.png',
      },
      {
        'nombre': 'Mente activa',
        'img': 'assets/images/pixel_brain.png',
      },
      {
        'nombre': 'Salud y nutrición',
        'img': 'assets/images/pixel_salad.png',
      },
      {
        'nombre': 'Economía y finanzas',
        'img': 'assets/images/pixel_coin.png',
      },
      {
        'nombre': 'Hábitos de higiene',
        'img': 'assets/images/pixel_soap.png',
      },
    ];
    int? selectedIndex;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Selecciona una categoría'),
            content: SizedBox(
              width: 350,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < categoriasMision.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => selectedIndex = i),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedIndex == i ? Color(0xFF91D6D8) : Colors.transparent,
                            border: Border.all(color: Color(0xFF3B5268), width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                categoriasMision[i]['img'],
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  categoriasMision[i]['nombre'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (selectedIndex == i)
                                Icon(Icons.check, color: Color(0xFF3B5268)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        Navigator.pop(context);
                        _showMissionDetailsDialog(context, categoriasMision[selectedIndex!]);
                      },
                child: Text('Siguiente'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMissionDetailsDialog(BuildContext context, Map<String, dynamic> categoria) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? startDateTime;
    DateTime? endDateTime;
    String repeat = 'única';
    final repeatOptions = ['única', 'diaria', 'semanal', 'quincenal', 'mensual'];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Nueva Misión'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(categoria['img'], width: 32, height: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        categoria['nombre'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Text('Inicio:')),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              startDateTime = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(
                        startDateTime != null
                          ? '${startDateTime!.day}/${startDateTime!.month}/${startDateTime!.year} ${startDateTime!.hour.toString().padLeft(2, '0')}:${startDateTime!.minute.toString().padLeft(2, '0')}'
                          : 'Seleccionar',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Fin:')),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDateTime ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startDateTime ?? DateTime.now()),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              endDateTime = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(
                        endDateTime != null
                          ? '${endDateTime!.day}/${endDateTime!.month}/${endDateTime!.year} ${endDateTime!.hour.toString().padLeft(2, '0')}:${endDateTime!.minute.toString().padLeft(2, '0')}'
                          : 'Seleccionar',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Repetir:')),
                    DropdownButton<String>(
                      value: repeat,
                      items: repeatOptions.map((opt) => DropdownMenuItem(
                        value: opt,
                        child: Text(opt),
                      )).toList(),
                      onChanged: (val) => setState(() => repeat = val ?? 'única'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  try {
                    await MissionService().createMission({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'status': 'disponible',
                      'categoria': categoria['nombre'],
                      'imgCategoria': categoria['img'],
                      'fechaCreacion': DateTime.now().toIso8601String(),
                      'startDateTime': startDateTime?.toIso8601String(),
                      'endDateTime': endDateTime?.toIso8601String(),
                      'repeat': repeat,
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear la misión: $e')),
                    );
                  }
                }
              },
              child: Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Entrando a build de HomePageWidget');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeHeader(
                        userName: 'John Doe',
                        avatarUrl: 'assets/images/me.jpg',
                        level: 7,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: DailyProgress(
                          completedTasks: 5,
                          totalTasks: 8,
                          streakDays: 7,
                          dailyGoal: 6,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: QuickActions(
                          actions: _quickActions,
                          onActionPressed: _handleActionPressed,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: MissionService().getMissionsByStatus('completado'),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: \\${snapshot.error}', style: TextStyle(color: Colors.red)));
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'No hay misiones completadas recientes.',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              );
                            }
                            final completedMissions = snapshot.data!;
                            completedMissions.sort((a, b) {
                              final aDate = parseDate(a['updatedAt'] ?? a['fechaCreacion']);
                              final bDate = parseDate(b['updatedAt'] ?? b['fechaCreacion']);
                              if (aDate == null && bDate == null) return 0;
                              if (aDate == null) return 1;
                              if (bDate == null) return -1;
                              return bDate.compareTo(aDate);
                            });
                            final recent = completedMissions.take(5).map((m) {
                              final dateStr = m['updatedAt'] ?? m['fechaCreacion'];
                              final date = parseDate(dateStr);
                              return {
                                'title': m['title'] ?? 'Misión completada',
                                'description': m['description'] ?? '',
                                'time': date != null ? timeAgoFromDate(date) : 'fecha inválida',
                                'icon': Icons.check_circle,
                              };
                            }).toList();
                            return RecentActivities(activities: recent);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: MissionService().getMissions(),
                          builder: (context, snapshot) {
                            print('Todas las misiones (sin filtro): ${snapshot.data}');
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'No hay misiones en la base de datos.',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              );
                            }
                            final allMissions = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('DEPURACIÓN: Todas las misiones:', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                                ...allMissions.map((m) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text('${m['title']} | status: ${m['status']}', style: TextStyle(color: Colors.white)),
                                )),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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

DateTime? parseDate(dynamic date) {
  if (date == null) return null;
  if (date is DateTime) return date;
  if (date is String) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }
  // Firestore Timestamp
  if (date is Timestamp) {
    return date.toDate();
  }
  return null;
}

String timeAgoFromDate(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inSeconds < 60) return 'hace un momento';
  if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'hace ${diff.inHours} h';
  return 'hace ${diff.inDays} d';
} 