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
      if(!mounted)return;
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

    final String status = txn.status.toString().toUpperCase();

    final bool isSuccess = status == "SUCCESS";
    final bool isPending = status.startsWith("PENDING");
    final bool isFailed =
        status.startsWith("FAIL") || status.startsWith("ERROR");

    final Color statusColor = isSuccess
        ? const Color(0xFF16A34A)
        : isPending
        ? const Color(0xFFD97706)
        : const Color(0xFFDC2626);

    final Color statusBackground = isSuccess
        ? const Color(0xFFF0FDF4)
        : isPending
        ? const Color(0xFFFFF7ED)
        : const Color(0xFFFEF2F2);

    final String customerName =
    txn.customerName.toString().trim().isEmpty
        ? "Unknown Customer"
        : txn.customerName.toString();

    final String initial = customerName.isNotEmpty
        ? customerName[0].toUpperCase()
        : "?";

    return Screenshot(
      controller: _screenshotController,

      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),

        appBar: buildAppBar(),

        body: Stack(
          children: [

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(
                18,
                8,
                18,
                30,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // =====================================================
                  // CONNECTION STATUS
                  // =====================================================

                  if (!isTakingSS)
                    _buildConnectionStatus(),

                  if (!isTakingSS)
                    const SizedBox(height: 14),

                  // =====================================================
                  // TRANSACTION SUMMARY
                  // =====================================================

                  _buildTransactionSummary(
                    txn: txn,
                    status: status,
                    statusColor: statusColor,
                    statusBackground: statusBackground,
                    isSuccess: isSuccess,
                    isPending: isPending,
                  ),

                  const SizedBox(height: 18),

                  // =====================================================
                  // RESPONSE MESSAGE
                  // =====================================================

                  _buildResponseBanner(
                    message: txn.responseMessage,
                    color: statusColor,
                    background: statusBackground,
                    isSuccess: isSuccess,
                  ),

                  const SizedBox(height: 22),

                  // =====================================================
                  // TRANSACTION DETAILS
                  // =====================================================

                  _sectionTitle("Transaction details"),

                  const SizedBox(height: 9),

                  _buildDetailsCard(
                    children: [

                      _detailItem(
                        label: "Transaction ID",
                        value: txn.transactionId,
                        icon: Icons.receipt_long_outlined,
                        isCopyable: true,
                      ),

                      _detailDivider(),

                      _detailItem(
                        label: "Gateway Transaction ID",
                        value: txn.paymentGatewayTransactionId,
                        icon: Icons.account_tree_outlined,
                        isCopyable: true,
                      ),

                      _detailDivider(),

                      _detailItem(
                        label: "Order ID",
                        value: txn.orderId,
                        icon: Icons.tag_rounded,
                        isCopyable: true,
                      ),

                      _detailDivider(),

                      _detailItem(
                        label: "Description",
                        value: txn.description,
                        icon: Icons.notes_outlined,
                      ),

                      _detailDivider(),

                      _detailItem(
                        label: "Payment Mode",
                        value: txn.paymentMode,
                        icon: Icons.account_balance_wallet_outlined,
                      ),

                      _detailDivider(),

                      _detailItem(
                        label: "Payment Channel",
                        value: txn.paymentChannel,
                        icon: Icons.device_hub_outlined,
                      ),

                      _detailDivider(),

                      _detailItem(
                        label: "Status",
                        value: txn.status,
                        icon: Icons.radio_button_checked_rounded,
                        valueColor: statusColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // =====================================================
                  // CUSTOMER
                  // =====================================================

                  _sectionTitle("Customer"),

                  const SizedBox(height: 9),

                  _buildCustomerCard(
                    customerName: customerName,
                    initial: initial,
                    email: txn.customerEmail,
                    phone: txn.customerPhone,
                  ),

                  const SizedBox(height: 22),

                  // =====================================================
                  // TIMELINE
                  // =====================================================

                  _sectionTitle("Timeline"),

                  const SizedBox(height: 9),

                  _buildTimeline(
                    createdAt: txn.createdAt,
                    completedAt: txn.completedAt,
                    statusColor: statusColor,
                    isSuccess: isSuccess,
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // ACTIONS
                  // =====================================================

                  if (!isTakingSS)
                    _buildActionButtons(),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "Transaction receipt",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =========================================================
            // LOADING
            // =========================================================

            if (_isLoading || _isConnecting)
              Container(
                color: Colors.black.withValues(alpha: 0.35),

                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildConnectionStatus() {
    final Color color = _isConnected
        ? const Color(0xFF16A34A)
        : const Color(0xFFD97706);

    return Row(
      children: [

        Container(
          width: 7,
          height: 7,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 7),

        Text(
          _connectionStatus,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSummary({
    required dynamic txn,
    required String status,
    required Color statusColor,
    required Color statusBackground,
    required bool isSuccess,
    required bool isPending,
  }) {
    final String orderId = txn.orderId?.toString() ?? "N/A";

    final String formattedDate = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(txn.createdAt);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7E8EC),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // TOP ROW
            // =========================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8A8F98),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "₹${txn.amount.toStringAsFixed(2)}",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF18181B),
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackground,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        status,
                        style: GoogleFonts.inter(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              isSuccess
                  ? "Payment received successfully"
                  : isPending
                  ? "Payment is being processed"
                  : "Payment was not completed",
              style: GoogleFonts.inter(
                color: const Color(0xFF8A8F98),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 18),

            // =========================================================
            // TRANSACTION METADATA
            // =========================================================

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Order ID
                  _summaryDetailRow(
                    icon: Icons.receipt_long_outlined,
                    label: "Order ID",
                    value: "#$orderId",
                  ),

                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 48),
                    color: const Color(0xFFEDEEF1),
                  ),

                  // Date
                  _summaryDetailRow(
                    icon: Icons.schedule_outlined,
                    label: "Date & time",
                    value: formattedDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _summaryDetailRow({
required IconData icon,
required String label,
required String value,
}) {
return Padding(
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 11,
),
child: Row(
children: [
Container(
width: 32,
height: 32,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(9),
),
child: Icon(
icon,
size: 15,
color: const Color(0xFF717780),
),
),

const SizedBox(width: 10),

Expanded(
child: Text(
label,
style: GoogleFonts.inter(
color: const Color(0xFF858A93),
fontSize: 10.5,
fontWeight: FontWeight.w500,
),
),
),

const SizedBox(width: 10),

Flexible(
child: Text(
value,
textAlign: TextAlign.right,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: GoogleFonts.inter(
color: const Color(0xFF27272A),
fontSize: 11,
fontWeight: FontWeight.w600,
),
),
),
],
),
);
}



  // Widget _buildTransactionSummary({
  //   required dynamic txn,
  //   required String status,
  //   required Color statusColor,
  //   required Color statusBackground,
  //   required bool isSuccess,
  //   required bool isPending,
  // }) {
  //   return Container(
  //     width: double.infinity,
  //
  //     padding: const EdgeInsets.fromLTRB(
  //       20,
  //       20,
  //       20,
  //       18,
  //     ),
  //
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //
  //       borderRadius: BorderRadius.circular(22),
  //
  //       border: Border.all(
  //         color: const Color(0xFFE8E8EC),
  //       ),
  //     ),
  //
  //     child: Column(
  //       children: [
  //
  //         // ---------------------------------------------------------
  //         // STATUS
  //         // ---------------------------------------------------------
  //
  //         Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 10,
  //             vertical: 6,
  //           ),
  //
  //           decoration: BoxDecoration(
  //             color: statusBackground,
  //             borderRadius: BorderRadius.circular(30),
  //           ),
  //
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //
  //             children: [
  //
  //               Icon(
  //                 isSuccess
  //                     ? Icons.check_circle_rounded
  //                     : isPending
  //                     ? Icons.schedule_rounded
  //                     : Icons.error_rounded,
  //
  //                 color: statusColor,
  //                 size: 15,
  //               ),
  //
  //               const SizedBox(width: 6),
  //
  //               Text(
  //                 status,
  //                 style: TextStyle(
  //                   color: statusColor,
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w800,
  //                   letterSpacing: 0.3,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         const SizedBox(height: 18),
  //
  //         // ---------------------------------------------------------
  //         // AMOUNT
  //         // ---------------------------------------------------------
  //
  //         Text(
  //           "₹${txn.amount.toStringAsFixed(2)}",
  //
  //           style: const TextStyle(
  //             fontSize: 32,
  //             fontWeight: FontWeight.w800,
  //             color: Color(0xFF18181B),
  //             letterSpacing: -1,
  //           ),
  //         ),
  //
  //         const SizedBox(height: 5),
  //
  //         Text(
  //           "Payment received",
  //
  //           style: TextStyle(
  //             fontSize: 11,
  //             color: Colors.grey.shade500,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //
  //         const SizedBox(height: 20),
  //
  //         Container(
  //           height: 1,
  //           color: const Color(0xFFEDEDEF),
  //         ),
  //
  //         const SizedBox(height: 15),
  //
  //         // ---------------------------------------------------------
  //         // ORDER / DATE
  //         // ---------------------------------------------------------
  //
  //         Row(
  //           children: [
  //
  //             Expanded(
  //               child: _summaryItem(
  //                 label: "ORDER ID",
  //                 value: "#${txn.orderId}",
  //               ),
  //             ),
  //
  //             Container(
  //               width: 1,
  //               height: 28,
  //               color: const Color(0xFFE5E5E7),
  //             ),
  //
  //             Expanded(
  //               child: _summaryItem(
  //                 label: "DATE",
  //                 value: DateFormat(
  //                   'dd MMM yyyy',
  //                 ).format(txn.createdAt),
  //                 alignment: CrossAxisAlignment.end,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _summaryItem({
    required String label,
    required String value,
    CrossAxisAlignment alignment =
        CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [

        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xFFA1A1AA),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF3F3F46),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
  Widget _buildResponseBanner({
    required String message,
    required Color color,
    required Color background,
    required bool isSuccess,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            isSuccess
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            size: 17,
            color: color,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE9EAEE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }


  // Widget _buildDetailsCard({
  //   required List<Widget> children,
  // }) {
  //   return Container(
  //     width: double.infinity,
  //
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(18),
  //       border: Border.all(
  //         color: const Color(0xFFE8E8EC),
  //       ),
  //     ),
  //
  //     child: Column(
  //       children: children,
  //     ),
  //   );
  // }
  Widget _detailItem({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
    bool isCopyable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(9),
            ),

            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF71717A),
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            flex: 2,

            child: Text(
              label,

              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF71717A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 3,

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.end,

              children: [

                Flexible(
                  child: Text(
                    value.isEmpty ? "—" : value,

                    textAlign: TextAlign.end,

                    maxLines: 2,

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 11,
                      color: valueColor ??
                          const Color(0xFF27272A),
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                if (isCopyable) ...[
                  const SizedBox(width: 5),

                  Icon(
                    Icons.copy_rounded,
                    size: 12,
                    color: Colors.grey.shade400,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _detailDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 58,
      endIndent: 15,
      color: Color(0xFFF0F0F2),
    );
  }
/*  Widget _buildCustomerCard({
    required String customerName,
    required String initial,
    required String email,
    required String phone,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius:
                  BorderRadius.circular(14),
                ),

                child: Center(
                  child: Text(
                    initial,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF52525B),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      customerName,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF18181B),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Customer",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _customerContactRow(
            Icons.email_outlined,
            email,
          ),

          const SizedBox(height: 10),

          _customerContactRow(
            Icons.phone_outlined,
            phone,
          ),
        ],
      ),
    );
  }*/

  Widget _buildCustomerCard({
    required String customerName,
    required String initial,
    required String email,
    required String phone,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7E8EC),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // CUSTOMER HEADER
            // =========================================================

            Row(
              children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: home1.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initial.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: home1,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Customer name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF18181B),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "Customer",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8A8F98),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // =========================================================
            // CONTACT INFORMATION
            // =========================================================

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _customerContactRow(
                    Icons.mail_outline_rounded,
                    email,
                  ),

                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 44),
                    color: const Color(0xFFEDEEF1),
                  ),
                  SizedBox(height: 10,),

                  _customerContactRow(
                    Icons.phone_outlined,
                    phone,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _customerContactRow(
      IconData icon,
      String value,
      ) {
    return Row(
      children: [

        Icon(
          icon,
          size: 15,
          color: const Color(0xFF71717A),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            value.isEmpty ? "Not available" : value,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF52525B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildTimeline({
    required DateTime createdAt,
    required DateTime? completedAt,
    required Color statusColor,
    required bool isSuccess,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),

      child: Column(
        children: [

          _timelineItem(
            icon: Icons.fiber_manual_record_rounded,
            title: "Transaction created",
            date: DateFormat(
              'dd MMM yyyy, hh:mm a',
            ).format(createdAt),
            color: const Color(0xFF71717A),
            showLine: true,
          ),

          _timelineItem(
            icon: isSuccess
                ? Icons.check_circle_rounded
                : Icons.radio_button_checked_rounded,
            title: isSuccess
                ? "Transaction completed"
                : "Transaction ${widget.paymentTransaction.status.toString().toLowerCase()}",
            date: completedAt != null
                ? DateFormat(
              'dd MMM yyyy, hh:mm a',
            ).format(completedAt)
                : "Not completed",
            color: isSuccess
                ? statusColor
                : const Color(0xFFA1A1AA),
            showLine: false,
          ),
        ],
      ),
    );
  }
  Widget _timelineItem({
    required IconData icon,
    required String title,
    required String date,
    required Color color,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        SizedBox(
          width: 24,

          child: Column(
            children: [

              Icon(
                icon,
                size: 13,
                color: color,
              ),

              if (showLine)
                Container(
                  width: 1,
                  height: 32,
                  margin:
                  const EdgeInsets.symmetric(
                    vertical: 3,
                  ),
                  color: const Color(0xFFE4E4E7),
                ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3F3F46),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  date,

                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFA1A1AA),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildActionButtons() {
    return Row(
      children: [

        Expanded(
          child: _actionButton(
            icon: Icons.print_outlined,
            label: "Print",
            filled: true,
            onTap: _isLoading
                ? null
                : _printReceipt,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _actionButton(
            icon: Icons.share_outlined,
            label: "Share",
            filled: false,
            onTap: _takeScreenshotAndShare,
          ),
        ),
      ],
    );
  }
  Widget _actionButton({
    required IconData icon,
    required String label,
    required bool filled,
    required VoidCallback? onTap,
  }) {
    const Color primary = Color(0xFFEA307B);

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(14),

        child: Container(
          height: 50,

          decoration: BoxDecoration(
            color: filled
                ? primary
                : Colors.white,

            borderRadius:
            BorderRadius.circular(14),

            border: Border.all(
              color: filled
                  ? primary
                  : const Color(0xFFE4E4E7),
            ),
          ),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                size: 18,
                color: filled
                    ? Colors.white
                    : const Color(0xFF3F3F46),
              ),

              const SizedBox(width: 7),

              Text(
                label,

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: filled
                      ? Colors.white
                      : const Color(0xFF3F3F46),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),

      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Color(0xFF92929A),
        letterSpacing: 0.8,
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   final txn = widget.paymentTransaction;
  //   final bool isSuccess = txn.status == "SUCCESS";
  //
  //   return Screenshot(
  //     controller: _screenshotController,
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       appBar: buildAppBar(),
  //       body: Stack(
  //         children: [
  //           SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 // Connection status pill — hidden during screenshot
  //                 // capture so it doesn't appear in the shared image.
  //                 if (!isTakingSS)
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
  //                     child: Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 12, vertical: 6),
  //                         decoration: BoxDecoration(
  //                           color: _isConnected
  //                               ? Colors.green[100]
  //                               : Colors.orange[100],
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         child: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Icon(
  //                               _isConnected
  //                                   ? Icons.check_circle
  //                                   : Icons.print_disabled_rounded,
  //                               color:
  //                               _isConnected ? Colors.green : Colors.orange,
  //                               size: 14,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               _connectionStatus,
  //                               style: TextStyle(
  //                                 color: _isConnected
  //                                     ? Colors.green
  //                                     : Colors.orange,
  //                                 fontSize: 11,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     padding: EdgeInsets.all(20),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(16),
  //                       color: Colors.white,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black12,
  //                           blurRadius: 3,
  //                           spreadRadius: 1,
  //                         )
  //                       ],
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Container(
  //                               padding: EdgeInsets.all(5),
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: isSuccess
  //                                     ? Colors.green.shade50
  //                                     : Colors.orange.shade50,
  //                               ),
  //                               child: Row(children: [
  //                                 isSuccess
  //                                     ? const Icon(Icons.check_circle,
  //                                     color: Colors.green)
  //                                     : const Icon(Icons.pending_actions,
  //                                     color: Colors.orange),
  //                                 Text(
  //                                   txn.status,
  //                                   style: TextStyle(
  //                                     color: isSuccess
  //                                         ? Colors.green
  //                                         : Colors.orange,
  //                                   ),
  //                                 ),
  //                               ]),
  //                             ),
  //                             CircleAvatar(
  //                               backgroundColor: Colors.blue.shade50,
  //                               child: const Icon(
  //                                   Icons.chrome_reader_mode_outlined),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 20),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Amount", style: TextStyle(fontSize: 12)),
  //                             const Text("Order ID", style: TextStyle(fontSize: 11)),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               "₹ ${txn.amount.toStringAsFixed(2)}",
  //                               style: const TextStyle(
  //                                   fontSize: 20, fontWeight: FontWeight.w700),
  //                             ),
  //                             Container(
  //                                 padding: EdgeInsets.all(7),
  //                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.indigo.shade50),
  //                                 child: Text(
  //                                     textAlign: TextAlign.end,
  //                                     txn.orderId,
  //                                     style: const TextStyle(fontSize: 11,color:Colors.grey,fontStyle:FontStyle.italic,fontWeight: FontWeight.w700))),
  //
  //                           ],
  //                         ),
  //                         const SizedBox(height: 20),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: const [
  //                             Text("Payment Mode",
  //                                 style: TextStyle(fontSize: 12)),
  //                             Spacer(flex: 1,),
  //                             Icon(Icons.date_range, color: Colors.grey,size: 16,),
  //                             SizedBox(width: 5,),
  //                             Text("Transaction Date",
  //                                 style: TextStyle(fontSize: 11)),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(txn.paymentMode,
  //                                 style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontStyle:FontStyle.italic, color: Colors.grey)),
  //                             Text(
  //                               DateFormat('dd MMM yyyy, hh:mm a').format(txn.createdAt),
  //                               style:  TextStyle(fontSize: 11, fontStyle:FontStyle.italic, color: Colors.grey, fontWeight: FontWeight.w700),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 20),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(16),
  //                       color: isSuccess
  //                           ? Colors.green.shade50
  //                           : Colors.red.shade50,
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         isSuccess
  //                             ? const Icon(Icons.check_circle,
  //                             color: Colors.green)
  //                             : const Icon(Icons.warning_amber,
  //                             color: Colors.orange),
  //                         isSuccess
  //                             ? Center(
  //                           child: Text(
  //                             txn.responseMessage,
  //                             style: const TextStyle(
  //                                 color: Colors.green, fontSize: 10),
  //                           ),
  //                         )
  //                             : Text(
  //                           txn.responseMessage,
  //                           style: const TextStyle(
  //                               color: Colors.red, fontSize: 10),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     width: double.infinity,
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(10),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black12,
  //                           blurRadius: 2,
  //                           spreadRadius: 1,
  //                         )
  //                       ],
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           "Transaction Information",
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w700,
  //                             fontSize: 12,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 15),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Transaction ID",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const SizedBox(height: 10),
  //                             Expanded(
  //                               child: Text(textAlign: TextAlign.end,txn.transactionId,
  //                                   style: const TextStyle(fontSize: 11)),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 10),
  //                         Divider(color: Colors.grey.shade300),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Expanded(
  //                               child: const Text("Payment Gateway Transaction ID",
  //                                   style: TextStyle(fontSize: 11)),
  //                             ),
  //                             const SizedBox(height: 10),
  //                             Expanded(
  //                               child: Text(textAlign: TextAlign.end,txn.paymentGatewayTransactionId,
  //                                   style: const TextStyle(fontSize: 11)),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 10),
  //                         Divider(color: Colors.grey.shade300),
  //                         const SizedBox(height: 10),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Description",
  //                                 style: TextStyle(fontSize: 11)),
  //                             Text(txn.description,
  //                                 style: const TextStyle(fontSize: 11)),
  //                           ],
  //                         ),
  //                         Divider(color: Colors.grey.shade300),
  //                         const SizedBox(height: 10),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Status",
  //                                 style: TextStyle(fontSize: 11)),
  //                             Container(
  //                               padding: EdgeInsets.all(10),
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(10),
  //                                 color: isSuccess
  //                                     ? Colors.green.shade50
  //                                     : Colors.yellow.shade50,
  //                               ),
  //                               child: Text(
  //                                 txn.status,
  //                                 style: TextStyle(
  //                                   fontSize: 11,
  //                                   fontWeight: FontWeight.w700,
  //                                   color: isSuccess
  //                                       ? Colors.green
  //                                       : Colors.orangeAccent,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Colors.grey.shade300),
  //                         const SizedBox(height: 10),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Response Message",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const Spacer(flex: 1),
  //                             Expanded(
  //                               child: Text(textAlign: TextAlign.end,txn.responseMessage,
  //                                   style: const TextStyle(fontSize: 10)),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Colors.grey.shade300),
  //                         const SizedBox(height: 10),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Created At",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const Spacer(flex: 1),
  //                             Text(
  //                               DateFormat('dd MMM yyyy, hh:mm a')
  //                                   .format(txn.createdAt),
  //                               style: const TextStyle(fontSize: 11),
  //                             ),
  //                           ],
  //                         ),
  //                         Divider(color: Colors.grey.shade300),
  //                         const SizedBox(height: 10),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text("Completed At",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const Spacer(flex: 1),
  //                             Text(
  //                               // completedAt is nullable — show a plain
  //                               // label instead of the literal string
  //                               // "null" when a transaction hasn't
  //                               // completed yet.
  //                               txn.completedAt != null
  //                                   ? DateFormat('dd MMM yyyy, hh:mm a')
  //                                   .format(txn.completedAt!)
  //                                   : 'Not completed',
  //                               style: const TextStyle(fontSize: 11),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     width: double.infinity,
  //                     padding: EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(10),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black12,
  //                           blurRadius: 2,
  //                           spreadRadius: 1,
  //                         )
  //                       ],
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           "Customer Information",
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w700,
  //                             fontSize: 12,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 15),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Icon(Icons.person_2_outlined,
  //                                 color: Colors.blue, size: 15),
  //                             const SizedBox(width: 5),
  //                             const Text("Customer Name",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const Spacer(flex: 1),
  //                             Text(txn.customerName,
  //                                 style: const TextStyle(fontSize: 11)),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 5),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 20),
  //                           child: Divider(color: Colors.grey.shade300),
  //                         ),
  //                         const SizedBox(height: 5),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Icon(Icons.email_outlined,
  //                                 color: Colors.blue, size: 15),
  //                             const SizedBox(width: 5),
  //                             const Text("Email",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const Spacer(flex: 1),
  //                             Text(txn.customerEmail,
  //                                 style: const TextStyle(fontSize: 11)),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 5),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 20),
  //                           child: Divider(color: Colors.grey.shade300),
  //                         ),
  //                         const SizedBox(height: 5),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Icon(Icons.phone_outlined,
  //                                 color: Colors.blue, size: 15),
  //                             const SizedBox(width: 5),
  //                             const Text("Phone",
  //                                 style: TextStyle(fontSize: 11)),
  //                             const Spacer(flex: 1),
  //                             Text(txn.customerPhone,
  //                                 style: const TextStyle(fontSize: 11)),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 10),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 // Print / Share actions — hidden during screenshot
  //                 // capture so the buttons themselves don't appear in the
  //                 // shared image.
  //                 if (!isTakingSS)
  //                   Padding(
  //                     padding: const EdgeInsets.all(10),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Material(
  //                             child: InkWell(
  //                               borderRadius: BorderRadius.circular(14),
  //                               onTap: _isLoading ? null : _printReceipt,
  //                               child: Ink(
  //                                 height: 52,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(14),
  //                                   gradient: LinearGradient(
  //                                     colors: [
  //                                       home1,
  //                                       home2.withValues(alpha: 0.85),
  //                                     ],
  //                                   ),
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color: home1.withValues(alpha: 0.25),
  //                                       blurRadius: 10,
  //                                       offset: const Offset(0, 4),
  //                                     )
  //                                   ],
  //                                 ),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment.center,
  //                                   children: [
  //                                     const Icon(Icons.print_rounded,
  //                                         color: Colors.white, size: 20),
  //                                     const SizedBox(width: 8),
  //                                     Text(
  //                                       "Print Receipt",
  //                                       style: GoogleFonts.poppins(
  //                                         color: Colors.white,
  //                                         fontSize: 15,
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Expanded(
  //                           child: Material(
  //                             child: InkWell(
  //                               borderRadius: BorderRadius.circular(14),
  //                               onTap: _takeScreenshotAndShare,
  //                               child: Ink(
  //                                 height: 52,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(14),
  //                                   color: Colors.white,
  //                                   border: Border.all(
  //                                     color: home1.withValues(alpha: 0.5),
  //                                   ),
  //                                 ),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment.center,
  //                                   children: [
  //                                     Icon(Icons.share_rounded,
  //                                         color: home1, size: 20),
  //                                     const SizedBox(width: 8),
  //                                     Text(
  //                                       "Share",
  //                                       style: GoogleFonts.poppins(
  //                                         color: home1,
  //                                         fontSize: 15,
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           ),
  //           // if (showFlash)
  //           //   Positioned.fill(
  //           //     child: IgnorePointer(
  //           //       child: Container(
  //           //         color: Colors.white.withValues(alpha: 0.9),
  //           //       ),
  //           //     ),
  //           //   ),
  //           if (_isLoading || _isConnecting)
  //             Container(
  //               color: Colors.black.withValues(alpha: 0.5),
  //               child: const Center(child: CircularProgressIndicator()),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
