import 'package:flutter/material.dart';
import 'package:helpero/feature/bookings/widget/select_address_bottomSheet.dart';
import 'package:helpero/feature/bookings/widget/calender.dart';
import 'package:sizer/sizer.dart';

class SelectSlotBottomSheet extends StatefulWidget {
  const SelectSlotBottomSheet({super.key});

  @override
  State<SelectSlotBottomSheet> createState() => _SelectSlotBottomSheetState();
}

class _SelectSlotBottomSheetState extends State<SelectSlotBottomSheet> {
  String? selectedType;
  bool isChecked = false;

  final List<String> timeSlot = [
    "10:00 AM",
    "11:00 AM",
    "12:30 PM",
    "01:30 PM",
    "03:00 PM",
    "04:30 PM",
  ];
  final isSmallScreen = 100.w < 360;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          // HorizontalDatePicker(),
          SizedBox(height: 1.h),
          Text(
            "Select Time",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 1.h),

          Wrap(
            spacing: 8.0,
            children: timeSlot.map((type) {
              final isSelected = selectedType == type;
              return ChoiceChip(
                showCheckmark: false,
                label: Text(type),
                selected: isSelected,
                selectedColor: Theme.of(context).highlightColor,
                backgroundColor: Theme.of(context).highlightColor,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onSelected: (selected) {
                  setState(() {
                    selectedType = selected ? type : null;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).highlightColor,
                    width: 1,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 1.5.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const SelectAddressBottomSheet(),
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Proceed to Checkout",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h,),
        ],
      ),
    );
  }
}
