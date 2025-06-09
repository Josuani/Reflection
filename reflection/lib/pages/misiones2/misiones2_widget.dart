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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Misiones2Model());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    // Suscribirse a los streams de Firebase
    _subscribeToMissions();
  }

  void _subscribeToMissions() {
    // Suscribirse a misiones disponibles
    _missionService.getMissionsByStatus('disponible').listen((missions) {
      setState(() {
        _availableMissions = missions;
      });
    });

    // Suscribirse a misiones en progreso
    _missionService.getMissionsByStatus('en_progreso').listen((missions) {
      setState(() {
        _inProgressMissions = missions;
      });
    });

    // Suscribirse a misiones completadas
    _missionService.getMissionsByStatus('completado').listen((missions) {
      setState(() {
        _completedMissions = missions;
      });
    });
  }

  Future<void> _handleMissionComplete(String missionId) async {
    try {
      await _missionService.updateMissionStatus(missionId, 'completado');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al completar la misión: $e')),
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

  void _mostrarFormularioNuevaMision() {
    final _tituloController = TextEditingController();
    final _descripcionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nueva Misión'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_tituloController.text.trim().isEmpty) return;
                
                final nuevaMision = {
                  'title': _tituloController.text.trim(),
                  'description': _descripcionController.text.trim(),
                  'progress': 0,
                  'total': 1,
                  'isUrgent': false,
                };

                await _missionService.createMission(nuevaMision);
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Misiones', style: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold)),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF91D6D8),
                  border: Border.all(color: Color(0xFF3B5268), width: 3),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF3B5268),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: GoogleFonts.pressStart2p(fontWeight: FontWeight.normal, fontSize: 12),
            tabs: [
              Tab(text: 'Disponibles'),
              Tab(text: 'En Progreso'),
              Tab(text: 'Completadas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña Disponibles
            Stack(
              children: [
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _missionService.getMissionsByStatus('disponible'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.where((mission) =>
                      mission['id'] != null &&
                      mission['title'] != null &&
                      mission['description'] != null &&
                      mission['status'] != null &&
                      mission['id'] is String &&
                      mission['title'] is String &&
                      mission['description'] is String &&
                      mission['status'] is String
                    ).isEmpty) {
                      return Center(
                        child: Text('No hay misiones disponibles'),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: snapshot.data!.where((mission) =>
                        mission['id'] != null &&
                        mission['title'] != null &&
                        mission['description'] != null &&
                        mission['status'] != null &&
                        mission['id'] is String &&
                        mission['title'] is String &&
                        mission['description'] is String &&
                        mission['status'] is String
                      ).length,
                      itemBuilder: (context, index) {
                        final filteredMissions = snapshot.data!.where((mission) =>
                          mission['id'] != null &&
                          mission['title'] != null &&
                          mission['description'] != null &&
                          mission['status'] != null &&
                          mission['id'] is String &&
                          mission['title'] is String &&
                          mission['description'] is String &&
                          mission['status'] is String
                        ).toList();
                        final mission = filteredMissions[index];
                        return ItemDeMisionWidget(
                          mission: mission,
                          onChangeStatus: (String id, String newStatus) async {
                            await _missionService.updateMissionStatus(id, newStatus);
                          },
                          onDelete: (String id) => _handleMissionDelete(id),
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () => _showAddMissionDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Nueva Misión', style: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold, fontSize: 12)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            // Pestaña En Progreso
            Stack(
              children: [
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _missionService.getMissionsByStatus('en_progreso'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.where((mission) =>
                      mission['id'] != null &&
                      mission['title'] != null &&
                      mission['description'] != null &&
                      mission['status'] != null &&
                      mission['id'] is String &&
                      mission['title'] is String &&
                      mission['description'] is String &&
                      mission['status'] is String
                    ).isEmpty) {
                      return Center(
                        child: Text('No hay misiones en progreso'),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: snapshot.data!.where((mission) =>
                        mission['id'] != null &&
                        mission['title'] != null &&
                        mission['description'] != null &&
                        mission['status'] != null &&
                        mission['id'] is String &&
                        mission['title'] is String &&
                        mission['description'] is String &&
                        mission['status'] is String
                      ).length,
                      itemBuilder: (context, index) {
                        final filteredMissions = snapshot.data!.where((mission) =>
                          mission['id'] != null &&
                          mission['title'] != null &&
                          mission['description'] != null &&
                          mission['status'] != null &&
                          mission['id'] is String &&
                          mission['title'] is String &&
                          mission['description'] is String &&
                          mission['status'] is String
                        ).toList();
                        final mission = filteredMissions[index];
                        return ItemDeMisionWidget(
                          mission: mission,
                          onChangeStatus: (String id, String newStatus) async {
                            await _missionService.updateMissionStatus(id, newStatus);
                          },
                          onDelete: (String id) => _handleMissionDelete(id),
                        );
                      },
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    onPressed: () => _showAddMissionDialog(context),
                    icon: Icon(Icons.add),
                    label: Text('Nueva Misión', style: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold, fontSize: 12)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            // Pestaña Completadas
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _missionService.getMissionsByStatus('completado'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.where((mission) =>
                  mission['id'] != null &&
                  mission['title'] != null &&
                  mission['description'] != null &&
                  mission['status'] != null &&
                  mission['id'] is String &&
                  mission['title'] is String &&
                  mission['description'] is String &&
                  mission['status'] is String
                ).isEmpty) {
                  return Center(
                    child: Text('No hay misiones completadas'),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.where((mission) =>
                    mission['id'] != null &&
                    mission['title'] != null &&
                    mission['description'] != null &&
                    mission['status'] != null &&
                    mission['id'] is String &&
                    mission['title'] is String &&
                    mission['description'] is String &&
                    mission['status'] is String
                  ).length,
                  itemBuilder: (context, index) {
                    final filteredMissions = snapshot.data!.where((mission) =>
                      mission['id'] != null &&
                      mission['title'] != null &&
                      mission['description'] != null &&
                      mission['status'] != null &&
                      mission['id'] is String &&
                      mission['title'] is String &&
                      mission['description'] is String &&
                      mission['status'] is String
                    ).toList();
                    final mission = filteredMissions[index];
                    return ItemDeMisionWidget(
                      mission: mission,
                      onChangeStatus: (String id, String newStatus) async {
                        await _missionService.updateMissionStatus(id, newStatus);
                      },
                      onDelete: (String id) => _handleMissionDelete(id),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
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
                                  style: GoogleFonts.pressStart2p(fontSize: 12, fontWeight: FontWeight.bold),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nueva Misión', style: GoogleFonts.pressStart2p(fontWeight: FontWeight.bold, fontSize: 14)),
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
                      style: GoogleFonts.pressStart2p(fontSize: 12, fontWeight: FontWeight.bold),
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
                  final tabIndex = _model.tabBarController?.index ?? 0;
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
    );
  }
}
