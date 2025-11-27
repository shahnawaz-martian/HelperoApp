import 'package:flutter/material.dart';
import 'package:helpero/feature/auth/controllers/auth_controller.dart';
import 'package:helpero/feature/home/widget/booking_type_card.dart';
import 'package:helpero/feature/profile/view/nevigation/my_addresses/view/my_address.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/location_controller.dart';
import '../../../helper/location_helper.dart';
import '../../profile/controllers/profile_contrroller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationController = Provider.of<LocationController>(
        context,
        listen: false,
      );

      final hasPermission = await LocationHelper.hasLocationPermission();

      if (!hasPermission) {
        await locationController.fetchApproxLocation();
      }

      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      Provider.of<ProfileController>(
        context,
        listen: false,
      ).getUserInfo(context, authController.getUserId());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MyAddresses(isFromCurrentAddress: true),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.not_listed_location_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 27,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Address',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 0.6.h),
                          Text(
                            Provider.of<LocationController>(
                                  context,
                                ).currentAddress ??
                                "Fetching...",
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.5.h),
              BookingTypeCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// class _HomeScreenState extends State<HomeScreen> {
//   final List<Map<String, String>> category = [
//     {'name': 'New York', 'country': 'USA'},
//     {'name': 'London', 'country': 'UK'},
//     {'name': 'Paris', 'country': 'France'},
//     {'name': 'Tokyo', 'country': 'Japan'},
//     {'name': 'Mumbai', 'country': 'India'},
//   ];
//
//   final List<CategoryModel> categories = [
//     CategoryModel(
//       categoryName: 'Carpenter',
//       imageUrl: 'assets/images/carpenter.png',
//     ),
//     CategoryModel(
//       categoryName: 'Plumber',
//       imageUrl: 'assets/images/plumber.png',
//     ),
//     CategoryModel(
//       categoryName: 'Electrician',
//       imageUrl: 'assets/images/electrician.png',
//     ),
//     CategoryModel(
//       categoryName: 'Painter',
//       imageUrl: 'assets/images/painting.png',
//     ),
//     CategoryModel(
//       categoryName: 'Cleaner',
//       imageUrl: 'assets/images/cleaner.png',
//     ),
//     CategoryModel(
//       categoryName: 'AC Repair',
//       imageUrl: 'assets/images/ac_repair.png',
//     ),
//     CategoryModel(
//       categoryName: 'Electrician',
//       imageUrl: 'assets/images/electrician.png',
//     ),
//     CategoryModel(
//       categoryName: 'Painter',
//       imageUrl: 'assets/images/painting.png',
//     ),
//   ];
//
//   final List<Map<String, dynamic>> services = [
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Home Cleaning",
//       "price": "\$50",
//       "provider": "Cleaners Co.",
//       "rating": 4.5,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Plumbing",
//       "price": "\$30",
//       "provider": "PlumbFix",
//       "rating": 4.2,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Electrician",
//       "price": "\$40",
//       "provider": "ElectroPro",
//       "rating": 4.7,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Car Wash",
//       "price": "\$25",
//       "provider": "WashIt",
//       "rating": 4.3,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Home Cleaning",
//       "price": "\$50",
//       "provider": "Cleaners Co.",
//       "rating": 4.5,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Plumbing",
//       "price": "\$30",
//       "provider": "PlumbFix",
//       "rating": 4.2,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Electrician",
//       "price": "\$40",
//       "provider": "ElectroPro",
//       "rating": 4.7,
//     },
//     {
//       "image": "assets/images/home_service.jpg",
//       "title": "Car Wash",
//       "price": "\$25",
//       "provider": "WashIt",
//       "rating": 4.3,
//     },
//   ];
//
//   final isSmallScreen = 100.w < 360;
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.primary.withOpacity(0.1),
//                     ),
//                     child: Icon(
//                       Icons.not_listed_location_outlined,
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 27,
//                     ),
//                   ),
//                   SizedBox(width: 2.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Delivery Address',
//                           style: Theme.of(context).textTheme.bodySmall
//                               ?.copyWith(fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(height: 0.6.h),
//                         Text(
//                           "F - 411 Titanium City Center",
//                           style: Theme.of(context).textTheme.bodyMedium,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => NotificationsScreen(),
//                       ),
//                     ),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         isDarkMode
//                             ? Image.asset(
//                                 'assets/images/icons/notification_dark.png',
//                                 width: 6.w,
//                                 height: 7.h,
//                               )
//                             : Image.asset(
//                                 'assets/images/icons/notification_light.png',
//                                 width: 6.w,
//                                 height: 7.h,
//                               ),
//                         Positioned(
//                           top: 9,
//                           right: 0.9,
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.error,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               '3',
//                               style: Theme.of(context).textTheme.bodySmall
//                                   ?.copyWith(
//                                     color: Theme.of(
//                                       context,
//                                     ).colorScheme.onError,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 1.5.h),
//               TypeAheadField<Map<String, String>>(
//                 suggestionsCallback: (search) {
//                   return category
//                       .where(
//                         (item) => item['name']!.toLowerCase().contains(
//                           search.toLowerCase(),
//                         ),
//                       )
//                       .toList();
//                 },
//                 // decorationBuilder: (context, child) {
//                 //   return Material(
//                 //     type: MaterialType.card,
//                 //     elevation: 4,
//                 //     borderRadius: BorderRadius.circular(8),
//                 //     child: child,
//                 //   );
//                 // },
//                 offset: Offset(0, 12),
//                 constraints: BoxConstraints(maxHeight: 500),
//                 builder: (context, controller, focusNode) {
//                   return CustomSearchField(
//                     controller: controller,
//                     focusNode: focusNode,
//                     label: 'Search',
//                   );
//                 },
//                 itemBuilder: (context, city) {
//                   return ListTile(
//                     title: Text(
//                       city['name']!,
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   );
//                 },
//                 onSelected: (city) {
//                   // handle selection
//                 },
//               ),
//               SizedBox(height: 2.5.h),
//               HeaderText(
//                 text: 'All Categories',
//                 tapText: 'See all',
//                 onLinkTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           BottomNavigationBarScreen(initialIndex: 1),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 2.5.h),
//               GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                   childAspectRatio: (10.w) / (6.5.h),
//                 ),
//                 itemCount: categories.length,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   return CategoryCard(
//                     categoryModel: categories[index],
//                     onTap: () => Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => CreateOrder()),
//                     ),
//                     //     Navigator.of(context).push(
//                     //   MaterialPageRoute(
//                     //     builder: (context) =>
//                     //         ServiceScreen(categoryName: category.categoryName),
//                     //   ),
//                     // ),
//                   );
//                 },
//               ),
//               SizedBox(height: 2.h),
//               HeaderText(
//                 text: 'Best Services',
//                 tapText: 'See all',
//                 onLinkTap: () => Navigator.of(
//                   context,
//                 ).push(MaterialPageRoute(builder: (context) => BestService())),
//               ),
//               SizedBox(height: 2.h),
//               SizedBox(
//                 // height: 33.h,
//                 height: (MediaQuery.of(context).size.height * 0.3).clamp(
//                   215.0,
//                   270.0,
//                 ),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: services.length,
//                   itemBuilder: (context, index) {
//                     final service = services[index];
//                     return ServiceCard(
//                       imagePath: service["image"],
//                       title: service["title"],
//                       price: service["price"],
//                       provider: service["provider"],
//                       rating: service["rating"],
//                       onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => ServiceDetails(),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
