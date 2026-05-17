import 'package:flutter/material.dart';
import 'package:test888/config/routes/app_routes.dart';
import 'package:test888/core/models/device_model.dart';
import 'package:test888/features/auth/presentation/screens/login_screen.dart';
import 'package:test888/features/auth/presentation/screens/splash_screen.dart';
import 'package:test888/features/auth/presentation/screens/verification_screen.dart';
import 'package:test888/features/device/presentation/screens/add_device_screen.dart';
import 'package:test888/features/device/presentation/screens/devices_screen.dart';
import 'package:test888/features/device/presentation/screens/device_detail_screen.dart';
import 'package:test888/features/device/presentation/screens/enter_device_details_screen.dart';
import 'package:test888/features/device/presentation/screens/qr_scan_screen.dart';
import 'package:test888/features/home/presentation/screens/home_screen.dart';
import 'package:test888/features/map/presentation/screens/map_screen.dart';
import 'package:test888/features/parking/presentation/screens/scan_to_park_screen.dart';
import 'package:test888/features/parking/presentation/screens/unlock_parking_screen.dart';
import 'package:test888/features/permissions/presentation/screens/bluetooth_permission_screen.dart';
import 'package:test888/features/permissions/presentation/screens/location_permission_screen.dart';
import 'package:test888/features/settings/presentation/screens/theme_settings_screen.dart';
import 'package:test888/features/profile/presentation/screens/profile_details_screen.dart';
import 'package:test888/features/profile/presentation/screens/language_screen.dart';
import 'package:test888/features/profile/presentation/screens/support_screen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.verification:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.addDevice:
        return MaterialPageRoute(builder: (_) => const AddDeviceScreen());
      case AppRoutes.enterDeviceDetails:
        return MaterialPageRoute(builder: (_) => const EnterDeviceDetailsScreen());
      case AppRoutes.map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case AppRoutes.bluetoothPermission:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => BluetoothPermissionScreen(nextRoute: args?['nextRoute']));
      case AppRoutes.locationPermission:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => LocationPermissionScreen(nextRoute: args?['nextRoute']));
      case AppRoutes.qrScan:
        return MaterialPageRoute(builder: (_) => const QrScanScreen());
      case AppRoutes.scanToPark:
        return MaterialPageRoute(builder: (_) => const ScanToParkScreen());
      case AppRoutes.unlockParking:
        return MaterialPageRoute(builder: (_) => const UnlockParkingScreen());
      case AppRoutes.themeSettings:
        return MaterialPageRoute(builder: (_) => const ThemeSettingsScreen());
      case AppRoutes.profileDetails:
        return MaterialPageRoute(builder: (_) => const ProfileDetailsScreen());
      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());
      case AppRoutes.support:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case AppRoutes.devices:
        return MaterialPageRoute(builder: (_) => const DevicesScreen());
      case AppRoutes.deviceDetail:
        final device = settings.arguments;
        if (device is DeviceModel) {
          return MaterialPageRoute(
            builder: (_) => DeviceDetailScreen(device: device),
          );
        }
        return null;
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
