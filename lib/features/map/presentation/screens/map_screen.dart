import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final LatLng _center = const LatLng(24.7136, 46.6753); // Default location (Riyadh)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          // Background Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
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
