import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class UnlockParkingScreen extends StatelessWidget {
  const UnlockParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black, // Dark background as per design
      body: Stack(
        children: [
          // Background placeholder for camera or map
           Opacity(
             opacity: 0.3,
             child: Container(
               decoration: const BoxDecoration(
                 image: DecorationImage(
                   image: NetworkImage("https://via.placeholder.com/400x800"), // Placeholder
                   fit: BoxFit.cover,
                 ),
               ),
             ),
           ),
           
           // Close button
           Positioned(
             top: 50.h,
             right: 20.w,
             child: CircleAvatar(
               backgroundColor: Colors.white.withValues(alpha: 0.2),
               child: IconButton(
                 icon: const Icon(Icons.close, color: Colors.white),
                 onPressed: () => Navigator.pop(context),
               ),
             ),
           ),

           // Scanning Frame
           Center(
             child: Container(
               width: 250.w,
               height: 250.w,
               decoration: BoxDecoration(
                 border: Border.all(color: Colors.amber, width: 2),
                 borderRadius: BorderRadius.circular(20.r),
               ),
             ),
           ),

           // Bottom Sheet Content
           Align(
             alignment: Alignment.bottomCenter,
             child: Container(
               padding: EdgeInsets.all(24.w),
               decoration: BoxDecoration(
                 color: theme.scaffoldBackgroundColor,
                 borderRadius: BorderRadius.only(
                   topLeft: Radius.circular(24.r),
                   topRight: Radius.circular(24.r),
                 ),
               ),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Container(
                     width: 40.w,
                     height: 4.h,
                     decoration: BoxDecoration(
                       color: Colors.grey.shade300,
                       borderRadius: BorderRadius.circular(2.r),
                     ),
                   ),
                   SizedBox(height: 24.h),
                   Row(
                     children: [
                       Container(
                         padding: EdgeInsets.all(10.w),
                         decoration: BoxDecoration(
                           color: Colors.orange.withValues(alpha: 0.1),
                           shape: BoxShape.circle,
                         ),
                         child: Icon(Icons.lock_open, color: Colors.orange),
                       ),
                       SizedBox(width: 16.w),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               l10n.unlockParking,
                               style: theme.textTheme.titleLarge?.copyWith(
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: 16.h),
                   Text(
                     l10n.unlockDesc,
                     style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                   ),
                   SizedBox(height: 24.h),
                   CustomButton(
                     text: l10n.learnMore, // Actually button says "Turn on Flashlight" in one design, "Learn More" in another? 
                     // Looking at image 3 row 2: "Unlock parking space... Learn More" button is secondary?
                     // Actually bottom button is "TURN ON THE FLASHLIGHT".
                     // Let's stick to "TURN ON THE FLASHLIGHT" for the big button.
                     // Wait, the "Unlock parking" image has "Learn More" inside the white box.
                     // And a "TURN ON THE FLASHLIGHT" floating button?
                     // I will implement the white box content + main button.
                     isOutline: true,
                     onPressed: () {},
                   ),
                   SizedBox(height: 16.h),
                   CustomButton(
                     text: l10n.turnOnFlash,
                     backgroundColor: Colors.black,
                     textColor: Colors.white,
                     icon: Icons.flashlight_on,
                     onPressed: () {},
                   ),
                 ],
               ),
             ),
           ),
        ],
      ),
    );
  }
}
