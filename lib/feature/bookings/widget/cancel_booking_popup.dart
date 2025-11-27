import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/domain/models/order_detail_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../base_widget/show_custom_snakbar_widget.dart';
import '../../../main.dart';
import '../controllers/order_controller.dart';
import '../domain/models/order_create_request_model.dart';

class CancelBookingPopup extends StatefulWidget {
  final double cancellationCharge;
  final OrderDetailModel orderDetailModel;
  const CancelBookingPopup({
    super.key,
    required this.cancellationCharge,
    required this.orderDetailModel,
  });

  @override
  State<CancelBookingPopup> createState() => _CancelBookingPopupState();
}

class _CancelBookingPopupState extends State<CancelBookingPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Cancel Booking",
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            "Are you sure you want to cancel your booking?",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 1.h),
          Text(
            "A cancellation charge of ₹${widget.cancellationCharge.toStringAsFixed(2)} will be applied.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final payload = OrderCreateRequest(
                      userId: widget.orderDetailModel.userId!,
                      service: widget.orderDetailModel.service,
                      orderType: widget.orderDetailModel.orderType,
                      comment: widget.orderDetailModel.comment,
                      subscriptionDurationInDays:
                          widget.orderDetailModel.subscriptionDurationInDays,
                      startDate: widget.orderDetailModel.startDate,
                      endDate: widget.orderDetailModel.endDate,
                      startTime: widget.orderDetailModel.startTime,
                      serviceCharge: widget.orderDetailModel.serviceCharge,
                      date: widget.orderDetailModel.date,
                      status: "CANCELLED",
                      duration: widget.orderDetailModel.duration,
                      paymentStatus: "UNPAID",
                      placeType: widget.orderDetailModel.placeType,
                      distance: widget.orderDetailModel.distance.toString(),
                      addressType: widget.orderDetailModel.addressType,
                      addressLine1: widget.orderDetailModel.addressLine1,
                      addressLine2: widget.orderDetailModel.addressLine2,
                      blockNo: widget.orderDetailModel.blockNo,
                      city: widget.orderDetailModel.city,
                      state: widget.orderDetailModel.state,
                      pinCode: widget.orderDetailModel.pincode,
                      transportationCharge:
                          widget.orderDetailModel.transportationCharge,
                    );

                    final response = await Provider.of<OrderController>(
                      context,
                      listen: false,
                    ).updateOrder(payload, widget.orderDetailModel.orderId!);

                    if (response.isSuccess) {
                      showCustomSnackBar(
                        "Order cancelled successfully!",
                        Get.context!,
                        isError: false,
                      );
                      Navigator.of(Get.context!).pop();
                      await Provider.of<OrderController>(
                        Get.context!,
                        listen: false,
                      ).getOrderDetails(widget.orderDetailModel.orderId!);
                    } else {
                      showCustomSnackBar(
                        "Failed to cancel order",
                        Get.context!,
                        isError: true,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.5.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "No",
                    style: Theme.of(context).textTheme.labelMedium,
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
