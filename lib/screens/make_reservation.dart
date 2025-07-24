import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:flutter/material.dart';


class MakeReservation extends StatefulWidget {
  const MakeReservation({super.key});

  @override
  State<MakeReservation> createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  final int _currentIndex = 1;
  //late Future<List<MakeReservation>> _makeReservationFuture;

  @override
  void initState() {
    super.initState();

  }

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



  @override
  Widget build(BuildContext context) {
    final projection = ModalRoute.of(context)!.settings.arguments as Projection;

    return Scaffold(
      appBar:
      AppBar(
          title: Text
            ('Reserve for ${projection.film.title}'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text
          ('Reservation details for ${projection.film.title}'),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
