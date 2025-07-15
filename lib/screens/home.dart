import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/components/movie_card.dart';
import 'package:cinema_reservations_front/utils/global_colors.dart';
import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Text(
                "Zdravo, Sandra",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "Najbolje ocenjeni",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Dolazi uskoro",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    MovieCard(
                      title: "Oppenheimer",
                      imagePath: "assets/oppenheimer.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "Angels & Demons",
                      imagePath: "assets/angels.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "The Menu",
                      imagePath: "assets/menu.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "The King's Man",
                      imagePath: "assets/kingsman.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "The King's Man",
                      imagePath: "assets/kingsman.png",
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Repertoar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    MovieCard(
                      title: "Oppenheimer",
                      imagePath: "assets/oppenheimer.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "Angels & Demons",
                      imagePath: "assets/angels.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "The Menu",
                      imagePath: "assets/menu.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "The King's Man",
                      imagePath: "assets/kingsman.png",
                    ),
                    SizedBox(width: 12),
                    MovieCard(
                      title: "The King's Man",
                      imagePath: "assets/kingsman.png",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
