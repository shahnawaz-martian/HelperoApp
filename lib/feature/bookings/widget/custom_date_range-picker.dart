import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sizer/sizer.dart';

class CustomDateRangePicker extends StatefulWidget {
  final Function(DateTime start, DateTime end, int duration)? onDateSelected;
  const CustomDateRangePicker({super.key, this.onDateSelected});

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  bool isExpanded = true;

  int serviceDuration = 3;

  @override
  void initState() {
    super.initState();
    serviceDuration = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
          SizedBox(height: 1.h),

          // ─── Start and End Date Boxes ───
          Stack(
            clipBehavior: Clip.none, // allow overflow
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat('d MMM').format(_startDate!)
                            : "Start Date",
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _endDate != null
                            ? DateFormat('d MMM').format(_endDate!)
                            : "End Date",
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              // ─── Days Box ───
              if (_endDate != null)
                Positioned(
                  top: 6,
                  left: MediaQuery.of(context).size.width * 0.32,
                  right: MediaQuery.of(context).size.width * 0.32,
                  child: Stack(
                    children: [
                      Container(
                        height: 25,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$serviceDuration Days",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // ─── Calendar ───
          if (isExpanded)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                rangeStartDay: _startDate,
                rangeEndDay: _endDate,
                rangeSelectionMode: RangeSelectionMode.toggledOn,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;

                    if (_startDate == null ||
                        (_startDate != null && _endDate != null)) {
                      _startDate = selectedDay;
                      _endDate = null;
                      serviceDuration = 0;
                    } else if (selectedDay.isAfter(_startDate!)) {
                      _endDate = selectedDay;
                      serviceDuration =
                          _endDate!.difference(_startDate!).inDays + 1;
                      if (widget.onDateSelected != null) {
                        widget.onDateSelected!(
                          _startDate!,
                          _endDate!,
                          serviceDuration,
                        );
                      }
                    } else {
                      _startDate = selectedDay;
                      _endDate = null;
                      serviceDuration = 0;
                    }
                  });
                },
                selectedDayPredicate: (day) =>
                    isSameDay(day, _startDate) || isSameDay(day, _endDate),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextFormatter: (date, locale) => '',
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    // fontWeight: FontWeight.w500,
                  ),
                  weekendStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.15),
                  rangeStartDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  // defaultTextStyle: TextStyle(
                  //   color: Theme.of(context).colorScheme.onBackground, // Enabled date text
                  //   // fontWeight: FontWeight.w500,
                  // ),
                  // disabledTextStyle: TextStyle(
                  //   // color: Colors.grey.shade400, // Disabled (out-of-range) text
                  // ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
