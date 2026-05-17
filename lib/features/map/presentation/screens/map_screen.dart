import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test888/core/providers/device_provider.dart';
import 'package:test888/features/map/presentation/widgets/map_search_bar.dart';
import 'package:test888/features/map/presentation/widgets/parking_location_preview.dart';
import 'package:test888/generated/l10n/app_localizations.dart';
import 'package:test888/features/home/presentation/widgets/custom_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(24.7136, 46.6753); // Default (Riyadh)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> _buildMarkers(DeviceProvider deviceProvider) {
    return deviceProvider.devices
        .where((d) => d.lat != null && d.lng != null)
        .map((d) {
          return Marker(
            markerId: MarkerId(d.id),
            position: LatLng(d.lat!, d.lng!),
            infoWindow: InfoWindow(
              title: d.name,
              snippet: d.location,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          );
        })
        .toSet();
  }

  void _moveCameraToDevice(DeviceProvider deviceProvider) {
    // Move camera to first device that has a location
    final devicesWithLocation = deviceProvider.devices
        .where((d) => d.lat != null && d.lng != null)
        .toList();

    if (devicesWithLocation.isNotEmpty) {
      final first = devicesWithLocation.first;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(first.lat!, first.lng!),
          15.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const CustomDrawer(),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          final markers = _buildMarkers(deviceProvider);

          return Stack(
            children: [
              // Background Google Map
              GoogleMap(
                onMapCreated: (controller) {
                  _onMapCreated(controller);
                  // Move camera to device location after map is ready
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _moveCameraToDevice(deviceProvider);
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: markers,
              ),

              // Top Area
              SafeArea(
                child: Column(
                  children: [
                    const MapSearchBar(),
                    SizedBox(height: 10.h),
                    // Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          _buildFilterChip(context, l10n.filterAll, true),
                          _buildFilterChip(context, l10n.filterEV, false),
                          _buildFilterChip(context, l10n.filterOpen, false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Device count badge (top right)
              if (markers.isNotEmpty)
                Positioned(
                  top: 60.h,
                  right: 16.w,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () => _moveCameraToDevice(deviceProvider),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.devices, color: Colors.white, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              '${markers.length} Device${markers.length > 1 ? 's' : ''}',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom Area
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: const ParkingLocationPreview(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {},
        backgroundColor: theme.cardColor,
        selectedColor: theme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
             color: isSelected ? theme.primaryColor : Colors.grey.shade300,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
