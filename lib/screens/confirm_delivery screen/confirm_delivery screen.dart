import 'dart:developer';

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
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';

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
  final TextEditingController _bottleController = TextEditingController();
  bool _isSubmitting = false;

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
    _bottleController.dispose();
    super.dispose();
  }

  Future<void> _submitOrderProof() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one proof image')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final dioHttp = DioHttp();
      final filePaths = _images.map((xfile) => xfile.path).toList();

      final uploadResponse = await dioHttp.uploadProofImages(
        context,
        filePaths: filePaths,
      );

      final List<String> uploadedUrls = [];
      if (uploadResponse.data['data'] is List) {
        for (var item in uploadResponse.data['data']) {
          if (item['fileUrl'] != null) {
            uploadedUrls.add(item['fileUrl']);
          }
        }
      }

      if (uploadedUrls.isEmpty) {
        throw Exception('No file URLs returned from upload');
      }

      final orderType = _getOrderType(_provider.details);
      final submitResponse = await dioHttp.submitOrderProof(
        context,
        orderId: widget.orderId.toString(),
        type: orderType.toLowerCase(),
        currentLat: position.latitude,
        currentLng: position.longitude,
        uploadedFileUrls: uploadedUrls,
        exchangeBottleCount: orderType.toLowerCase() == 'subscription'
            ? _bottleController.text
            : null,
      );

      if (mounted) {
        final returnCode =
            submitResponse.data['dataResponse']?['returnCode'] ?? -1;
        final description =
            submitResponse.data['dataResponse']?['description'] ??
            'Unknown error';

        if (returnCode == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(description), backgroundColor: Colors.green),
          );

          context.push(
            AppRoutes.paymentCollectionScreen,
            extra: {'id': widget.orderId, 'type': widget.type},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(description),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting proof: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: CommonButton(
                buttonValue: 'Confirm Order',
                isfullWidth: true,
                isLoading: _isSubmitting,
                onTap: _isSubmitting ? null : _submitOrderProof,
              ),
            ),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      children: [
                        DeliveryConfirmCont(
                          name: name,
                          address: address,
                          rupee: amount,
                          items:
                              '${details?['cart']?['cartDetails']?.length ?? 0} items',
                        ),
                        SizedBox(height: 16.h),
                        _confirmationContainer(),
                        SizedBox(height: 16.h),
                        if (_getOrderType(details).toLowerCase() ==
                            'subscription') ...[
                          _EmptyBottleContainer(),
                          SizedBox(height: 20.h),
                        ],
                      ],
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proof of Delivery',
            style: TextStyle(
              fontSize: 15.sp,
              color: AllColors.verifyheadingcolor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Capture a clear photo of the delivered items or door/gate as proof.',
            style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 12.h),

          /// Icon + short label
          Row(
            children: [
              CommonIconBackgCont(
                icon: Icon(Icons.security, color: AllColors.primaryColor),
                backgroundColor: const Color.fromARGB(255, 230, 255, 248),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Photos help us verify successful delivery and avoid disputes.',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),
          CommonDottedBox(
            paddding: EdgeInsets.all(10.r),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 32.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'No photo captured yet',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Add at least one photo as delivery proof.',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],

                /// Action buttons
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        buttonValue: 'Take Photo',
                        isfullWidth: true,
                        onTap: _takePhoto,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CommonButton(
                        buttonValue: 'From Gallery',
                        isfullWidth: true,
                        onTap: _pickFromGallery,
                        backgroundColor: Colors.white,
                        outlineColor: AllColors.primaryColor,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: AllColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          /// Title row
          Row(
            children: [
              Text(
                'Empty Bottles Collected',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Enter how many empty bottles you collected from the customer (if any).',
            style: TextStyle(color: Colors.grey[700], fontSize: 11.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            'Number of empty bottles',
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          CommonTextfield(
            textEditingController: _bottleController,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 10.w,
            ),
            hintText: 'Enter count (e.g. 2)',
            fillColor: Colors.white,
            borderColor: Colors.grey.shade300,
            radius: 12.r,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
