import 'package:flutter/material.dart';

import 'dropdown_controller.dart';
import 'dropdown_model.dart';

/// The `CascadingDropdown` widget allows you to create a dropdown
/// whose options depend on the selection of the previous dropdown.
///
/// Example usage:
/// ```dart
/// CascadingDropdown(
///   controller: _controller,
///   hintText: "Select a country",
/// )
/// ```

class CascadingDropdown<T> extends StatefulWidget {
  /// The controller that manages the state of the dropdown.
  final DropdownController<T> controller;

  /// The hint text to display when no option is selected.
  final String hintText;
  final String searchHint;
  final String validateHint;
  final bool isMultiSelect;
  final bool isEnabled;
  final void Function(List<DropdownItem<T>>)? onItemsChanged;

  /// Creates a new instance of the `CascadingDropdown` widget.
  ///
  /// The `controller` is used to manage the dropdown's state, and
  /// `hintText` is the label shown when no option is selected.
  ///
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

  void _onControllerChange() {
    setState(() {
      _filteredItems = widget.controller.options;
      _selectedItems = widget.controller.selectedItems;

      if (widget.isEnabled) {
        _isSearchMode = false;
      }
    });
  }

  void _toggleSearchMode() {
    if (!widget.isEnabled) return;
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (_isSearchMode) _searchController.clear();
    });
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.controller.options
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

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

  void _removeSelectedItem(DropdownItem<T> item) {
    setState(() {
      _selectedItems.remove(item);
    });
    widget.controller.setSelectedItems(_selectedItems);
    widget.onItemsChanged?.call(_selectedItems);
  }

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
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget implementation...
    final hasSelection = _selectedItems.isNotEmpty;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: widget.isEnabled ? 1 : 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child:
                  Text(_errorText!, style: const TextStyle(color: Colors.red)),
            ),
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
                    child: _filteredItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: AnimatedOpacity(
                                opacity: 1,
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  "No ${widget.hintText.split(' ').last} found",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: _filteredItems.length,
                            itemBuilder: (_, index) {
                              final item = _filteredItems[index];
                              final isSelected = _selectedItems.contains(item);
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
                  )
                : const SizedBox.shrink(key: ValueKey("empty")),
          ),
        ],
      ),
    );
  }
}
