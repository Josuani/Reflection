import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'barrahome_model.dart';
import 'package:flutter_flow/flutter_flow_theme.dart';
import 'package:flutter_flow/flutter_flow_widgets.dart';

class BarrahomeWidget extends StatefulWidget {
  const BarrahomeWidget({Key? key}) : super(key: key);

  @override
  _BarrahomeWidgetState createState() => _BarrahomeWidgetState();
}

class _BarrahomeWidgetState extends State<BarrahomeWidget> {
  late BarrahomeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BarrahomeModel());
    _model.compactview = false;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _model.compactview ? 80 : 250,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: FlutterFlowTheme.of(context).shadowColor,
            offset: const Offset(2, 0),
          ),
        ],
      ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: Row(
                mainAxisSize: MainAxisSize.max,
              children: [
                if (!_model.compactview)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                        Text(
                          'Reflection',
                          style: FlutterFlowTheme.of(context).headlineMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Tu espacio personal',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    _model.compactview ? Icons.menu_open : Icons.menu,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _model.compactview = !_model.compactview;
                    });
                  },
                            ),
                          ],
                        ),
                      ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  label: 'Inicio',
                  isSelected: true,
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: Icons.flag_outlined,
                  label: 'Misiones',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Perfil',
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  label: 'Configuración',
                  onTap: () {},
                    ),
                ],
              ),
              ),
                    Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent1,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (!_model.compactview)
                  Expanded(
                        child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                            'Usuario',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                                Text(
                            'usuario@email.com',
                            style: FlutterFlowTheme.of(context).bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primaryBackground
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.transparent,
              width: 3,
                  ),
                ),
              ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
              child: Icon(
                icon,
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 24,
              ),
            ),
            if (!_model.compactview)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: isSelected
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                  ],
        ),
      ),
    );
  }
}
