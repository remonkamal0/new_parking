import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/models/device_model.dart';
import 'package:test888/core/providers/device_provider.dart';
import 'package:test888/core/utils/location_helper.dart';
import 'package:test888/core/widgets/custom_button.dart';
import 'package:test888/features/home/presentation/widgets/custom_drawer.dart';
import 'package:test888/generated/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  MapType _currentMapType = MapType.normal;
  final LatLng _defaultCenter = const LatLng(24.7136, 46.6753); // Riyadh Default

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _centerMapOnDevices();
  }

  void _centerMapOnDevices() {
    final devices = context.read<DeviceProvider>().devices;
    final devicesWithCoords = devices.where((d) => d.lat != null && d.lng != null).toList();

    if (devicesWithCoords.isNotEmpty && _mapController != null) {
      final first = devicesWithCoords.first;
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(first.lat!, first.lng!), 14.0),
      );
    } else {
      _animateToCurrentLocation();
    }
  }

  Future<void> _animateToCurrentLocation() async {
    final loc = await LocationHelper.getCurrentLocation();
    if (loc != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(loc.lat, loc.lng), 15.0),
      );
    }
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  Set<Marker> _buildMarkers(List<DeviceModel> devices) {
    return devices
        .where((d) => d.lat != null && d.lng != null)
        .map((d) {
          return Marker(
            markerId: MarkerId(d.id),
            position: LatLng(d.lat!, d.lng!),
            infoWindow: InfoWindow(
              title: d.name,
              snippet: d.location,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            onTap: () {
              // Option to directly view detail
            },
          );
        })
        .toSet();
  }

  void _showDevicesBottomSheet(BuildContext context, List<DeviceModel> devices, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Devices (${devices.length})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor, size: 28.sp),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushNamed(context, AppRoutes.addDevice);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.devices, size: 48.sp, color: Colors.grey),
                            SizedBox(height: 10.h),
                            Text('No Devices Added Yet', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: devices.length,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemBuilder: (c, index) {
                          final device = devices[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.r),
                              onTap: () {
                                Navigator.pop(ctx);
                                if (device.lat != null && device.lng != null && _mapController != null) {
                                  _mapController!.animateCamera(
                                    CameraUpdate.newLatLngZoom(LatLng(device.lat!, device.lng!), 16.0),
                                  );
                                }
                                Navigator.pushNamed(context, AppRoutes.deviceDetail, arguments: device);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(14.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      ),
                                      child: Icon(Icons.devices, color: Theme.of(context).primaryColor, size: 22.sp),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(device.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 12.sp, color: Colors.grey),
                                              SizedBox(width: 3.w),
                                              Expanded(
                                                child: Text(
                                                  device.location,
                                                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            'SN: ${device.serialNumber}',
                                            style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined, color: Theme.of(context).primaryColor, size: 20.sp),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            _showEditDialog(context, device);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20.sp),
                                          onPressed: () {
                                            Navigator.pop(ctx);
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
              ),
            ],
          ),
        );
      },
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
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.my_location),
                        label: Text(isFetchingLocation ? 'Fetching...' : 'Use My Current Location'),
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
                          name: nameController.text.trim().isEmpty ? device.name : nameController.text.trim(),
                          location: locationController.text.trim().isEmpty ? device.location : locationController.text.trim(),
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
          content: Text('Are you sure you want to delete "' + device.name + '"?'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          final markers = _buildMarkers(deviceProvider.devices);

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _defaultCenter,
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: _currentMapType,
                markers: markers,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu, color: theme.primaryColor, size: 28.sp),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/VPM.png',
                            height: 36.h,
                            fit: BoxFit.contain,
                          ),
                          const Spacer(),
                          SizedBox(width: 48.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16.w,
                bottom: 120.h,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'mapTypeBtn',
                      onPressed: _toggleMapType,
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      child: const Icon(Icons.map),
                    ),
                    SizedBox(height: 12.h),
                    FloatingActionButton.small(
                      heroTag: 'myLocationBtn',
                      onPressed: _animateToCurrentLocation,
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      child: const Icon(Icons.my_location),
                    ),
                    SizedBox(height: 12.h),
                    FloatingActionButton.small(
                      heroTag: 'addDeviceShortcutBtn',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.addDevice);
                      },
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showDevicesBottomSheet(context, deviceProvider.devices, l10n),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu, color: theme.primaryColor, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Show List',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
