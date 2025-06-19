import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarProfile extends StatelessWidget {
  final bool isExpanded;
  final String userName;
  final String userEmail;

  const SidebarProfile({
    Key? key,
    required this.isExpanded,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return IconButton(
        icon: Icon(
          Icons.logout,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 20,
        ),
        onPressed: () {},
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                userEmail,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 14,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.logout,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 20,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
} 