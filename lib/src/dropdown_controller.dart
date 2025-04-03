import 'package:flutter/foundation.dart';

import 'dropdown_model.dart';

/// A controller class that manages the state of a dropdown, including the options
/// and the selected items. This class notifies listeners whenever the options or
/// selected items are updated.
class DropdownController<T> extends ChangeNotifier {
  /// A private list holding the available options for the dropdown.
  List<DropdownItem<T>> _options = [];

  /// A private list holding the currently selected items in the dropdown.
  List<DropdownItem<T>> _selectedItems = [];

  /// Returns the list of available options for the dropdown.
  ///
  /// This is a getter that provides access to the `_options` list.
  List<DropdownItem<T>> get options => _options;

  /// Returns the list of currently selected items in the dropdown.
  ///
  /// This is a getter that provides access to the `_selectedItems` list.
  List<DropdownItem<T>> get selectedItems => _selectedItems;

  /// Sets the options for the dropdown and notifies listeners.
  ///
  /// This method updates the `_options` list with a new set of options and calls
  /// `notifyListeners()` to notify any listeners that the options have changed.
  ///
  /// - Parameter newOptions: The new list of options to be displayed in the dropdown.
  void setOptions(List<DropdownItem<T>> newOptions) {
    _options = newOptions;
    notifyListeners();
  }

  /// Sets the selected items for the dropdown and notifies listeners.
  ///
  /// This method updates the `_selectedItems` list with the newly selected items
  /// and calls `notifyListeners()` to notify listeners about the change.
  ///
  /// - Parameter selected: The list of items that are selected in the dropdown.
  void setSelectedItems(List<DropdownItem<T>> selected) {
    _selectedItems = selected;
    notifyListeners();
  }

  /// Clears the selected items in the dropdown and notifies listeners.
  ///
  /// This method clears the `_selectedItems` list and calls `notifyListeners()`
  /// to notify any listeners that the selection has been cleared.
  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }
}
