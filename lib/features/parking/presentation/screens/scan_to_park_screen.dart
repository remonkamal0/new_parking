import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';

class ScanToParkScreen extends StatelessWidget {
  const ScanToParkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "", actions: [
        IconButton(icon: Icon(Icons.more_vert), onPressed: (){}),
      ]),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                       SizedBox(height: 20.h),
                       Text(
                         l10n.scanToPark,
                         style: TextStyle(
                           color: Colors.orange, // Orange pill
                           fontWeight: FontWeight.bold,
                           backgroundColor: Colors.orange.withValues(alpha: 0.1),
                         ),
                       ),
                       // Just a label style adjustment
                       Chip(
                         label: Text(l10n.scanToPark.toUpperCase()),
                         backgroundColor: Colors.orange.withValues(alpha: 0.1),
                         labelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                         side: BorderSide.none,
                       ),
            
                       Spacer(),
                       // QR Frame
                       Center(
                         child: Container(
                           width: 250.w,
                           height: 250.w,
                           padding: EdgeInsets.all(2.w),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20.r),
                             border: Border.all(color: Colors.orange, width: 2),
                           ),
                           child: Container(
                             decoration: BoxDecoration(
                               color: Colors.grey.shade100, // Placeholder for camera
                               borderRadius: BorderRadius.circular(18.r),
                             ),
                             child: Icon(Icons.qr_code_2, size: 100.sp, color: Colors.grey.shade300),
                           ),
                         ),
                       ),
                       SizedBox(height: 30.h),
                       Text(
                         l10n.alignQr,
                         style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                       ),
                       SizedBox(height: 10.h),
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 40.w),
                         child: Text(
                           l10n.scanInstruction,
                           textAlign: TextAlign.center,
                           style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                         ),
                       ),
                       SizedBox(height: 20.h),
                       GestureDetector(
                         onTap: () {
                            Navigator.pushNamed(context, AppRoutes.enterDeviceDetails);
                         },
                         child: Text(
                           l10n.enterManually,
                           style: TextStyle(
                             color: Colors.orange,
                             fontWeight: FontWeight.bold,
                             decoration: TextDecoration.underline,
                             decorationColor: Colors.orange,
                           ),
                         ),
                       ),
                       Spacer(),
                       
                       // Bottom Actions
                       Padding(
                         padding: EdgeInsets.only(bottom: 40.h),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             _actionButton(Icons.flashlight_on, theme),
                             GestureDetector(
                               onTap: () => Navigator.pop(context), 
                               child: _actionButton(Icons.close, theme, isClose: true),
                             ),
                             _actionButton(Icons.help_outline, theme),
                           ],
                         ),
                       )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, ThemeData theme, {bool isClose = false}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isClose ? Colors.orange : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ]
      ),
      child: Icon(
        icon, 
        color: isClose ? Colors.white : Colors.orange,
        size: 24.sp,
      ),
    );
  }
}
