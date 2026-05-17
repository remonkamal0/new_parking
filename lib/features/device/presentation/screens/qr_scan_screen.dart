import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/core/providers/device_provider.dart';
import 'package:test888/core/models/device_model.dart';
import 'package:test888/core/utils/location_helper.dart';
import 'dart:math';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isScanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String code = barcodes.first.rawValue!;
      setState(() {
        _isScanned = true;
      });
      _handleSuccessfulScan(code);
    }
  }

  void _handleSuccessfulScan(String serialNumber) {
    final id = Random().nextInt(100000).toString();
    final newDevice = DeviceModel(
      id: id,
      name: 'New Device',
      location: 'Unknown Location',
      serialNumber: serialNumber,
      type: 'Terminal', // Default type
    );

    context.read<DeviceProvider>().addDevice(newDevice);
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
          title: Text('Device Scanned Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Serial: ${device.serialNumber}'),
              SizedBox(height: 10.h),
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
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: l10n.scanToPark,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          // Overlay to make it look like a scanner
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 250.w,
                      height: 250.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Stack(
              children: [
                 Positioned(top: 0, left: 0, child: _corner(theme)),
                 Positioned(top: 0, right: 0, child: RotatedBox(quarterTurns: 1, child: _corner(theme))),
                 Positioned(bottom: 0, right: 0, child: RotatedBox(quarterTurns: 2, child: _corner(theme))),
                 Positioned(bottom: 0, left: 0, child: RotatedBox(quarterTurns: 3, child: _corner(theme))),
              ],
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
                 SizedBox(height: 40.h),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                      GestureDetector(
                        onTap: () => cameraController.toggleTorch(),
                        child: _bottomIcon(Icons.flashlight_on, l10n.torch, theme),
                      ),
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
             color: Colors.white.withOpacity(0.2),
          ),
          child: Icon(icon, color: theme.primaryColor),
        ),
        SizedBox(height: 8.h),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

