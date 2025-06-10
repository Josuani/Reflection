import 'package:flutter/material.dart';

class SidebarModel extends ChangeNotifier {
  bool _isExpanded = true;
  int _selectedIndex = 0;
  final Map<int, int> _badges = {};

  bool get isExpanded => _isExpanded;
  int get selectedIndex => _selectedIndex;
  
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setBadge(int index, int count) {
    _badges[index] = count;
    notifyListeners();
  }

  int getBadge(int index) => _badges[index] ?? 0;

  void clearBadge(int index) {
    _badges.remove(index);
    notifyListeners();
  }
} 