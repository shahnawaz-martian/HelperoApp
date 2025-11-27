import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../category/model/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel categoryModel;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.categoryModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8.5.h,
            width: 20.w,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              categoryModel.imageUrl,
              fit: BoxFit.fill,
              height: 3.h,
              width: 3.w,
            ),
          ),

          SizedBox(height: 1.5.h),

          SizedBox(
            width: 20.w,
            child: Text(
              categoryModel.categoryName,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

//Image(image: NetworkImage(widget.categoryModel.imageUrl)),
