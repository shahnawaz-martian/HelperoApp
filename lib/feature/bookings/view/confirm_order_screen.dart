import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/domain/models/order_create_request_model.dart';
import 'package:helpero/feature/home/view/home_screen.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../base_widget/show_custom_snakbar_widget.dart';
import '../../../data/model/response_model.dart';
import '../../../main.dart';
import '../../widget/primary_button.dart';
import '../controllers/order_controller.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final OrderCreateRequest orderCreateRequest;
  final String orderId;
  final String? customerName;
  final String? address;
  final int? serviceCharge;
  const ConfirmOrderScreen({
    super.key,
    required this.orderCreateRequest,
    required this.orderId,
    this.customerName,
    this.address,
    this.serviceCharge,
  });

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Order Summary",
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
        child: Consumer<OrderController>(
          builder: (context, orderController, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _summaryCard(context),
                        SizedBox(height: 1.h),
                        _customerCard(context),
                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Fixed Charge + Button
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Service Charge",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "₹${widget.serviceCharge}",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      PrimaryButton(
                        text: "Confirm Order",
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        isLoading: orderController.isLoading,
                        onPressed: orderController.isLoading
                            ? null
                            : () async {
                                final order = widget.orderCreateRequest;

                                ResponseModel response = await orderController
                                    .updateOrder(
                                      order,
                                      widget.orderId,
                                    );

                                if (response.isSuccess) {
                                  Navigator.of(Get.context!).pop(true);
                                  // Navigator.of(Get.context!).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         BottomNavigationBarScreen(
                                  //           initialIndex: 1,
                                  //         ),
                                  //   ),
                                  // );
                                } else {
                                  showCustomSnackBar(
                                    response.message,
                                    Get.context!,
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String title, String? value, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          ": ",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value ?? "-",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            width: double.infinity,
            child: Text(
              "Service Details",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
              top: 0.3.h,
              bottom: 0.7.h,
            ),
            child: Column(
              children: [
                _buildRow(
                  "Service",
                  widget.orderCreateRequest.service,
                  context,
                ),
                SizedBox(height: 1.h),
                widget.orderCreateRequest.orderType == "SUBSCRIPTION"
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildRow(
                              "Start Date",
                              widget.orderCreateRequest.startDate,
                              context,
                            ),
                          ),
                          Expanded(
                            child: _buildRow(
                              "End Date",
                              widget.orderCreateRequest.endDate,
                              context,
                            ),
                          ),
                        ],
                      )
                    : _buildRow(
                        "Date",
                        widget.orderCreateRequest.date,
                        context,
                      ),
                SizedBox(height: 1.h),
                _buildRow(
                  "Start Time",
                  widget.orderCreateRequest.startTime,
                  context,
                ),
                SizedBox(height: 1.h),
                // _buildRow(
                //   "Place Type",
                //   widget.orderCreateRequest.placeType,
                //   context,
                // ),
                SizedBox(height: 1.h),
                _buildRow(
                  "Comment",
                  (widget.orderCreateRequest.comment?.trim().isNotEmpty ??
                          false)
                      ? widget.orderCreateRequest.comment!
                      : " - ",
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerCard(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            width: double.infinity,
            child: Text(
              "Customer Details",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
              top: 0.3.h,
              bottom: 0.7.h,
            ),
            child: Column(
              children: [
                _buildRow("Customer Name", widget.customerName, context),
                SizedBox(height: 1.h),
                _buildRow("Address", widget.address, context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
