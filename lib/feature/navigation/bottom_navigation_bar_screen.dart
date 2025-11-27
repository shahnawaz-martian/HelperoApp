import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/view/create_order.dart';
import 'package:helpero/feature/bookings/view/my_booking_screen.dart';
import 'package:helpero/feature/category/view/category_screen.dart';
import 'package:helpero/feature/home/view/home_screen.dart';
import 'package:helpero/feature/profile/view/profile_screen.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavigationBarScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    HomeScreen(),
    // CreateOrder(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget _getPage(int index) => _pages[index];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        // shape: const CircularNotchedRectangle(),
        // notchMargin: 8,
        height: 8.h,
        // color: Theme.of(context).colorScheme.surface,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Home'),
              // _buildNavItem(1, Icons.assignment_outlined, 'Book Service'),
              _buildNavItem(1, Icons.event_note_outlined, 'Bookings'),
              _buildNavItem(2, Icons.person_outline_outlined, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: currentIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: currentIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
