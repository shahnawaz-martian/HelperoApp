import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HorizontalDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final int daysToShow;
  final Function(DateTime) onDateSelected; // callback

  const HorizontalDatePicker({
    super.key,
    this.initialDate,
    this.daysToShow = 5,
    required this.onDateSelected,
  });

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late DateTime today;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    today = widget.initialDate ?? DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(today);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 9.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.daysToShow,
        itemBuilder: (context, index) {
          DateTime date = today.add(Duration(days: index));
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onDateSelected(date);
            },
            child: Container(
              width: 16.w,
              margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).highlightColor,
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    DateFormat('d').format(date),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
