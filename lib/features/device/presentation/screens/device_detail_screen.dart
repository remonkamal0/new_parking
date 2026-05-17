import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test888/core/models/device_model.dart';
import 'package:test888/core/widgets/custom_app_bar.dart';

class DeviceDetailScreen extends StatefulWidget {
  final DeviceModel device;
  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen>
    with SingleTickerProviderStateMixin {
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isOpen = false;
  String _statusMessage = 'Not Connected';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _connectToDevice();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _connectedDevice?.disconnect();
    super.dispose();
  }

  Future<void> _connectToDevice() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = 'Scanning for device...';
    });

    try {
      // Start scanning for BLE devices
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      StreamSubscription? sub;
      sub = FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult r in results) {
          // Match by device name or serial number
          if (r.device.platformName.toLowerCase().contains(
                widget.device.serialNumber.toLowerCase(),
              ) ||
              r.advertisementData.advName
                  .toLowerCase()
                  .contains(widget.device.serialNumber.toLowerCase())) {
            await FlutterBluePlus.stopScan();
            sub?.cancel();
            await _connectAndDiscoverServices(r.device);
            return;
          }
        }
      });

      // After timeout, if not found
      await Future.delayed(const Duration(seconds: 6));
      sub.cancel();
      if (!_isConnected && mounted) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Device not found nearby.\nMake sure Bluetooth is on.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Connection failed: $e';
        });
      }
    }
  }

  Future<void> _connectAndDiscoverServices(BluetoothDevice device) async {
    if (!mounted) return;
    setState(() => _statusMessage = 'Connecting...');

    try {
      await device.connect(license: License.free);
      _connectedDevice = device;

      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic char in service.characteristics) {
          if (char.properties.write || char.properties.writeWithoutResponse) {
            _writeCharacteristic = char;
            break;
          }
        }
        if (_writeCharacteristic != null) break;
      }

      if (mounted) {
        setState(() {
          _isConnected = true;
          _isConnecting = false;
          _statusMessage = 'Connected';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Failed to connect: $e';
        });
      }
    }
  }

  Future<void> _sendCommand(bool open) async {
    if (_writeCharacteristic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not connected to device. Please wait...')),
      );
      return;
    }

    final String cmdString = open ? "open" : "close";
    final cmd = utf8.encode(cmdString);
    try {
      await _writeCharacteristic!.write(cmd, withoutResponse: true);
      setState(() => _isOpen = open);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(open ? 'Gate OPENED ✅' : 'Gate CLOSED 🔒'),
          backgroundColor: open ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send command: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final device = widget.device;

    return Scaffold(
      appBar: CustomAppBar(title: device.name),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // Status Circle
            ScaleTransition(
              scale: _isConnecting ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnecting
                      ? Colors.orange.withOpacity(0.15)
                      : _isConnected
                          ? Colors.green.withOpacity(0.15)
                          : Colors.red.withOpacity(0.15),
                ),
                child: Center(
                  child: _isConnecting
                      ? SizedBox(
                          width: 48.w,
                          height: 48.w,
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          _isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                          size: 56.sp,
                          color: _isConnected ? Colors.green : Colors.red,
                        ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Status message
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: _isConnected ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 32.h),

            // Device Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    _infoRow(Icons.devices, 'Device Name', device.name, theme),
                    Divider(height: 24.h),
                    _infoRow(Icons.location_on, 'Location', device.location, theme),
                    Divider(height: 24.h),
                    _infoRow(Icons.qr_code, 'Serial Number', device.serialNumber, theme),
                    Divider(height: 24.h),
                    _infoRow(Icons.category, 'Type', device.type, theme),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Gate status indicator
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: _isOpen
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
              ),
              child: Text(
                _isOpen ? '🔓  Gate is OPEN' : '🔒  Gate is CLOSED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: _isOpen ? Colors.green : Colors.red,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // OPEN / CLOSE Buttons
            Row(
              children: [
                // OPEN Button
                Expanded(
                  child: GestureDetector(
                    onTap: _isConnected ? () => _sendCommand(true) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: _isConnected
                            ? Colors.green
                            : Colors.grey.shade300,
                        boxShadow: _isConnected
                            ? [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4))]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_open_rounded, color: Colors.white, size: 32.sp),
                          SizedBox(height: 6.h),
                          Text(
                            'OPEN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // CLOSE Button
                Expanded(
                  child: GestureDetector(
                    onTap: _isConnected ? () => _sendCommand(false) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: _isConnected
                            ? Colors.red
                            : Colors.grey.shade300,
                        boxShadow: _isConnected
                            ? [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 12, offset: Offset(0, 4))]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_rounded, color: Colors.white, size: 32.sp),
                          SizedBox(height: 6.h),
                          Text(
                            'CLOSE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Reconnect button
            if (!_isConnected && !_isConnecting)
              TextButton.icon(
                onPressed: _connectToDevice,
                icon: Icon(Icons.refresh, color: theme.primaryColor),
                label: Text('Try Reconnect', style: TextStyle(color: theme.primaryColor)),
              ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: theme.primaryColor, size: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ],
          ),
        ),
      ],
    );
  }
}
