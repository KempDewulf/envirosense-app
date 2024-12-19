class RoomType {
  final String id;
  final String name;
  final String icon;
  final List<String>? rooms;

  RoomType({
    required this.id,
    required this.name,
    required this.icon,
    this.rooms,
  });
}
