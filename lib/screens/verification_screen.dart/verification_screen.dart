import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'widgets/dotted_container.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final ImagePicker _picker = ImagePicker();

  String? _idPhotoPath;
  String? _drivingLicensePath;
  String? _vehicleRegistrationPath;
  String? _idPhotoUrl;
  String? _drivingLicenseUrl;
  String? _vehicleRegistrationUrl;

  bool _uploadingId = false;
  bool _uploadingDriving = false;
  bool _uploadingVehicle = false;
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _pickAndUpload(String docType, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked == null) return;

      setState(() {
        if (docType == 'idPhoto') {
          _idPhotoPath = picked.path;
          _uploadingId = true;
        } else if (docType == 'drivingLicense') {
          _drivingLicensePath = picked.path;
          _uploadingDriving = true;
        } else if (docType == 'vehicleRegistration') {
          _vehicleRegistrationPath = picked.path;
          _uploadingVehicle = true;
        }
      });

      final dio = DioHttp();
      final resp = await dio.uploadKYCDocument(
        context,
        documentType: docType,
        filePath: picked.path,
      );

      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300) {
        // parse fileUrl from response and save it for registration payload
        final fileUrl = resp.data?['data']?['fileUrl'] as String?;
        if (fileUrl != null) {
          if (docType == 'idPhoto') _idPhotoUrl = fileUrl;
          if (docType == 'drivingLicense') _drivingLicenseUrl = fileUrl;
          if (docType == 'vehicleRegistration')
            _vehicleRegistrationUrl = fileUrl;
        }

        MySnackBar.showSnackBar(context, 'Uploaded $docType successfully');
      } else {
        MySnackBar.showSnackBar(context, 'Upload failed for $docType');
        setState(() {
          if (docType == 'idPhoto') {
            _idPhotoPath = null;
          } else if (docType == 'drivingLicense') {
            _drivingLicensePath = null;
          } else if (docType == 'vehicleRegistration') {
            _vehicleRegistrationPath = null;
          }
        });
      }
    } catch (e) {
      MySnackBar.showSnackBar(context, 'Error uploading document');
      // log or handle
    } finally {
      setState(() {
        _uploadingId = false;
        _uploadingDriving = false;
        _uploadingVehicle = false;
      });
    }
  }

  Widget _buildDottedBox({
    required String title,
    required String subTitle,
    required bool isUploaded,
    String? fileName,
    required VoidCallback onTakePhoto,
    required VoidCallback onUploadFile,
    Widget? preview,
    VoidCallback? onRemove,
    required Widget icon,
    bool uploading = false,
  }) {
    return DottedUploadBox(
      backgroundColor: Colors.white,
      title: title,
      subTitle: subTitle,
      isUploaded: isUploaded,
      fileName: fileName,
      icon: uploading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : icon,
      onTakePhoto: onTakePhoto,
      onUploadFile: onUploadFile,
      preview: preview,
      onRemove: onRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'Verification'),
      backgroundColor: AllColors.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextfield(
              hintText: 'Full Name',
              textEditingController: fullnameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10.h),
            CommonTextfield(
              hintText: 'Email Address',
              textEditingController: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10.h),

            CommonTextfield(
              hintText: 'Mobile Number',
              textEditingController: mobileController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10.h),

            CommonTextfield(
              hintText: 'Password',
              textEditingController: passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),

            SizedBox(height: 20.h),

            _buildDottedBox(
              title: "ID Photo",
              subTitle: "Take a clear photo of your government ID",
              isUploaded: _idPhotoPath != null,
              fileName: _idPhotoPath != null
                  ? _idPhotoPath!.split('/').last
                  : null,
              icon: _idPhotoPath != null
                  ? Icon(Icons.check, size: 20.sp, color: Color(0xFF41C19E))
                  : Icon(
                      Icons.file_upload_outlined,
                      size: 20.sp,
                      color: AllColors.deliverydetailfontColor,
                    ),
              uploading: _uploadingId,
              onTakePhoto: () => _pickAndUpload('idPhoto', ImageSource.camera),
              onUploadFile: () =>
                  _pickAndUpload('idPhoto', ImageSource.gallery),
              preview: _idPhotoPath != null
                  ? Image.file(File(_idPhotoPath!), fit: BoxFit.cover)
                  : null,
              onRemove: _idPhotoPath != null
                  ? () {
                      setState(() {
                        _idPhotoPath = null;
                        _idPhotoUrl = null;
                      });
                    }
                  : null,
            ),

            SizedBox(height: 18.h),

            _buildDottedBox(
              title: "Driving License",
              subTitle: "Upload your valid driving license",
              isUploaded: _drivingLicensePath != null,
              fileName: _drivingLicensePath != null
                  ? _drivingLicensePath!.split('/').last
                  : null,
              icon: _drivingLicensePath != null
                  ? Icon(Icons.check, size: 20.sp, color: Color(0xFF41C19E))
                  : Icon(
                      Icons.file_copy_outlined,
                      size: 18.sp,
                      color: AllColors.deliverydetailfontColor,
                    ),
              uploading: _uploadingDriving,
              onTakePhoto: () =>
                  _pickAndUpload('drivingLicense', ImageSource.camera),
              onUploadFile: () =>
                  _pickAndUpload('drivingLicense', ImageSource.gallery),
              preview: _drivingLicensePath != null
                  ? Image.file(File(_drivingLicensePath!), fit: BoxFit.cover)
                  : null,
              onRemove: _drivingLicensePath != null
                  ? () {
                      setState(() {
                        _drivingLicensePath = null;
                        _drivingLicenseUrl = null;
                      });
                    }
                  : null,
            ),

            SizedBox(height: 18.h),

            _buildDottedBox(
              title: "Vehicle Registration",
              subTitle: "Upload your vehicle registration document",
              isUploaded: _vehicleRegistrationPath != null,
              fileName: _vehicleRegistrationPath != null
                  ? _vehicleRegistrationPath!.split('/').last
                  : null,
              icon: _vehicleRegistrationPath != null
                  ? Icon(Icons.check, size: 20.sp, color: Color(0xFF41C19E))
                  : Icon(
                      Icons.file_copy_outlined,
                      size: 18.sp,
                      color: AllColors.deliverydetailfontColor,
                    ),
              uploading: _uploadingVehicle,
              onTakePhoto: () =>
                  _pickAndUpload('vehicleRegistration', ImageSource.camera),
              onUploadFile: () =>
                  _pickAndUpload('vehicleRegistration', ImageSource.gallery),
              preview: _vehicleRegistrationPath != null
                  ? Image.file(
                      File(_vehicleRegistrationPath!),
                      fit: BoxFit.cover,
                    )
                  : null,
              onRemove: _vehicleRegistrationPath != null
                  ? () {
                      setState(() {
                        _vehicleRegistrationPath = null;
                        _vehicleRegistrationUrl = null;
                      });
                    }
                  : null,
            ),

            SizedBox(height: 22.h),

            CommonButton(
              isfullWidth: true,
              buttonValue: "Complete Verification",
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              onTap: _registerDeliveryPartner,
            ),

            SizedBox(height: 14.h),

            Align(
              alignment: Alignment.center,
              child: Text(
                "Your documents will be reviewed within 24 hours",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerDeliveryPartner() async {
    final fullName = fullnameController.text.trim();
    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty) {
      MySnackBar.showSnackBar(context, 'Please fill all required fields');
      return;
    }

    if (_idPhotoUrl == null ||
        _drivingLicenseUrl == null ||
        _vehicleRegistrationUrl == null) {
      MySnackBar.showSnackBar(context, 'Please upload all required documents');
      return;
    }

    setState(() {});

    try {
      final dio = DioHttp();
      final resp = await dio.registerDeliveryPartner(
        context,
        fullName: fullName,
        emailId: email,
        mobileNumber: mobile,
        password: password,
        idPhotoUrl: _idPhotoUrl!,
        drivingLicenseUrl: _drivingLicenseUrl!,
        vehicleRegistrationUrl: _vehicleRegistrationUrl!,
      );

      final returnCode =
          resp.data?['dataResponse']?['returnCode'] as int? ?? -1;
      final description =
          resp.data?['dataResponse']?['description'] as String? ??
          'Unknown error';

      if (returnCode == 0) {
        final token = resp.data?['data']?['token'] as String?;
        if (token != null) {
          final storage = MySecureStorage();
          await storage.writeToken(token);
        }
        MySnackBar.showSnackBar(context, 'Registration successful');
        // navigate to home
        if (mounted) context.go(AppRoutes.homeScreen);
      } else {
        MySnackBar.showSnackBar(context, 'Registration failed: $description');
      }
    } catch (e) {
      MySnackBar.showSnackBar(context, 'Error during registration');
    }
  }
}
