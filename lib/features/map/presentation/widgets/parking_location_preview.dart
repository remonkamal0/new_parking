import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class ParkingLocationPreview extends StatelessWidget {
  const ParkingLocationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.grey.shade300,
                  image: const DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/150"), // Placeholder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Downtown Central Parking",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                       children: [
                         Icon(Icons.star, color: Colors.amber, size: 16.sp),
                         Text(" 4.5 ", style: TextStyle(fontWeight: FontWeight.bold)),
                         Text("(124 reviews)", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                       ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "\$ 4.0 / hr (includes tax)",
                       style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Center(
                    child: Text(
                      l10n.available.toUpperCase(),
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  text: l10n.reserve,
                  onPressed: () {},
                  height: 45.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
