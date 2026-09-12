import 'package:documind/views/home/home_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const Center(child: Text("Documents Screen")),
    const Center(child: Text("Add Item Screen")), // Placeholder for center button action
    const Center(child: Text("Folders Screen")),
    const Center(child: Text("Profile Screen")),
  ];

  void _onItemTapped(int index) {
    if (index == 2) return; // Don't switch screen for center button here if it's a modal
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color indigoTheme = Color(0xFF3F51B5);

    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the "+" button
          print("Add button pressed");
        },
        backgroundColor: indigoTheme,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.home, "Home", indigoTheme),
                    _buildNavItem(1, Icons.description_outlined, "Documents", indigoTheme),
                  ],
                ),
              ),
              const SizedBox(width: 40), // Space for FAB
              // Right side items
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(3, Icons.folder_open_outlined, "Folders", indigoTheme),
                    _buildNavItem(4, Icons.person_outline, "Profile", indigoTheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? activeColor : Colors.grey,
            size: 26,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isSelected ? activeColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
