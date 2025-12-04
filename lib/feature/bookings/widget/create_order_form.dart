import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/bookings/widget/select_address_bottomSheet.dart';
import 'package:helpero/feature/bookings/widget/custom_date_range-picker.dart';
import 'package:helpero/feature/bookings/widget/time_slot_selector_widget.dart';
import 'package:helpero/feature/bookings/widget/calender.dart';
import 'package:helpero/feature/profile/controllers/profile_contrroller.dart';
import 'package:helpero/feature/profile/domain/models/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../base_widget/show_custom_snakbar_widget.dart';
import '../../../base_widget/snackbar.dart';
import '../../../data/model/response_model.dart';
import '../../../helper/velidate_check.dart';
import '../../../main.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/primary_button.dart';
import '../controllers/order_controller.dart';
import '../domain/models/order_charges_model.dart';
import '../domain/models/order_create_request_model.dart';
import 'package:intl/intl.dart';

import '../../../base_widget/add_address_popup.dart';

class CreateOrderForm extends StatefulWidget {
  final bool isSubscription;
  final ProfileModel? user;
  final Function(Addresses)? onAddressSelected;
  const CreateOrderForm({
    super.key,
    this.isSubscription = false,
    required this.user,
    this.onAddressSelected,
  });

  @override
  State<CreateOrderForm> createState() => _CreateOrderFormState();
}

class _CreateOrderFormState extends State<CreateOrderForm> {
  final serviceController = TextEditingController();
  final instructionController = TextEditingController();
  final serviceChargeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedType = "1 hr";
  String? selectedPeriod;
  DateTime? _selectedDate;
  String? selectedStartTime;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int selectedDuration = 0;
  final List<String> timeSlot = ["1 hr", "2 hr", "3 hr", "4 hr"];
  Addresses? selectedAddress;
  Charges? charges;
  double finalServiceCharge = 0;
  double finalTransportCharge = 0;
  double finalTotalCharge = 0;

