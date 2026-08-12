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
  String lastError = '';
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _connectionTimer;
  bool isFirstPrintAttempt = true;
  bool isBackgroundScanComplete = false;
  String? lastConnectedMac;
  bool isTakingSS = false;
  bool showFlash = false;
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
        if (printStatementStatus) {
          print("Bluetooth is disabled");
        }

        return;
      }

      // Get paired devices
      final List<BluetoothInfo> result =
      await PrintBluetoothThermal.pairedBluetooths;

      setState(() {
        devices = result;
        isBackgroundScanComplete = true;
      });

      // Try to auto-connect to the first available printer
      if (devices.isNotEmpty) {
        final firstDevice = devices.first;
        lastConnectedMac = firstDevice.macAdress;

        // Try to connect in background
        _backgroundConnectToPrinter(firstDevice.macAdress);
      }
    } catch (e) {
      if (printStatementStatus) {
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
          'Connected to ${devices
              .firstWhere((d) => d.macAdress == mac)
              .name}';
        });
      }
    } catch (e) {
      if (printStatementStatus) {
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
              ? 'Connected to ${devices
              .firstWhere((d) => d.macAdress == selectedMac)
              .name}'
              : 'Disconnected';
        });
      }
    } catch (e) {
      if (printStatementStatus) {
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
        if (printStatementStatus) {
          print("Some permissions were denied");
        }
      }

      statuses.forEach((perm, status) {
        if (printStatementStatus) {
          print('$perm: ${status.isGranted}');
        }
      });

      return allGranted;
    } catch (e) {
      if (printStatementStatus) {
        print("Permission error: ${e.toString()}");
      }

      return false;
    }
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isLoading = true;
      lastError = '';
    });
    final List<BluetoothInfo> result =
    await PrintBluetoothThermal.pairedBluetooths;

    if (printStatementStatus) {
      print("Found devices: ${result.length}");
    }

    for (var d in result) {
      if (printStatementStatus) {
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
      setState(() => lastError = 'Device scan timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Device scan timed out")),
      );
    } catch (e) {
      setState(() => lastError = e.toString());
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
      lastError = '';
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
          'Connected to ${devices
              .firstWhere((d) => d.macAdress == mac)
              .name}';
          lastConnectedMac = mac;
        });
      } else {
        throw Exception('Connection returned false');
      }
    } on TimeoutException {
      setState(() => lastError = 'Connection timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection timed out")),
      );
    } catch (e) {
      setState(() => lastError = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection failed: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  Future<Uint8List> generateQrCodeImage() async {
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
      if (printStatementStatus) {
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
      lastError = '';
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
      setState(() => lastError = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Print failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPrinterSelectionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// TOP HANDLE
                Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                /// HEADER
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: home1.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.print_rounded,
                        color: home1,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Printer",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            devices.isEmpty
                                ? "No printers available"
                                : "${devices.length} printers found",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// EMPTY STATE
                if (devices.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.print_disabled_rounded,
                            size: 42,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "No Printers Found",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Make sure your printer is powered on and within Bluetooth range.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _scanDevices();
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text("Scan Again"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: home1,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                /// DEVICE LIST
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: devices.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        final isSelected = selectedMac == device.macAdress;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? home1.withValues(alpha: .08)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? home1.withValues(alpha: .35)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? home1.withValues(alpha: .15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.print_rounded,
                                color:
                                isSelected ? home1 : Colors.grey.shade700,
                              ),
                            ),
                            title: Text(
                              device.name ?? "Unknown Device",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                device.macAdress ?? "No MAC Address",
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            trailing: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? home1 : Colors.transparent,
                                border: Border.all(
                                  color:
                                  isSelected ? home1 : Colors.grey.shade400,
                                  width: 1.6,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _connectToPrinter(
                                device.macAdress,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 18),

                /// CANCEL BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takeScreenshotAndShare() async {
    // 1. Hide sensitive data and prepare for capture
    setState(() {
      isTakingSS = true;
      // Don't touch _showFlash here yet
    });

    // Wait for UI to update and hide the sensitive data
    await Future.delayed(const Duration(milliseconds: 20));

    // 2. Show the flash animation
    setState(() {
      showFlash = true;
    });

    // Wait a tiny bit for the flash to actually appear on screen
    await Future.delayed(const Duration(milliseconds: 10));

    // 3. Capture the screenshot (UI is now with hidden data + flash visible)
    final Uint8List? imageBytes = await _screenshotController.capture();

    // 4. Immediately hide the flash AND show the real data again
    setState(() {
      showFlash = false; // <- This was missing!
      isTakingSS = false;
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

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .04),
                            blurRadius: 24,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          /// TOP BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: home2.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: home2.withValues(alpha: .15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.verified_rounded,
                                  color: home2,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Verified Transaction QR",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: .2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          /// QR SECTION
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [

                                /// BACKGROUND GLOW
                                Container(
                                  width: 170,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: home2.withValues(alpha: .05),
                                  ),
                                ),

                                /// QR
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
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
                                    size: 165,
                                    backgroundColor: Colors.white,
                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: Colors.black,
                                    ),
                                    dataModuleStyle: const QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.square,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// INFO CARD
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: home2.withValues(alpha: .08),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: home2,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Quick Verification",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Scan this QR code to instantly verify transaction details securely.",
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          height: 1.4,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: home2.withValues(alpha: .08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: home2.withValues(alpha: .06),
                            blurRadius: 24,
                            spreadRadius: 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// HEADER
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: home2.withValues(alpha: .08),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: home2,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Transaction Details",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: home2,
                                        letterSpacing: -.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Secure transaction summary",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          /// STATUS CARD
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: .06),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: .12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: .12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Transaction Successful",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Payment processed securely",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          /// DETAILS
                          _buildDetailRow(
                            "Transaction ID",
                            widget.receiptDataModel.txnId,
                          ),

                          _buildDetailRow(
                            "Transaction Type",
                            widget.receiptDataModel.tranType.contains("CASH")
                                ? "CASH"
                                : "UPI",
                          ),

                          _buildDetailRow(
                            "Customer Acc No",
                            widget.receiptDataModel.accNo,
                          ),

                          _buildDetailRow(
                            "Date & Time",
                            widget.receiptDataModel.dat.toString(),
                          ),

                          /// AMOUNT HIGHLIGHT
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  home2,
                                  home2.withValues(alpha: .85),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: home2.withValues(alpha: .25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.currency_rupee_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Transaction Amount",
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: .8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₹${widget.receiptDataModel.amount}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _buildDetailRow(
                            "Customer Name",
                            widget.receiptDataModel.custName,
                          ),

                          _buildDetailRow(
                            "Agent Name",
                            widget.receiptDataModel.agentName,
                          ),

                          _buildDetailRow(
                            "Agent Phone",
                            widget.receiptDataModel.agentPhone,
                          ),

                          if (widget.receiptDataModel.custPhone.isNotEmpty)
                            _buildDetailRow(
                              "Customer Phone",
                              widget.receiptDataModel.custPhone,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    if (isTakingSS == false)
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
                                side: BorderSide(
                                    color: home1.withValues(alpha: 0.6)),
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
                                shadowColor: home2.withValues(alpha: 0.3),
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

                  ],
                ),
              ),
            ),
            if (_isLoading || _isConnecting)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            // if (_showFlash)
            //   IgnorePointer(
            //     // Makes the flash layer non-interactive
            //     child: Container(
            //       color: Colors.white.withValues(alpha:0.9), // Bright white flash
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LABEL SECTION
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 36,
                  height: 3,
                  decoration: BoxDecoration(
                    color: home2.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          /// VALUE SECTION
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: home2,
                  letterSpacing: .2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

