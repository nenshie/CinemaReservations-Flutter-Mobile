class Room {
  final int roomId;
  final String name;
  final int capacity;

  Room({
    required this.roomId,
    required this.name,
    required this.capacity
  });


  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      name: json['name'] ?? 'Unknown Room name',
      capacity  : json['capacity'] ?? 0,
    );
  }
}