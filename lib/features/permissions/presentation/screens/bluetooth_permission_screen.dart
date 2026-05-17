import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';

class BluetoothPermissionScreen extends StatelessWidget {
  final String? nextRoute;

  const BluetoothPermissionScreen({super.key, this.nextRoute});

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
                color: Colors.amber.withValues(alpha: 0.2), // Or primary color
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bluetooth, size: 50.sp, color: Colors.amber),
            ),
            SizedBox(height: 30.h),
            Text(
              l10n.bluetoothAccess,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.bluetoothDesc,
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
            _buildReasonItem(context, Icons.link, l10n.reason1),
            _buildReasonItem(context, Icons.sync, l10n.reason2),
            _buildReasonItem(context, Icons.bluetooth_audio, l10n.reason1), // Reuse or new
            Spacer(),
            CustomButton(
              text: l10n.continueBtn.toUpperCase(),
              onPressed: () async {
                if (Platform.isAndroid) {
                  await [
                    Permission.bluetoothScan,
                    Permission.bluetoothConnect,
                  ].request();

                  try {
                    await FlutterBluePlus.turnOn();
                  } catch (e) {
                    debugPrint('Error turning on Bluetooth: $e');
                    if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Error: $e. Did you completely restart the app?')),
                       );
                    }
                  }
                } else if (Platform.isIOS) {
                  await Permission.bluetooth.request();
                }

                if (context.mounted) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.locationPermission,
                    arguments: {'nextRoute': nextRoute},
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                if (nextRoute != null) {
                  Navigator.pushReplacementNamed(context, nextRoute!);
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
