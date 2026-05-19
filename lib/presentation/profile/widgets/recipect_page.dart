import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collection_qr_flutter/core/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils.dart';

class ReceiptPage extends StatefulWidget {
  final ReceiptDataModel receiptDataModel;

  const ReceiptPage({super.key, required this.receiptDataModel});

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
  bool _isTakingSS = false;
  bool _showFlash = false;
  final ScreenshotController _screenshotController = ScreenshotController();

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
    _connectionTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (selectedMac != null && !_isConnecting) {
        _checkConnectionStatus();
      }
    });
  }

  Future<void> _startBackgroundBluetoothSetup() async {
    // Run in background without UI blocking
    try {
      // Check if Bluetooth is enabled
      final bool isBluetoothEnabled =
          await PrintBluetoothThermal.bluetoothEnabled;
      if (!isBluetoothEnabled) {
        if(printStatementStatus){
          print("Bluetooth is disabled");
        }

        return;
      }

      // Get paired devices
      final List<BluetoothInfo> result =
          await PrintBluetoothThermal.pairedBluetooths;

      setState(() {
        devices = result;
        _isBackgroundScanComplete = true;
      });

      // Try to auto-connect to the first available printer
      if (devices.isNotEmpty) {
        final firstDevice = devices.first;
        _lastConnectedMac = firstDevice.macAdress;

        // Try to connect in background
        _backgroundConnectToPrinter(firstDevice.macAdress);
      }
    } catch (e) {
      if (printStatementStatus){
        print('Background Bluetooth setup error: $e');
      }

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
          _connectionStatus =
              'Connected to ${devices.firstWhere((d) => d.macAdress == mac).name}';
        });
      }
    } catch (e) {
if (printStatementStatus){
  print('Background connection failed: $e');
}

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
if (printStatementStatus){

  print('Connection check error: $e');
}

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
if (printStatementStatus){
  print("Some permissions were denied");
}

      }

      statuses.forEach((perm, status) {

if (printStatementStatus){
  print('$perm: ${status.isGranted}');
}

      });

      return allGranted;
    } catch (e) {
if (printStatementStatus){
  print("Permission error: ${e.toString()}");
}

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
    final List<BluetoothInfo> result =
        await PrintBluetoothThermal.pairedBluetooths;

if (printStatementStatus){
  print("Found devices: ${result.length}");
}

    for (var d in result) {
if (printStatementStatus){
  print('Device: ${d.name} - ${d.macAdress}');
}

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

      final qrData = widget.receiptDataModel.custPhone.isNotEmpty
          ? '''
      Transaction ID: ${widget.receiptDataModel.txnId}
      Amount: Rs.${widget.receiptDataModel.amount}
      Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
      Bank: ${widget.receiptDataModel.bankName}
      Customer: ${widget.receiptDataModel.custName}
      Customer ID: ${widget.receiptDataModel.custId}
      Customer Phone: ${widget.receiptDataModel.custPhone}
      Agent: ${widget.receiptDataModel.agentName}
      Agent Phone: ${widget.receiptDataModel.agentPhone}
      Transaction Type: ${widget.receiptDataModel.txnType}
      '''
          : '''
      Transaction ID: ${widget.receiptDataModel.txnId}
      Amount: Rs.${widget.receiptDataModel.amount}
      Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
      Bank: ${widget.receiptDataModel.bankName}
      Customer: ${widget.receiptDataModel.custName}
      Customer ID: ${widget.receiptDataModel.custId}
      Agent: ${widget.receiptDataModel.agentName}
      Agent Phone: ${widget.receiptDataModel.agentPhone}
      Transaction Type: ${widget.receiptDataModel.txnType}
      ''';

      final qrImage = await QrPainter(
        data: qrData,
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
      ).toImageData(200);

      return qrImage!.buffer.asUint8List();
    } catch (e) {
if (printStatementStatus){
  print('QR generation error: $e');
}

      throw Exception('Failed to generate QR code');
    }
  }

  Future<void> _printReceipt() async {
    if (selectedMac == null) {
      _showPrinterSelectionDialog();
      return;
    }

    setState(() {
      _isLoading = true;
      _lastError = '';
    });

    try {
      if (!_isConnected) {
        await _connectToPrinter(selectedMac!);
      }

      final now = DateTime.now();
      final formattedDate = DateFormat('dd MMM yyyy').format(now);
      final formattedTime = DateFormat('hh:mm a').format(now);

      final List<int> bytes = [];

      // Reset
      bytes.addAll([0x1B, 0x40]);

      // ===== HEADER =====
      bytes.addAll([0x1B, 0x61, 0x01]); // Center
      bytes.addAll([0x1B, 0x21, 0x30]); // Big + Bold
      bytes.addAll("${widget.receiptDataModel.bankName}\n".codeUnits);

      bytes.addAll([0x1B, 0x21, 0x00]);
      bytes.addAll("Transaction Receipt\n".codeUnits);

      bytes.addAll("\n".codeUnits);
      bytes.addAll("------------------------------\n".codeUnits);

      // ===== DATE & TIME =====
      bytes.addAll([0x1B, 0x61, 0x00]); // Left
      bytes.addAll("Date : $formattedDate\n".codeUnits);
      bytes.addAll("Time : $formattedTime\n".codeUnits);

      bytes.addAll("------------------------------\n".codeUnits);

      // ===== TRANSACTION =====
      bytes.addAll([0x1B, 0x21, 0x08]); // Bold
      bytes.addAll("TRANSACTION\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]);

      String txnType =
          widget.receiptDataModel.tranType.contains("CASH") ? "CASH" : "UPI";

      bytes.addAll("Type     : $txnType\n".codeUnits);
      bytes.addAll("Status   : SUCCESS\n".codeUnits);

      if (widget.receiptDataModel.txnId.isNotEmpty) {
        bytes.addAll("Txn ID   : ${widget.receiptDataModel.txnId}\n".codeUnits);
      }

      bytes.addAll("\n".codeUnits);

      // ===== AMOUNT (Highlight) =====
      bytes.addAll([0x1B, 0x61, 0x01]); // Center
      bytes.addAll([0x1B, 0x21, 0x30]); // Large
      bytes.addAll("Rs. ${widget.receiptDataModel.amount}\n".codeUnits);

      bytes.addAll([0x1B, 0x21, 0x00]);
      bytes.addAll([0x1B, 0x61, 0x00]);

      bytes.addAll("------------------------------\n".codeUnits);

      // ===== CUSTOMER =====
      bytes.addAll([0x1B, 0x21, 0x08]);
      bytes.addAll("CUSTOMER\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]);

      bytes
          .addAll("Name     : ${widget.receiptDataModel.custName}\n".codeUnits);

      if (widget.receiptDataModel.custPhone.isNotEmpty) {
        bytes.addAll(
            "Phone    : ${widget.receiptDataModel.custPhone}\n".codeUnits);
      }

      bytes.addAll("A/C No   : ${widget.receiptDataModel.accNo}\n".codeUnits);

      bytes.addAll("------------------------------\n".codeUnits);

      // ===== AGENT =====
      bytes.addAll([0x1B, 0x21, 0x08]);
      bytes.addAll("AGENT\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]);

      bytes.addAll(
          "Name     : ${widget.receiptDataModel.agentName}\n".codeUnits);
      bytes.addAll(
          "Phone    : ${widget.receiptDataModel.agentPhone}\n".codeUnits);

      bytes.addAll("------------------------------\n".codeUnits);

      // ===== FOOTER =====
      bytes.addAll([0x1B, 0x61, 0x01]); // Center
      bytes.addAll("\nThank you for banking with us!\n".codeUnits);

      bytes.addAll("\n\n".codeUnits);

      // Cut
      bytes.addAll([0x1D, 0x56, 0x41, 0x10]);

      await PrintBluetoothThermal.writeBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Receipt printed successfully!")),
      );
    } catch (e) {
      setState(() => _lastError = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Print failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
/*  Future<void> _printReceipt() async {
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
      bytes.addAll("${widget.receiptDataModel.bankName}\n".codeUnits);
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

      bytes.addAll("Txn Type:         ${widget.receiptDataModel.tranType.contains("CASH")?"CASH":"UPI"}\n".codeUnits);
      bytes.addAll("Amount:           Rs.${widget.receiptDataModel.amount}\n".codeUnits);
      bytes.addAll("Status:           Success\n".codeUnits);
      widget.receiptDataModel.txnId.isNotEmpty
          ? bytes.addAll("Txn ID:           ${widget.receiptDataModel.txnId}\n".codeUnits)
          : "";
      bytes.addAll("Customer:         ${widget.receiptDataModel.custName}\n".codeUnits);
      widget.receiptDataModel.custPhone.isNotEmpty
          ? bytes.addAll("Customer Phone:   ${widget.receiptDataModel.custPhone}\n".codeUnits)
          : "";
      bytes.addAll("Account No:            ${widget.receiptDataModel.accNo}\n".codeUnits);
      bytes.addAll("Agent:            ${widget.receiptDataModel.agentName}\n".codeUnits);
      bytes.addAll("Agent Phone:      ${widget.receiptDataModel.agentPhone}\n".codeUnits);
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
  }*/

  void _showPrinterSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HANDLE BAR
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// TITLE
              Row(
                children: const [
                  Icon(Icons.print, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Select Printer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// CONTENT
              devices.isEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Icon(
                          Icons.print_disabled,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "No printers found",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Make sure your printer is on and nearby",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _scanDevices();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Scan for Printers"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: devices.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.grey.shade200),
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          final isSelected = selectedMac == device.macAdress;

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.grey.shade200,
                              child: Icon(
                                Icons.print,
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                            ),
                            title: Text(
                              device.name ?? "Unknown Device",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              device.macAdress ?? "No MAC Address",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle,
                                    color: Colors.blue)
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              _connectToPrinter(device.macAdress);
                            },
                          );
                        },
                      ),
                    ),

              const SizedBox(height: 12),

              /// CANCEL BUTTON
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }
  // void _showPrinterSelectionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Select Printer"),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: devices.isEmpty
  //             ? Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const Text("No printers found"),
  //                   const SizedBox(height: 16),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       _scanDevices();
  //                     },
  //                     child: const Text("Scan for Printers"),
  //                   ),
  //                 ],
  //               )
  //             : ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: devices.length,
  //                 itemBuilder: (context, index) {
  //                   final device = devices[index];
  //                   return ListTile(
  //                     title: Text(device.name ?? "Unknown Device"),
  //                     subtitle: Text(device.macAdress ?? "No MAC Address"),
  //                     trailing: Icon(
  //                       Icons.print,
  //                       color: selectedMac == device.macAdress
  //                           ? Colors.blue
  //                           : Colors.grey,
  //                     ),
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                       _connectToPrinter(device.macAdress);
  //                     },
  //                   );
  //                 },
  //               ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // This function will be called by the button
  Future<void> _takeScreenshotAndShare() async {
    // 1. Hide sensitive data and prepare for capture
    setState(() {
      _isTakingSS = true;
      // Don't touch _showFlash here yet
    });

    // Wait for UI to update and hide the sensitive data
    await Future.delayed(const Duration(milliseconds: 20));

    // 2. Show the flash animation
    setState(() {
      _showFlash = true;
    });

    // Wait a tiny bit for the flash to actually appear on screen
    await Future.delayed(const Duration(milliseconds: 10));

    // 3. Capture the screenshot (UI is now with hidden data + flash visible)
    final Uint8List? imageBytes = await _screenshotController.capture();

    // 4. Immediately hide the flash AND show the real data again
    setState(() {
      _showFlash = false; // <- This was missing!
      _isTakingSS = false;
    });

    if (imageBytes == null) return;

    // 5. Share the image
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/screenshot.png').create();
    await file.writeAsBytes(imageBytes);
    await Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Transaction Receipt",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: home2,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: home2),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Connection status indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isConnected
                            ? Colors.green[100]
                            : Colors.orange[100],
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
                          const SizedBox(width: 8),
                          Text(
                            _connectionStatus,
                            style: TextStyle(
                              color:
                                  _isConnected ? Colors.green : Colors.orange,
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
                          widget.receiptDataModel.bankName,
                          style: const TextStyle(
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

                    const SizedBox(height: 10),

                    // QR Code Section
                    /* Container(
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
                              Amount: Rs.${widget.receiptDataModel.amount}
                              Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
                              Bank: ${widget.receiptDataModel.bankName}
                              Customer: ${widget.receiptDataModel.custName}
                              Customer ID: ${widget.receiptDataModel.custId}
                              Customer Phone: ${widget.receiptDataModel.custPhone}
                              Agent: ${widget.receiptDataModel.agentName}
                              Agent Phone: ${widget.receiptDataModel.agentPhone}
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
                    ),*/
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          /// TITLE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified, color: home2, size: 18),
                              const SizedBox(width: 6),
                              const Text(
                                "Transaction QR",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// QR CONTAINER (FOCUS AREA)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: QrImageView(
                              data: '''
Transaction ID: 1234567890
Amount: Rs.${widget.receiptDataModel.amount}
Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
Bank: ${widget.receiptDataModel.bankName}
Customer: ${widget.receiptDataModel.custName}
Customer ID: ${widget.receiptDataModel.custId}
Customer Phone: ${widget.receiptDataModel.custPhone}
Agent: ${widget.receiptDataModel.agentName}
Agent Phone: ${widget.receiptDataModel.agentPhone}
''',
                              version: QrVersions.auto,
                              size: 140,
                              backgroundColor: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// DESCRIPTION
                          Text(
                            "Scan to verify this transaction",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Transaction Details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
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
                          const SizedBox(height: 10),
                          _buildDetailRow(
                              "Transaction ID:", widget.receiptDataModel.txnId),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow(
                              "Transaction Type:",
                              widget.receiptDataModel.tranType.contains("CASH")
                                  ? "CASH"
                                  : "UPI"),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow("Customer Acc No:",
                              widget.receiptDataModel.accNo),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow("Date & Time",
                              widget.receiptDataModel.dat.toString()),
                          // _buildDetailRow("Date & Time:",
                          //     "${DateFormat('dd-MMM-yyyy').format(DateTime.now())} - ${DateFormat('hh:mm a').format(DateTime.now())}"),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow("Amount:",
                              "Rs.${widget.receiptDataModel.amount}"),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow("Customer Name:",
                              widget.receiptDataModel.custName),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow(
                              "Agent Name:", widget.receiptDataModel.agentName),
                          Divider(height: 10, color: home2.withOpacity(0.1)),
                          _buildDetailRow("Agent Phone:",
                              widget.receiptDataModel.agentPhone),
                          Divider(height: 10, color: home2.withOpacity(0.1)),

                          widget.receiptDataModel.custPhone.isNotEmpty
                              ? _buildDetailRow("Customer Phone:",
                                  widget.receiptDataModel.custPhone)
                              : const SizedBox.shrink(),
                       //   Divider(height: 24, color: home2.withOpacity(0.1)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    if (_isTakingSS == false)
                      Row(
                        children: [
                          /// PRINT BUTTON
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _printReceipt,
                              icon: const Icon(Icons.print, size: 18),
                              label: const Text("Print"),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: home1.withOpacity(0.6)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                foregroundColor: home1,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// SHARE BUTTON
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _takeScreenshotAndShare();
                              },
                              icon: const Icon(
                                Icons.share,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Share",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: home2,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 2,
                                shadowColor: home2.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    /*  Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _printReceipt,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: home1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                _takeScreenshotAndShare();
                                // Download functionality
                              },
                              child: const Text(
                                "Share",
                                style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),*/
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
            // if (_showFlash)
            //   IgnorePointer(
            //     // Makes the flash layer non-interactive
            //     child: Container(
            //       color: Colors.white.withOpacity(0.9), // Bright white flash
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  //   fontWeight: FontWeight.w600,
                  color: home2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
/*  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: home2.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style:const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: home2,
          ),
        ),
      ],
    );
  }*/
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
//       Amount: Rs.${widget.receiptDataModel.amount}
//       Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
//       Bank: ${widget.receiptDataModel.bankName}
//       Customer: ${widget.receiptDataModel.custName}
//       Customer ID: ${widget.receiptDataModel.custId}
//       Customer Phone: ${widget.receiptDataModel.custPhone}
//       Agent: ${widget.receiptDataModel.agentName}
//       Agent Phone: ${widget.receiptDataModel.agentPhone}
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
//       bytes.addAll("${widget.receiptDataModel.bankName}\n".codeUnits);
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
//       bytes.addAll("Amount:           Rs.${widget.receiptDataModel.amount}\n".codeUnits);
//       bytes.addAll("Status:           Success\n".codeUnits);
//       bytes.addAll("Customer:         ${widget.receiptDataModel.custName}\n".codeUnits);
//       // bytes.addAll("Customer ID:      ${widget.receiptDataModel.custId}\n".codeUnits);
//       bytes.addAll("Customer Phone:   ${widget.receiptDataModel.custPhone}\n".codeUnits);
//       bytes.addAll("Agent:            ${widget.receiptDataModel.agentName}\n".codeUnits);
//       bytes.addAll("Agent Phone:      ${widget.receiptDataModel.agentPhone}\n".codeUnits);
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
//                         widget.receiptDataModel.bankName,
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
//                             Amount: Rs.${widget.receiptDataModel.amount}
//                             Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}
//                             Bank: ${widget.receiptDataModel.bankName}
//                             Customer: ${widget.receiptDataModel.custName}
//                             Customer ID: ${widget.receiptDataModel.custId}
//                             Customer Phone: ${widget.receiptDataModel.custPhone}
//                             Agent: ${widget.receiptDataModel.agentName}
//                             Agent Phone: ${widget.receiptDataModel.agentPhone}
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
//                         _buildDetailRow("Amount:", "Rs.${widget.receiptDataModel.amount}"),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Customer Name:", widget.receiptDataModel.custName),
//                         // Divider(height: 24, color: home2.withOpacity(0.1)),
//                         // _buildDetailRow("Customer ID:", widget.receiptDataModel.custId),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Customer Phone:", widget.receiptDataModel.custPhone),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Agent Name:", widget.receiptDataModel.agentName),
//                         Divider(height: 24, color: home2.withOpacity(0.1)),
//                         _buildDetailRow("Agent Phone:", widget.receiptDataModel.agentPhone),
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
