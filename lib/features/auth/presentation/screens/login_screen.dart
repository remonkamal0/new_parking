import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/providers/app_language_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  static const _prefsLastCountryKey = 'last_country_iso';
  String _initialCountryCode = 'SA';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadLastCountry();
  }

  Future<void> _loadLastCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsLastCountryKey);
    if (!mounted) return;
    if (saved == null || saved.isEmpty) return;
    setState(() {
      _initialCountryCode = saved;
    });
  }

  Future<void> _persistCountry(String isoCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsLastCountryKey, isoCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),
                  Container(
                    width: double.infinity,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8), // Light blue background
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 60.sp,
                            color: theme.primaryColor,
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 80.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    l10n.welcome,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.enterPhone,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Phone Number",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  IntlPhoneField(
                    controller: _phoneController,
                    initialCountryCode: _initialCountryCode,
                    showCountryFlag: true,
                    showDropdownIcon: true,
                    dropdownIconPosition: IconPosition.trailing,
                    flagsButtonPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: InputDecoration(
                      hintText: '5XX XXX XX XX',
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: theme.primaryColor),
                      ),
                    ),
                    invalidNumberMessage: 'Invalid phone number',
                    onCountryChanged: (country) {
                      _persistCountry(country.code);
                    },
                    validator: (phone) {
                      if (phone == null) return 'Invalid phone number';
                      if (phone.number.trim().isEmpty) return 'Phone number is required';
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (!(_formKey.currentState?.validate() ?? false)) return;
                        Navigator.pushNamed(context, AppRoutes.verification);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.login.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F8),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            final isArabic = context.read<AppLanguageProvider>().isArabic;
                            context.read<AppLanguageProvider>().setLocale(isArabic ? const Locale('en') : const Locale('ar'));
                          },
                          icon: Icon(Icons.language, color: theme.primaryColor, size: 20.sp),
                          label: Text(
                            context.watch<AppLanguageProvider>().isArabic ? 'English' : 'عربي',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Text(
                      l10n.termsAndPrivacy,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
