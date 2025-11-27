import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../controllers/order_controller.dart';

class BookingStatusWidget extends StatelessWidget {
  const BookingStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final orderDetail = context.watch<OrderController>().orderDetailModel;
    final currentStatus = orderDetail?.status ?? 'Pending';

    final statuses = ['Pending', 'Confirmed', 'Completed'];
    final statusSubtext = {
      'Pending': 'Waiting for confirmation',
      'Confirmed': 'Helper has been assigned',
      'Completed': 'Service completed successfully',
    };

    int currentIndex = statuses.indexWhere(
      (s) => s.toUpperCase() == currentStatus.toUpperCase(),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        bool isLast = index == statuses.length - 1;
        bool isActiveOrCompleted = index <= currentIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 4.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isActiveOrCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 4.h,
                    color: index < currentIndex
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
              ],
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statuses[index],
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActiveOrCompleted
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.grey,
                  ),
                ),
                SizedBox(height: 0.5),
                Text(
                  statusSubtext[statuses[index]] ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        );
      },
    );
  }
}
