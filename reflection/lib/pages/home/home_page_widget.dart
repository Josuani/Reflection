import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_model.dart';
import 'widgets/home_header.dart';
import 'widgets/daily_progress.dart';
import 'widgets/recent_activities.dart';
import 'widgets/quick_actions.dart';
import 'widgets/stats_summary.dart';
import '/backend/firebase/mission_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/misiones2/misiones2_widget.dart';
import '/services/database_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:reflection/pages/profile/profile_page_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> with TickerProviderStateMixin {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final StreamSubscription<ConnectivityResult> _connSub;
  
  // Controladores de animación
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Datos del usuario
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _errorMessage = '';

  /// Método que recarga datos de usuario y misiones
  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final doc = await DatabaseService().readUsuario(userId);
        if (mounted) {
          setState(() {
            _userData = doc.data() as Map<String, dynamic>?;
            _isLoading = false;
          });
        }
      }
      await DatabaseService().refreshMissionsCache();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar datos: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Datos de actividades mejorados
  List<Map<String, dynamic>> get _activities {
    if (_userData == null) return [];
    
    return [
      {
        'title': 'Reflexión Diaria Completada',
        'description': 'Has completado tu reflexión diaria',
        'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
        'icon': Icons.edit_note,
        'xpReward': 50,
        'time': 'hace 30 min',
      },
      {
        'title': 'Nuevo Logro Desbloqueado',
        'description': 'Guerrero Semanal - Completa 7 reflexiones diarias',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)),
        'icon': Icons.emoji_events,
        'xpReward': 100,
        'time': 'hace 2 h',
      },
      {
        'title': 'Misión Completada',
        'description': 'Has completado la misión "Rutina Matutina"',
        'timestamp': DateTime.now().subtract(Duration(hours: 5)),
        'icon': Icons.flag,
        'xpReward': 75,
        'time': 'hace 5 h',
      },
    ];
  }

  // Acciones rápidas mejoradas
  List<Map<String, dynamic>> get _quickActions {
    return [
      {
        'id': 'new_reflection',
        'title': 'Nueva Reflexión',
        'description': 'Inicia tu reflexión diaria',
        'icon': Icons.edit_note,
        'color': Colors.blue,
      },
      {
        'id': 'view_missions',
        'title': 'Ver Misiones',
        'description': 'Revisa tus misiones activas',
        'icon': Icons.flag,
        'color': Colors.green,
      },
      {
        'id': 'add_mission',
        'title': 'Crear Misión',
        'description': 'Crea una nueva misión personalizada',
        'icon': Icons.add_task,
        'color': Colors.orange,
      },
      {
        'id': 'view_stats',
        'title': 'Ver Estadísticas',
        'description': 'Revisa tu progreso detallado',
        'icon': Icons.bar_chart,
        'color': Colors.purple,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // Inicializar controladores de animación
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Cargar datos iniciales
    _loadInitialData();

    // Sincronizar cambios pendientes y refrescar caché
    DatabaseService()
      .syncPendingChanges()
      .then((_) => DatabaseService().refreshMissionsCache());

    // Listener de conectividad para re-sincronizar al reconectar
    _connSub = Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        DatabaseService()
          .syncPendingChanges()
          .then((_) => DatabaseService().refreshMissionsCache());
      }
    });
  }

  Future<void> _loadInitialData() async {
    await refreshData();
    
    // Iniciar animaciones
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _model.dispose();
    _connSub.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleActionPressed(String actionId) {
    switch (actionId) {
      case 'new_reflection':
        _showReflectionDialog();
        break;
      case 'view_missions':
        context.pushNamed('misiones2');
        break;
      case 'add_mission':
        _showAddMissionDialog(context);
        break;
      case 'view_stats':
        _showStatsDialog();
        break;
    }
  }

  void _showReflectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva Reflexión'),
        content: Text('¿Quieres iniciar tu reflexión diaria?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navegar a la página de reflexión
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Funcionalidad en desarrollo')),
              );
            },
            child: Text('Iniciar'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Estadísticas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nivel: ${_userData?['nivel'] ?? 1}'),
            Text('Puntos: ${_userData?['puntos'] ?? 0}'),
            Text('Misiones completadas: 15'),
            Text('Racha actual: 7 días'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
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
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: _isLoading
              ? _buildLoadingState()
              : _errorMessage.isNotEmpty
                  ? _buildErrorState()
                  : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              FlutterFlowTheme.of(context).primary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando...',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: FlutterFlowTheme.of(context).error,
          ),
          SizedBox(height: 16),
          Text(
            'Error al cargar datos',
            style: FlutterFlowTheme.of(context).titleMedium,
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage,
            style: FlutterFlowTheme.of(context).bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: refreshData,
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Header con datos reales del usuario
                HomeHeader(
                  userName: _userData?['nombre'] ?? 'Usuario',
                  level: _userData?['nivel'] ?? 1,
                ),
                SizedBox(height: 16),
                
                // Resumen de estadísticas
                StatsSummary(
                  totalPoints: _userData?['puntos'] ?? 0,
                  totalMissions: 15,
                  completedMissions: 12,
                  currentStreak: 7,
                ),
                SizedBox(height: 16),
                
                // Progreso diario con datos reales
                DailyProgress(
                  completedTasks: 3,
                  totalTasks: 5,
                  streakDays: 7,
                  dailyGoal: 5,
                ),
                SizedBox(height: 16),
                
                // Actividades recientes
                RecentActivities(activities: _activities),
                SizedBox(height: 16),
                
                // Acciones rápidas
                QuickActions(
                  actions: _quickActions,
                  onActionPressed: _handleActionPressed,
                ),
                SizedBox(height: 16),
                
                // Botón flotante para crear misión
                FloatingActionButton.extended(
                  onPressed: () => _showAddMissionDialog(context),
                  icon: Icon(Icons.add),
                  label: Text('Nueva Misión'),
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                ),
                SizedBox(height: 32),
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