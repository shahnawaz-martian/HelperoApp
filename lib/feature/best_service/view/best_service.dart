import 'package:flutter/material.dart';
import 'package:helpero/feature/service/view/service_details.dart';
import 'package:sizer/sizer.dart';

import '../../bookings/view/booking_summary.dart';
import '../../widget/servie_card.dart';

class BestService extends StatefulWidget {
  const BestService({super.key});

  @override
  State<BestService> createState() => _BestServiceState();
}

class _BestServiceState extends State<BestService> {
  final List<Map<String, dynamic>> services = [
    {
      "image": "assets/images/home_service.jpg",
      "title": "Home Cleaning",
      "price": "\$50",
      "provider": "Cleaners Co.",
      "rating": 4.5,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Plumbing",
      "price": "\$30",
      "provider": "PlumbFix",
      "rating": 4.2,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Electrician",
      "price": "\$40",
      "provider": "ElectroPro",
      "rating": 4.7,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Car Wash",
      "price": "\$25",
      "provider": "WashIt",
      "rating": 4.3,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Home Cleaning",
      "price": "\$50",
      "provider": "Cleaners Co.",
      "rating": 4.5,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Plumbing",
      "price": "\$30",
      "provider": "PlumbFix",
      "rating": 4.2,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Electrician",
      "price": "\$40",
      "provider": "ElectroPro",
      "rating": 4.7,
    },
    {
      "image": "assets/images/home_service.jpg",
      "title": "Car Wash",
      "price": "\$25",
      "provider": "WashIt",
      "rating": 4.3,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Best Services",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, size: 20), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              // return ServiceCard(
              //   imagePath: service["image"],
              //   title: service["title"],
              //   price: service["price"],
              //   provider: service["provider"],
              //   rating: service["rating"],
              //   isFromBestServiceScreen: true,
              //   onTap: () => Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => ServiceDetails()),
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
