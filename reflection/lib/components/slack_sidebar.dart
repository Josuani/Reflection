import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class SlackSidebar extends StatefulWidget {
  final int selectedIndex;
  final List<dynamic> destinations;
  final ValueChanged<int> onItemSelected;

  const SlackSidebar({
    Key? key,
    required this.selectedIndex,
    required this.destinations,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<SlackSidebar> createState() => _SlackSidebarState();
}

class _SlackSidebarState extends State<SlackSidebar> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = _expanded ? 220.0 : 72.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(
          right: BorderSide(color: theme.accent2, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accent2.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
            child: _expanded
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.bubble_chart_rounded, color: theme.primary, size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Reflection',
                            style: theme.titleLarge.copyWith(
                              color: theme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: theme.primary),
                        tooltip: 'Contraer',
                        onPressed: () => setState(() => _expanded = false),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bubble_chart_rounded, color: theme.primary, size: 32),
                      IconButton(
                        icon: Icon(Icons.chevron_right, color: theme.primary),
                        tooltip: 'Expandir',
                        onPressed: () => setState(() => _expanded = true),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          // Ítems de navegación
          Expanded(
            child: ListView.separated(
              itemCount: widget.destinations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final item = widget.destinations[i];
                final selected = widget.selectedIndex == i;
                return Tooltip(
                  message: item.label,
                  textStyle: theme.bodySmall.copyWith(fontFamily: 'VT323', fontSize: 16, color: theme.primaryText),
                  waitDuration: const Duration(milliseconds: 400),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => widget.onItemSelected(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: _expanded ? 16 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? theme.primary.withOpacity(0.18) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? theme.primary : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: theme.primary.withOpacity(0.18),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(item.icon, color: selected ? theme.primary : theme.secondaryText, size: 28),
                          if (_expanded)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  item.label,
                                  style: theme.titleSmall.copyWith(
                                    color: selected ? theme.primary : theme.secondaryText,
                                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Perfil abajo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
            child: _expanded
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/me.jpg'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: theme.labelLarge.copyWith(color: theme.primary, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'Nivel 7',
                              style: theme.labelSmall.copyWith(color: theme.secondaryText, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: theme.secondaryText, size: 20),
                        tooltip: 'Cerrar sesión',
                        onPressed: () {},
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/me.jpg'),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: Icon(Icons.logout, color: theme.secondaryText, size: 20),
                        tooltip: 'Cerrar sesión',
                        onPressed: () {},
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  const _SidebarItem({required this.icon, required this.label});
} 