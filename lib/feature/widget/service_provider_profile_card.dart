// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class ServiceProviderProfileCard extends StatefulWidget {
//   final bool isFromBestServiceScreen;
//   const ServiceProviderProfileCard({
//     super.key,
//     required this.isFromBestServiceScreen,
//   });
//
//   @override
//   State<ServiceProviderProfileCard> createState() =>
//       _ServiceProviderProfileCardState();
// }
//
// class _ServiceProviderProfileCardState
//     extends State<ServiceProviderProfileCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.grey.shade200,
//           radius: widget.isFromBestServiceScreen ? 25 : 20,
//           backgroundImage: widget.profile.imageUrl.isNotEmpty
//               ? NetworkImage(widget.profile.imageUrl)
//               : const AssetImage('assets/images/user.png') as ImageProvider,
//         ),
//         SizedBox(width: 1.5.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.profile.name,
//                 style: widget.isFromBestServiceScreen
//                     ? Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       )
//                     : Theme.of(context).textTheme.bodySmall?.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//               ),
//               SizedBox(height: widget.isFromBestServiceScreen ? 0.2.h : 0.5.h),
//               Text(
//                 widget.profile.serviceName,
//                 style: widget.isFromBestServiceScreen
//                     ? Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Theme.of(context).colorScheme.onBackground,
//                       )
//                     : Theme.of(context).textTheme.labelSmall?.copyWith(
//                         color: Theme.of(context).colorScheme.onBackground,
//                       ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 1.5.w),
//         OutlinedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           style: OutlinedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             side: BorderSide(color: Theme.of(context).colorScheme.primary),
//             backgroundColor: Theme.of(context).colorScheme.primary,
//           ),
//           child: Text(
//             "Add",
//             style: Theme.of(context).textTheme.labelMedium?.copyWith(
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//           ),
//         ),
//         SizedBox(width: 2.w),
//       ],
//     );
//   }
// }
