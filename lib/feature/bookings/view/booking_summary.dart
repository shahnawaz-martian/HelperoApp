import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpero/feature/bookings/widget/profile_card.dart';
import 'package:helpero/feature/bookings/widget/slot_bottomsheet.dart';
import 'package:sizer/sizer.dart';

import '../../service/view/service_details.dart';
import '../../widget/servie_card.dart';

class BookingSummary extends StatefulWidget {
  const BookingSummary({super.key});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  final String description =
      "The red line moved across the page. With each millimeter it advanced forward, something changed in the room. The actual change taking place was difficult to perceive, but the change was real. The red line continued relentlessly across the page and the room would never be the same.";

  late final _ratingController;
  late double _rating;
  double _initialRating = 2.0;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
  }

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
          "Booking Summary",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(
                          //     12,
                          //   ), // adjust the value as needed
                          //   child: Image.asset(
                          //     'assets/images/leaving_room_cleaning.jpg',
                          //     height: 10.h,
                          //     width: 25.w,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Container(
                            height: 10.h,
                            width: 25.w,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 2.5.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Leaving Room cleaning",
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 0.7.h),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: 2.0,
                                    minRating: 1,
                                    allowHalfRating: true,
                                    unratedColor: Colors.amber.withAlpha(50),
                                    itemCount: 5,
                                    itemSize: 17.0,
                                    itemPadding: EdgeInsets.symmetric(
                                      horizontal: 0.5,
                                    ),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                      });
                                    },
                                    updateOnDrag: true,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "(${_initialRating.toString()})",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.5.h),
                              Text(
                                '\$200',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 2.5.h),
                      Text(
                        "Frequently Added Together",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height * 0.3)
                            .clamp(215.0, 270.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            // return ServiceCard(
                            //   imagePath: service["image"],
                            //   title: service["title"],
                            //   price: service["price"],
                            //   provider: service["provider"],
                            //   rating: service["rating"],
                            //   onTap: () => Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //       builder: (context) => ServiceDetails(),
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 6,
                //     offset: Offset(0, -2),
                //   ),
                // ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.5.w),
                      Expanded(
                        child: Text(
                          "Apply Coupon",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(width: 2.5.w),
                      Icon(Icons.arrow_forward_ios_outlined, size: 20),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  SizedBox(height: 1.h),
                  // PaymentSummaryWidget(paymentSummary: paymentSummary),
                  SizedBox(height: 1.h),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Icon(
                        Icons.not_listed_location_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Address',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 0.6.h),
                            Text(
                              "F - 411 Titanium City Center",
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Change",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Divider(color: Theme.of(context).colorScheme.outline),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Price',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '\$200',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => SelectSlotBottomSheet(),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Select Slot",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
