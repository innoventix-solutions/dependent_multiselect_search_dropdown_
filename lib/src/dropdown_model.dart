class DropdownItem<T> {
  final String id;
  final String name;
  final T value;

  DropdownItem({
    required this.id,
    required this.name,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem<T> &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
