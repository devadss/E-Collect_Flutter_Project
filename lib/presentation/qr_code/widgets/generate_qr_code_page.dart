import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../../core/colors.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
class NewQrCodePage extends StatefulWidget {
  final String paymentSessionId;
  final String amount;
  final String custName;
  final String custPhone;
  final String custId;

  const NewQrCodePage({
    super.key,
    required this.paymentSessionId,
    required this.amount,
    required this.custName,
    required this.custPhone,
    required this.custId,
  });

  @override
  State<NewQrCodePage> createState() => _NewQrCodePageState();
}

class _NewQrCodePageState extends State<NewQrCodePage>
    with TickerProviderStateMixin {
  // ===========================================================================
  // CONSTANTS
  // ===========================================================================
  final GlobalKey _qrKey = GlobalKey();
  static const int _initialSeconds = 180;

  static Color get _background => Colors.white;
  static Color get _surface => Colors.white;
  static Color get _primary => home1;
  static Color get _primaryDark => home2;
  static Color get _text => black;
  static Color get _mutedText => Colors.grey.shade600;
  static Color get _border => Colors.grey.shade200;
  static Color get _success => Colors.green;
  static Color get _danger => Colors.red;

  // ===========================================================================
  // TIMER
  // ===========================================================================

  Timer? _timer;

  int _remainingSeconds = _initialSeconds;

  String get _timeString => _formatTime(_remainingSeconds);

  double get _timerProgress =>
      (_remainingSeconds / _initialSeconds).clamp(0.0, 1.0);

  bool get _isAlmostExpired => _remainingSeconds <= 30;

  // ===========================================================================
  // ANIMATIONS
  // ===========================================================================

  late final AnimationController _pageAnimationController;
  late final AnimationController _qrAnimationController;
  late final AnimationController _pulseController;

  late final Animation<double> _pageFadeAnimation;
  late final Animation<Offset> _pageSlideAnimation;
  late final Animation<double> _qrScaleAnimation;

  // ===========================================================================
  // QR / AGENT / BANK DATA
  // ===========================================================================

  Uint8List? qrCodeImageBytes;

  String? agentName;
  String? agentPhoneNumber;
  String? bankName;

  // ===========================================================================
  // FIREBASE
  // ===========================================================================

  StreamSubscription<RemoteMessage>? _firebaseMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _initializeAnimations();
    _startTimer();
    _initializeFirebaseMessaging();
  }

  void _initializeAnimations() {
    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _qrAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _pageFadeAnimation = CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOut,
    );

    _pageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _qrScaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _qrAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _pageAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _qrAnimationController.forward();
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    _firebaseMessageSubscription?.cancel();
    _messageOpenedSubscription?.cancel();

    _pageAnimationController.dispose();
    _qrAnimationController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // TIMER
  // ===========================================================================

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        if (_remainingSeconds <= 1) {
          _timer?.cancel();

          setState(() {
            _remainingSeconds = 0;
          });

          if (mounted) {
            Navigator.of(context).pop();
          }

          return;
        }

        setState(() {
          _remainingSeconds--;
        });
      },
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ===========================================================================
  // FIREBASE
  // ===========================================================================

  void _initializeFirebaseMessaging() {
    debugPrint('_initializeFirebaseMessaging');

    _firebaseMessageSubscription?.cancel();

    _firebaseMessageSubscription =
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    _messageOpenedSubscription?.cancel();

    _messageOpenedSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(
          _handleNotificationOpened,
        );

    _handleInitialMessage();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;

    if (notification == null) return;

    final String? notificationTitle = notification.title;
    final String? notificationBody = notification.body;

    if (notificationTitle == "Wallet Load Successful 🎉" ||
        notificationTitle == "Amount Collected Successfully" ||
        notificationTitle?.isNotEmpty == true) {
      if (mounted) {
        _showSuccessMessage(notificationBody);
      }
    }
  }

  void _handleNotificationOpened(RemoteMessage message) {
    // Keep your existing background notification click logic here.
  }

  Future<void> _handleInitialMessage() async {
    final RemoteMessage? message =
    await FirebaseMessaging.instance.getInitialMessage();

    if (!mounted || message == null) return;

    // Keep your existing terminated/cold-start notification logic here.
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_remainingSeconds <= 0) {
          Navigator.of(context).pop();
          return;
        }

          _showWarning();

      },
      child: Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: FadeTransition(
            opacity: _pageFadeAnimation,
            child: SlideTransition(
              position: _pageSlideAnimation,
              child: Column(
                children: [
                  _buildTopBar(),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            4,
                            20,
                            20,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 24,
                            ),
                            child: Column(
                              children: [
                                _buildPaymentHeader(),

                                const SizedBox(height: 24),

                                _buildQrSection(),

                                const SizedBox(height: 22),

                                _buildPaymentStatus(),

                                const SizedBox(height: 22),

                                _buildActionButtons(),

                                const SizedBox(height: 24),

                                _buildTimerCard(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          _buildIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              if (_remainingSeconds > 0) {
                _showWarning();
              }
            },
          ),

          Expanded(
            child: Column(
              children: [
                Text(
                  'Scan to Pay',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                Text(
                  'Secure QR payment',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _mutedText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _border,
            ),
          ),
          child: Icon(
            icon,
            color: _text,
            size: 22,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PAYMENT HEADER
  // ===========================================================================

  Widget _buildPaymentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Column(
        children: [
          Text(
            'PAYMENT REQUEST',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _mutedText,
              letterSpacing: 1.4,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Icon(
                Icons.currency_rupee_rounded,
                size: 28,
                color: _primary,
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  widget.amount,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: _primary,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            'Scan the QR below to complete your payment',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _mutedText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // QR SECTION
  // ===========================================================================

  Widget _buildQrSection() {
    return ScaleTransition(
      scale: _qrScaleAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildQrCode(),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.85 + (_pulseController.value * 0.15),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration:  BoxDecoration(
                        color: _success,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'QR ready to scan',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCode() {
    return RepaintBoundary(
      key: _qrKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
        ),
        child: QrImageView(
          data: widget.paymentSessionId,
          version: QrVersions.auto,
          size: 220,
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
    );
  }

  // ===========================================================================
  // PAYMENT STATUS
  // ===========================================================================

  Widget _buildPaymentStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child:  Icon(
              Icons.qr_code_scanner_rounded,
              color: _primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waiting for payment',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Open any UPI app and scan this QR',
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    color: _mutedText,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.verified_user_outlined,
            color: _success,
            size: 19,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACTION BUTTONS
  // ===========================================================================

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Expanded(
        //   child: _buildActionButton(
        //     icon: Icons.download_rounded,
        //     label: 'Save QR',
        //     onTap: () {
        //       if (!mounted) return;
        //
        //       // Keep your existing Save logic here.
        //       _showSuccessMessage('Payment completed successfully');
        //     },
        //   ),
        // ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildActionButton(
            icon: Icons.ios_share_rounded,
            label: 'Share QR',
            onTap: _shareQrCode,
          ),
        ),
      ],
    );
  }
  Future<void> _shareQrCode() async {
    try {
      final boundary = _qrKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;

      if (boundary == null) {
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        return;
      }

      final bytes = byteData.buffer.asUint8List();

      await SharePlus.instance.share(
        ShareParams(
          text: 'Scan this QR code to make a payment.',
          subject: 'Payment QR Code',
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'image/png',
              name: 'payment_qr.png',
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Share QR error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to share QR code'),
        ),
      );
    }
  }
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: _text,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TIMER
  // ===========================================================================

  Widget _buildTimerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
      decoration: BoxDecoration(
        color: _text,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: _isAlmostExpired
                      ? const Color(0xFFFF8D8D)
                      : Colors.white,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment expires in',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _isAlmostExpired
                          ? 'Please complete your payment soon'
                          : 'Complete your payment before the timer ends',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: GoogleFonts.poppins(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: _isAlmostExpired
                      ? const Color(0xFFFF8D8D)
                      : Colors.white,
                  letterSpacing: 0.5,
                ),
                child: Text(_timeString),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: _timerProgress,
                end: _timerProgress,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 5,
                  backgroundColor: Colors.white.withValues(alpha: 0.10),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isAlmostExpired
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF54C7B4),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WARNING DIALOG
  // ===========================================================================

  void _showWarning() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Leave payment?',
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your current payment session will be cancelled if you leave this screen.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    height: 1.5,
                    color: _mutedText,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          side:  BorderSide(
                            color: _border,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Stay',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _text,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();

                          _stopTimer();

                          if (!mounted) return;

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          backgroundColor: home1,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Leave',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // SUCCESS DIALOG
  // ===========================================================================

  void _showSuccessMessage(String? message) {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: _SuccessDialogContent(
            message: message,
            onPressed: () {
              Navigator.of(dialogContext).pop();

              if (!mounted) return;

              _stopTimer();

              Navigator.of(context).pop();
              Navigator.of(context).pop('fetch_balance');
            },
          ),
        );
      },
    );
  }
}

// =============================================================================
// SUCCESS DIALOG WIDGET
// =============================================================================

class _SuccessDialogContent extends StatefulWidget {
  final String? message;
  final VoidCallback onPressed;

  const _SuccessDialogContent({
    required this.message,
    required this.onPressed,
  });

  @override
  State<_SuccessDialogContent> createState() => _SuccessDialogContentState();
}

class _SuccessDialogContentState extends State<_SuccessDialogContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  static const Color _success = Color(0xFF1B9A67);
  static const Color _text = Color(0xFF17211F);
  static const Color _muted = Color(0xFF77827F);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: _success.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: _success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Payment Successful',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _text,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.message ??
                  'Your payment has been successfully completed.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                height: 1.5,
                color: _muted,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _success,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class NewQrCodePage extends StatefulWidget {
//   final String paymentSessionId;
//   final String amount;
//   final String custName;
//   final String custPhone;
//   final String custId;
//
//   const NewQrCodePage({
//     super.key,
//     required this.paymentSessionId,
//     required this.amount,
//     required this.custName,
//     required this.custPhone,
//     required this.custId,
//   });
//
//   @override
//   State<NewQrCodePage> createState() => _NewQrCodePageState();
// }
//
// class _NewQrCodePageState extends State<NewQrCodePage>
//     with SingleTickerProviderStateMixin {
//   // ---- Timer / UI state ----
//   late Timer _timer;
//   int _start = 180; // 3 minutes in seconds
//   String _timeString = "03:00";
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//
//   // ---- QR image + agent/bank display data (populated externally) ----
//   Uint8List? qrCodeImageBytes;
//   String? agentName;
//   String? agentPhoneNumber;
//   String? bankName;
//
//   // ---- Firebase messaging state ----
//   bool _isFirebaseListenerInitialized = false; // ✅ Prevent duplicate listeners
//   StreamSubscription<RemoteMessage>? _firebaseMessageSubscription;
//
//   // =================================================================
//   // FIREBASE MESSAGING
//   // =================================================================
//   void _listenForFirebaseMessages() {
//     print("_listenForFirebaseMessages");
//     _firebaseMessageSubscription?.cancel(); // ✅ Ensure only one listener
//
//     _firebaseMessageSubscription = FirebaseMessaging.onMessage.listen((
//         RemoteMessage message,
//         ) {
//       if (message.notification != null) {
//         final String? notificationTitle = message.notification?.title;
//         final String? notificationBody = message.notification?.body;
//
//         if (notificationTitle == "Wallet Load Successful 🎉"
//             || notificationTitle == "Amount Collected Successfully"
//         || notificationTitle?.isNotEmpty == true
//         ) {
//           if (mounted) {
//             _showSuccessMessage(notificationBody);
//           }
//         }
//       }
//     });
//
//     // ✅ Handle background notification clicks
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // handle background tap
//     });
//
//     // ✅ Handle terminated app notification taps
//     FirebaseMessaging.instance.getInitialMessage().then((
//         RemoteMessage? message,
//         ) {
//       if (message != null) {
//         // handle cold-start tap
//       }
//     });
//   }
//
//   // =================================================================
//   // LIFECYCLE
//   // =================================================================
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//     _startTimer();
//
//     if (!_isFirebaseListenerInitialized) {
//       _listenForFirebaseMessages();
//       _isFirebaseListenerInitialized = true;
//     }
//
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _firebaseMessageSubscription?.cancel();
//     super.dispose();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (_start == 0) {
//         _timer.cancel();
//         Navigator.pop(context);
//       } else {
//         setState(() {
//           _start--;
//           _timeString = _formatTime(_start);
//         });
//       }
//     });
//   }
//
//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
//   }
//
//   // =================================================================
//   // DIALOGS (UI)
//   // =================================================================
//   void showWarning() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           title: const Center(
//             child: Text(
//               "⚠️ WARNING",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//             ),
//           ),
//           content: const Text(
//             softWrap: true,
//             "Are you sure you want to go back ?",
//             style: TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                   style: TextButton.styleFrom(
//                       side: const BorderSide(color: home1),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                   onPressed: () {
//                     setState(() {
//                       _timeString = "00:00";
//                       _timer.cancel();
//                     });
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: home1,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     "No",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   void _showSuccessMessage(String? message) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.1),
//                   blurRadius: 24,
//                   spreadRadius: 0,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: 48,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   "Success",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   message ?? "payment successfully completed!",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 0,
//                   ),
//                   onPressed: () {
//                     if (mounted) {
//                       Navigator.pop(context); // Close the dialog
//                       Navigator.pop(context); // Close the dialog
//                       Navigator.pop(context, "fetch_balance");
//                     }
//                   },
//                   child: const Text(
//                     "OK",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Expanded(
//                 //       child: ElevatedButton(
//                 //         style: ElevatedButton.styleFrom(
//                 //           backgroundColor: Colors.blue,
//                 //           foregroundColor: Colors.white,
//                 //           padding: const EdgeInsets.symmetric(vertical: 16),
//                 //           shape: RoundedRectangleBorder(
//                 //               borderRadius: BorderRadius.circular(12)),
//                 //           elevation: 0,
//                 //         ),
//                 //         onPressed: () {
//                 //           Navigator.pop(context); // Close this dialog
//                 //           var receiptModel = ReceiptDataModel(
//                 //             amount: widget.amount,
//                 //             bankName: bankName ?? "XYZ BANK",
//                 //             agentName: agentName ?? "Name",
//                 //             agentPhone: agentPhoneNumber ?? "agentPhone",
//                 //             custName: widget.custName,
//                 //             custPhone: widget.custPhone,
//                 //             custId: widget.custId,
//                 //             txnId: "",
//                 //             txnType: "QR",
//                 //             dat: '',
//                 //             tranType: '',
//                 //             accNo: '',
//                 //           );
//                 //           Navigator.push(
//                 //               context,
//                 //               MaterialPageRoute(
//                 //                   builder: (context) => ReceiptPage(
//                 //                     receiptDataModel: receiptModel,
//                 //                   )));
//                 //         },
//                 //         child: const Text(
//                 //           "Show Receipt",
//                 //           style: TextStyle(
//                 //             fontSize: 16,
//                 //             fontWeight: FontWeight.w600,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     const SizedBox(width: 10),
//                 //     Expanded(
//                 //       child: ElevatedButton(
//                 //         style: ElevatedButton.styleFrom(
//                 //           backgroundColor: Colors.green,
//                 //           foregroundColor: Colors.white,
//                 //           padding: const EdgeInsets.symmetric(vertical: 16),
//                 //           shape: RoundedRectangleBorder(
//                 //               borderRadius: BorderRadius.circular(12)),
//                 //           elevation: 0,
//                 //         ),
//                 //         onPressed: () {
//                 //           if (mounted) {
//                 //             Navigator.pop(context); // Close the dialog
//                 //             Navigator.pop(context, "fetch_balance");
//                 //           }
//                 //         },
//                 //         child: const Text(
//                 //           "OK",
//                 //           style: TextStyle(
//                 //             fontSize: 16,
//                 //             fontWeight: FontWeight.w600,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void showCustomCircularProgressDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: white,
//                   borderRadius: BorderRadius.circular(360),
//                 ),
//                 padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
//                 height: 70,
//                 width: 70,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     const SizedBox(
//                       width: 60,
//                       height: 60,
//                       child: CircularProgressIndicator(
//                         color: deepTeal,
//                         strokeWidth: 4.0,
//                       ),
//                     ),
//                     Image.asset(
//                       "assets/images/logo_cut.png",
//                       width: 40,
//                       height: 40,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // =================================================================
//   // BUILD / WIDGET TREE (UI)
//   // =================================================================
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_timeString != "00:00") showWarning();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Column(
//               children: [
//                 _buildAppBar(),
//                 Transform.translate(
//                   offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
//                   child: Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: _buildAmountCard(),
//                   ),
//                 ),
//                 Expanded(
//                   child: Transform.translate(
//                     offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
//                     child: Opacity(
//                       opacity: _fadeAnimation.value,
//                       child: _buildQrCodeSection(),
//                     ),
//                   ),
//                 ),
//                 Transform.translate(
//                   offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
//                   child: Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: _buildActionButtons(),
//                   ),
//                 ),
//                 _buildTimerSection(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       centerTitle: true,
//       title: Text(
//         "Scan To Pay",
//         style: GoogleFonts.poppins(
//           fontWeight: FontWeight.w600,
//           color: home2,
//           fontSize: 22,
//           letterSpacing: 0.5,
//         ),
//       ),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_rounded, color: home2, size: 28),
//         onPressed: () {
//           if (_timeString != "00:00") showWarning();
//         },
//       ),
//     );
//   }
//
//   Widget _buildAmountCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [home1, home2],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: deepTeal.withValues(alpha: 0.3),
//               blurRadius: 20,
//               spreadRadius: 2,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.currency_rupee_rounded,
//                   color: Colors.white, size: 32),
//               const SizedBox(width: 8),
//               Text(
//                 widget.amount,
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQrCodeSection() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Positioned(
//           top: 50,
//           left: 30,
//           child: AnimatedContainer(
//             duration: const Duration(seconds: 8),
//             curve: Curves.easeInOut,
//             width: 120,
//             height: 160,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: home1.withValues(alpha: 0.05),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 40,
//           right: 40,
//           child: AnimatedContainer(
//             duration: const Duration(seconds: 6),
//             curve: Curves.easeInOut,
//             width: 160,
//             height: 180,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: home2.withValues(alpha: 0.05),
//             ),
//           ),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ScaleTransition(
//               scale: _scaleAnimation,
//               child: Container(
//                 padding: const EdgeInsets.all(1),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.1),
//                       blurRadius: 30,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: widget.paymentSessionId == null
//                     ? const SizedBox(
//                   width: 200,
//                   height: 200,
//                   child: Center(
//                     child: CircularProgressIndicator(
//                       color: deepTeal,
//                       strokeWidth: 3,
//                     ),
//                   ),
//                 )
//                     : QrImageView(data: widget.paymentSessionId, version: QrVersions.auto,size: 200,
//                 backgroundColor: Colors.white,)
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "Scan the QR code to make payment",
//               style: GoogleFonts.poppins(
//                 color: Colors.grey[700],
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildAnimatedButton(
//             icon: Icons.download_rounded,
//             label: "Save",
//             color: black,
//             onTap: () {
//               if (mounted) {
//                 _showSuccessMessage("Payment completed successfully");
//               }
//               // hook up download/save action here
//             },
//           ),
//           _buildAnimatedButton(
//             icon: Icons.share_rounded,
//             label: "Share",
//             color: black,
//             onTap: () {
//               // hook up share action here
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnimatedButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required Function() onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//           decoration: BoxDecoration(
//             color: color.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(50),
//             border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, color: color, size: 22),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: GoogleFonts.poppins(
//                   color: color,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimerSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(40),
//           topRight: Radius.circular(40),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             blurRadius: 20,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             "Time remaining",
//             style: GoogleFonts.poppins(
//               color: black,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TweenAnimationBuilder(
//             duration: const Duration(milliseconds: 800),
//             tween: Tween<double>(begin: 0, end: 1),
//             builder: (context, value, child) {
//               return Transform.scale(
//                 scale: 1 + (0.1 * sin(value * 2 * pi)), // Pulsing effect
//                 child: Opacity(opacity: value, child: child),
//               );
//             },
//             child: Text(
//               _timeString,
//               style: GoogleFonts.poppins(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 38,
//                 color: home1,
//                 letterSpacing: 1,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _start / 180, // 3 minutes = 180 seconds
//             backgroundColor: Colors.grey[200],
//             valueColor: const AlwaysStoppedAnimation<Color>(home2),
//             minHeight: 6,
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ],
//       ),
//     );
//   }
// }

