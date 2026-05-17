import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutline = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isEnabled = onPressed != null;
    final bgColor = backgroundColor ?? (isOutline ? Colors.transparent : primaryColor);
    final txtColor = textColor ?? (isOutline ? primaryColor : Colors.white);
    final effectiveBg = isEnabled ? bgColor : theme.disabledColor.withValues(alpha: 0.2);
    final effectiveText = isEnabled ? txtColor : theme.disabledColor;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: effectiveText,
          side: isOutline
              ? BorderSide(color: isEnabled ? primaryColor : theme.disabledColor, width: 2)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          elevation: isOutline ? 0 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: effectiveText),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: effectiveText,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
