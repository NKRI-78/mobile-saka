extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str).join(' ');
}