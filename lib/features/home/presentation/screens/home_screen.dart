import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/features/home/presentation/widgets/custom_drawer.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Parky"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Empty State Pulse Animation Placeholder
                      Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 60.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        l10n.noDevicesFound,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "You have no devices yet. Add/Buy a new device to start using app!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      SizedBox(height: 40.h),
                      CustomButton(
                        text: l10n.addNewDevice,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.addDevice);
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: l10n.buyDevice,
                        isOutline: true,
                        onPressed: () {},
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: l10n.showMap,
                        backgroundColor: Colors.black, // Or dark grey
                        textColor: Colors.white,
                        onPressed: () {
                           Navigator.pushNamed(context, AppRoutes.map);
                        },
                      ),
                      SizedBox(height: 20.h), // Extra padding at the bottom
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
