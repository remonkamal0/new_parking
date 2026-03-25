import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Placeholder for Camera View
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: l10n.scanToPark,
        // actions: [Icon(Icons.more_vert)], // If needed
      ),
      body: Stack(
        children: [
          // Camera Placeholder
          GestureDetector(
            onTap: () {
               Navigator.pushNamed(context, AppRoutes.unlockParking);
            },
            child: Center(
              child: Stack(
                children: [
                   // Corner markers
                   Positioned(top: 0, left: 0, child: _corner(theme)),
                   Positioned(top: 0, right: 0, child: RotatedBox(quarterTurns: 1, child: _corner(theme))),
                   Positioned(bottom: 0, right: 0, child: RotatedBox(quarterTurns: 2, child: _corner(theme))),
                   Positioned(bottom: 0, left: 0, child: RotatedBox(quarterTurns: 3, child: _corner(theme))),
                   
                   // Scanning Line Animation (Static for now)
                   Center(
                     child: Container(
                       height: 2.h,
                       width: 240.w,
                       color: Colors.red, // Scanning line
                     ),
                   )
                ],
              ),
            ),
          ),
          
          // Bottom Controls
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  l10n.alignQr,
                   style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    l10n.scanInstruction,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ),
                 SizedBox(height: 20.h),
                 Text(
                   l10n.enterManually,
                   style: TextStyle(color: theme.primaryColor, decoration: TextDecoration.underline, decorationColor: theme.primaryColor),
                 ),
                 SizedBox(height: 40.h),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                      _bottomIcon(Icons.history, "History", theme),
                      _bottomIcon(Icons.flashlight_on, l10n.torch, theme),
                      _bottomIcon(Icons.help_outline, l10n.help, theme),
                   ],
                 )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _corner(ThemeData theme) {
     return Container(
       width: 20.w,
       height: 20.w,
       decoration: BoxDecoration(
          border: Border(
             top: BorderSide(color: theme.primaryColor, width: 4),
             left: BorderSide(color: theme.primaryColor, width: 4),
          )
       ),
     );
  }

  Widget _bottomIcon(IconData icon, String label, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
             shape: BoxShape.circle,
             color: Colors.white.withValues(alpha: 0.2),
          ),
          child: Icon(icon, color: theme.primaryColor),
        ),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
