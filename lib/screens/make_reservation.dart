import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:cinema_reservations_front/services/SeatService.dart';
import '../utils/global_colors.dart';

class MakeReservation extends StatefulWidget {
  const MakeReservation({super.key});

  @override
  State<MakeReservation> createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  final int _currentIndex = 1;
  final SeatService seatService = SeatService();

  List<Seat> takenSeats = [];
  bool isLoading = true;
  List<int> selectedSeats = [];

  void _onNavBarTap(int index) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/tickets');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }
  }

  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${remainingMinutes}m';
    }
  }

  String formatProjectionDateTime(String rawDate, String rawTime) {
    try {
      final date = DateTime.parse(rawDate);
      final time = DateTime.parse(rawTime);

      final formattedDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      return 'Date:  $formattedDate\nTime: $formattedTime';
    } catch (e) {
      return '$rawDate $rawTime';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projection = ModalRoute.of(context)!.settings.arguments as Projection;
      _loadTakenSeats(projection.room.roomId, projection.film.filmId);
    });
  }

  Future<void> _loadTakenSeats(int roomId, int filmId) async {
    try {
      final seats = await seatService.fetchAllSeatsForRoom(roomId, filmId);
      setState(() {
        takenSeats = seats;
        isLoading = false;
      });
    } catch (e) {
      print('Greška prilikom učitavanja sedišta: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isSeatTaken(int seatNumber) {
    return takenSeats.any((seat) => seat.seatNumber == seatNumber);
  }

  @override
  Widget build(BuildContext context) {
    final projection = ModalRoute.of(context)!.settings.arguments as Projection;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Reservation', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    projection.film.posterUrl,
                    width: 140,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 200,
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projection.film.title,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatDuration(projection.film.duration),
                        style: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatProjectionDateTime(projection.date, projection.time),
                        style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Choose seats", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: List.generate(
                  projection.room.capacity,
                      (index) {
                    final seatNumber = index + 1;
                    final isTaken = isSeatTaken(seatNumber);
                    final isSelected = selectedSeats.contains(seatNumber);

                    return GestureDetector(
                      onTap: () {
                        if (!isTaken) {
                          setState(() {
                            if (isSelected) {
                              selectedSeats.remove(seatNumber);
                            } else {
                              selectedSeats.add(seatNumber);
                            }
                          });
                        }
                      },
                      child: Icon(
                        Icons.chair,
                        color: isTaken
                            ? Colors.grey
                            : isSelected
                            ? GlobalColors.red
                            : Colors.white,
                        size: 33,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: selectedSeats.isEmpty
                  ? null
                  : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Rezervacija poslana (dummy)!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.red,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Rezerviši", style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
