// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:veedasip/core/theme/theme.dart';
// import 'package:veedasip/core/utils/common_widgets/common_button.dart';
// import 'package:veedasip/core/utils/common_widgets/common_dotted_box.dart';
// import 'package:veedasip/core/utils/common_widgets/common_icon_backg_cont.dart';
// import 'package:veedasip/core/utils/common_widgets/common_textfield.dart';

// class CustomTabWidget extends StatelessWidget {
//   final String heading;
//   final String title1;
//   final String title2;
//   final Icon icon;
//   final String iconheading;
//   final String iconSubheading;
//   final bool? isIconNeeded;
//   final String icontext;
//   final Icon? icon2;

//   const CustomTabWidget({
//     super.key,
//     required this.heading,
//     required this.title1,
//     required this.title2,
//     required this.icon,
//     required this.iconheading,
//     required this.iconSubheading,
//     required this.icontext,
//     required this.icon2,
//     this.isIconNeeded,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade400),
//         ),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               heading,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: AllColors.verifyheadingcolor,
//               ),
//             ),
//             SizedBox(height: 10),
//             TabBar(
//               dividerColor: Colors.transparent,
//               labelColor: Colors.white,
//               labelStyle: TextStyle(fontWeight: FontWeight.bold),
//               unselectedLabelColor: AllColors.primaryColor,
//               indicator: BoxDecoration(
//                 color: AllColors.primaryColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               indicatorSize: TabBarIndicatorSize.tab,
//               tabs: [
//                 Tab(text: title1),
//                 Tab(text: title2),
//               ],
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               height: 280,
//               child: TabBarView(
//                 children: [
//                   Column(
//                     children: [
//                       ConfirmationMethod(
//                         isuploadneeded: isIconNeeded ?? false,
//                         icon: icon,
//                         iconHeading: iconheading,
//                         iconsubheading: iconSubheading,
//                         uploadtext: icontext,
//                         innericon:
//                             icon2 ?? Icon(Icons.qr_code_2_outlined, size: 30),
//                       ),
//                     ],
//                   ),
//                   Column(children: [ConfirmationMethod2()]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConfirmationMethod extends StatelessWidget {
//   final Icon icon;
//   final String iconHeading;
//   final String iconsubheading;
//   final bool? isuploadneeded;
//   final String uploadtext;
//   final Icon innericon;

//   const ConfirmationMethod({
//     super.key,
//     required this.icon,
//     required this.iconHeading,
//     required this.iconsubheading,
//     required this.uploadtext,
//     required this.innericon,
//     this.isuploadneeded,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(height: 10),
//         CommonIconBackgCont(icon: icon),
//         Text(
//           iconHeading,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: AllColors.verifyheadingcolor,
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           iconsubheading,
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//             color: AllColors.verifyheadingcolor,
//           ),
//         ),
//         SizedBox(height: 20),

//         if (isuploadneeded ?? false) ...[
//           CommonDottedBox(
//             child: Column(
//               children: [
//                 SizedBox(height: 10),
//                 icon,
//                 Text(
//                   uploadtext,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 //   children: [
//                 //     CommonButton(buttonValue: 'Upload Photo'),
//                 //     CommonButton(buttonValue: 'Upload File'),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ] else ...[
//           CommonTextfield(hintText: '', labelText: 'Enter OTP'),
//           SizedBox(height: 20),
//           CommonButton(buttonValue: 'Confirm Delivery', onTap: () {}),
//         ],
//       ],
//     );
//   }
// }

// class ConfirmationMethod2 extends StatelessWidget {
//   final Icon? icon;
//   final bool isuploadneeded = false;
//   final String? uploadtext;
//   const ConfirmationMethod2({super.key, this.icon, this.uploadtext});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CommonIconBackgCont(
//           icon: Icon(Icons.security_rounded, color: AllColors.primaryColor),
//         ),
//         Text(
//           'Photo Proof',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: AllColors.verifyheadingcolor,
//           ),
//         ),
//         Text(
//           'ASK the customer for their 4- digit delivery confirmation code',
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//             color: AllColors.verifyheadingcolor,
//           ),
//         ),
//         SizedBox(height: 20),

//         CommonDottedBox(
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               icon ??
//                   Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 40),
//               Text(
//                 uploadtext ?? 'No photo uploaded yet',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                 ),
//               ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //   children: [
//               //     CommonButton(buttonValue: 'Upload Photo'),
//               //     CommonButton(buttonValue: 'Upload File'),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ConfirmationMethod3 extends StatelessWidget {
//   final Icon icon;
//   final String iconHeading;
//   final String iconsubheading;
//   const ConfirmationMethod3({
//     super.key,
//     required this.icon,
//     required this.iconHeading,
//     required this.iconsubheading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(height: 10),
//         CommonIconBackgCont(icon: icon),
//         Text(
//           iconHeading,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: AllColors.verifyheadingcolor,
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           iconsubheading,
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//             color: AllColors.verifyheadingcolor,
//           ),
//         ),
//         SizedBox(height: 20),
//         DottedBorder(child: Column()),
//         SizedBox(height: 20),
//         CommonButton(buttonValue: 'Confirm Delivery', onTap: () {}),
//       ],
//     );
//   }
// }
