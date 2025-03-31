import 'package:flutter/foundation.dart';

import 'dropdown_model.dart';

class DropdownController<T> extends ChangeNotifier {
  List<DropdownItem<T>> _options = [];
  List<DropdownItem<T>> _selectedItems = [];

  List<DropdownItem<T>> get options => _options;
  List<DropdownItem<T>> get selectedItems => _selectedItems;

  void setOptions(List<DropdownItem<T>> newOptions) {
    _options = newOptions;
    notifyListeners();
  }

  void setSelectedItems(List<DropdownItem<T>> selected) {
    _selectedItems = selected;
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }
}
