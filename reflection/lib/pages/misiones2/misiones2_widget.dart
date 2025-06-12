import '/components/item_de_mision_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modales/tarjetaobjetivo/tarjetaobjetivo_widget.dart';
import '/backend/firebase/mission_service.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'misiones2_model.dart';
import '../home_page/home_page_widget.dart';
import 'package:go_router/go_router.dart';
export 'misiones2_model.dart';

/// intento a mano de misiones
class Misiones2Widget extends StatefulWidget {
  const Misiones2Widget({super.key});

  static String routeName = 'Misiones2';
  static String routePath = '/misiones2';

  @override
  State<Misiones2Widget> createState() => _Misiones2WidgetState();
}

class _Misiones2WidgetState extends State<Misiones2Widget>
    with TickerProviderStateMixin {
  late Misiones2Model _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _missionService = MissionService();

  // Listas para almacenar las misiones
  List<Map<String, dynamic>> _availableMissions = [];
  List<Map<String, dynamic>> _inProgressMissions = [];
  List<Map<String, dynamic>> _completedMissions = [];

  // Definición de categorías
  final List<Map<String, dynamic>> categoriasMision = [
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Misiones2Model());

    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

    // Suscribirse a los streams de Firebase
    _subscribeToMissions();
  }

  void _subscribeToMissions() {
    // Suscribirse a misiones disponibles
    _missionService.getMissionsByStatus('disponible').listen((missions) {
      setState(() => _availableMissions = missions);
    });

    // Suscribirse a misiones en progreso
    _missionService.getMissionsByStatus('en_progreso').listen((missions) {
      setState(() => _inProgressMissions = missions);
    });

    // Suscribirse a misiones completadas
    _missionService.getMissionsByStatus('completado').listen((missions) {
      setState(() => _completedMissions = missions);
    });
  }

  Future<void> _handleChangeMissionStatus(String missionId, String newStatus) async {
    print('Intentando cambiar el estado de la misión $missionId a $newStatus');
    try {
      await _missionService.updateMissionStatus(missionId, newStatus);
      print('Estado actualizado correctamente en Firestore');
      // Navegar a la página de inicio después de completar
      if (newStatus == 'completado') {
        if (mounted) {
          context.go('/');
        }
      }
    } catch (e) {
      print('Error al cambiar el estado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar el estado: $e')),
      );
    }
  }

  Future<void> _handleMissionDelete(String missionId) async {
    try {
      await _missionService.deleteMission(missionId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la misión: $e')),
      );
    }
  }

  void _showAddMissionDialog(BuildContext context) {
    // Paso 1: Selección de categoría
    showDialog(
      context: context,
      builder: (context) {
        int? selectedIndex;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Selecciona una categoría', style: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold, fontSize: 14)),
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
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                categoriasMision[i]['img'],
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  categoriasMision[i]['nombre'],
                                  style: GoogleFonts.pressStart2p(fontSize: 12, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                child: Text('Cancelar', style: GoogleFonts.pressStart2p(fontSize: 12)),
              ),
              ElevatedButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        Navigator.pop(context);
                        _showMissionDetailsDialog(context, categoriasMision[selectedIndex!]);
                      },
                child: Text('Siguiente', style: GoogleFonts.pressStart2p(fontSize: 12)),
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
          title: Text('Nueva Misión', style: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold, fontSize: 14)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(categoria['img'], width: 32, height: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        categoria['nombre'],
                        style: GoogleFonts.pressStart2p(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: GoogleFonts.pressStart2p(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: GoogleFonts.pressStart2p(fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: GoogleFonts.pressStart2p(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: GoogleFonts.pressStart2p(fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                // Selector de fecha/hora de inicio
                Row(
                  children: [
                    Expanded(child: Text('Inicio:', style: GoogleFonts.pressStart2p(fontSize: 12))),
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
                        style: GoogleFonts.pressStart2p(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Selector de fecha/hora de fin
                Row(
                  children: [
                    Expanded(child: Text('Fin:', style: GoogleFonts.pressStart2p(fontSize: 12))),
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
                        style: GoogleFonts.pressStart2p(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Dropdown de repetición
                Row(
                  children: [
                    Expanded(child: Text('Repetir:', style: GoogleFonts.pressStart2p(fontSize: 12))),
                    DropdownButton<String>(
                      value: repeat,
                      items: repeatOptions.map((opt) => DropdownMenuItem(
                        value: opt,
                        child: Text(opt, style: GoogleFonts.pressStart2p(fontSize: 12)),
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
              onPressed: () {
                Navigator.pop(context);
                _showAddMissionDialog(context);
              },
              child: Text('Atrás', style: GoogleFonts.pressStart2p(fontSize: 12)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: GoogleFonts.pressStart2p(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  try {
                    final tabIndex = _tabController.index;
                    String initialStatus = 'disponible';
                    if (tabIndex == 1) initialStatus = 'en_progreso';
                    if (tabIndex == 2) initialStatus = 'completado';
                    await _missionService.createMission({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'status': initialStatus,
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
              child: Text('Crear', style: GoogleFonts.pressStart2p(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0,
        title: Text(
          'Misiones',
          style: theme.headlineMedium.copyWith(
            color: theme.accent1,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.accent2, width: 2),
          ),
          labelStyle: theme.titleSmall.copyWith(letterSpacing: 1.5),
          unselectedLabelStyle: theme.titleSmall.copyWith(color: theme.secondaryText),
          tabs: const [
            Tab(text: 'Disponibles'),
            Tab(text: 'En progreso'),
            Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            _MissionList(
              missions: _availableMissions,
              emptyText: 'No hay misiones disponibles',
              theme: theme,
              onChangeStatus: _handleChangeMissionStatus,
              onDelete: _handleMissionDelete,
            ),
            _MissionList(
              missions: _inProgressMissions,
              emptyText: 'No tienes misiones en progreso',
              theme: theme,
              onChangeStatus: _handleChangeMissionStatus,
              onDelete: _handleMissionDelete,
            ),
            _MissionList(
              missions: _completedMissions,
              emptyText: 'No has completado misiones',
              theme: theme,
              onChangeStatus: _handleChangeMissionStatus,
              onDelete: _handleMissionDelete,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primary,
        foregroundColor: theme.accent1,
        onPressed: () => _showAddMissionDialog(context),
        child: Icon(Icons.add, size: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.accent2, width: 3),
        ),
      ),
    );
  }
}

class _MissionList extends StatelessWidget {
  final List<Map<String, dynamic>> missions;
  final String emptyText;
  final FlutterFlowTheme theme;
  final Function(String, String) onChangeStatus;
  final Function(String) onDelete;
  const _MissionList({
    required this.missions,
    required this.emptyText,
    required this.theme,
    required this.onChangeStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: theme.bodyLarge.copyWith(color: theme.secondaryText),
        ),
      );
    }
    return ListView.separated(
      itemCount: missions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, i) {
        final m = missions[i];
        return ItemDeMisionWidget(
          mission: m,
          onChangeStatus: onChangeStatus,
          onDelete: onDelete,
        );
      },
    );
  }
}
