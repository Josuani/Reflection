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
    final String title = widget.mission['title'] ?? '';
    final String description = widget.mission['description'] ?? '';
    final String categoria = widget.mission['categoria'] ?? '';
    final String imgCategoria = widget.mission['imgCategoria'] ?? 'assets/images/pixel_brain.png'; // Imagen por defecto
    final String repeat = widget.mission['repeat'] ?? 'única';
    final String? startDateTimeStr = widget.mission['startDateTime'];
    final String? endDateTimeStr = widget.mission['endDateTime'];
    DateTime? startDateTime = startDateTimeStr != null ? DateTime.tryParse(startDateTimeStr) : null;
    DateTime? endDateTime = endDateTimeStr != null ? DateTime.tryParse(endDateTimeStr) : null;
    String formatDate(DateTime? dt) {
      if (dt == null) return '';
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    final Color mainTextColor = Colors.white;
    final Color detailTextColor = Colors.grey[300]!;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 400;
    final double imageSize = isMobile ? 32 : 48;
    final double titleFontSize = isMobile ? 16 : 22;
    final double descFontSize = isMobile ? 12 : 15;
    final double detailFontSize = isMobile ? 10 : 12;
    final double cardPadding = isMobile ? 10 : 16;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF393939), // Fondo oscuro para la tarjeta
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen grande de la categoría
            Image.asset(
              imgCategoria,
              width: imageSize,
              height: imageSize,
            ),
            SizedBox(width: isMobile ? 10 : 20),
            // Título, descripción y duración
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.pressStart2p(
                      fontWeight: FontWeight.w700,
                      fontSize: titleFontSize,
                      color: mainTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isMobile ? 4 : 10),
                  Text(
                    description,
                    style: GoogleFonts.pressStart2p(
                      fontSize: descFontSize,
                      color: mainTextColor,
                    ),
                    maxLines: isMobile ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (startDateTime != null || endDateTime != null)
                    Padding(
                      padding: EdgeInsets.only(top: isMobile ? 4 : 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (startDateTime != null)
                            Text('Inicio: ${formatDate(startDateTime)}', style: GoogleFonts.pressStart2p(fontSize: detailFontSize, color: detailTextColor)),
                          if (endDateTime != null)
                            Text('Fin: ${formatDate(endDateTime)}', style: GoogleFonts.pressStart2p(fontSize: detailFontSize, color: detailTextColor)),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: isMobile ? 2 : 4),
                    child: Text('Repetición: $repeat', style: GoogleFonts.pressStart2p(fontSize: detailFontSize, color: detailTextColor)),
                  ),
                ],
              ),
            ),
            // Botones de acción a la derecha
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.mission['status'] == 'disponible')
                  ElevatedButton(
                    onPressed: () => widget.onChangeStatus(widget.mission['id'], 'en_progreso'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: isMobile ? 6 : 10),
                      textStyle: GoogleFonts.pressStart2p(fontSize: isMobile ? 10 : 12),
                    ),
                    child: Text('Iniciar'),
                  ),
                if (widget.mission['status'] == 'en_progreso')
                  ElevatedButton(
                    onPressed: () => widget.onChangeStatus(widget.mission['id'], 'completado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getStatusColor(),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16, vertical: isMobile ? 6 : 10),
                      textStyle: GoogleFonts.pressStart2p(fontSize: isMobile ? 10 : 12),
                    ),
                    child: Text('Completar'),
                  ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: isMobile ? 18 : 24),
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
