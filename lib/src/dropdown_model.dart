/// A class that represents an item in a dropdown with an `id`, `name`, and `value`.
///
/// The `DropdownItem` is used to represent a single option in a dropdown. Each item
/// has a unique `id`, a `name` to display, and a `value` that can be of any type.
class DropdownItem<T> {
  /// The unique identifier for this dropdown item.
  ///
  /// The `id` is used to uniquely identify each dropdown item, and it must be unique
  /// across all items in the dropdown.
  final String id;

  /// The name or label of the dropdown item.
  ///
  /// The `name` is the human-readable label shown to the user in the dropdown menu.
  final String name;

  /// The value associated with the dropdown item.
  ///
  /// The `value` can be of any type (`T`). This allows the dropdown item to store
  /// any data type that can be used as the selected value when the item is chosen.
  final T value;

  /// Creates a new `DropdownItem` with the given `id`, `name`, and `value`.
  ///
  /// - `id`: A unique identifier for the dropdown item.
  /// - `name`: The label to display for the item.
  /// - `value`: The actual value associated with the item.
  DropdownItem({
    required this.id,
    required this.name,
    required this.value,
  });

  /// Compares two `DropdownItem` objects for equality based on their `id`.
  ///
  /// This method overrides the `==` operator to check if two `DropdownItem` objects
  /// are considered equal. Two `DropdownItem` objects are considered equal if their
  /// `id` values are the same.
  ///
  /// - Parameter other: The object to compare this item to.
  /// - Returns: `true` if both items have the same `id`, otherwise `false`.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem<T> &&
          runtimeType == other.runtimeType &&
          id == other.id;

  /// Returns the hash code of the `DropdownItem` based on its `id`.
  ///
  /// This method overrides the `hashCode` getter to ensure that the `DropdownItem`
  /// can be correctly used in collections like `Set` and `Map`. The hash code is
  /// generated based on the `id` of the item.
  ///
  /// - Returns: The hash code of the item.
  @override
  int get hashCode => id.hashCode;
}
