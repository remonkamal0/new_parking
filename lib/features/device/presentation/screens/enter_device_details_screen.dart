import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/core/widgets/custom_text_field.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/providers/device_provider.dart';
import 'package:test888/core/models/device_model.dart';
import 'package:test888/core/utils/location_helper.dart';
import 'dart:math';

class EnterDeviceDetailsScreen extends StatefulWidget {
  const EnterDeviceDetailsScreen({super.key});

  @override
  State<EnterDeviceDetailsScreen> createState() => _EnterDeviceDetailsScreenState();
}

class _EnterDeviceDetailsScreenState extends State<EnterDeviceDetailsScreen> {
  final TextEditingController _serialController = TextEditingController();

  void _addManualDevice() {
    if (_serialController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid serial number.')),
      );
      return;
    }

    // Generate random ID
    final id = Random().nextInt(100000).toString();
    final newDevice = DeviceModel(
      id: id,
      name: 'New Device',
      location: 'Unknown Location',
      serialNumber: _serialController.text.trim(),
      type: 'Terminal', // Default type
    );

    context.read<DeviceProvider>().addDevice(newDevice);

    // Prompt for Name and Location
    _showEditDeviceDialog(context, newDevice);
  }

  void _showEditDeviceDialog(BuildContext context, DeviceModel device) {
    final nameController = TextEditingController(text: device.name);
    final locationController = TextEditingController(text: 'Fetching location...');
    double? _lat;
    double? _lng;

    LocationHelper.getCurrentLocation().then((result) {
      if (result != null) {
        locationController.text = result.address;
        _lat = result.lat;
        _lng = result.lng;
      } else {
        locationController.text = 'Unknown Location';
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Device Added Successfully!'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Text('Please enter a name and location for this device:'),
              SizedBox(height: 16.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Device Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location (auto-detected)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ),
        actions: [
            ElevatedButton(
              onPressed: () {
                context.read<DeviceProvider>().updateDevice(
                      device.id,
                      name: nameController.text.trim().isEmpty ? 'New Device' : nameController.text.trim(),
                      location: locationController.text.trim().isEmpty ? 'Unknown' : locationController.text.trim(),
                      lat: _lat,
                      lng: _lng,
                    );
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
              },
              child: Text('Save & Continue'),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: l10n.addNewDevice),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                l10n.enterDeviceDetails,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                "Please type the serial number of the device to continue setup.",
                 style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 30.h),
              Text(l10n.serialNumber, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              CustomTextField(
                 controller: _serialController,
                 hintText: l10n.snPlaceholder,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16.sp, color: theme.primaryColor),
                  SizedBox(width: 8.w),
                  Text(l10n.whereFindSn, style: TextStyle(color: theme.primaryColor, fontSize: 12.sp)),
                ],
              ),
               SizedBox(height: 40.h),
               GestureDetector(
                 onTap: () {
                   Navigator.pushNamed(context, AppRoutes.qrScan);
                 },
                 child: Center(
                   child: Column(
                     children: [
                       Icon(Icons.qr_code_scanner, size: 80.sp, color: theme.primaryColor),
                       SizedBox(height: 10.h),
                       Text('Or Tap Here to Scan QR Code', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                     ],
                   ),
                 ),
               ),
               SizedBox(height: 40.h), // Replaced Spacer with fixed SizedBox to avoid SingleChildScrollView overflow
               CustomButton(
                 text: l10n.continueBtn.toUpperCase(),
                 onPressed: _addManualDevice,
               ),
               SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
