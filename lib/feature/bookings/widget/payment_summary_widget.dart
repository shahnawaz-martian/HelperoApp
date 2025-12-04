import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentSummaryWidget extends StatelessWidget {
  final double serviceCharge;
  final double transportationCharge;
  final double amount;
  const PaymentSummaryWidget({
    super.key,
    required this.serviceCharge,
    required this.transportationCharge,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Service Charge', serviceCharge.toStringAsFixed(2), context),
        SizedBox(height: 1.h),
        _row(
          'Transportation Charge',
          transportationCharge.toStringAsFixed(2),
          context,
        ),
        SizedBox(height: 1.h),
        Divider(color: Theme.of(context).colorScheme.outline, thickness: 0.75),
        SizedBox(height: 1.h),
        _row('Total Payable Amount', amount.toStringAsFixed(2), context),
      ],
    );
  }

  Widget _row(String name, String amount, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: name == "Total Payable Amount"
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
        Text(
          "₹ $amount", //\u20B9
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