  @override
  void initState() {
    super.initState();

    final addresses = Provider.of<ProfileController>(
      context,
      listen: false,
    ).userInfoModel?.addresses;

    if (addresses != null && addresses.isNotEmpty) {
      selectedAddress = addresses.first;
    }
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
          calculateCharges();
        }
      },
    );
  }

  String formatToDMY(DateTime input) {
    try {
      return DateFormat("dd/MM/yyyy").format(input);
    } catch (e) {
      return input.toString();
    }
  }

  String formatTimeForApi(String time) {
    try {
      final parts = time.split(" ");
      final timeParts = parts[0].split(":");
      final period = parts[1];

      int hour = int.parse(timeParts[0]);
      String minute = timeParts[1];

      final formattedHour = hour.toString().padLeft(2, '0');
      return "$formattedHour:$minute $period";
    } catch (e) {
      return time;
    }
  }

  void calculateCharges() {
    if (charges == null || selectedAddress == null) return;

    double distance = selectedAddress?.distance ?? 0;

    num baseService = widget.isSubscription
        ? (charges!.subscriptionServiceCharge ?? 0)
        : (charges!.oneTimeServiceCharge ?? 0);

    int days = widget.isSubscription ? selectedDuration : 1;
    String durationStr = selectedType ?? "1 hr";
    int hours =
        int.tryParse(durationStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    if (widget.isSubscription) {
      finalServiceCharge = (baseService * hours * days).toDouble();
      finalTransportCharge =
          (charges?.transportationCharges ?? 0) * distance * days;
    } else {
      finalServiceCharge = (baseService * hours).toDouble();
      finalTransportCharge = (charges?.transportationCharges ?? 0) * distance;
    }
    finalTotalCharge = finalServiceCharge + finalTransportCharge;

    serviceChargeController.text = finalTotalCharge.toStringAsFixed(2);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        child: Consumer<ProfileController>(
          builder: (context, provider, child) {
            final addresses = provider.userInfoModel?.addresses;
            if (selectedAddress == null &&
                addresses != null &&
                addresses.isNotEmpty) {
              selectedAddress = addresses.first;
            }
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    CustomTextField(
                      controller: serviceController,
                      label: "Expected Service",
                      hintText: "Sweeping, Mopping, Cleaning, etc",
                      validator: (value) => ValidateCheck.validateEmptyText(
                        value,
                        "Service is required",
                      ),
                      prefixIcon: Icon(
                        Icons.home_repair_service_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Date / Subscription dates
                    if (!widget.isSubscription) ...[
                      // ONE TIME BOOKING
                      selectDateWidget(),
                    ] else ...[
                      // SUBSCRIPTION BOOKING
                      CustomDateRangePicker(
                        onDateSelected: (start, end, duration) {
                          setState(() {
                            selectedStartDate = start;
                            selectedEndDate = end;
                            selectedDuration = duration;
                          });
                          calculateCharges();
                        },
                      ),
                    ],
                    SizedBox(height: 2.h),
                    selectDurationWidget(
                      onDurationSelected: (duration) {
                        setState(() {
                          selectedType = duration;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                    TimeSlotSelectorWidget(
                      onSlotSelected: (period, slot) {
                        setState(() {
                          selectedPeriod = period;
                          selectedStartTime = slot;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                    CustomTextField(
                      controller: instructionController,
                      label: "Any Special Instructions?",
                      hintText: "Special Instructions",
                      prefixIcon: Icon(
                        Icons.insert_comment_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).highlightColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Address",
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.8,
                                      ),
                                ),
                                SizedBox(height: 1.5.h),
                                Text(
                                  selectedAddress != null
                                      ? "${selectedAddress!.blockNo ?? ''} "
                                            "${selectedAddress!.addressLine1 ?? ''} "
                                            "${selectedAddress!.addressLine2 ?? ''} "
                                            "${selectedAddress!.city ?? ''}"
                                      : "No address added",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<Addresses>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (context) =>
                                        SelectAddressBottomSheet(
                                          selectedAddress: selectedAddress,
                                        ),
                                  );

                              if (result != null) {
                                setState(() {
                                  selectedAddress = result;
                                });

                                calculateCharges();

                                if (widget.onAddressSelected != null) {
                                  widget.onAddressSelected!(result);
                                }
                              }
                            },
                            child: Text(
                              "Change",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    finalTotalCharge != 0
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).highlightColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                finalServiceCharge != 0
                                    ? Text(
                                        "Charges Summary: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.8,
                                            ),
                                      )
                                    : SizedBox(),
                                SizedBox(height: 1.5.h),
                                finalServiceCharge != 0
                                    ? _row(
                                        "Service Charge",
                                        "₹ ${finalServiceCharge.toStringAsFixed(2)}",
                                        context,
                                      )
                                    : SizedBox(),
                                SizedBox(height: 1.h),
                                finalTransportCharge != 0
                                    ? _row(
                                        "Transportation Charge",
                                        "₹ ${finalTransportCharge.toStringAsFixed(2)}",
                                        context,
                                      )
                                    : SizedBox(),
                                SizedBox(height: 1.h),
                                finalTotalCharge != 0
                                    ? _row(
                                        "Total Charge",
                                        "₹ ${finalTotalCharge.toStringAsFixed(2)}",
                                        context,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 2.5.h),
                    Consumer<OrderController>(
                      builder: (context, orderController, _) {
                        return PrimaryButton(
                          text: "Confirm Booking",
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          isLoading: orderController.isLoading,
                          onPressed: orderController.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    final userId = Provider.of<AuthController>(
                                      context,
                                      listen: false,
                                    ).getUserId();

                                    if (selectedType == null) {
                                      showCustomSnackBar(
                                        "Please select duration",
                                        context,
                                      );
                                    } else if (widget.isSubscription &&
                                        selectedStartDate == null) {
                                      showCustomSnackBar(
                                        "Please select start date and end date",
                                        context,
                                      );
                                    } else if (selectedStartTime == null) {
                                      showCustomSnackBar(
                                        "Please select start time and slot", //"Please select start time"
                                        context,
                                      );
                                    } else if (addresses == null ||
                                        addresses.isEmpty) {
                                      showDialog(
                                        context: Get.context!,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: AddAddressPopup(
                                              isFromCreateOrder: true,
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      final order = widget.isSubscription
                                          ? OrderCreateRequest(
                                              userId: userId,
                                              service: serviceController.text,
                                              orderType: widget.isSubscription
                                                  ? "SUBSCRIPTION"
                                                  : "ONETIME",
                                              comment:
                                                  instructionController.text,
                                              subscriptionDurationInDays:
                                                  selectedDuration,
                                              startDate:
                                                  selectedStartDate != null
                                                  ? formatToDMY(
                                                      selectedStartDate!,
                                                    )
                                                  : "",
                                              endDate: selectedEndDate != null
                                                  ? formatToDMY(
                                                      selectedEndDate!,
                                                    )
                                                  : "",
                                              startTime: selectedStartTime,
                                              serviceCharge: finalServiceCharge,
                                              date: "",
                                              status: "pending",
                                              duration: selectedType,
                                              paymentStatus: "UNPAID",
                                              placeType:
                                                  selectedAddress
                                                      ?.addressType ??
                                                  '',
                                              distance:
                                                  (selectedAddress?.distance ??
                                                          0.0)
                                                      .toString(),
                                              addresses: selectedAddress != null
                                                  ? [selectedAddress!]
                                                  : null,
                                              addressType:
                                                  selectedAddress?.addressType,
                                              addressLine1:
                                                  selectedAddress?.addressLine1,
                                              addressLine2:
                                                  selectedAddress?.addressLine2,
                                              blockNo: selectedAddress?.blockNo,
                                              city: selectedAddress?.city,
                                              state: selectedAddress?.state,
                                              pinCode: selectedAddress?.pinCode,
                                              transportationCharge:
                                                  finalTransportCharge,
                                            )
                                          : OrderCreateRequest(
                                              userId: userId,
                                              date: _selectedDate != null
                                                  ? formatToDMY(_selectedDate!)
                                                  : "",
                                              service: serviceController.text,
                                              orderType: widget.isSubscription
                                                  ? "SUBSCRIPTION"
                                                  : "ONETIME",
                                              comment:
                                                  instructionController.text,
                                              startTime:
                                                  selectedStartTime ?? '',
                                              serviceCharge: finalServiceCharge,
                                              subscriptionDurationInDays: 0,
                                              status: "pending",
                                              duration: selectedType,
                                              paymentStatus: "UNPAID",
                                              placeType:
                                                  selectedAddress
                                                      ?.addressType ??
                                                  '',
                                              addresses: selectedAddress != null
                                                  ? [selectedAddress!]
                                                  : null,
                                              distance:
                                                  (selectedAddress?.distance ??
                                                          0.0)
                                                      .toString(),
                                              addressType:
                                                  selectedAddress?.addressType,
                                              addressLine1:
                                                  selectedAddress?.addressLine1,
                                              addressLine2:
                                                  selectedAddress?.addressLine2,
                                              blockNo: selectedAddress?.blockNo,
                                              city: selectedAddress?.city,
                                              state: selectedAddress?.state,
                                              pinCode: selectedAddress?.pinCode,
                                              transportationCharge:
                                                  finalTransportCharge,
                                            );

                                      ResponseModel response =
                                          await orderController.createOrder(
                                            order,
                                          );

                                      if (response.isSuccess) {
                                      } else {
                                        customSnackBar(
                                          response.message,
                                          Get.context!,
                                        );
                                      }
                                    }
                                  }
                                },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _row(String name, String amount, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
        ),
        Text(
          amount,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget selectDateWidget() {
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
            "Select Date",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 1.h),
          HorizontalDatePicker(
            daysToShow: 5,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget selectDurationWidget({
    Function(String selectedDuration)? onDurationSelected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Duration",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 1.5.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeSlot.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              final type = timeSlot[index];
              final isSelected = selectedType == type;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedType = type;
                    calculateCharges();
                    if (onDurationSelected != null) {
                      onDurationSelected(type);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).highlightColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    type,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
