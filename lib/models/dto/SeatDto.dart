class Seat {
  final int seatId;
  final int roomId;
  final int rowNumber;
  final int seatNumber;

  Seat({
    required this.seatId,
    required this.roomId,
    required this.rowNumber,
    required this.seatNumber,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatId: json['seatId'],
      roomId: json['roomId'],
      rowNumber: json['rowNumber'],
      seatNumber: json['seatNumber'],
    );
  }
}

