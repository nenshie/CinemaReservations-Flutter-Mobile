import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dto/FilmDto.dart';
import '../models/dto/RoomDto.dart';
import '../services/FilmService.dart';
import '../services/ProjectionService.dart';
import '../services/room_service.dart';

class AddProjectionScreen extends StatefulWidget {
  const AddProjectionScreen({super.key});

  @override
  State<AddProjectionScreen> createState() => _AddProjectionScreenState();
}

class _AddProjectionScreenState extends State<AddProjectionScreen> {
  List<Film> films = [];
  List<Room> rooms = [];

  Film? selectedFilm;
  Room? selectedRoom;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final fetchedFilms = await FilmService.fetchAllFilms();
    final fetchedRooms = await RoomService.fetchAllRooms();
    setState(() {
      films = fetchedFilms;
      rooms = fetchedRooms;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (selectedFilm == null || selectedRoom == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    setState(() => isLoading = true);

    final projectionDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final success = await ProjectionService.addProjection(
      filmId: selectedFilm!.filmId,
      roomId: selectedRoom!.roomId,
      date: projectionDateTime.toIso8601String(),
    );

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add projection')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Projection'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Film Dropdown
            DropdownButtonFormField<Film>(
              dropdownColor: Colors.grey[900],
              value: selectedFilm,
              hint: const Text("Select Film", style: TextStyle(color: Colors.white)),
              items: films.map((film) {
                return DropdownMenuItem<Film>(
                  value: film,
                  child: Text(film.title, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedFilm = val),
            ),
            const SizedBox(height: 20),

            // Room Dropdown
            DropdownButtonFormField<Room>(
              dropdownColor: Colors.grey[900],
              value: selectedRoom,
              hint: const Text("Select Room", style: TextStyle(color: Colors.white)),
              items: rooms.map((room) {
                return DropdownMenuItem<Room>(
                  value: room,
                  child: Text(room.name, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedRoom = val),
            ),
            const SizedBox(height: 20),

            // Date
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                selectedDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
            ),
            const SizedBox(height: 20),

            // Time
            ElevatedButton(
              onPressed: () => _selectTime(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                selectedTime == null
                    ? 'Select Time'
                    : selectedTime!.format(context),
              ),
            ),
            const Spacer(),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
              ),
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
