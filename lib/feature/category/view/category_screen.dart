import 'package:flutter/material.dart';
import 'package:helpero/feature/category/widget/category_card.dart';
import 'package:sizer/sizer.dart';

import '../../service/view/service_screen.dart';
import '../model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<CategoryModel> categories = [
    CategoryModel(
      categoryName: 'Carpenter',
      imageUrl: 'assets/images/carpenter.png',
    ),
    CategoryModel(
      categoryName: 'Plumber',
      imageUrl: 'assets/images/plumber.png',
    ),
    CategoryModel(
      categoryName: 'Electrician',
      imageUrl: 'assets/images/electrician.png',
    ),
    CategoryModel(
      categoryName: 'Painter',
      imageUrl: 'assets/images/painting.png',
    ),
    CategoryModel(
      categoryName: 'Cleaner',
      imageUrl: 'assets/images/cleaner.png',
    ),
    CategoryModel(
      categoryName: 'AC Repair',
      imageUrl: 'assets/images/ac_repair.png',
    ),
    CategoryModel(
      categoryName: 'Electrician',
      imageUrl: 'assets/images/electrician.png',
    ),
    CategoryModel(
      categoryName: 'Painter',
      imageUrl: 'assets/images/painting.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "All Categories",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                isDarkMode
                    ? Image.asset(
                        'assets/images/icons/search_dark.png',
                        width: 5.w,
                        height: 5.h,
                      )
                    : Image.asset(
                        'assets/images/icons/search_light.png',
                        width: 5.w,
                        height: 5.h,
                      ),
                SizedBox(width: 2.5.w),
              ],
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: CategoryCard(
                      categoryModel: categories[index],
                      // onTap: () => Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ServiceScreen(
                      //       categoryName: category.categoryName,
                      //     ),
                      //   ),
                      // ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
