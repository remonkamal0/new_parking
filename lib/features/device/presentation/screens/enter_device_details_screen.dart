import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/core/widgets/custom_text_field.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';

class EnterDeviceDetailsScreen extends StatelessWidget {
  const EnterDeviceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: l10n.addNewDevice),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              l10n.enterDeviceDetails,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              "Please type the serial number of the device to continue setup.",
               style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 30.h),
            Text(l10n.serialNumber, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            CustomTextField(
               hintText: l10n.snPlaceholder,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16.sp, color: theme.primaryColor),
                SizedBox(width: 8.w),
                Text(l10n.whereFindSn, style: TextStyle(color: theme.primaryColor, fontSize: 12.sp)),
              ],
            ),
             SizedBox(height: 40.h),
             Center(
               child: Icon(Icons.qr_code_scanner, size: 80.sp, color: Colors.grey.shade300),
             ),
             Spacer(),
             CustomButton(
               text: l10n.continueBtn.toUpperCase(), // "NEXT" in design
               onPressed: () {
                 Navigator.pushNamed(context, AppRoutes.qrScan);
               },
             ),
             SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
