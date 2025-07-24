class Room {
  final String name;
  final int capacity;

  Room({
    required this.name,
    required this.capacity
  });


  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'] ?? 'Unknown Room name',
      capacity  : json['capacity'] ?? 0,
    );
  }
}