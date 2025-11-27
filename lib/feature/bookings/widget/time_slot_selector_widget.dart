import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // optional for responsive height like 2.h

class TimeSlotSelectorWidget extends StatefulWidget {
  final Function(String period, String slot)? onSlotSelected;

  const TimeSlotSelectorWidget({super.key, this.onSlotSelected});

  @override
  State<TimeSlotSelectorWidget> createState() => _TimeSlotSelectorWidgetState();
}

class _TimeSlotSelectorWidgetState extends State<TimeSlotSelectorWidget> {
  bool isExpanded = true;
  String? selectedPeriod;
  String? selectedSlot;

  final Map<String, List<String>> timeSlots = {
    "Morning": [
      "09:00 AM",
      "09:30 AM",
      "10:00 AM",
      "10:30 AM",
      "11:00 AM",
      "11:30 AM",
    ],
    "Afternoon": [
      "12:00 PM",
      "12:30 PM",
      "01:00 PM",
      "01:30 PM",
      "02:00 PM",
      "02:30 PM",
      "03:00 PM",
      "03:30 PM",
      "04:00 PM",
      "04:30 PM",
    ],
    "Evening": ["05:00 PM", "05:30 PM", "06:00 PM", "06:30 PM"],
  };

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
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Start Time",
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
          if (isExpanded) ...[
            SizedBox(height: 1.h),

            /// ---------------------- PERIODS ----------------------
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timeSlots.keys.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                String period = timeSlots.keys.elementAt(index);
                bool isSelectedPeriod = selectedPeriod == period;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedPeriod = period;
                      selectedSlot = null;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelectedPeriod
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelectedPeriod
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      period,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelectedPeriod
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),

            if (selectedPeriod != null) SizedBox(height: 2.h),

            if (selectedPeriod != null)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timeSlots[selectedPeriod]!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  String slot = timeSlots[selectedPeriod]![index];
                  bool isSelectedSlot = selectedSlot == slot;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedSlot = slot;
                        widget.onSlotSelected?.call(selectedPeriod!, slot);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelectedSlot
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1)
                            : Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelectedSlot
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).highlightColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        slot,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          // fontWeight: FontWeight.w500,
                          color: isSelectedSlot
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
