import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/domain/models/order_detail_model.dart';
import 'package:sizer/sizer.dart';

class PaymentDetailsWidget extends StatefulWidget {
  final OrderDetailModel orderDetailModel;
  const PaymentDetailsWidget({super.key, required this.orderDetailModel});

  @override
  State<PaymentDetailsWidget> createState() => _PaymentDetailsWidgetState();
}

class _PaymentDetailsWidgetState extends State<PaymentDetailsWidget> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey.shade300),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor.withOpacity(0.99),
            blurRadius: 6,
            spreadRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Summary",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 24,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow(
                  "Service Charge: ",
                  widget.orderDetailModel.serviceCharge.toString() ?? '',
                  context,
                ),
                SizedBox(height: 1.h),
                _buildRow(
                  "Transportation Charge: ",
                  widget.orderDetailModel.transportationCharge.toString(),
                  context,
                ),
                SizedBox(height: 1.h),
                Divider(color: Theme.of(context).colorScheme.outline),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Payment",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF808080),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      "${widget.orderDetailModel.amount.toString() ?? "-"} /-",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildRow(String title, String? value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            // fontWeight: FontWeight.w500,
            color: Color(0xFF808080),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.2.h),
        Text(
          value ?? "-",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Color(0xFF808080),
          ),
        ),
      ],
    );
  }
}
