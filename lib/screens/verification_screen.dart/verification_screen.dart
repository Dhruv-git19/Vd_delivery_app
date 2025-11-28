import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'widgets/dotted_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
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

  bool _uploadingId = false;
  bool _uploadingDriving = false;
  bool _uploadingVehicle = false;


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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'Verification'),
      backgroundColor: AllColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete Your Profile",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AllColors.verifyheadingcolor,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                "Upload required document to start delivering",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 15.h),

              Text(
                "37% complete",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 6.h),

              Container(
                height: 6.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.37,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF41C19E),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
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
                onTakePhoto: () =>
                    _pickAndUpload('idPhoto', ImageSource.camera),
                onUploadFile: () =>
                    _pickAndUpload('idPhoto', ImageSource.gallery),
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
                // You can add onTap to submit or move forward depending on the flow
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
      ),
    );
  }
}
