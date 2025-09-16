// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
// import 'package:vedasip_delivery_app/core/theme/theme.dart';
// import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
// import 'package:vedasip_delivery_app/core/utils/common_widgets/dotted_container.dart';
// import 'package:vedasip_delivery_app/feature/verification%20screen/widgets/common_verify_button.dart';

// class VerificationScreen extends StatelessWidget {
//   const VerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [verificationColor, Color.fromARGB(255, 218, 247, 239)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Complete Your Profile',
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                     color: verifyheadingcolor,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   'Please upload the following documents',
//                   style: TextStyle(
//                     fontSize: 9.sp,
//                     color: const Color.fromARGB(255, 106, 106, 106),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5.0),
//                   child: Column(
//                     children: [
//                       DottedContainer(
//                         title: 'ID Photo',
//                         subtitle: 'Take a clear photo of your government ID',
//                         icon: Icons.check_rounded,
//                         button: CommonVerifyButton(
//                           buttonValue: 'Replace',
//                           width: 60.w,
//                           backgroundColor: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 15.h),
//                       DottedContainer(
//                         title: 'Driving License',
//                         subtitle: 'Take a clear photo of your government ID',
//                         icon: Icons.plagiarism_outlined,
//                         button: CommonVerifyButton(
//                           buttonValue: 'Replace',
//                           width: 60.w,
//                           backgroundColor: Colors.white,
//                         ),
//                         button2: CommonVerifyButton(
//                           buttonValue: 'Upload File',
//                           width: 60.w,
//                           backgroundColor: Colors.white,
//                         ),
//                       ),

//                       SizedBox(height: 15.h),
//                       DottedContainer(
//                         title: 'Vehicle Registration',
//                         subtitle: 'Upload your vehicle registration document',
//                         icon: Icons.plagiarism_outlined,
//                         button: CommonVerifyButton(
//                           buttonValue: 'Replace',
//                           width: 60.w,
//                           backgroundColor: Colors.white,
//                         ),
//                         button2: CommonVerifyButton(
//                           buttonValue: 'Upload File',
//                           width: 60.w,
//                           backgroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 CommonButton(
//                   buttonValue: 'Complete Verification',
//                   onTap: () {
//                     GoRouter.of(context).pushNamed(AppRoutes.homeScreen);
//                   },
//                 ),
//                 SizedBox(height: 5),
//                 Center(
//                   child: Text(
//                     'By logging in, you agree to our Terms of Service',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: const Color.fromARGB(255, 136, 136, 136),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
