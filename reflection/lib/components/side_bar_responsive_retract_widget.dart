import 'package:flutter/material.dart';
import 'side_bar_responsive_retract_model.dart';
import 'sidebar/sidebar.dart';

export 'side_bar_responsive_retract_model.dart';

class SideBarResponsiveRetractWidget extends StatefulWidget {
  const SideBarResponsiveRetractWidget({super.key});

  @override
  State<SideBarResponsiveRetractWidget> createState() =>
      _SideBarResponsiveRetractWidgetState();
}

class _SideBarResponsiveRetractWidgetState
    extends State<SideBarResponsiveRetractWidget> {
  late SideBarResponsiveRetractModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SideBarResponsiveRetractModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(-1.0, 0.0),
      child: Sidebar(),
    );
  }
}
