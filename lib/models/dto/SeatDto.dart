class Seat {
  final int seatId;
  final int roomId;
  final int filmId;
  final int rowNumber;
  final int seatNumber;

  Seat({
    required this.seatId,
    required this.roomId,
    required this.filmId,
    required this.rowNumber,
    required this.seatNumber,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatId: json['seatId'],
      roomId: json['roomId'],
      filmId: json['filmId'],
      rowNumber: json['rowNumber'],
      seatNumber: json['seatNumber'],
    );
  }
}

