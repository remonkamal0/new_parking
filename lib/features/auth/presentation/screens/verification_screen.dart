import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/features/auth/presentation/controllers/countdown_timer_notifier.dart';
import 'package:test888/features/auth/presentation/controllers/otp_notifier.dart';
import 'package:test888/features/auth/presentation/widgets/otp_input.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, this.otpLength = 6, this.countdownSeconds = 60});

  final int otpLength;
  final int countdownSeconds;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final CountdownTimerNotifier _countdown;
  late final OtpNotifier _otp;
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    _countdown = CountdownTimerNotifier(initialSeconds: widget.countdownSeconds)..start();
    _otp = OtpNotifier(length: widget.otpLength);
  }

  @override
  void dispose() {
    _countdown.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _countdown),
        ChangeNotifierProvider.value(value: _otp),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            l10n.phoneVerification,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    l10n.phoneVerification,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.enterPhone, // usually 'Please enter verification code...' but let's re-use existing string or add custom text if we didn't add it to arb.
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 40.h),
                  OtpInput(
                    length: widget.otpLength,
                    onChanged: (v) {
                      context.read<OtpNotifier>().setCode(v);
                      setState(() {
                        _currentOtp = v;
                      });
                    },
                    onCompleted: (v) {
                      context.read<OtpNotifier>().setCode(v);
                      setState(() {
                        _currentOtp = v;
                      });
                    },
                  ),
                  SizedBox(height: 32.h),
                  Consumer<CountdownTimerNotifier>(
                    builder: (context, timer, _) {
                      final minutes = (timer.secondsRemaining ~/ 60).toString().padLeft(2, '0');
                      final seconds = (timer.secondsRemaining % 60).toString().padLeft(2, '0');
                      final timeText = '$minutes:$seconds';
  
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F8), // Light blue box
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeText,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  l10n.didntReceiveCode,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: timer.canResend
                                  ? () {
                                      context.read<OtpNotifier>().clear();
                                      context.read<CountdownTimerNotifier>().restart();
                                    }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.all(8.r),
                                child: Row(
                                  children: [
                                    Text(
                                      l10n.resend,
                                      style: TextStyle(
                                        color: timer.canResend ? theme.primaryColor : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16.sp,
                                      color: timer.canResend ? theme.primaryColor : Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E7BBF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_currentOtp.length == widget.otpLength) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please complete the verification code.')),
                          );
                        }
                      },
                      child: Text(
                        l10n.verifyCode,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    l10n.needHelp,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.email_outlined, color: theme.primaryColor),
                            label: Text(
                              l10n.emailSupport,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.chat_bubble_outline, color: theme.primaryColor),
                            label: Text(
                              l10n.whatsappSupport,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
