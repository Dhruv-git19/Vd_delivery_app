import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  Future<void> _launchExternal(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        MySnackBar.showSnackBar(context, 'Could not open');
      }
    } catch (_) {
      MySnackBar.showSnackBar(context, 'Could not open');
    }
  }

  Widget _contactRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AllColors.deliverydetailBoundary),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: AllColors.drawerIconBackColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 20.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AllColors.deliverydetailshadelight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 22.r),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const phoneDisplay = '+91 94141 03794';
    const email = 'veedasip@gmail.com';
    final phoneUri = Uri.parse('tel:+919414103794');
    final emailUri = Uri.parse('mailto:$email');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppbar(title: 'Contact Support'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact support for delivery partners',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AllColors.verifyheadingcolor,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Tap to call or email',
              style: TextStyle(
                fontSize: 12.sp,
                color: AllColors.deliverydetailshadelight,
              ),
            ),
            SizedBox(height: 14.h),
            _contactRow(
              context: context,
              icon: Icons.phone_in_talk_outlined,
              label: 'Phone',
              value: phoneDisplay,
              onTap: () => _launchExternal(context, phoneUri),
            ),
            SizedBox(height: 10.h),
            _contactRow(
              context: context,
              icon: Icons.mail_outline,
              label: 'Email',
              value: email,
              onTap: () => _launchExternal(context, emailUri),
            ),
          ],
        ),
      ),
    );
  }
}
