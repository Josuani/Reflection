import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../providers/user_profile_provider.dart';

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
    return Container(
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
          Consumer<UserProfileProvider>(
            builder: (context, userProfileProvider, _) {
              final user = userProfileProvider.userProfile;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (user != null) ...[
                      PixelAvatar(avatarUrl: user.avatarUrl, size: 64),
                      const SizedBox(height: 8),
                      Text(user.displayName ?? 'Sin nombre', style: theme.titleLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5)),
                      const SizedBox(height: 4),
                      Text('Nivel ${user.level}', style: theme.labelSmall.copyWith(color: theme.secondaryText, fontSize: 13)),
                    ] else ...[
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              );
            },
          ),
          const Divider(color: AppTheme.accentColor),
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