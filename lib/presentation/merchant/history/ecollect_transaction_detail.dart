import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/colors.dart';
import '../../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
/// Requires the same packages already used by the printing flow elsewhere
/// in the app: permission_handler, print_bluetooth_thermal, screenshot,
/// share_plus, path_provider, intl, and google_fonts.

class EcollectTransactionDetail extends StatefulWidget {
  final PaymentTransaction paymentTransaction;

  const EcollectTransactionDetail({super.key, required this.paymentTransaction});

  @override
  State<EcollectTransactionDetail> createState() =>
      _EcollectTransactionDetailState();
}

class _EcollectTransactionDetailState extends State<EcollectTransactionDetail> {
  // ---- Printer / connection state ----
  List<BluetoothInfo> devices = [];
  String? selectedMac;
  bool _isLoading = false;
  String _connectionStatus = 'Not Connected';
  String lastError = '';
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _connectionTimer;
  String? lastConnectedMac;

  // ---- Screenshot / share state ----
  bool isTakingSS = false;
 // bool showFlash = false;
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
    _connectionTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (selectedMac != null && !_isConnecting) {
        _checkConnectionStatus();
      }
    });
  }

  Future<void> _startBackgroundBluetoothSetup() async {
    try {
      final bool isBluetoothEnabled =
      await PrintBluetoothThermal.bluetoothEnabled;
      if (!isBluetoothEnabled) return;

      final List<BluetoothInfo> result =
      await PrintBluetoothThermal.pairedBluetooths;
      if (!mounted) return;
      setState(() => devices = result);

      if (devices.isNotEmpty) {
        final firstDevice = devices.first;
        lastConnectedMac = firstDevice.macAdress;
        _backgroundConnectToPrinter(firstDevice.macAdress);
      }
    } catch (_) {
      // Silent — this is a background convenience connect only. The user
      // can still pick a printer manually from the print button.
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

      if (result && mounted) {
        setState(() {
          selectedMac = mac;
          _isConnected = true;
          _connectionStatus =
          'Connected to ${devices.firstWhere((d) => d.macAdress == mac).name}';
        });
      }
    } catch (_) {
      // Background attempt only — failures here are expected and silent.
    }
  }

  Future<void> _checkConnectionStatus() async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected != _isConnected && mounted) {
        setState(() {
          _isConnected = isConnected;
          _connectionStatus = isConnected
              ? 'Connected to ${devices.firstWhere((d) => d.macAdress == selectedMac).name}'
              : 'Disconnected';
        });
      }
    } catch (_) {
      // Non-fatal — the periodic check will simply retry.
    }
  }

  Future<bool> _requestBluetoothPermission() async {
    try {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      return statuses.values.every((status) => status.isGranted);
    } catch (_) {
      return false;
    }
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isLoading = true;
      lastError = '';
    });

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

      if (devices.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Bluetooth printers found")),
        );
      }
    } on TimeoutException {
      setState(() => lastError = 'Device scan timed out');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Device scan timed out")),
        );
      }
    } catch (e) {
      setState(() => lastError = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Scan failed: $e")),
        );
      }
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
          'Connected to ${devices.firstWhere((d) => d.macAdress == mac).name}';
          lastConnectedMac = mac;
        });
      } else {
        throw Exception('Connection returned false');
      }
    } on TimeoutException {
      setState(() => lastError = 'Connection timed out');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection timed out")),
        );
      }
    } catch (e) {
      setState(() => lastError = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection failed: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  /// Printer bytes are built from `String.codeUnits`, and calling that on a
  /// `null` value throws — every nullable transaction field is routed
  /// through here first instead of being interpolated directly.
  String _safe(String? value, {String fallback = 'N/A'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value;
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

      final txn = widget.paymentTransaction;
      final now = DateTime.now();
      final formattedDate = DateFormat('dd MMM yyyy').format(now);
      final formattedTime = DateFormat('hh:mm a').format(now);
      final String currencyLabel =
      txn.currency.isNotEmpty ? txn.currency : "Rs.";

      final List<int> bytes = [];

      bytes.addAll([0x1B, 0x40]); // Reset

      // ===== HEADER =====
      bytes.addAll([0x1B, 0x61, 0x01]); // Center
      bytes.addAll([0x1B, 0x21, 0x30]); // Big + Bold
      bytes.addAll(
          "${_safe(txn.merchantName, fallback: 'Merchant')}\n".codeUnits);

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

      bytes.addAll("Mode     : ${_safe(txn.paymentMode)}\n".codeUnits);
      bytes.addAll("Channel  : ${_safe(txn.paymentChannel)}\n".codeUnits);
      bytes.addAll(
          "Status   : ${_safe(txn.status).toUpperCase()}\n".codeUnits);

      // errorDescription only applies to failed transactions.
      if (txn.status.toUpperCase() != 'SUCCESS' &&
          txn.errorDescription != null &&
          txn.errorDescription!.isNotEmpty) {
        bytes.addAll("Reason   : ${txn.errorDescription}\n".codeUnits);
      }

      if (txn.transactionId.isNotEmpty) {
        bytes.addAll("Txn ID   : ${txn.transactionId}\n".codeUnits);
      }
      if (txn.paymentGatewayTransactionId.isNotEmpty) {
        bytes.addAll(
            "Gateway  : ${txn.paymentGatewayTransactionId}\n".codeUnits);
      }
      if (txn.orderId.isNotEmpty) {
        bytes.addAll("Order ID : ${txn.orderId}\n".codeUnits);
      }
      if (txn.description.isNotEmpty) {
        bytes.addAll("Desc     : ${txn.description}\n".codeUnits);
      }

      bytes.addAll("\n".codeUnits);

      // ===== AMOUNT (Highlight) =====
      bytes.addAll([0x1B, 0x61, 0x01]); // Center
      bytes.addAll([0x1B, 0x21, 0x30]); // Large
      bytes.addAll(
          "$currencyLabel ${txn.amount.toStringAsFixed(2)}\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]);
      bytes.addAll([0x1B, 0x61, 0x00]);
      bytes.addAll("------------------------------\n".codeUnits);

      // ===== CUSTOMER =====
      bytes.addAll([0x1B, 0x21, 0x08]);
      bytes.addAll("CUSTOMER\n".codeUnits);
      bytes.addAll([0x1B, 0x21, 0x00]);
      bytes.addAll("Name     : ${_safe(txn.customerName)}\n".codeUnits);
      if (txn.customerPhone.isNotEmpty) {
        bytes.addAll("Phone    : ${txn.customerPhone}\n".codeUnits);
      }
      if (txn.customerEmail.isNotEmpty) {
        bytes.addAll("Email    : ${txn.customerEmail}\n".codeUnits);
      }
      bytes.addAll("------------------------------\n".codeUnits);

      // ===== AGENT =====
      // Agent fields are nullable — the whole section is skipped rather
      // than printing "Name: N/A / Phone: N/A" when there's no agent at
      // all on the transaction.
      if (txn.agentName != null || txn.agentPhone != null) {
        bytes.addAll([0x1B, 0x21, 0x08]);
        bytes.addAll("AGENT\n".codeUnits);
        bytes.addAll([0x1B, 0x21, 0x00]);
        bytes.addAll("Name     : ${_safe(txn.agentName)}\n".codeUnits);
        bytes.addAll("Phone    : ${_safe(txn.agentPhone)}\n".codeUnits);
        bytes.addAll("------------------------------\n".codeUnits);
      }

      // ===== FOOTER =====
      bytes.addAll([0x1B, 0x61, 0x01]); // Center
      bytes.addAll("\nThank you for banking with us!\n".codeUnits);
      bytes.addAll("\n\n".codeUnits);

      bytes.addAll([0x1D, 0x56, 0x41, 0x10]); // Cut

      await PrintBluetoothThermal.writeBytes(bytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Receipt printed successfully!")),
      );
    } catch (e) {
      setState(() => lastError = e.toString());
      if (!mounted) return;
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: home1.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.print_rounded, color: home1, size: 24),
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
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
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
                                  color: isSelected
                                      ? home1
                                      : Colors.grey.shade400,
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
                              _connectToPrinter(device.macAdress);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w600),
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
    if (isTakingSS) return;

    try {
      // Hide buttons/status while capturing
      setState(() {
        isTakingSS = true;
      });

      // Wait for Flutter to rebuild the widget tree
      await WidgetsBinding.instance.endOfFrame;

      // Capture AFTER the UI has been rebuilt
      final Uint8List? imageBytes =
      await _screenshotController.capture(
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );

      // Restore UI
      if (mounted) {
        setState(() {
          isTakingSS = false;
        });
      }

      if (imageBytes == null || imageBytes.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to capture screenshot"),
          ),
        );
        return;
      }

      // Save image
      final tempDir = await getTemporaryDirectory();

      final file = File(
        '${tempDir.path}/transaction_${widget.paymentTransaction.transactionId}.png',
      );

      await file.writeAsBytes(imageBytes, flush: true);

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Transaction Receipt',
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          isTakingSS = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Screenshot failed: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final txn = widget.paymentTransaction;
    final bool isSuccess = txn.status == "SUCCESS";

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Connection status pill — hidden during screenshot
                  // capture so it doesn't appear in the shared image.
                  if (!isTakingSS)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
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
                                _isConnected
                                    ? Icons.check_circle
                                    : Icons.print_disabled_rounded,
                                color:
                                _isConnected ? Colors.green : Colors.orange,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _connectionStatus,
                                style: TextStyle(
                                  color: _isConnected
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSuccess
                                      ? Colors.green.shade50
                                      : Colors.orange.shade50,
                                ),
                                child: Row(children: [
                                  isSuccess
                                      ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                      : const Icon(Icons.timelapse,
                                      color: Colors.orange),
                                  Text(
                                    txn.status,
                                    style: TextStyle(
                                      color: isSuccess
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ]),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.blue.shade50,
                                child: const Icon(
                                    Icons.chrome_reader_mode_outlined),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Amount", style: TextStyle(fontSize: 12)),
                              Text("Order ID", style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹ ${txn.amount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Text(txn.orderId,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Payment Mode",
                                  style: TextStyle(fontSize: 12)),
                              Text("Transaction Date",
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(txn.paymentMode,
                                  style: const TextStyle(fontSize: 12)),
                              Text(
                                DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(txn.createdAt),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSuccess
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isSuccess
                              ? const Icon(Icons.check_circle,
                              color: Colors.green)
                              : const Icon(Icons.warning_amber,
                              color: Colors.orange),
                          isSuccess
                              ? Center(
                            child: Text(
                              txn.responseMessage,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 10),
                            ),
                          )
                              : Text(
                            txn.responseMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transaction Information",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Transaction ID",
                                  style: TextStyle(fontSize: 11)),
                              const SizedBox(height: 10),
                              Text(txn.transactionId,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.shade300),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Payment Gateway Transaction ID",
                                  style: TextStyle(fontSize: 11)),
                              const SizedBox(height: 10),
                              Text(txn.paymentGatewayTransactionId,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Description",
                                  style: TextStyle(fontSize: 11)),
                              Text(txn.description,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Status",
                                  style: TextStyle(fontSize: 11)),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSuccess
                                      ? Colors.green.shade50
                                      : Colors.yellow.shade50,
                                ),
                                child: Text(
                                  txn.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSuccess
                                        ? Colors.green
                                        : Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Response Message",
                                  style: TextStyle(fontSize: 11)),
                              const Spacer(flex: 1),
                              Expanded(
                                child: Text(txn.responseMessage,
                                    style: const TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Created At",
                                  style: TextStyle(fontSize: 11)),
                              const Spacer(flex: 1),
                              Text(
                                DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(txn.createdAt),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Completed At",
                                  style: TextStyle(fontSize: 11)),
                              const Spacer(flex: 1),
                              Text(
                                // completedAt is nullable — show a plain
                                // label instead of the literal string
                                // "null" when a transaction hasn't
                                // completed yet.
                                txn.completedAt != null
                                    ? DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(txn.completedAt!)
                                    : 'Not completed',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Customer Information",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.person_2_outlined,
                                  color: Colors.blue, size: 15),
                              const SizedBox(width: 5),
                              const Text("Customer Name",
                                  style: TextStyle(fontSize: 11)),
                              const Spacer(flex: 1),
                              Text(txn.customerName,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Divider(color: Colors.grey.shade300),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.email_outlined,
                                  color: Colors.blue, size: 15),
                              const SizedBox(width: 5),
                              const Text("Email",
                                  style: TextStyle(fontSize: 11)),
                              const Spacer(flex: 1),
                              Text(txn.customerEmail,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Divider(color: Colors.grey.shade300),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.phone_outlined,
                                  color: Colors.blue, size: 15),
                              const SizedBox(width: 5),
                              const Text("Phone",
                                  style: TextStyle(fontSize: 11)),
                              const Spacer(flex: 1),
                              Text(txn.customerPhone,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  // Print / Share actions — hidden during screenshot
                  // capture so the buttons themselves don't appear in the
                  // shared image.
                  if (!isTakingSS)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _isLoading ? null : _printReceipt,
                                child: Ink(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: LinearGradient(
                                      colors: [
                                        home1,
                                        home2.withValues(alpha: 0.85),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: home1.withValues(alpha: 0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.print_rounded,
                                          color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Print Receipt",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: _takeScreenshotAndShare,
                                child: Ink(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: home1.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share_rounded,
                                          color: home1, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Share",
                                        style: GoogleFonts.poppins(
                                          color: home1,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // if (showFlash)
            //   Positioned.fill(
            //     child: IgnorePointer(
            //       child: Container(
            //         color: Colors.white.withValues(alpha: 0.9),
            //       ),
            //     ),
            //   ),
            if (_isLoading || _isConnecting)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "Transaction Details",
        style: TextStyle(
          color: home1,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}


// class EcollectTransactionDetail extends StatefulWidget {
//   final PaymentTransaction paymentTransaction;
//   const EcollectTransactionDetail({super.key, required this.paymentTransaction});
//
//   @override
//   State<EcollectTransactionDetail> createState() => _EcollectTransactionDetailState();
// }
//
// class _EcollectTransactionDetailState extends State<EcollectTransactionDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar:  buildAppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 3,spreadRadius: 1
//                     )
//                   ]
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color:
//                           widget.paymentTransaction.status == "SUCCESS"?Colors.green.shade50:
//                           Colors.orange.shade50),
//                           child: Row(children: [
//                             widget.paymentTransaction.status == "SUCCESS"?
//                                 Icon(Icons.check_circle, color: Colors.green,):
//                             Icon(
//                               Icons.timelapse, color: Colors.orange,), Text(widget.paymentTransaction.status, style: TextStyle(color:
//                             widget.paymentTransaction.status == "SUCCESS"?green:
//                             Colors.orange),)
//                           ],),
//                         ),
//                         CircleAvatar(backgroundColor: Colors.blue.shade50, child: Icon(Icons.chrome_reader_mode_outlined),)
//                       ],
//                     ),
//                     SizedBox(height: 20,),
//                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                       Text("Amount",style: TextStyle(fontSize: 12),),
//                       Text("Order ID",style: TextStyle(fontSize: 11),)
//                     ],),
//                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                       Text("₹ ${widget.paymentTransaction.amount}",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
//                       Text(widget.paymentTransaction.orderId,style: TextStyle(fontSize: 11),)
//                     ],),
//                     SizedBox(height: 20,),
//                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Payment Mode",style: TextStyle(fontSize: 12),),
//                         Text("Transaction Date",style: TextStyle(fontSize: 11),)
//                       ],),
//                     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(widget.paymentTransaction.paymentMode,style: TextStyle(fontSize: 12),),
//                         Text(widget.paymentTransaction.createdAt.toString(),style: TextStyle(fontSize: 11),)
//                       ],),
//                     SizedBox(height: 20,),
//
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color:
//                     widget.paymentTransaction.status == "SUCCESS"?
//                         Colors.green.shade50:
//                     Colors.red.shade50
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     widget.paymentTransaction.status == "SUCCESS"?
//                     Icon(Icons.check_circle, color: Colors.green,):
//                   Icon(Icons.warning_amber, color: Colors.orange,),
//                     widget.paymentTransaction.status == "SUCCESS"?
//                     Center(child: Text(widget.paymentTransaction.responseMessage, style: TextStyle(color: Colors.green,fontSize: 10))):
//
//                       Text(widget.paymentTransaction.responseMessage, style: TextStyle(color: Colors.red,
//                       fontSize: 10
//                   ),)
//                 ],),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(10),
//                 decoration:
//                 BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12, blurRadius: 2, spreadRadius: 1
//                     )
//                   ]
//                 ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(textAlign: TextAlign.start,"Transaction Information", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
//                   SizedBox(height: 15,),
//                   Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//           Text("Transaction ID", style: TextStyle(fontSize: 11),),
//           SizedBox(height: 10,),
//           Text(widget.paymentTransaction.transactionId, style: TextStyle(fontSize: 11)),
//         ],),
//                   SizedBox(height: 10,),
//                   Divider(color: Colors.grey.shade300,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Payment Gateway Transaction ID", style: TextStyle(fontSize: 11),),
//                       SizedBox(height: 10,),
//                       Text(widget.paymentTransaction.paymentGatewayTransactionId, style: TextStyle(fontSize: 11)),
//                     ],),
//                   SizedBox(height: 10,),
//                   Divider(color: Colors.grey.shade300,),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Description", style: TextStyle(fontSize: 11),),
//                       Text(widget.paymentTransaction.description, style: TextStyle(fontSize: 11)),
//                     ],),
//                   Divider(color: Colors.grey.shade300,),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Status", style: TextStyle(fontSize: 11),),
//
//                       Container(
//                         padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color:
//                             widget.paymentTransaction.status == "SUCCESS"?
//                             Colors.green.shade50:
//                             Colors.yellow.shade50
//                           ),
//                           child: Text(widget.paymentTransaction.status, style: TextStyle(fontSize: 11, color:
//                           widget.paymentTransaction.status == "SUCCESS"?Colors.green:
//                           Colors.orangeAccent))),
//                     ],),
//                   Divider(color: Colors.grey.shade300,),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Response Message", style: TextStyle(fontSize: 11),),
//         Spacer(flex: 1,),
//                       Expanded(
//                         child: Text(widget.paymentTransaction.responseMessage,
//                             style: TextStyle(fontSize: 10)),
//                       ),
//                     ],),
//                   Divider(color: Colors.grey.shade300,),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Created At", style: TextStyle(fontSize: 11),),
//                       Spacer(flex: 1,),
//                       Text(widget.paymentTransaction.createdAt.toString(),
//                           style: TextStyle(fontSize: 11)),
//                     ],),
//                   Divider(color: Colors.grey.shade300,),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Completed At", style: TextStyle(fontSize: 11),),
//                       Spacer(flex: 1,),
//                       Text(widget.paymentTransaction.completedAt.toString(),
//                           style: TextStyle(fontSize: 11)),
//                     ],),
//
//                 ],
//               ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(10),
//                 decoration:
//                 BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black12, blurRadius: 2, spreadRadius: 1
//                       )
//                     ]
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(textAlign: TextAlign.start,"Customer Information", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 12),),
//                     SizedBox(height: 15,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(Icons.person_2_outlined, color: Colors.blue,size: 15),
//                         SizedBox(width: 5,),
//                         Text("Customer Name", style: TextStyle(fontSize: 11),),
//                        Spacer(flex: 1,),
//                         Text(widget.paymentTransaction.customerName, style: TextStyle(fontSize: 11)),
//                       ],),
//                     SizedBox(height: 5,),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Divider(color: Colors.grey.shade300,),
//                     ),
//                     SizedBox(height: 5,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(Icons.email_outlined, color: Colors.blue,size: 15,),
//                         SizedBox(width: 5,),
//                         Text("Email", style: TextStyle(fontSize: 11),),
//                         Spacer(flex: 1,),
//                         Text(widget.paymentTransaction.customerEmail, style: TextStyle(fontSize: 11)),
//                       ],),
//                     SizedBox(height: 5,),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Divider(color: Colors.grey.shade300,),
//                     ),
//                     SizedBox(height: 5,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(Icons.phone_outlined, color: Colors.blue,size: 15,),
//                         SizedBox(width: 5,),
//                         Text("Phone", style: TextStyle(fontSize: 11),),
//                         Spacer(flex: 1,),
//                         Text(widget.paymentTransaction.customerPhone, style: TextStyle(fontSize: 11)),
//                       ],),
//                     SizedBox(height: 10,),
//
//
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsetsGeometry.all(10),
//               child: Material(
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(14),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EcollectReceiptPage(transaction: widget.paymentTransaction,
//
//                         ),
//                       ),
//                     );
//                   },
//                   child: Ink(
//                     height: 52,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14),
//
//                       /// subtle gradient = modern look
//                       gradient: LinearGradient(
//                         colors: [
//                           home1,
//                           home2.withValues(alpha:0.85),
//                         ],
//                       ),
//
//                       boxShadow: [
//                         BoxShadow(
//                           color: home1.withValues(alpha:0.25),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         )
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.print_rounded, color: Colors.white, size: 20),
//                         const SizedBox(width: 8),
//                         Text(
//                           "Print Receipt",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   AppBar buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       centerTitle: true,
//       title: Text(
//         "Transaction Details",
//         style: TextStyle(
//           color: home1,
//           fontWeight: FontWeight.w700,
//           fontSize: 24,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }
// }
