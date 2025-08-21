// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:collection_qr_flutter/core/colors.dart';
//
// class ReceiptPage extends StatefulWidget {
//   final String amount;
//   const ReceiptPage({super.key, required this.amount});
//
//   @override
//   State<ReceiptPage> createState() => _ReceiptPageState();
// }
//
// class _ReceiptPageState extends State<ReceiptPage> {
//   // Add the POS Printer class
//   static const _printerChannel = MethodChannel('mypos/bridge');
//   final GlobalKey _globalKey = GlobalKey(); // For capturing widget image
//   Future<void> _printReceipt() async {
//     try {
//       RenderRepaintBoundary boundary =
//       _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       ByteData? byteData =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//       Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//       await _printerChannel.invokeMethod('printImage', pngBytes);
//     } on PlatformException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to print receipt: ${e.message}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Transaction Receipt",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: home2,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: home2),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: RepaintBoundary(
//         key: _globalKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 // Bank Header with gradient
//                 Column(
//                   children: [
//                     const Text(
//                       "XYZ BANK",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: home2,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Transaction Successful",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.green[500],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // QR Code Section
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: home1.withOpacity(0.3)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: home2.withOpacity(0.1),
//                         spreadRadius: 2,
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: home1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           Icons.qr_code,
//                           color: home1,
//                           size: 120,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         "Scan to verify transaction",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: home2.withOpacity(0.7),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Transaction Details
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: home2.withOpacity(0.1)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: home2.withOpacity(0.05),
//                         spreadRadius: 2,
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Transaction Details",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: home2,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDetailRow("Transaction ID:", "1234567890"),
//                       Divider(height: 24, color: home2.withOpacity(0.1)),
//                       _buildDetailRow("Date & Time:", "July 25, 2023 - 14:30"),
//                       Divider(height: 24, color: home2.withOpacity(0.1)),
//                       _buildDetailRow("Amount:", "Rs.${widget.amount}"),
//                       Divider(height: 24, color: home2.withOpacity(0.1)),
//                       _buildDetailRow("Recipient:", "John Doe"),
//                       Divider(height: 24, color: home2.withOpacity(0.1)),
//                       _buildDetailRow("Reference:", "Invoice #4567"),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Action Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _printReceipt,
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           side: BorderSide(color: home1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           "PRINT",
//                           style: TextStyle(
//                             color: home1,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: home2,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           elevation: 0,
//                         ),
//                         onPressed: () {
//                           // Download functionality
//                         },
//                         child: Text(
//                           "DOWNLOAD",
//                           style: TextStyle(
//                             color: white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: home2.withOpacity(0.7),
//             fontSize: 14,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: home2,
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collection_qr_flutter/core/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiptPage extends StatefulWidget {
  final String amount;
  final String bankName;
  final String agentName;
  final String agentPhone;
  final String custName;
  final String custPhone;
  final String custId;
  final String txnId;
  final String txnType;

  const ReceiptPage(
      {super.key,
        required this.amount,
        required this.bankName,
        required this.agentName,
        required this.agentPhone,
        required this.custName,
        required this.custPhone,
        required this.custId, required this.txnId, required this.txnType});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  List<BluetoothInfo> devices = [];
  String? selectedMac;
  bool _isLoading = false;
  String _connectionStatus = 'Not Connected';
  String _lastError = '';
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _connectionTimer;
  bool _isFirstPrintAttempt = true;
  bool _isBackgroundScanComplete = false;
  String? _lastConnectedMac;

  @override
  void initState() {
    super.initState();
    _initializePrinter();
    _startBackgroundBluetoothSetup();
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializePrinter() async {
    await _requestBluetoothPermission();
    // Start periodic connection check
    _connectionTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (selectedMac != null && !_isConnecting) {
        _checkConnectionStatus();
      }
    });
  }

  Future<void> _startBackgroundBluetoothSetup() async {
    // Run in background without UI blocking
    try {
      // Check if Bluetooth is enabled
      final bool isBluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!isBluetoothEnabled) {
        print("Bluetooth is disabled");
        return;
      }

      // Get paired devices
      final List<BluetoothInfo> result = await PrintBluetoothThermal.pairedBluetooths;

      setState(() {
        devices = result;
        _isBackgroundScanComplete = true;
      });

      // Try to auto-connect to the first available printer
      if (devices.isNotEmpty) {
        final firstDevice = devices.first;
        _lastConnectedMac = firstDevice.macAdress;

        // Try to connect in background
        _backgroundConnectToPrinter(firstDevice.macAdress!);
      }
    } catch (e) {
      print('Background Bluetooth setup error: $e');
    }
  }

  Future<void> _backgroundConnectToPrinter(String mac) async {
    try {
      if (await PrintBluetoothThermal.connectionStatus) {
        await PrintBluetoothThermal.disconnect;
      }

      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: mac,
      ).timeout(const Duration(seconds: 5));

      if (result) {
        setState(() {
          selectedMac = mac;
          _isConnected = true;
          _connectionStatus = 'Connected to ${devices.firstWhere((d) => d.macAdress == mac).name}';
        });
      }
    } catch (e) {
      print('Background connection failed: $e');
    }
  }

  Future<void> _checkConnectionStatus() async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected != _isConnected) {
        setState(() {
          _isConnected = isConnected;
          _connectionStatus = isConnected
              ? 'Connected to ${devices.firstWhere((d) => d.macAdress == selectedMac).name}'
              : 'Disconnected';
        });
      }
    } catch (e) {
      print('Connection check error: $e');
    }
  }
  Future<bool> _requestBluetoothPermission() async {
    try {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      final allGranted = statuses.values.every((status) => status.isGranted);

      if (!allGranted) {
        print("Some permissions were denied");
      }

      statuses.forEach((perm, status) {
        print('$perm: ${status.isGranted}');
      });

      return allGranted;
    } catch (e) {
      print("Permission error: ${e.toString()}");
      return false;
    }
  }

