import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/features/device/presentation/widgets/device_type_card.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  int _selectedIndex = -1;

  Future<void> _onSelectPressed() async {
    if (_selectedIndex == -1) return;

    // Check if both permissions are already granted
    final btGranted = await Permission.bluetoothScan.isGranted;
    final locGranted = await Permission.locationWhenInUse.isGranted;

    if (!mounted) return;

    if (btGranted && locGranted) {
      // Permissions already OK → go directly to enter device details
      Navigator.pushNamed(context, AppRoutes.enterDeviceDetails);
    } else if (!btGranted) {
      // Need BT permission first (BT screen → Location screen → enter details)
      Navigator.pushNamed(context, AppRoutes.bluetoothPermission, arguments: {'nextRoute': AppRoutes.enterDeviceDetails});
    } else {
      // BT granted but Location not → go to Location screen
      Navigator.pushNamed(context, AppRoutes.locationPermission, arguments: {'nextRoute': AppRoutes.enterDeviceDetails});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.addNewDevice),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          l10n.selectDeviceType,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 30.h),
                        DeviceTypeCard(
                          title: l10n.bouncer,
                          description: l10n.bouncerDesc,
                          icon: Icons.cancel_presentation, // Placeholder icon
                          isSelected: _selectedIndex == 0,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                        DeviceTypeCard(
                          title: l10n.terminal,
                          description: l10n.terminalDesc,
                          icon: Icons.confirmation_number_outlined, // Placeholder icon
                          isSelected: _selectedIndex == 1,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                        Spacer(),
                        CustomButton(
                          text: l10n.select.toUpperCase(),
                          onPressed: _selectedIndex != -1 ? _onSelectPressed : () {},
                          backgroundColor: _selectedIndex != -1 ? null : Colors.grey.shade400,
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

