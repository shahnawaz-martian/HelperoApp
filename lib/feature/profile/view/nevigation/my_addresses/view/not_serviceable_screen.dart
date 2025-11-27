import 'package:flutter/material.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../main.dart';

class NotServiceableScreen extends StatelessWidget {
  final String area;
  const NotServiceableScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BottomNavigationBarScreen(initialIndex: 0),
          ),
          (_) => false,
        );
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 80, color: Colors.redAccent),
                SizedBox(height: 20),
                Text(
                  "Sorry!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "We are not serviceable yet for your location: $area",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => Navigator.of(Get.context!).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          BottomNavigationBarScreen(initialIndex: 0),
                    ),
                    (route) => false,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Go To Home",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
