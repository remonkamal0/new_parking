import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/models/device_model.dart';
import 'package:test888/core/providers/device_provider.dart';
import 'package:test888/core/utils/location_helper.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.devices,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: theme.primaryColor, size: 28.sp),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addDevice);
            },
          ),
        ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          final devices = deviceProvider.devices;

          if (devices.isEmpty) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.devices,
                          size: 64.sp,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        l10n.noDevicesFound,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.noDevicesFound, // Or fallback text
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      CustomButton(
                        text: l10n.addNewDevice,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.addDevice);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SafeArea(
            child: ListView.builder(
              itemCount: devices.length,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              itemBuilder: (context, index) {
                final device = devices[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.deviceDetail,
                        arguments: device,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.devices,
                              color: theme.primaryColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14.sp,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        device.location,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${l10n.serialNumber}: ${device.serialNumber}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade400,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: theme.primaryColor,
                                  size: 22.sp,
                                ),
                                onPressed: () {
                                  _showEditDialog(context, device);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 22.sp,
                                ),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, device);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, DeviceModel device) {
    final nameController = TextEditingController(text: device.name);
    final locationController = TextEditingController(text: device.location);
    double? lat = device.lat;
    double? lng = device.lng;
    bool isFetchingLocation = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Device'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Device Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.devices),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isFetchingLocation
                            ? null
                            : () async {
                                setDialogState(() => isFetchingLocation = true);
                                locationController.text = 'Fetching location...';
                                final result = await LocationHelper.getCurrentLocation();
                                if (result != null) {
                                  locationController.text = result.address;
                                  lat = result.lat;
                                  lng = result.lng;
                                } else {
                                  locationController.text = 'Could not fetch location';
                                }
                                setDialogState(() => isFetchingLocation = false);
                              },
                        icon: isFetchingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(
                          isFetchingLocation
                              ? 'Fetching...'
                              : 'Use My Current Location',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<DeviceProvider>().updateDevice(
                          device.id,
                          name: nameController.text.trim().isEmpty
                              ? device.name
                              : nameController.text.trim(),
                          location: locationController.text.trim().isEmpty
                              ? device.location
                              : locationController.text.trim(),
                          lat: lat,
                          lng: lng,
                        );
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, DeviceModel device) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Device'),
          content: Text('Are you sure you want to delete "${device.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<DeviceProvider>().removeDevice(device.id);
                Navigator.pop(ctx);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