/*  Future<void> _requestBluetoothPermission() async {
    try {
      final statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (!mounted) return;

      if (statuses.values.any((status) => !status.isGranted)) {
        print("Some permissions were denied");
      }
    } catch (e) {
      print("Permission error: ${e.toString()}");
    }
  }*/

  Future<void> _scanDevices() async {
    setState(() {
      _isLoading = true;
      _lastError = '';
    });
    final List<BluetoothInfo> result = await PrintBluetoothThermal.pairedBluetooths;

    print("Found devices: ${result.length}");
    for (var d in result) {
      print('Device: ${d.name} - ${d.macAdress}');
    }

    try {
      final bool isBluetoothEnabled =
      await PrintBluetoothThermal.bluetoothEnabled;
      if (!isBluetoothEnabled) {
        throw Exception(
            'Bluetooth is disabled. Please enable Bluetooth and try again.');
      }

      final List<BluetoothInfo> result = await PrintBluetoothThermal
          .pairedBluetooths
          .timeout(const Duration(seconds: 15));

      setState(() => devices = result);

      if (devices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Bluetooth printers found")),
        );
      }
    } on TimeoutException {
      setState(() => _lastError = 'Device scan timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Device scan timed out")),
      );
    } catch (e) {
      setState(() => _lastError = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Scan failed: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _connectToPrinter(String mac) async {
    setState(() {
      _isConnecting = true;
      _lastError = '';
    });

    try {
      if (await PrintBluetoothThermal.connectionStatus) {
        await PrintBluetoothThermal.disconnect;
      }

      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: mac,
      ).timeout(const Duration(seconds: 10));

      if (result) {
        setState(() {
          selectedMac = mac;
          _isConnected = true;
          _connectionStatus =
          'Connected to ${devices.firstWhere((d) => d.macAdress == mac).name}';
          _lastConnectedMac = mac;
        });
      } else {
        throw Exception('Connection returned false');
      }
    } on TimeoutException {
      setState(() => _lastError = 'Connection timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection timed out")),
      );
    } catch (e) {
      setState(() => _lastError = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection failed: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  Future<Uint8List> _generateQrCodeImage() async {
    try {
      // Generate QR code data with all transaction details

      final qrData = widget.custPhone.isNotEmpty?'''
      Transaction ID: ${widget.txnId}
      Amount: Rs.${widget.amount}
      Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
      Bank: ${widget.bankName}
      Customer: ${widget.custName}
      Customer ID: ${widget.custId}
      Customer Phone: ${widget.custPhone}
      Agent: ${widget.agentName}
      Agent Phone: ${widget.agentPhone}
      Transaction Type: ${widget.txnType}
      ''': '''
      Transaction ID: ${widget.txnId}
      Amount: Rs.${widget.amount}
      Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
      Bank: ${widget.bankName}
      Customer: ${widget.custName}
      Customer ID: ${widget.custId}
      Agent: ${widget.agentName}
      Agent Phone: ${widget.agentPhone}
      Transaction Type: ${widget.txnType}
      ''';

      final qrImage = await QrPainter(
        data: qrData,
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      ).toImageData(200);

      return qrImage!.buffer.asUint8List();
    } catch (e) {
      print('QR generation error: $e');
      throw Exception('Failed to generate QR code');
    }
  }

  Future<void> _printReceipt() async {
    // First print attempt - try to use background connection
    if (_isFirstPrintAttempt) {
      setState(() {
        _isFirstPrintAttempt = false;
        _isLoading = true;
      });

      // If we have a previously connected printer, try to use it
      if (_lastConnectedMac != null && !_isConnected) {
        await _connectToPrinter(_lastConnectedMac!);
      }

      // If still not connected, show printer selection
      if (!_isConnected) {
        _showPrinterSelectionDialog();
        setState(() => _isLoading = false);
        return;
      }
    }

    // If no printer is selected, show selection dialog
    if (selectedMac == null) {
      _showPrinterSelectionDialog();
      return;
    }

    setState(() {
      _isLoading = true;
      _lastError = '';
    });

    try {
      // Check connection status
      if (!_isConnected) {
        await _connectToPrinter(selectedMac!);
      }

      // Generate QR code image
      final qrBytes = await _generateQrCodeImage();

      final List<int> bytes = [];
      bytes.addAll([0x1B, 0x40]); // Reset printer
      bytes.addAll([0x1B, 0x61, 0x01]); // Center alignment

      // Header (double height + bold)
      bytes.addAll([0x1B, 0x21, 0x30]); // Text size big
      bytes.addAll("${widget.bankName}\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]); // Reset style

      bytes.addAll("Transaction Receipt\n".codeUnits);
      bytes.addAll("-----------------------------\n".codeUnits);

      // Set alignment left for details
      bytes.addAll([0x1B, 0x61, 0x00]);

      // Current date and time
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MMM-yyyy').format(now);
      final formattedTime = DateFormat('hh:mm a').format(now);

      bytes.addAll("Date: $formattedDate\n".codeUnits);
      bytes.addAll("Time: $formattedTime\n".codeUnits);
      bytes.addAll("-----------------------------\n".codeUnits);

      // Transaction Details
      bytes.addAll([0x1B, 0x21, 0x08]); // Bold
      bytes.addAll("Transaction Details:\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]); // Reset

      bytes.addAll("Txn Type:         ${widget.txnType}\n".codeUnits);
      bytes.addAll("Amount:           Rs.${widget.amount}\n".codeUnits);
      bytes.addAll("Status:           Success\n".codeUnits);
      widget.txnId.isNotEmpty?
      bytes.addAll("Txn ID:           ${widget.txnId}\n".codeUnits):
      "";
      bytes.addAll("Customer:         ${widget.custName}\n".codeUnits);
      widget.custPhone.isNotEmpty?
      bytes.addAll("Customer Phone:   ${widget.custPhone}\n".codeUnits):
      "";
      bytes.addAll("Agent:            ${widget.agentName}\n".codeUnits);
      bytes.addAll("Agent Phone:      ${widget.agentPhone}\n".codeUnits);
      bytes.addAll("-----------------------------\n".codeUnits);

      // Print QR Code
      bytes.addAll([0x1B, 0x61, 0x01]); // Center alignment

      // Print the QR code image
      await PrintBluetoothThermal.writeBytes(bytes); // Print text first
      // await PrintBluetoothThermal.writeBytes(qrBytes); // Then print QR code

      // Continue with footer
      final List<int> footerBytes = [];
      footerBytes.addAll("\n-----------------------------\n".codeUnits);
      footerBytes.addAll([0x1B, 0x61, 0x01]); // Center alignment
      footerBytes.addAll("Thank you for banking with us!\n".codeUnits);

      // Feed paper and cut
      footerBytes.addAll([0x1D, 0x56, 0x41, 0x10]); // Partial cut
      footerBytes.addAll([0x1B, 0x64, 0x03]); // Feed 3 lines

      await PrintBluetoothThermal.writeBytes(footerBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Receipt printed successfully!")),
      );
    } on TimeoutException {
      setState(() => _lastError = 'Print job timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Print job timed out")),
      );
    } catch (e) {
      setState(() => _lastError = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Print failed: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPrinterSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Printer"),
        content: SizedBox(
          width: double.maxFinite,
          child: devices.isEmpty
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("No printers found"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _scanDevices();
                },
                child: const Text("Scan for Printers"),
              ),
            ],
          )
              : ListView.builder(
            shrinkWrap: true,
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                title: Text(device.name ?? "Unknown Device"),
                subtitle: Text(device.macAdress ?? "No MAC Address"),
                trailing: Icon(
                  Icons.print,
                  color: selectedMac == device.macAdress
                      ? Colors.blue
                      : Colors.grey,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _connectToPrinter(device.macAdress!);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Transaction Receipt",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: home2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Connection status indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isConnected ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isConnected ? Icons.check_circle : Icons.warning,
                          color: _isConnected ? Colors.green : Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _connectionStatus,
                          style: TextStyle(
                            color: _isConnected ? Colors.green : Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bank Header with gradient
                  Column(
                    children: [
                      Text(
                        widget.bankName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: home2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Transaction Successful",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // QR Code Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: home1.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: home2.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: home1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: QrImageView(
                            data: '''
                            Transaction ID: 1234567890
                            Amount: Rs.${widget.amount}
                            Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
                            Bank: ${widget.bankName}
                            Customer: ${widget.custName}
                            Customer ID: ${widget.custId}
                            Customer Phone: ${widget.custPhone}
                            Agent: ${widget.agentName}
                            Agent Phone: ${widget.agentPhone}
                            ''',
                            version: QrVersions.auto,
                            size: 120,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Scan to verify transaction",
                          style: TextStyle(
                            fontSize: 14,
                            color: home2.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Transaction Details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: home2.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: home2.withOpacity(0.05),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transaction Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: home2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow("Transaction ID:", widget.txnId),
                        Divider(height: 24, color: home2.withOpacity(0.1)),
                        _buildDetailRow(
                            "Date & Time:", "${DateFormat('dd-MMM-yyyy').format(DateTime.now())} - ${DateFormat('hh:mm a').format(DateTime.now())}"),
                        Divider(height: 24, color: home2.withOpacity(0.1)),
                        _buildDetailRow("Amount:", "Rs.${widget.amount}"),
                        Divider(height: 24, color: home2.withOpacity(0.1)),
                        _buildDetailRow("Customer Name:", widget.custName),
                        Divider(height: 24, color: home2.withOpacity(0.1)),

                        _buildDetailRow("Agent Name:", widget.agentName),
                        Divider(height: 24, color: home2.withOpacity(0.1)),
                        _buildDetailRow("Agent Phone:", widget.agentPhone),
                        widget.custPhone.isNotEmpty?
                        _buildDetailRow("Customer Phone:", widget.custPhone):
                        const SizedBox.shrink(),
                        Divider(height: 24, color: home2.withOpacity(0.1)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _printReceipt,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: home1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "PRINT",
                            style: TextStyle(
                              color: home1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: home2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // Download functionality
                          },
                          child: Text(
                            "DOWNLOAD",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading || _isConnecting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: home2.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: home2,
          ),
        ),
      ],
    );
  }
}
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:collection_qr_flutter/core/colors.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class ReceiptPage extends StatefulWidget {
//   final String amount;
//   final String bankName;
//   final String agentName;
//   final String agentPhone;
//   final String custName;
//   final String custPhone;
//   final String custId;
//
//   const ReceiptPage(
//       {super.key,
//         required this.amount,
//         required this.bankName,
//         required this.agentName,
//         required this.agentPhone,
//         required this.custName,
//         required this.custPhone,
//         required this.custId});
//
//   @override
//   State<ReceiptPage> createState() => _ReceiptPageState();
// }
//
// class _ReceiptPageState extends State<ReceiptPage> {
//   List<BluetoothInfo> devices = [];
//   String? selectedMac;
//   bool _isLoading = false;
//   String _connectionStatus = 'Not Connected';
//   String _lastError = '';
//   bool _isConnected = false;
//   bool _isConnecting = false;
//   Timer? _connectionTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePrinter();
//   }
//
//   @override
//   void dispose() {
//     _connectionTimer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _initializePrinter() async {
//     await _requestBluetoothPermission();
//     // Start periodic connection check
//     _connectionTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//       if (selectedMac != null && !_isConnecting) {
//         _checkConnectionStatus();
//       }
//     });
//   }
//
//   Future<void> _checkConnectionStatus() async {
//     try {
//       final bool isConnected = await PrintBluetoothThermal.connectionStatus;
//       if (isConnected != _isConnected) {
//         setState(() {
//           _isConnected = isConnected;
//           _connectionStatus = isConnected
//               ? 'Connected to ${devices.firstWhere((d) => d.macAdress == selectedMac).name}'
//               : 'Disconnected';
//         });
//       }
//     } catch (e) {
//       print('Connection check error: $e');
//     }
//   }
//
//   Future<void> _requestBluetoothPermission() async {
//     setState(() => _isLoading = true);
//     try {
//       final statuses = await [
//         Permission.bluetooth,
//         Permission.bluetoothScan,
//         Permission.bluetoothConnect,
//         Permission.location,
//       ].request();
//
//       if (!mounted) return;
//
//       if (statuses.values.any((status) => !status.isGranted)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Some permissions were denied")),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Permission error: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   Future<void> _scanDevices() async {
//     setState(() {
//       _isLoading = true;
//       _lastError = '';
//     });
//
//     try {
//       final bool isBluetoothEnabled =
//       await PrintBluetoothThermal.bluetoothEnabled;
//       if (!isBluetoothEnabled) {
//         throw Exception(
//             'Bluetooth is disabled. Please enable Bluetooth and try again.');
//       }
//
//       final List<BluetoothInfo> result = await PrintBluetoothThermal
//           .pairedBluetooths
//           .timeout(const Duration(seconds: 15));
//
//       setState(() => devices = result);
//
//       if (devices.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No Bluetooth printers found")),
//         );
//       }
//     } on TimeoutException {
//       setState(() => _lastError = 'Device scan timed out');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Device scan timed out")),
//       );
//     } catch (e) {
//       setState(() => _lastError = e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Scan failed: ${e.toString()}")),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   Future<void> _connectToPrinter(String mac) async {
//     setState(() {
//       _isConnecting = true;
//       _lastError = '';
//     });
//
//     try {
//       if (await PrintBluetoothThermal.connectionStatus) {
//         await PrintBluetoothThermal.disconnect;
//       }
//
//       final bool result = await PrintBluetoothThermal.connect(
//         macPrinterAddress: mac,
//       ).timeout(const Duration(seconds: 10));
//
//       if (result) {
//         setState(() {
//           selectedMac = mac;
//           _isConnected = true;
//           _connectionStatus =
//           'Connected to ${devices.firstWhere((d) => d.macAdress == mac).name}';
//         });
//       } else {
//         throw Exception('Connection returned false');
//       }
//     } on TimeoutException {
//       setState(() => _lastError = 'Connection timed out');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Connection timed out")),
//       );
//     } catch (e) {
//       setState(() => _lastError = e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Connection failed: ${e.toString()}")),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isConnecting = false);
//       }
//     }
//   }
//
//   Future<Uint8List> _generateQrCodeImage() async {
//     try {
//       // Generate QR code data with all transaction details
//       final qrData = '''
//       Transaction ID: 1234567890
//       Amount: Rs.${widget.amount}
//       Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
//       Bank: ${widget.bankName}
//       Customer: ${widget.custName}
//       Customer ID: ${widget.custId}
//       Customer Phone: ${widget.custPhone}
//       Agent: ${widget.agentName}
//       Agent Phone: ${widget.agentPhone}
//       ''';
//
//       final qrImage = await QrPainter(
//         data: qrData,
//         version: QrVersions.auto,
//         color: Colors.black,
//         emptyColor: Colors.white,
//       ).toImageData(200);
//
//       return qrImage!.buffer.asUint8List();
//     } catch (e) {
//       print('QR generation error: $e');
//       throw Exception('Failed to generate QR code');
//     }
//   }
//
//   Future<void> _printReceipt() async {
//     if (selectedMac == null) {
//       _showPrinterSelectionDialog();
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _lastError = '';
//     });
//
//     try {
//       // Check connection status
//       if (!_isConnected) {
//         await _connectToPrinter(selectedMac!);
//       }
//
//       // Generate QR code image
//       final qrBytes = await _generateQrCodeImage();
//
//       final List<int> bytes = [];
//       bytes.addAll([0x1B, 0x40]); // Reset printer
//       bytes.addAll([0x1B, 0x61, 0x01]); // Center alignment
//
//       // Header (double height + bold)
//       bytes.addAll([0x1B, 0x21, 0x30]); // Text size big
//       bytes.addAll("${widget.bankName}\n".codeUnits);
//       bytes.addAll([0x1B, 0x21, 0x00]); // Reset style
//
//       bytes.addAll("Transaction Receipt\n".codeUnits);
//       bytes.addAll("-----------------------------\n".codeUnits);
//
//       // Set alignment left for details
//       bytes.addAll([0x1B, 0x61, 0x00]);
//
//       // Current date and time
//       final now = DateTime.now();
//       final formattedDate = DateFormat('dd-MMM-yyyy').format(now);
//       final formattedTime = DateFormat('hh:mm a').format(now);
//
//       bytes.addAll("Date: $formattedDate\n".codeUnits);
//       bytes.addAll("Time: $formattedTime\n".codeUnits);
//       bytes.addAll("-----------------------------\n".codeUnits);
//
//       // Transaction Details
//       bytes.addAll([0x1B, 0x21, 0x08]); // Bold
//       bytes.addAll("Transaction Details:\n".codeUnits);
//       bytes.addAll([0x1B, 0x21, 0x00]); // Reset
//
//       bytes.addAll("Amount:           Rs.${widget.amount}\n".codeUnits);
//       bytes.addAll("Status:           Success\n".codeUnits);
//       bytes.addAll("Customer:         ${widget.custName}\n".codeUnits);
//       // bytes.addAll("Customer ID:      ${widget.custId}\n".codeUnits);
//       bytes.addAll("Customer Phone:   ${widget.custPhone}\n".codeUnits);
//       bytes.addAll("Agent:            ${widget.agentName}\n".codeUnits);
//       bytes.addAll("Agent Phone:      ${widget.agentPhone}\n".codeUnits);
//       // bytes.addAll("Reference:        Invoice #4567\n".codeUnits);
//       bytes.addAll("-----------------------------\n".codeUnits);
//
//       // Print QR Code
//       bytes.addAll([0x1B, 0x61, 0x01]); // Center alignment
//       // bytes.addAll("Verification QR Code:\n".codeUnits);
//
//       // Print the QR code image
//       await PrintBluetoothThermal.writeBytes(bytes); // Print text first
//       // await PrintBluetoothThermal.writeBytes(qrBytes); // Then print QR code
//
//       // Continue with footer
//       final List<int> footerBytes = [];
//       footerBytes.addAll("\n-----------------------------\n".codeUnits);
//       footerBytes.addAll([0x1B, 0x61, 0x01]); // Center alignment
//       footerBytes.addAll("Thank you for banking with us!\n".codeUnits);
//       // footerBytes.addAll("For support contact:\n".codeUnits);
//       // footerBytes.addAll("support@xyzbank.com\n".codeUnits);
//       // footerBytes.addAll("+91 9876543210\n".codeUnits);
//
//       // Feed paper and cut
//       footerBytes.addAll([0x1D, 0x56, 0x41, 0x10]); // Partial cut
//       footerBytes.addAll([0x1B, 0x64, 0x03]); // Feed 3 lines
//
//       await PrintBluetoothThermal.writeBytes(footerBytes);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Receipt printed successfully!")),
//       );
//     } on TimeoutException {
//       setState(() => _lastError = 'Print job timed out');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Print job timed out")),
//       );
//     } catch (e) {
//       setState(() => _lastError = e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Print failed: ${e.toString()}")),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   void _showPrinterSelectionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Select Printer"),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: devices.isEmpty
//               ? Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("No printers found"),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _scanDevices();
//                 },
//                 child: const Text("Scan for Printers"),
//               ),
//             ],
//           )
//               : ListView.builder(
//             shrinkWrap: true,
//             itemCount: devices.length,
//             itemBuilder: (context, index) {
//               final device = devices[index];
//               return ListTile(
//                 title: Text(device.name ?? "Unknown Device"),
//                 subtitle: Text(device.macAdress ?? "No MAC Address"),
//                 trailing: Icon(
//                   Icons.print,
//                   color: selectedMac == device.macAdress
//                       ? Colors.blue
//                       : Colors.grey,
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _connectToPrinter(device.macAdress!);
//                 },
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Transaction Receipt",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: home2,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: home2),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   // Bank Header with gradient
//                   Column(
//                     children: [
//                       Text(
//                         widget.bankName,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: home2,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Transaction Successful",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.green[500],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // QR Code Section
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: home1.withOpacity(0.3)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: home2.withOpacity(0.1),
//                           spreadRadius: 2,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: home1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: QrImageView(
//                             data: '''
//                             Transaction ID: 1234567890
//                             Amount: Rs.${widget.amount}
//                             Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
//                             Bank: ${widget.bankName}
//                             Customer: ${widget.custName}
//                             Customer ID: ${widget.custId}
//                             Customer Phone: ${widget.custPhone}
//                             Agent: ${widget.agentName}
//                             Agent Phone: ${widget.agentPhone}
//                             ''',
//                             version: QrVersions.auto,
//                             size: 120,
//                             backgroundColor: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "Scan to verify transaction",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: home2.withOpacity(0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Transaction Details
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: home2.withOpacity(0.1)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: home2.withOpacity(0.05),
//                           spreadRadius: 2,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Transaction Details",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: home2,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildDetailRow("Transaction ID:", "1234567890"),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow(
//                             "Date & Time:", "${DateFormat('dd-MMM-yyyy').format(DateTime.now())} - ${DateFormat('hh:mm a').format(DateTime.now())}"),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Amount:", "Rs.${widget.amount}"),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Customer Name:", widget.custName),
//                         // Divider(height: 24, color: home2.withOpacity(0.1)),
//                         // _buildDetailRow("Customer ID:", widget.custId),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Customer Phone:", widget.custPhone),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Agent Name:", widget.agentName),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Agent Phone:", widget.agentPhone),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         // _buildDetailRow("Reference:", "Invoice #4567"),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Action Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: _printReceipt,
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             side: BorderSide(color: home1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: Text(
//                             "PRINT",
//                             style: TextStyle(
//                               color: home1,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: home2,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 0,
//                           ),
//                           onPressed: () {
//                             // Download functionality
//                           },
//                           child: Text(
//                             "DOWNLOAD",
//                             style: TextStyle(
//                               color: white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (_isLoading || _isConnecting)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: home2.withOpacity(0.7),
//             fontSize: 14,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//             color: home2,
//           ),
//         ),
//       ],
//     );
//   }
// }