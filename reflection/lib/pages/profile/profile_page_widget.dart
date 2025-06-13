import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:reflection/flutter_flow/flutter_flow_theme.dart';
import 'package:reflection/flutter_flow/flutter_flow_util.dart';
import 'profile_page_model.dart';
import 'package:reflection/services/database_service.dart';
import 'package:reflection/pages/home/home_screen.dart';
import 'package:reflection/pages/utils/image_utils.dart';
export 'profile_page_model.dart';

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profile';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  late ProfilePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Controladores para editar
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());
    _nameController = TextEditingController(text: currentUser.nombre);
    _descController = TextEditingController(text: currentUser.descripcion);
  }

  @override
  void dispose() {
    _model.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Devolver true para indicar que hubo cambios
            Navigator.of(context).pop(true);
          },
        ),
        title: Text(
          'Perfil',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 22,
              ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo Nombre
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Campo Descripción
                    TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.edit),
                      ),
                    ),

                    // Avatar
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: buildImage(
                            filePath: currentUser.avatarLocalPath,
                            networkUrl: currentUser.avatarUrl,
                            assetPath: 'assets/images/placeholder.png',
                          ),
                        ),
                      ),
                    ),

                    // Botón de guardar
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final newName = _nameController.text.trim();
                          final newDesc = _descController.text.trim();

                          // 1) Actualizar en Firestore
                          await DatabaseService.instance.updateUsuario(
                            currentUser.id,
                            {
                              'nombre': newName,
                              'descripcion': newDesc,
                            },
                          );

                          // 2) Actualizar modelo local y UI
                          setState(() {
                            currentUser = currentUser.copyWith(
                              nombre: newName,
                              descripcion: newDesc,
                            );
                          });

                          // 3) Volver a Home indicando true
                          Navigator.of(context).pop(true);

                          // 4) Confirmación visual
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Perfil guardado correctamente')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Guardar perfil',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
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
      ),
    );
  }
} 