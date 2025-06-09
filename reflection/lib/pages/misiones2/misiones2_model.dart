import '/components/item_de_mision_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/modales/tarjetaobjetivo/tarjetaobjetivo_widget.dart';
import 'dart:ui';
import 'misiones2_widget.dart' show Misiones2Widget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Misiones2Model extends FlutterFlowModel<Misiones2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for ItemDeMision component.
  late ItemDeMisionModel itemDeMisionModel1;
  // Model for tarjetaobjetivo component.
  late TarjetaobjetivoModel tarjetaobjetivoModel1;
  // Model for ItemDeMision component.
  late ItemDeMisionModel itemDeMisionModel2;
  // Model for tarjetaobjetivo component.
  late TarjetaobjetivoModel tarjetaobjetivoModel2;
  // Model for ItemDeMision component.
  late ItemDeMisionModel itemDeMisionModel3;
  // Model for ItemDeMision component.
  late ItemDeMisionModel itemDeMisionModel4;

  @override
  void initState(BuildContext context) {
    itemDeMisionModel1 = createModel(context, () => ItemDeMisionModel());
    tarjetaobjetivoModel1 = createModel(context, () => TarjetaobjetivoModel());
    itemDeMisionModel2 = createModel(context, () => ItemDeMisionModel());
    tarjetaobjetivoModel2 = createModel(context, () => TarjetaobjetivoModel());
    itemDeMisionModel3 = createModel(context, () => ItemDeMisionModel());
    itemDeMisionModel4 = createModel(context, () => ItemDeMisionModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    itemDeMisionModel1.dispose();
    tarjetaobjetivoModel1.dispose();
    itemDeMisionModel2.dispose();
    tarjetaobjetivoModel2.dispose();
    itemDeMisionModel3.dispose();
    itemDeMisionModel4.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
