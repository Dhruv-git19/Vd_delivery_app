import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/common_widgets/common_appbar.dart';
import '../../core/utils/common_widgets/common_button.dart';
import '../../core/utils/common_widgets/common_delivery_confirm_cont.dart';
import '../../core/utils/common_widgets/common_dotted_box.dart';
import '../../core/utils/common_widgets/common_textfield.dart';
import '../../services/dio_http.dart';
import '../../widget/snack_bar.dart';
import '../delivery_details_screen/provider/delivery_details_provider.dart';

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
  final List<XFile> _bottleImages = [];
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
        MySnackBar.showSnackBar(context, "Unable to open camera: $e");
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> photos = await _picker.pickMultiImage(imageQuality: 80);
      if (photos.isNotEmpty) {
        setState(() {
          _images.addAll(photos);
        });
      }
    } catch (e) {
      if (mounted) {
        MySnackBar.showSnackBar(context, "Unable to open gallery: $e");
      }
    }
  }

  Future<void> _takeBottlePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _bottleImages.add(photo);
        });
      }
    } catch (e) {
      if (mounted) {
        MySnackBar.showSnackBar(context, "Unable to open camera: $e");
      }
    }
  }

  Future<void> _pickBottleFromGallery() async {
    try {
      final List<XFile> photos = await _picker.pickMultiImage(imageQuality: 80);
      if (photos.isNotEmpty) {
        setState(() {
          _bottleImages.addAll(photos);
        });
      }
    } catch (e) {
      if (mounted) {
        MySnackBar.showSnackBar(context, "Unable to open gallery: $e");
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
      MySnackBar.showSnackBar(context, 'Please add at least one proof image');
      return;
    }

    if (widget.type == 'subscription') {
      final bottleCount = _bottleController.text.trim();
      if (bottleCount.isNotEmpty) {
        final count = int.tryParse(bottleCount);
        if (count == null || count <= 0) {
          MySnackBar.showSnackBar(context, 'Please enter a valid bottle count');
          return;
        }
        if (_bottleImages.isEmpty) {
          MySnackBar.showSnackBar(
            context,
            'Please add photos of collected bottles',
          );
          return;
        }
      }
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
          // support server returning list of strings (urls) or list of objects
          if (item is String) {
            uploadedUrls.add(item);
          } else if (item is Map && item['fileUrl'] != null) {
            uploadedUrls.add(item['fileUrl'].toString());
          } else if (item is Map && item['url'] != null) {
            uploadedUrls.add(item['url'].toString());
          }
        }
      }

      if (uploadedUrls.isEmpty) {
        throw Exception('No file URLs returned from upload');
      }

      if (widget.type == 'subscription') {
        final bottleCountText = _bottleController.text.trim();
        if (bottleCountText.isNotEmpty && _bottleImages.isNotEmpty) {
          final bottleCount = int.tryParse(bottleCountText) ?? 0;
          final bottleFilePaths = _bottleImages
              .map((xfile) => xfile.path)
              .toList();
          final bottleUploadResponse = await dioHttp.uploadProofImages(
            context,
            filePaths: bottleFilePaths,
          );

          final List<String> bottleUploadedUrls = [];
          if (bottleUploadResponse.data['data'] is List) {
            for (var item in bottleUploadResponse.data['data']) {
              if (item is String) {
                bottleUploadedUrls.add(item);
              } else if (item is Map && item['fileUrl'] != null) {
                bottleUploadedUrls.add(item['fileUrl'].toString());
              } else if (item is Map && item['url'] != null) {
                bottleUploadedUrls.add(item['url'].toString());
              }
            }
          }

          if (bottleUploadedUrls.isEmpty) {
            throw Exception('No bottle image URLs returned from upload');
          }
          final bottleCountResponse = await dioHttp
              .submitSubscriptionBottleCount(
                context,
                uploadedFileUrls: bottleUploadedUrls,
                subscriptionId: widget.orderId!,
                takenBottleCount: bottleCount,
              );

          final bottleReturnCode =
              bottleCountResponse.data['dataResponse']?['returnCode'] ?? -1;
          if (bottleReturnCode != 0) {
            final bottleDescription =
                bottleCountResponse.data['dataResponse']?['description'] ??
                'Failed to submit bottle count';
            MySnackBar.showSnackBar(context, bottleDescription);
            return;
          }
        }
      }

      final submitResponse = await dioHttp.submitOrderProof(
        context,
        orderId: widget.orderId.toString(),
        type: widget.type ?? 'cart',
        currentLat: position.latitude,
        currentLng: position.longitude,
        uploadedFileUrls: uploadedUrls,
        exchangeBottleCount: widget.type == 'subscription'
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
          MySnackBar.showSnackBar(context, description);

          context.push(
            AppRoutes.paymentCollectionScreen,
            extra: {'id': widget.orderId, 'type': widget.type},
          );
        } else {
          MySnackBar.showSnackBar(context, description);
        }
      }
    } catch (e) {
      if (mounted) {
        log("Error submitting order proof: $e");
        MySnackBar.showSnackBar(context, 'Error: $e');
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
                        if (widget.type == 'subscription') ...[
                          _emptyBottleContainer(),
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.camera_alt_rounded,
                size: 20.r,
                color: AllColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Proof of Delivery',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Capture a clear photo of the delivered items or door/gate as proof.',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AllColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AllColors.primaryColor.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: AllColors.primaryColor,
                  size: 20.r,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Photos help us verify successful delivery and avoid disputes.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AllColors.primaryColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
          CommonDottedBox(
            paddding: EdgeInsets.all(12.r),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_images.isNotEmpty) ...[
                  SizedBox(
                    height: 100.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (context, i) {
                        final xfile = _images[i];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(
                                File(xfile.path),
                                width: 140.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _images.removeAt(i));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(4.r),
                                  child: Icon(
                                    Icons.close,
                                    size: 16.r,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          size: 32.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'No photo captured yet',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Add at least one photo as delivery proof.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],

                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        buttonValue: 'Take Photo',
                        isfullWidth: true,
                        onTap: _takePhoto,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CommonButton(
                        buttonValue: 'Gallery',
                        isfullWidth: true,
                        onTap: _pickFromGallery,
                        backgroundColor: Colors.white,
                        outlineColor: AllColors.primaryColor,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
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

  Widget _emptyBottleContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.recycling_rounded, size: 20.r, color: Colors.green),
              SizedBox(width: 8.w),
              Text(
                'Empty Bottles Collected',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Enter how many empty bottles you collected from the customer (if any).',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            'Number of empty bottles',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          CommonTextfield(
            textEditingController: _bottleController,
            hintText: 'Enter count (e.g. 2)',
            fillColor: Colors.grey.shade50,
            borderColor: Colors.grey.shade200,
            radius: 12.r,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {});
            },
          ),
          if (_bottleController.text.trim().isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(
              'Bottle Collection Proof',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            CommonDottedBox(
              paddding: EdgeInsets.all(12.r),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_bottleImages.isNotEmpty) ...[
                    SizedBox(
                      height: 100.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _bottleImages.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
                        itemBuilder: (context, i) {
                          final xfile = _bottleImages[i];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  File(xfile.path),
                                  width: 140.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -8,
                                right: -8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _bottleImages.removeAt(i));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(4.r),
                                    child: Icon(
                                      Icons.close,
                                      size: 16.r,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.add_a_photo_rounded,
                            size: 32.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'No bottle photos yet',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          buttonValue: 'Take Photo',
                          isfullWidth: true,
                          onTap: _takeBottlePhoto,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CommonButton(
                          buttonValue: 'Gallery',
                          isfullWidth: true,
                          onTap: _pickBottleFromGallery,
                          backgroundColor: Colors.white,
                          outlineColor: AllColors.primaryColor,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
