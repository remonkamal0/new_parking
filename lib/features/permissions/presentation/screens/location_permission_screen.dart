import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';

// Very similar to Bluetooth, could refactor into a Generic Permission Screen
class LocationPermissionScreen extends StatelessWidget {
  final String? nextRoute;

  const LocationPermissionScreen({super.key, this.nextRoute});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: ""),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on, size: 50.sp, color: Colors.amber),
            ),
            SizedBox(height: 30.h),
            Text(
              l10n.locationAccess,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.locationDesc,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.whyNeedAccess,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.h),
            _buildReasonItem(context, Icons.navigation, l10n.reason3),
             // Reuse other reasons or add specific location ones
            _buildReasonItem(context, Icons.map, "Personalized Lists"),
            Spacer(),
            CustomButton(
              text: l10n.continueBtn.toUpperCase(),
              onPressed: () async {
                await Permission.locationWhenInUse.request();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('onboarding_complete', true);
                if (context.mounted) {
                  if (nextRoute != null) {
                    Navigator.of(context).pushReplacementNamed(nextRoute!);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    );
                  }
                }
              },
            ),
            TextButton(
              onPressed: () async {
                // Skip but still mark onboarding complete
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('onboarding_complete', true);
                if (context.mounted) {
                  if (nextRoute != null) {
                    Navigator.of(context).pushReplacementNamed(nextRoute!);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                    );
                  }
                }
              },
              child: Text(
                l10n.maybeLater,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
