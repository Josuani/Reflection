import '/components/item_de_mision_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modales/tarjetaobjetivo/tarjetaobjetivo_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'misiones2_model.dart';
export 'misiones2_model.dart';

/// intento a mano de misiones
class Misiones2Widget extends StatefulWidget {
  const Misiones2Widget({super.key});

  static String routeName = 'misiones2';
  static String routePath = '/misiones2';

  @override
  State<Misiones2Widget> createState() => _Misiones2WidgetState();
}

class _Misiones2WidgetState extends State<Misiones2Widget>
    with TickerProviderStateMixin {
  late Misiones2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Misiones2Model());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment(0.0, 0),
                      child: FlutterFlowButtonTabBar(
                        useToggleButtonStyle: false,
                        isScrollable: true,
                        labelStyle:
                            FlutterFlowTheme.of(context).labelSmall.override(
                                  font: GoogleFonts.pressStart2p(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                        unselectedLabelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.pressStart2p(
                                    fontWeight: FontWeight.w100,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w100,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                        labelColor: Color(0xFF91D6D8),
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        backgroundColor: Color(0xFF3B5268),
                        unselectedBackgroundColor:
                            FlutterFlowTheme.of(context).alternate,
                        borderColor: FlutterFlowTheme.of(context).primary,
                        unselectedBorderColor:
                            FlutterFlowTheme.of(context).alternate,
                        borderWidth: 2.0,
                        borderRadius: 8.0,
                        elevation: 0.0,
                        buttonMargin:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        padding:
                            EdgeInsetsDirectional.fromSTEB(1.0, 1.0, 1.0, 1.0),
                        tabs: [
                          Tab(
                            text: 'available',
                            iconMargin: EdgeInsetsDirectional.fromSTEB(
                                8.0, 8.0, 8.0, 8.0),
                          ),
                          Tab(
                            text: 'progress',
                          ),
                          Tab(
                            text: 'completed',
                            iconMargin: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                wrapWithModel(
                                  model: _model.itemDeMisionModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ItemDeMisionWidget(),
                                ),
                                wrapWithModel(
                                  model: _model.tarjetaobjetivoModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TarjetaobjetivoWidget(),
                                ),
                                wrapWithModel(
                                  model: _model.itemDeMisionModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ItemDeMisionWidget(),
                                ),
                                wrapWithModel(
                                  model: _model.tarjetaobjetivoModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: TarjetaobjetivoWidget(),
                                ),
                              ],
                            ),
                          ),
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              wrapWithModel(
                                model: _model.itemDeMisionModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDeMisionWidget(),
                              ),
                            ],
                          ),
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              wrapWithModel(
                                model: _model.itemDeMisionModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: ItemDeMisionWidget(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 99.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x33000000),
                      offset: Offset(
                        0.0,
                        -2.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                  child: Text(
                    'Add Missions',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.pressStart2p(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      shadows: [
                        Shadow(
                          color: FlutterFlowTheme.of(context).secondaryText,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
