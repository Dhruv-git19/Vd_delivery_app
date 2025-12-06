import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

import 'widgets/dotted_container.dart';

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
  bool _obscurePassword = true;
  bool _loadingAreas = false;
  String? emailError;
  String? mobileError;
  String? passwordError;
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Map<String, Object>> _areas = [];
  List<int> _selectedAreaIds = [];

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    setState(() {
      _loadingAreas = true;
    });

    try {
      final dio = DioHttp();
      final resp = await dio.getAllAreas(context, page: 1, pageSize: 100);

      final returnCode =
          resp.data?['dataResponse']?['returnCode'] as int? ?? -1;
      if (returnCode == 0) {
        final items = resp.data?['data']?['items'] as List<dynamic>? ?? [];
        setState(() {
          _areas = items
              .map(
                (e) => <String, Object>{
                  'id': e['id'] as int? ?? 0,
                  'areaName': e['areaName'] as String? ?? '',
                  'pinCode':
                      (e['pinCode'] is int
                          ? e['pinCode'].toString()
                          : e['pinCode'] as String?) ??
                      '',
                  'status': e['status'] as int? ?? 0,
                },
              )
              .where((area) => area['status'] == 1)
              .toList();
        });
      } else {
        MySnackBar.showSnackBar(context, 'Failed to load areas');
      }
    } catch (e) {
      log('Error fetching areas: $e');
      MySnackBar.showSnackBar(context, 'Error loading areas');
    } finally {
      setState(() {
        _loadingAreas = false;
      });
    }
  }

  void validateEmail(String value) {
    final emailRegExp = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      final v = value.trim();
      if (v.isEmpty) {
        emailError = null;
      } else if (!emailRegExp.hasMatch(v)) {
        emailError = 'Please enter a valid email address.';
      } else {
        emailError = null;
      }
    });
  }

  void validateMobile(String value) {
    final phoneRegExp = RegExp(r'^\d{10}$');
    setState(() {
      final v = value.trim();
      if (v.isEmpty) {
        mobileError = null;
      } else if (!phoneRegExp.hasMatch(v)) {
        mobileError = 'Please enter a valid 10-digit mobile number.';
      } else {
        mobileError = null;
      }
    });
  }

  void validatePassword(String value) {
    final pwdRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    setState(() {
      if (value.isEmpty) {
        passwordError = null;
      } else if (!pwdRegExp.hasMatch(value)) {
        passwordError =
            'Password must be 8+ chars, include uppercase, number & special char.';
      } else {
        passwordError = null;
      }
    });
  }

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
      if (resp.data?['dataResponse']?['returnCode'] == 0) {
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
            _idPhotoUrl = null;
          } else if (docType == 'drivingLicense') {
            _drivingLicensePath = null;
            _drivingLicenseUrl = null;
          } else if (docType == 'vehicleRegistration') {
            _vehicleRegistrationPath = null;
            _vehicleRegistrationUrl = null;
          }
        });
      }
    } catch (e) {
      setState(() {
        if (docType == 'idPhoto') {
          _idPhotoPath = null;
          _idPhotoUrl = null;
        } else if (docType == 'drivingLicense') {
          _drivingLicensePath = null;
          _drivingLicenseUrl = null;
        } else if (docType == 'vehicleRegistration') {
          _vehicleRegistrationPath = null;
          _vehicleRegistrationUrl = null;
        }
      });

      MySnackBar.showSnackBar(context, 'Error uploading document check logs');
      // log or handle
    } finally {
      setState(() {
        _uploadingId = false;
        _uploadingDriving = false;
        _uploadingVehicle = false;
      });
    }
  }

  /// Pick any file (images or pdf) from device storage and upload.
  Future<void> _pickAndUploadFile(String docType) async {
    try {
      // allow images and pdfs
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;
      final path = pickedFile.path;
      if (path == null) return;

      setState(() {
        if (docType == 'idPhoto') {
          _idPhotoPath = path;
          _uploadingId = true;
        } else if (docType == 'drivingLicense') {
          _drivingLicensePath = path;
          _uploadingDriving = true;
        } else if (docType == 'vehicleRegistration') {
          _vehicleRegistrationPath = path;
          _uploadingVehicle = true;
        }
      });

      final dio = DioHttp();
      final resp = await dio.uploadKYCDocument(
        context,
        documentType: docType,
        filePath: path,
      );

      if (resp.data?['dataResponse']?['returnCode'] == 0) {
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
            _idPhotoUrl = null;
          } else if (docType == 'drivingLicense') {
            _drivingLicensePath = null;
            _drivingLicenseUrl = null;
          } else if (docType == 'vehicleRegistration') {
            _vehicleRegistrationPath = null;
            _vehicleRegistrationUrl = null;
          }
        });
      }
    } catch (e) {
      setState(() {
        if (docType == 'idPhoto') {
          _idPhotoPath = null;
          _idPhotoUrl = null;
        } else if (docType == 'drivingLicense') {
          _drivingLicensePath = null;
          _drivingLicenseUrl = null;
        } else if (docType == 'vehicleRegistration') {
          _vehicleRegistrationPath = null;
          _vehicleRegistrationUrl = null;
        }
      });
      MySnackBar.showSnackBar(context, 'Error uploading document');
    } finally {
      setState(() {
        _uploadingId = false;
        _uploadingDriving = false;
        _uploadingVehicle = false;
      });
    }
  }

  Widget? _buildFilePreview(String? path) {
    if (path == null) return null;
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) {
      final fileName = path.split('/').last;
      return Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(fileName, style: TextStyle(fontSize: 12.sp)),
            ),
          ],
        ),
      );
    }

    // for images, show actual image
    return Image.file(File(path), fit: BoxFit.cover);
  }

  void _showAreaSelectionDialog() {
    final tempSelected = List<int>.from(_selectedAreaIds);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Select Delivery Areas',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _areas.length,
              itemBuilder: (context, index) {
                final area = _areas[index];
                final areaId = area['id'] as int;
                final areaName = area['areaName'] as String;
                final pinCode = area['pinCode'] as String;
                final isSelected = tempSelected.contains(areaId);

                return CheckboxListTile(
                  title: Text(areaName, style: TextStyle(fontSize: 14.sp)),
                  subtitle: Text(
                    'PIN: $pinCode',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setDialogState(() {
                      if (value == true) {
                        tempSelected.add(areaId);
                      } else {
                        tempSelected.remove(areaId);
                      }
                    });
                  },
                  activeColor: primaryColor,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedAreaIds = tempSelected;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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
              errorText: emailError,
              onChanged: (v) => validateEmail(v),
            ),
            SizedBox(height: 10.h),

            CommonTextfield(
              hintText: 'Mobile Number',
              textEditingController: mobileController,
              keyboardType: TextInputType.phone,
              errorText: mobileError,
              onChanged: (v) => validateMobile(v),
            ),
            SizedBox(height: 10.h),

            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (v) => validatePassword(v),
              decoration: InputDecoration(
                hint: Row(
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 97, 95, 95),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                filled: true,
                fillColor: textfieldColor,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 97, 95, 95),
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: primaryColor, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: primaryColor, width: 1.w),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AllColors.deliverydetailfontColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            if (passwordError != null)
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  passwordError!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),

            SizedBox(height: 20.h),

            // Area Selection Section
            Text(
              'Select Delivery Areas',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            if (_loadingAreas)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_areas.isEmpty)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  'No areas available',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: textfieldColor,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: primaryColor, width: 1.w),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _showAreaSelectionDialog(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedAreaIds.isEmpty
                                    ? 'Tap to select areas'
                                    : '${_selectedAreaIds.length} area(s) selected',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: _selectedAreaIds.isEmpty
                                      ? const Color.fromARGB(255, 97, 95, 95)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: AllColors.deliverydetailfontColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedAreaIds.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8.w),
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _selectedAreaIds.map((id) {
                            final area = _areas.firstWhere(
                              (a) => a['id'] == id,
                              orElse: () => <String, Object>{
                                'id': 0,
                                'areaName': 'Unknown',
                                'pinCode': '',
                                'status': 0,
                              },
                            );
                            return Chip(
                              label: Text(
                                area['areaName'] as String,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              deleteIcon: Icon(Icons.close, size: 16.sp),
                              onDeleted: () {
                                setState(() {
                                  _selectedAreaIds.remove(id);
                                });
                              },
                              backgroundColor: primaryColor.withOpacity(0.1),
                              side: BorderSide(color: primaryColor, width: 1),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),

            SizedBox(height: 20.h),

            _buildDottedBox(
              title: "ID Photo",
              subTitle: "Take a clear photo of your government ID",
              isUploaded: _idPhotoPath != null,
              fileName: _idPhotoPath?.split('/').last,
              icon: _idPhotoPath != null
                  ? Icon(Icons.check, size: 20.sp, color: Color(0xFF41C19E))
                  : Icon(
                      Icons.file_upload_outlined,
                      size: 20.sp,
                      color: AllColors.deliverydetailfontColor,
                    ),
              uploading: _uploadingId,
              onTakePhoto: () => _pickAndUpload('idPhoto', ImageSource.camera),
              onUploadFile: () => _pickAndUploadFile('idPhoto'),
              preview: _buildFilePreview(_idPhotoPath),
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
              fileName: _drivingLicensePath?.split('/').last,
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
              onUploadFile: () => _pickAndUploadFile('drivingLicense'),
              preview: _buildFilePreview(_drivingLicensePath),
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
              fileName: _vehicleRegistrationPath?.split('/').last,
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
              onUploadFile: () => _pickAndUploadFile('vehicleRegistration'),
              preview: _buildFilePreview(_vehicleRegistrationPath),
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

    validateEmail(email);
    validateMobile(mobile);
    validatePassword(password);

    if (fullName.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty) {
      MySnackBar.showSnackBar(context, 'Please fill all required fields');
      return;
    }

    if (emailError != null || mobileError != null || passwordError != null) {
      MySnackBar.showSnackBar(context, 'Please correct the highlighted errors');
      return;
    }

    if (_selectedAreaIds.isEmpty) {
      MySnackBar.showSnackBar(
        context,
        'Please select at least one delivery area',
      );
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
        areaIds: _selectedAreaIds,
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

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
