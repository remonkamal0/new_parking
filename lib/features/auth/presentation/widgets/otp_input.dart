import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.length,
    required this.onChanged,
    required this.onCompleted,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final basePinTheme = PinTheme(
      width: 50.w,
      height: 56.h,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Pinput(
      length: length,
      keyboardType: TextInputType.number,
      autofocus: true,
      separatorBuilder: (_) => SizedBox(width: 8.w),
      defaultPinTheme: basePinTheme,
      focusedPinTheme: basePinTheme.copyWith(
        decoration: basePinTheme.decoration?.copyWith(
          border: Border.all(color: theme.primaryColor, width: 2),
        ),
      ),
      submittedPinTheme: basePinTheme,
      preFilledWidget: Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: Color(0xFF6C7A9C), // Slate grey dot
          shape: BoxShape.circle,
        ),
      ),
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
