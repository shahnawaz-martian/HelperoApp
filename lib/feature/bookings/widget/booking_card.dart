import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/domain/models/order_model.dart';
import 'package:sizer/sizer.dart';

class BookingCard extends StatelessWidget {
  final OrderModel booking;
  const BookingCard({super.key, required this.booking});

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case "COMPLETED":
        return Colors.green.shade50;
      case "CONFIRMED":
        return Colors.blue.shade50;
      case "CANCELLED":
        return Colors.red.shade50;
      case "PENDING":
        return Colors.orange.shade50;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusTextColor(String? status) {
    switch (status?.toUpperCase()) {
      case "COMPLETED":
        return Colors.green;
      case "CONFIRMED":
        return Colors.blue;
      case "CANCELLED":
        return Colors.red;
      case "PENDING":
        return Colors.orange.shade600;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              "BOOKING ${booking.status}".toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _getStatusTextColor(booking.status),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),

          // Title + arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.service ?? '',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
          SizedBox(height: 0.7.h),

          (booking.startDate != null && booking.startDate!.isNotEmpty) &&
                  (booking.endDate != null && booking.endDate!.isNotEmpty)
              ? Row(
                  children: [
                    Text(
                      booking.startDate!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      ' to ${booking.endDate!}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      ' at ${booking.startTime}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      booking.date!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      ' at ${booking.startTime}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),

          if (booking.amount != null &&
              booking.status?.toUpperCase() != "CANCELLED") ...[
            SizedBox(height: 0.7.h),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              thickness: 0.75,
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    booking.paymentStatus?.toUpperCase() == "UNPAID"
                        ? Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 20,
                          )
                        : Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                    SizedBox(width: 2.5.w),
                    Text(
                      booking.paymentStatus?.toUpperCase() == "UNPAID"
                          ? "Amount To Pay ₹ ${(booking.amount ?? 0).round().toInt()}"
                          : "Amount Paid ₹ ${booking.amount?.round().toInt() ?? 0}",

                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
