import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helpero/feature/review/widget/review_success_bottomsheet.dart';
import 'package:sizer/sizer.dart';

import '../../widget/custom_textfield.dart';
import '../../widget/primary_button.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final productReviewController = TextEditingController();
  final technicianReviewController = TextEditingController();
  late final _ratingController;
  late final _technicianController;
  late double _technicianRating;
  late double _rating;
  double _initialRating = 2.0;
  double technicianInitialRating = 2.0;
  Set<String> selectedTypes = {};
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
    _technicianController = TextEditingController(text: '2.0');
    _technicianRating = technicianInitialRating;
  }

  final List<String> review = [
    "Service Quality",
    "Technician Behaviour",
    "On Time Service",
    "Customer Support",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Write a Review",
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Rate Service",
                      //   style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // SizedBox(height: 1.h),
                      TextField(
                        style: TextStyle(fontSize: 14),
                        controller: productReviewController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: "Write a Review",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14,
                          ),
                          floatingLabelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: _initialRating,
                        minRating: 1,
                        allowHalfRating: true,
                        // unratedColor: Colors.amber.withAlpha(50),
                        itemCount: 5,
                        itemSize: 30.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                        updateOnDrag: true,
                      ),
                      SizedBox(height: 1.h),
                      Divider(color: Theme.of(context).colorScheme.outline),
                      SizedBox(height: 1.h),
                      CheckboxListTile(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        title: Text(
                          "I recommended this service provider to my friends",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.5.h),
                Container(
                  width: 100.w,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What impressed you?",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 8.0,
                        children: review.map((type) {
                          final isSelected = selectedTypes.contains(type);
                          return ChoiceChip(
                            showCheckmark: false,
                            label: Text(type),
                            selected: isSelected,
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            backgroundColor: Theme.of(context).highlightColor,
                            labelStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedTypes.add(type);
                                } else {
                                  selectedTypes.remove(type);
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ), // corner radius
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
                    ],
                  ),
                ),
                SizedBox(height: 1.5.h),
                Container(
                  width: 100.w,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rate Technician",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // adjust the value as needed
                            child: Image.network(
                              'https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg',
                              height: 7.h,
                              width: 14.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 2.5.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ronald Richards",
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 0.7.h),
                              RatingBar.builder(
                                initialRating: technicianInitialRating,
                                minRating: 1,
                                allowHalfRating: true,
                                unratedColor: Colors.amber.withAlpha(50),
                                itemCount: 5,
                                itemSize: 20.0,
                                itemPadding: EdgeInsets.symmetric(
                                  horizontal: 0.5,
                                ),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                                updateOnDrag: true,
                              ),
                              SizedBox(height: 1.5.h),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      TextField(
                        style: TextStyle(fontSize: 14),
                        controller: technicianReviewController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          label: Text("Add a Comment"),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          floatingLabelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE9E9E9),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.5.h),
                PrimaryButton(
                  text: 'Submit Review',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ReviewSuccessBottomsheet(),
                    );
                    productReviewController.clear();
                    technicianReviewController.clear();
                    selectedTypes = {};
                    _rating = 2.0;
                    _technicianRating = 2.0;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
