// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:helpero/feature/bookings/widget/profile_card.dart';
// import 'package:helpero/feature/widget/service_provider_profile_card.dart';
// import 'package:sizer/sizer.dart';
//
// import '../bookings/model/profile_model.dart';
//
// class ServiceCard extends StatefulWidget {
//   final String imagePath;
//   final String title;
//   final String price;
//   final String provider;
//   final double rating;
//   final bool isFromBestServiceScreen;
//   final VoidCallback onTap;
//
//   const ServiceCard({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.price,
//     required this.provider,
//     required this.rating,
//     this.isFromBestServiceScreen = false,
//     required this.onTap,
//   });
//
//   @override
//   State<ServiceCard> createState() => _ServiceCardState();
// }
//
// class _ServiceCardState extends State<ServiceCard> {
//   late double currentRating;
//
//   @override
//   void initState() {
//     super.initState();
//     currentRating = widget.rating;
//   }
//
//   void onRatingUpdate(double rating) {
//     setState(() {
//       // currentRating = rating;
//     });
//     print("New rating: $rating");
//   }
//
//   Profile profile = Profile(
//     name: 'Ronald Richards',
//     serviceName: 'Service Provider',
//     phoneNumber: '1234567890',
//     imageUrl:
//         'https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg',
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: widget.onTap,
//       child: Container(
//         width: widget.isFromBestServiceScreen ? 100.w : 70.w,
//         margin: widget.isFromBestServiceScreen
//             ? EdgeInsets.zero
//             : EdgeInsets.only(right: 16),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(9),
//             side: BorderSide(color: Colors.grey.shade400),
//           ),
//           elevation: 1,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(9),
//                 ),
//                 child: Image.asset(
//                   widget.imagePath,
//                   height: widget.isFromBestServiceScreen ? 15.h : 13.h,
//                   width: double.infinity,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 1.5.w,
//                   vertical: 0.5.h,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         RatingBarIndicator(
//                           rating: widget.rating,
//                           itemBuilder: (context, index) =>
//                               const Icon(Icons.star, color: Colors.amber),
//                           itemCount: 5,
//                           itemSize: 15, // size of each star
//                           direction: Axis.horizontal,
//                         ),
//                         Text(
//                           "(130 Reviews)",
//                           style: Theme.of(context).textTheme.labelSmall,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 0.5.h),
//                     Text(
//                       widget.title,
//                       style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 0.5.h),
//                     Text(
//                       widget.price,
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     SizedBox(height: 0.5.h),
//                     Text(
//                       widget.provider,
//                       style: Theme.of(context).textTheme.labelSmall,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 0.5.h),
//                     ServiceProviderProfileCard(
//                       profile: profile,
//                       isFromBestServiceScreen: widget.isFromBestServiceScreen,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
