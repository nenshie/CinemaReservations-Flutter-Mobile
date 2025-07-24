import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../providers/user_provider.dart';
import '../utils/global_colors.dart';
import '../widgets/global_navbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3;

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _jmbgController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _surnameController = TextEditingController(text: user?.surname ?? '');
    _phoneController = TextEditingController(text: user?.MobileNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _jmbgController = TextEditingController(text: user?.jmbg ?? '');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, 'mainScreen/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, 'trainings/');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, 'reservations/');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, 'profile/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const NavBar(automaticallyImplyLeading: false),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/peakpx 1.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 50,
                bottom: kBottomNavigationBarHeight + 30,
              ),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  if (user == null) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: GlobalColors.darkGrey,
                          ),
                          const CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Opacity(
                        opacity: 0.9,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: GlobalColors.darkGrey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 350,
                          child: Column(
                            children: [
                              _buildProfileField(
                                icon: Icons.person,
                                label: 'Ime',
                                controller: _nameController,
                              ),
                              _buildProfileField(
                                icon: Icons.person_outline,
                                label: 'Prezime',
                                controller: _surnameController,
                              ),
                              _buildProfileField(
                                icon: Icons.email,
                                label: 'Email',
                                controller: _emailController,
                              ),
                              _buildProfileField(
                                icon: Icons.contact_mail,
                                label: 'JMBG',
                                controller: _jmbgController,
                              ),
                              _buildProfileField(
                                icon: Icons.phone,
                                label: 'Broj telefona',
                                controller: _phoneController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
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

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: TextStyle(color: GlobalColors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: GlobalColors.red),
          labelText: label,
          labelStyle: TextStyle(color: GlobalColors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GlobalColors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GlobalColors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GlobalColors.red),
          ),
          filled: true,
          fillColor: Colors.black,
        ),
      ),
    );
  }
}
