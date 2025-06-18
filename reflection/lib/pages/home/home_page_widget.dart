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
import '/services/database_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:reflection/pages/profile/profile_page_widget.dart';
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
  late final StreamSubscription<ConnectivityResult> _connSub;

  /// Método que recarga datos de usuario y misiones
  void refreshData() {
    DatabaseService.instance
      .readUsuario(DatabaseService.instance.currentUserId)
      .then((doc) {
        if (mounted) {
          setState(() {
            // Aquí actualizamos el estado con los nuevos datos
            // Por ejemplo:
            // currentUser = Usuario.fromMap(doc.data()!);
          });
        }
    });
    DatabaseService.instance.refreshMissionsCache();
  }

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
      'id': 'new_task',
      'title': 'Nueva tarea',
      'description': 'Crea una nueva misión',
      'icon': Icons.edit_note,
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // Sincronizar cambios pendientes y refrescar caché
    DatabaseService.instance
      .syncPendingChanges()
      .then((_) => DatabaseService.instance.refreshMissionsCache());

    // Listener de conectividad para re-sincronizar al reconectar
    _connSub = Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        DatabaseService.instance
          .syncPendingChanges()
          .then((_) => DatabaseService.instance.refreshMissionsCache());
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _connSub.cancel();
    super.dispose();
  }

  void _handleActionPressed(String actionId) {
    switch (actionId) {
      case 'new_task':
        context.pushNamed('misiones2');
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
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.max,
              children: [
              HomeHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Text(
                  'Reflection es una plataforma para el crecimiento personal y la gestión de hábitos. Aquí podrás registrar tus reflexiones diarias, establecer metas, monitorear tu progreso y desbloquear logros mientras mejoras diferentes áreas de tu vida.',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              QuickActions(
                actions: _quickActions,
                onActionPressed: _handleActionPressed,
              ),
              RecentActivities(activities: _activities),
              // Botón de prueba de Firestore
                      Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // 1) Crear un usuario de prueba en Firestore
                        final docRef = await DatabaseService().createUsuario({
                          'nombre': 'TestUser',
                          'nivel': 1,
                          'puntos': 0,
                          'avatar': 'https://mi.avatar/imagen.png',
                        });
                        // 2) Leerlo de vuelta
                        final docSnapshot = await DatabaseService().readUsuario(docRef.id);
                        // 3) Mostrarlo en consola
                        debugPrint('Usuario leído: ${docSnapshot.data()}');
                      },
                      child: Text('Probar Firestore'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // 1) Crear misión de prueba en Hive
                        final prueba = Mision(
                          id: 'test_hive',
                          titulo: 'Misión Offline',
                          descripcion: 'Descripción de prueba',
                          puntos: 5,
                        );
                        await DatabaseService().cacheMision(prueba);

                        // 2) Leerla de vuelta
                        final cached = DatabaseService().getCachedMision('test_hive');

                        // 3) Mostrar resultado en consola
                        debugPrint('Hive: ${cached?.titulo} – ${cached?.puntos} puntos');
                      },
                      child: Text('Probar Hive'),
                      ),
                    ],
                  ),
                ),
              ),
              // Botón de perfil
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24,
                ),
                onPressed: () async {
                  final updated = await context.pushNamed<bool>('editarPerfil');
                  if (updated == true) {
                    await DatabaseService.instance.readUsuario(DatabaseService.instance.currentUserId);
                    setState(() {});
                  }
                },
              ),
              ],
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