import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'item_de_mision_model.dart';
export 'item_de_mision_model.dart';

/// la idea de este componente es reutilizarlo en donde se necesite llamar una
/// mision
class ItemDeMisionWidget extends StatefulWidget {
  final Map<String, dynamic> mission;
  final Function(String, String) onChangeStatus;
  final Function(String) onDelete;

  const ItemDeMisionWidget({
    super.key,
    required this.mission,
    required this.onChangeStatus,
    required this.onDelete,
  });

  @override
  State<ItemDeMisionWidget> createState() => _ItemDeMisionWidgetState();
}

class _ItemDeMisionWidgetState extends State<ItemDeMisionWidget> {
  late ItemDeMisionModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemDeMisionModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String _getStatusText() {
    switch (widget.mission['status']) {
      case 'disponible':
        return 'Disponible';
      case 'en_progreso':
        return 'En Progreso';
      case 'completado':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }

  Color _getStatusColor() {
    switch (widget.mission['status']) {
      case 'disponible':
        return FlutterFlowTheme.of(context).primary;
      case 'en_progreso':
        return Colors.orange;
      case 'completado':
        return Colors.green;
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  String _getActionButtonText() {
    switch (widget.mission['status']) {
      case 'disponible':
        return 'Iniciar';
      case 'en_progreso':
        return 'Completar';
      case 'completado':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mission['title'],
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.pressStart2p(
                                fontWeight: FontWeight.w600,
                              ),
                              fontSize: 16,
                            ),
                      ),
                      SizedBox(height: 4),
                      if (widget.mission['categoria'] != null && widget.mission['imgCategoria'] != null)
                        Row(
                          children: [
                            Image.asset(
                              widget.mission['imgCategoria'],
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.mission['categoria'],
                              style: GoogleFonts.pressStart2p(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.mission['description'],
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.mission['status'] == 'disponible')
                  ElevatedButton(
                    onPressed: () => widget.onChangeStatus(widget.mission['id'], 'en_progreso'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Iniciar'),
                  ),
                if (widget.mission['status'] == 'en_progreso')
                  ElevatedButton(
                    onPressed: () => widget.onChangeStatus(widget.mission['id'], 'completado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Completar'),
                  ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => widget.onDelete(widget.mission['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
