import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widget/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> todayNotifications = [
    {
      "title": "30% Special Discount!",
      "subtitle": "Special promotion only valid today",
      "icon": "discount",
    },
    {
      "title": "Password Update Successful",
      "subtitle": "Your password update successfully",
      "icon": "lock",
    },
    {
      "title": "30% Special Discount!",
      "subtitle": "Special promotion only valid today",
      "icon": "discount",
    },
    {
      "title": "Password Update Successful",
      "subtitle": "Your password update successfully",
      "icon": "lock",
    },
  ];

  final List<Map<String, String>> yesterdayNotifications = [
    {
      "title": "Account Setup Successful!",
      "subtitle": "Your account has been created",
      "icon": "account",
    },
    {
      "title": "Get 30% OFF",
      "subtitle": "Get 30% OFF on first booking",
      "icon": "discount",
    },
    {
      "title": "Debit card added successfully",
      "subtitle": "Your debit card added successfully",
      "icon": "card",
    },
    {
      "title": "Account Setup Successful!",
      "subtitle": "Your account has been created",
      "icon": "account",
    },
    {
      "title": "Get 30% OFF",
      "subtitle": "Get 30% OFF on first booking",
      "icon": "discount",
    },
    {
      "title": "Debit card added successfully",
      "subtitle": "Your debit card added successfully",
      "icon": "card",
    },
  ];

  NotificationsScreen({super.key});

  IconData _getIcon(String name) {
    switch (name) {
      case "discount":
        return Icons.local_offer_outlined;
      case "lock":
        return Icons.lock_outline;
      case "account":
        return Icons.person_outline;
      case "card":
        return Icons.credit_card_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notifications",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            Text(
              "Today",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            ...todayNotifications.map(
              (notif) => NotificationCard(
                title: notif["title"]!,
                subtitle: notif["subtitle"]!,
                icon: _getIcon(notif["icon"]!),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Yesterday",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 1.h),
            ...yesterdayNotifications.map(
              (notif) => NotificationCard(
                title: notif["title"]!,
                subtitle: notif["subtitle"]!,
                icon: _getIcon(notif["icon"]!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
