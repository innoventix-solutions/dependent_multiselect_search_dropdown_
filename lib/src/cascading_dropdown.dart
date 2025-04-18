import 'package:flutter/material.dart';

import 'dropdown_controller.dart';
import 'dropdown_model.dart';

/// A reusable dropdown widget supporting multi-select, search, custom entry, and cascading logic.
class CascadingDropdown<T> extends StatefulWidget {
  final DropdownController<T> controller;
  final String hintText;
  final String searchHint;
  final String validateHint;
  final bool isMultiSelect;
  final bool isEnabled;
  final void Function(List<DropdownItem<T>>)? onItemsChanged;

  const CascadingDropdown({
    super.key,
    required this.controller,
    required this.hintText,
    required this.searchHint,
    required this.validateHint,
    this.isMultiSelect = false,
    this.isEnabled = true,
    this.onItemsChanged,
  });

  @override
  State<CascadingDropdown<T>> createState() => _CascadingDropdownState<T>();
}

class _CascadingDropdownState<T> extends State<CascadingDropdown<T>>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customInputController = TextEditingController();

  List<DropdownItem<T>> _filteredItems = [];
  List<DropdownItem<T>> _selectedItems = [];

  bool _isSearchMode = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.controller.options;
    _selectedItems = widget.controller.selectedItems;
    widget.controller.addListener(_onControllerChange);
  }

  /// Reacts to changes in the controller (new options or selected items)
  void _onControllerChange() {
    setState(() {
      _filteredItems = widget.controller.options;
      _selectedItems = widget.controller.selectedItems;
      if (widget.isEnabled) {
        _isSearchMode = false;
      }
    });
  }

  /// Toggles the dropdown open/close state
  void _toggleSearchMode() {
    if (!widget.isEnabled) return;
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (_isSearchMode) _searchController.clear();
    });
  }

  /// Filters dropdown options based on search input
  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.controller.options
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

  /// Shows a dialog allowing user to add a custom entry
  void _promptCustomEntry() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add custom ${widget.hintText.split(' ').last}"),
        content: TextField(
          controller: _customInputController,
          decoration: const InputDecoration(hintText: "Enter value"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final input = _customInputController.text.trim();
              if (input.isNotEmpty) {
                final newItem = DropdownItem<T>(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: input,
                  value: input as T,
                );
                setState(() {
                  // Add new item to list and select it
                  widget.controller
                      .setOptions([...widget.controller.options, newItem]);
                  _selectItem(newItem);
                });
                _customInputController.clear();
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  /// Selects or deselects an item from the dropdown
  void _selectItem(DropdownItem<T> item) {
    setState(() {
      if (widget.isMultiSelect) {
        _selectedItems.contains(item)
            ? _selectedItems.remove(item)
            : _selectedItems.add(item);
      } else {
        _selectedItems = [item];
        _isSearchMode = false;
      }
      _errorText = null;
    });

    widget.controller.setSelectedItems(_selectedItems);
    widget.onItemsChanged?.call(_selectedItems);
  }

  /// Removes a selected item
  void _removeSelectedItem(DropdownItem<T> item) {
    setState(() {
      _selectedItems.remove(item);
    });
    widget.controller.setSelectedItems(_selectedItems);
    widget.onItemsChanged?.call(_selectedItems);
  }

  /// Validates if a selection has been made
  String? validate() {
    if (_selectedItems.isEmpty) {
      setState(() => _errorText = widget.validateHint);
      return _errorText;
    }
    setState(() => _errorText = null);
    return null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customInputController.dispose();
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedItems.isNotEmpty;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: widget.isEnabled ? 1 : 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown field container
          GestureDetector(
            onTap: _toggleSearchMode,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: widget.isEnabled ? Colors.white : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _errorText != null ? Colors.red : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isSearchMode)
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: _filterItems,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        border: InputBorder.none,
                      ),
                    )
                  else
                    // Display selected count or hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hasSelection
                                ? "${_selectedItems.length} selected"
                                : widget.hintText,
                            style: TextStyle(
                              color:
                                  widget.isEnabled ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        Icon(
                          _isSearchMode ? Icons.close : Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  // Show selected chips
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: hasSelection
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _selectedItems.map((item) {
                                return Chip(
                                  label: Text(item.name),
                                  onDeleted: () => _removeSelectedItem(item),
                                  backgroundColor: Colors.teal.shade50,
                                  labelStyle:
                                      const TextStyle(color: Colors.teal),
                                );
                              }).toList(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
          // Show validation error if any
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child:
                  Text(_errorText!, style: const TextStyle(color: Colors.red)),
            ),

          // Dropdown list with optional "Add Other"
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isSearchMode
                ? Container(
                    key: const ValueKey("dropdown"),
                    margin: const EdgeInsets.only(top: 6),
                    constraints: const BoxConstraints(maxHeight: 150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Dropdown item list
                        Expanded(
                          child: _filteredItems.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: AnimatedOpacity(
                                      opacity: 1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Text(
                                        "No ${widget.hintText.split(' ').last} found",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  itemCount: _filteredItems.length,
                                  itemBuilder: (_, index) {
                                    final item = _filteredItems[index];
                                    final isSelected =
                                        _selectedItems.contains(item);
                                    return CheckboxListTile(
                                      value: isSelected,
                                      onChanged: (_) => _selectItem(item),
                                      title: Text(item.name),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: Colors.teal,
                                    );
                                  },
                                ),
                        ),
                        // Add custom entry button
                        TextButton.icon(
                          onPressed: _promptCustomEntry,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add Other"),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey("empty")),
          ),
        ],
      ),
    );
  }
}
