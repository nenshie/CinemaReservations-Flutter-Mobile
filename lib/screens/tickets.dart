import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../providers/user_provider.dart';
import '../utils/global_colors.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/projections');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/tickets');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final role = user.role;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.black,
        title: Text(
          role == 'Admin' ? 'Admin Panel' : 'My Tickets',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black54,
            ),
          ),
          // Sadržaj tela
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: role == 'Admin' ? _buildAdminView(context) : _buildClientView(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAdminView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAdminCard(
            title: 'Check the Tickets',
            icon: Icons.qr_code_scanner,
            onTap: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
          const SizedBox(height: 30),
          _buildAdminCard(
            title: 'Films and Projections',
            icon: Icons.movie_filter_outlined,
            onTap: () {
              Navigator.pushNamed(context, '/films');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClientView() {
    return const Center(
      child: Text(
        'Your Tickets',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: GlobalColors.red,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
