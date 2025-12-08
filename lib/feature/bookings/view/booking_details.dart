import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/domain/models/order_detail_model.dart';
import 'package:helpero/feature/bookings/widget/booking_status_widget.dart';
import 'package:helpero/feature/bookings/widget/cancel_booking_popup.dart';
import 'package:helpero/feature/bookings/widget/payment_summary_widget.dart';
import 'package:helpero/feature/bookings/widget/profile_card.dart';
import 'package:helpero/feature/navigation/bottom_navigation_bar_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../controllers/order_controller.dart';
import '../domain/models/order_charges_model.dart';

class BookingDetails extends StatefulWidget {
  final bool isFromBookingScreen;
  final String bookingId;
  const BookingDetails({
    super.key,
    required this.bookingId,
    this.isFromBookingScreen = false,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  Timer? _timer;
  Charges? charges;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderController>(
        context,
        listen: false,
      ).getOrderDetails(widget.bookingId);
    });

    _timer = Timer.periodic(const Duration(seconds: 40), (_) {
      if (mounted) {
        Provider.of<OrderController>(
          context,
          listen: false,
        ).getOrderDetails(widget.bookingId, isBackground: true);
      }
    });

    Provider.of<OrderController>(context, listen: false).getOrderCharges().then(
      (_) {
        final list = Provider.of<OrderController>(
          Get.context!,
          listen: false,
        ).chargesList;

        if (list.isNotEmpty) {
          setState(() {
            charges = list.first;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatNum(num? value) {
    if (value == null) return "0";
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Booking Details",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => !widget.isFromBookingScreen
              ? Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BottomNavigationBarScreen(initialIndex: 0),
                  ),
                )
              : Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: SafeArea(
        child: Consumer<OrderController>(
          builder: (context, orderDetails, _) {
            OrderDetailModel orderDetail =
                orderDetails.orderDetailModel ?? OrderDetailModel();

            if (!orderDetails.isInitialLoadDone && orderDetails.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

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
                        Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 12.h,
                                  width: 25.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                if (orderDetail.orderType != "ONETIME")
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 3,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        (orderDetail.orderType ?? '')
                                            .toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(width: 2.5.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderDetail.service ?? '',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 0.4.h),
                                if (orderDetail.orderType != "ONETIME") ...[
                                  _buildRow(
                                    "Start Date: ",
                                    orderDetail.startDate,
                                    context,
                                  ),
                                  SizedBox(height: 0.4.h),
                                  _buildRow(
                                    "End Date: ",
                                    orderDetail.endDate,
                                    context,
                                  ),
                                ],
                                if (orderDetail.orderType == "ONETIME") ...[
                                  _buildRow(
                                    "Date: ",
                                    orderDetail.date,
                                    context,
                                  ),
                                ],
                                SizedBox(height: 0.4.h),
                                _buildRow(
                                  "Start Time: ",
                                  orderDetail.startTime,
                                  context,
                                ),
                                SizedBox(height: 0.4.h),
                                _buildRow(
                                  "Duration: ",
                                  orderDetail.duration,
                                  context,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "₹ ${(orderDetail.amount ?? 0).toStringAsFixed(2)}",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (orderDetail.helperDetails != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            "About Service Provider",
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 1.5.h),
                          ProfileCard(
                            profile: orderDetail.helperDetails!,
                            firstname:
                                orderDetail.helperDetails?.firstName ?? '',
                            lastname: orderDetail.helperDetails?.lastName ?? '',
                            phoneNo: orderDetail.helperDetails?.phoneNo ?? '',
                          ),
                        ],
                        SizedBox(height: 2.h),
                        Text(
                          "Service Address",
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 1.5.h),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).highlightColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "${orderDetail.blockNo ?? ''} "
                            "${orderDetail.addressLine1 ?? ''} "
                            "${orderDetail.addressLine2 ?? ''} "
                            "${orderDetail.city ?? ''} "
                            "${orderDetail.pincode ?? ''}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        if (orderDetail.comment != null &&
                            orderDetail.comment!.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Special Instructions",
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "${orderDetail.comment}",
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                        ],
                        Text(
                          "Booking Status",
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 1.5.h),
                        BookingStatusWidget(),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).highlightColor.withOpacity(0.99),
                        offset: const Offset(0, -4),
                        blurRadius: 2,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 4.w,
                    right: 4.w,
                    top: 1.5.h,
                    bottom: orderDetail.status?.toUpperCase() == "PENDING"
                        ? 0
                        : 2.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Summary",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      PaymentSummaryWidget(
                        serviceCharge: orderDetail.serviceCharge ?? 0.0,
                        transportationCharge:
                            orderDetail.transportationCharge ?? 0.0,
                        amount: orderDetail.amount ?? 0.0,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<OrderController>(
        builder: (context, orderDetails, _) {
          return (orderDetails.orderDetailModel?.status?.toUpperCase() ==
                  "PENDING")
              ? Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      final serviceCharge =
                          orderDetails.orderDetailModel?.serviceCharge ?? 0;
                      final cancellationCharge =
                          serviceCharge *
                          ((charges?.cancellationCharge ?? 0) / 100);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CancelBookingPopup(
                              cancellationCharge: cancellationCharge,
                              orderDetailModel: orderDetails.orderDetailModel!,
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Cancel Booking"),
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRow(
    String title1,
    String? value1,
    BuildContext context, {
    int? maxLines = 1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title1,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.2.h),
        Text(
          value1 ?? "-",
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Color(0xFF808080)),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
