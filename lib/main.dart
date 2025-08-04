import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/feature/login_screen.dart/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Delivery App',
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}

// lib/
// ├─ core/
// │  ├─ routing/
// │  │  ├─ app_routes.dart
// │  │  └─ route_generator.dart
// │  ├─ services/
// │  │  └─ api_services.dart
// │  ├─ theme/
// │  │  └─ theme.dart
// │  └─ utils/
// │     ├─ auth_screen/
// │     │  └─ auth_screen.dart
// │     ├─ common_widgets/
// │     │  ├─ common_appbar.dart
// │     │  ├─ common_bottom_app_bar.dart
// │     │  ├─ common_button.dart
// │     │  ├─ common_checkbox.dart
// │     │  ├─ common_country_dropdown.dart
// │     │  ├─ common_date_picker.dart
// │     │  ├─ common_dropdown.dart
// │     │  ├─ common_filter_button.dart
// │     │  ├─ common_phone_number_field.dart
// │     │  ├─ common_radio_button.dart
// │     │  ├─ common_search_bar.dart
// │     │  └─ common_textfield.dart
// │     └─ prefs/
// │        └─ prefs.dart
// ├─ feature/
// │  ├─ all_doctors_screen/
// │  │  ├─ provider/
// │  │  │  └─ all_doctors_provider.dart
// │  │  └─ all_doctors_screen.dart
// │  ├─ booking_screen/
// │  │  ├─ provider/
// │  │  │  └─ booking_provider.dart
// │  │  └─ booking_screen.dart
// │  ├─ categories_screen/
// │  │  ├─ model/
// │  │  │  └─ category_model.dart
// │  │  ├─ provider/
// │  │  │  └─ category_provider.dart
// │  │  └─ categories_screen.dart
// │  ├─ clinical_report_screen/
// │  │  └─ clinical_report_screen.dart
// │  ├─ create_account_screen/
// │  │  └─ create_account_screen.dart
// │  ├─ dashboard_health_data_screen/
// │  │  └─ dashboard_health_data_screen.dart
// │  ├─ dashboard_prescription_screen/
// │  │  ├─ provider/
// │  │  │  └─ dashboard_prescription_provider.dart
// │  │  └─ dashboard_prescription_screen.dart
// │  ├─ dashboard_report_screen/
// │  │  ├─ provider/
// │  │  │  └─ reports_provider.dart
// │  │  ├─ widget/
// │  │  │  ├─ add_clinical_record_screen/
// │  │  │  │  └─ add_clinical_report_screen.dart
// │  │  │  ├─ add_test_report_screen/
// │  │  │  │  └─ add_test_report_screen.dart
// │  │  │  └─ common_report_tab_bar.dart
// │  │  └─ reports_screen.dart
// │  ├─ dashboard_screen/
// │  │  └─ dashboard_screen.dart
// │  ├─ doctor_profile_screen/
// │  │  ├─ provider/
// │  │  │  └─ doctor_profile_provider.dart
// │  │  └─ doctor_profile_screen.dart
// │  ├─ home_screen/
// │  │  ├─ provider/
// │  │  │  └─ home_provider.dart
// │  │  └─ home_screen.dart
// │  ├─ login_screen/
// │  │  ├─ provider/
// │  │  │  └─ login_provider.dart
// │  │  ├─ widget/
// │  │  │  └─ forget_password/
// │  │  │     ├─ provider/
// │  │  │     │  └─ forget_password_provider.dart
// │  │  │     └─ forget_password_screen.dart
// │  │  └─ login_screen.dart
// │  ├─ medical_prediction_screen/
// │  │  └─ medical_prediction_screen.dart
// │  ├─ my_bookings_screen/
// │  │  ├─ provider/
// │  │  │  └─ my_bookings_provider.dart
// │  │  └─ my_bookings_screen.dart
// │  ├─ my_profile_screen/
// │  │  ├─ widget/
// │  │  │  ├─ privacy_policy_screen.dart
// │  │  │  └─ terms_condition_screen.dart
// │  │  └─ my_profile_screen.dart
// │  ├─ onboarding_screen/
// │  │  └─ onboarding_screen.dart
// │  ├─ payment_method_screen/
// │  │  └─ payment_method_screen.dart
// │  ├─ register_screen/
// │  │  ├─ provider/
// │  │  │  └─ register_provider.dart
// │  │  └─ register_screen.dart
// │  ├─ report_generated_screen/
// │  │  ├─ provider/
// │  │  │  └─ report_generated_provider.dart
// │  │  └─ report_generated_screen.dart
// │  ├─ splash_screen/
// │  │  └─ splash_screen.dart
// │  └─ test_report_screen/
// │     └─ test_report_screen.dart
// └─ main.dart
