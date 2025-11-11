import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/provider/delivery_details_provider.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dotted_box.dart';

class ConfirmDeliveryScreen extends StatefulWidget {
  final int? orderId;
  final String? type;

  const ConfirmDeliveryScreen({super.key, this.orderId, this.type});

  @override
  State<ConfirmDeliveryScreen> createState() => _ConfirmDeliveryScreenState();
}

class _ConfirmDeliveryScreenState extends State<ConfirmDeliveryScreen> {
  late final DeliveryDetailsProvider _provider;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _images.add(photo);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to open camera: $e')));
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile>? photos = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (photos != null && photos.isNotEmpty) {
        setState(() {
          _images.addAll(photos);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to open gallery: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _provider = DeliveryDetailsProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orderId != null) {
        _provider.fetchOrderDetails(
          context,
          orderId: widget.orderId!,
          type: widget.type ?? 'cart',
        );
      }
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  String _getCustomerName(Map<String, dynamic>? details) {
    return details?['customer']?['fullName'] ?? '---';
  }

  String _getCustomerAddress(Map<String, dynamic>? details) {
    return details?['address']?['fullAddress'] ?? '---';
  }

  String _getTotalAmount(Map<String, dynamic>? details) {
    return details?['totalAmount']?.toString() ?? '0.00';
  }

  String _getOrderType(Map<String, dynamic>? details) {
    return details?['type']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeliveryDetailsProvider>.value(
      value: _provider,
      child: Consumer<DeliveryDetailsProvider>(
        builder: (context, provider, _) {
          final details = provider.details;
          final name = _getCustomerName(details);
          final address = _getCustomerAddress(details);
          final amount = _getTotalAmount(details);

          return Scaffold(
            appBar: CommonAppbar(
              title: 'Confirm Delivery',
              text: 'Awaiting Confirmation',
              code: '#DEL${widget.orderId ?? ''}',
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(8.0.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    verificationColor,
                    const Color.fromARGB(255, 218, 247, 239),
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0.r),
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            DeliveryConfirmCont(
                              name: name,
                              address: address,
                              rupee: amount,
                              items:
                                  '${details?['cart']?['cartDetails']?.length ?? 0} items',
                            ),

                            SizedBox(height: 20.h),
                            _confirmationContainer(),
                            SizedBox(height: 20.h),
                            // Show empty bottle section only for subscription orders
                            if (_getOrderType(details).toLowerCase() ==
                                'subscription') ...[
                              _EmptyBottleContainer(),
                              SizedBox(height: 20.h),
                            ],
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _confirmationContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            'Choose Confirmation Method',
            style: TextStyle(
              fontSize: 14.sp,
              color: AllColors.verifyheadingcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 225, 255, 247),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Photo Proof',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AllColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CommonIconBackgCont(
            icon: Icon(Icons.security, color: AllColors.primaryColor),
            backgroundColor: const Color.fromARGB(255, 230, 255, 248),
          ),
          SizedBox(height: 10.h),
          Text(
            'Photo Proof',
            style: TextStyle(
              fontSize: 14.sp,
              color: AllColors.verifyheadingcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Take a photo showing the delivered items or customer receipt',
            style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
          ),
          SizedBox(height: 10.h),
          CommonDottedBox(
            paddding: EdgeInsets.all(10.r),
            width: double.infinity,
            child: Column(
              children: [
                // Show selected images (camera or gallery)
                if (_images.isNotEmpty) ...[
                  SizedBox(
                    height: 90.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, i) {
                        final xfile = _images[i];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                File(xfile.path),
                                width: 120.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _images.removeAt(i));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  padding: EdgeInsets.all(4.r),
                                  child: Icon(
                                    Icons.close,
                                    size: 16.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                ] else ...[
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 35.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No photo captured yet',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 12.h),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5.w),
                    Expanded(
                      child: CommonButton(
                        isfullWidth: false,
                        buttonValue: 'Take Photo',
                        onTap: () async => await _takePhoto(),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: AllColors.deliverydetailfontColor,
                        ),
                        borderRadius: 4.r,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 2.h,
                        ),
                        backgroundColor: Colors.transparent,
                        outlineColor: Colors.grey,
                        boxConstraints: BoxConstraints(
                          maxWidth: 40.w,
                          maxHeight: 20.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: CommonButton(
                        borderRadius: 4.r,
                        isfullWidth: false,
                        boxConstraints: BoxConstraints(
                          maxWidth: 40.w,
                          maxHeight: 20.h,
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: AllColors.deliverydetailfontColor,
                        ),
                        backgroundColor: Colors.transparent,
                        outlineColor: Colors.grey,
                        buttonValue: 'Upload File',
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 2.h,
                        ),
                        onTap: () async => await _pickFromGallery(),
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _EmptyBottleContainer() {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Empty Bottles Collected',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text('2 Items', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            'No. Of Empty Bottles',
            style: TextStyle(color: Colors.grey[850], fontSize: 11.sp),
          ),
          SizedBox(height: 10.h),
          CommonTextfield(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0.h,
              horizontal: 5.w,
            ),
            hintText: 'Enter the numbers',
            fillColor: Colors.white,
            borderColor: Colors.grey.shade300,
            radius: 12.r,
          ),
        ],
      ),
    );
  }
}
