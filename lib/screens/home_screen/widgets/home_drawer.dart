import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/home_screen/provider/homeProvider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/drawerMenuItemWidget.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: 10.h),
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 35.r,
                          backgroundImage: const AssetImage(
                            "assets/images/profilePhoto.png",
                          ),
                        ),
                      ),
                      SizedBox(width: 6.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.user?.fullName ?? 'Delivery Partner',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              provider.user?.mobileNumber ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 10.h),
              Divider(height: 1, color: Colors.grey.shade200),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerMenuItem(
                    icon: Icons.inventory_2_outlined,
                    text: 'My Delivery',
                    onTap: () {
                      context.push(AppRoutes.deliveryListScreen);
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.map_outlined,
                    text: 'Live Map',
                    onTap: () {
                      context.push(AppRoutes.routeNavigationScreen);
                    },
                  ),
                ],
              ),
              const Spacer(),
              Divider(height: 1, color: Colors.grey.shade200),
              Column(
                children: [
                  DrawerMenuItem(
                    icon: Icons.delete_outline_rounded,
                    text: 'Delete Account',
                    iconColor: Colors.red.shade400,
                    iconBackgroundColor: Colors.red.shade50,
                    textColor: Colors.red.shade400,
                    onTap: () => _handleDeleteAccount(context),
                  ),
                  DrawerMenuItem(
                    icon: Icons.logout_rounded,
                    text: 'Logout',
                    iconColor: Colors.red.shade400,
                    iconBackgroundColor: Colors.red.shade50,
                    textColor: Colors.red.shade400,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(12.w),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AllColors.drawerIconBackColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red.shade600,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Delete Confirmation',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to delete your account? This action cannot be undone and all your data will be removed.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(ctx).pop(false),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AllColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AllColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: provider.isLoading
                          ? null
                          : () async {
                              final success = await provider.deleteAccount(ctx);
                              Navigator.of(ctx).pop(success);
                            },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: provider.isLoading
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await MySecureStorage().deleteToken();
      MySnackBar.showSnackBar(context, 'Account deleted successfully');
      Navigator.pop(context);
      context.go(AppRoutes.loginscreen);
    } else if (confirmed == false) {
      MySnackBar.showSnackBar(context, 'Deletion cancelled');
    } else {
      MySnackBar.showSnackBar(context, 'Deletion failed');
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(12.w),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Logout Confirmation',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to logout? You will need to login again to access your account.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(ctx).pop(false),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AllColors.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AllColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(ctx).pop(true),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await MySecureStorage().deleteToken();
      context.pop(); // Close drawer
      context.go(AppRoutes.loginscreen);
    }
  }
}
