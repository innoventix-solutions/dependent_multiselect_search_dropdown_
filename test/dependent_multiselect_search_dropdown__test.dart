import 'package:dependent_multiselect_search_dropdown/dependent_multiselect_search_dropdown.dart'
    show DropdownController;
import 'package:dependent_multiselect_search_dropdown/src/dropdown_model.dart'
    show DropdownItem;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DropdownController', () {
    test('should set and get options', () {
      final controller = DropdownController();
      final items = [
        DropdownItem(id: '1', name: 'India', value: ""),
        DropdownItem(id: '2', name: 'USA', value: ""),
      ];

      controller.setOptions(items);

      expect(controller.options.length, 2);
      expect(controller.options[0].name, 'India');
    });

    test('should set and clear selected items', () {
      final controller = DropdownController();
      final item = DropdownItem(id: '1', name: 'India', value: "");

      controller.setSelectedItems([item]);
      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems[0].name, 'India');

      controller.clearSelection();
      expect(controller.selectedItems.isEmpty, true);
    });
  });
}
