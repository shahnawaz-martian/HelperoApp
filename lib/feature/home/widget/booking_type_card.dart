import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:helpero/feature/bookings/view/create_order.dart';

class BookingTypeCard extends StatefulWidget {
  const BookingTypeCard({super.key});

  @override
  State<BookingTypeCard> createState() => _BookingTypeCardState();
}

class _BookingTypeCardState extends State<BookingTypeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).highlightColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Prebook for convenience",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Tap to select your slot",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              letterSpacing: 1.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 1.5.h),

          Row(
            children: [
              // SINGLE BOOKING CARD
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateOrder(isSubscription: false),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1,
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Single Booking",
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                              ),
                            ),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 1.7.h),
                                Image.asset(
                                  "assets/images/clock.png",
                                  height: 7.5.h,
                                  width: 17.5.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // GLOW BEHIND IMAGE
                      Positioned(
                        bottom: -10,
                        right: -18,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.bottomCenter,
                              radius: 1.5,
                              colors: [
                                Color(0xFF0483D0).withOpacity(0.18),
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 10),

              // MULTIPLE BOOKING CARD
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateOrder(isSubscription: true),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1,
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Multiple Booking",
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                              ),
                            ),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 1.7.h),
                                Image.asset(
                                  "assets/images/calender.png",
                                  height: 7.5.h,
                                  width: 17.5.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // GLOW BEHIND IMAGE
                      Positioned(
                        bottom: -10,
                        right: -18,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.bottomCenter,
                              radius: 1.5,
                              colors: [
                                Color(0xFF0483D0).withOpacity(0.18),
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
