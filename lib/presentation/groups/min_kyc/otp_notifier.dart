import 'dart:async';

import 'package:flutter/cupertino.dart';

class OtpNotifier extends ChangeNotifier {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  int _remainingTime = 120;
  bool _canResendOtp = false;
  Timer? _timer;

  int get remainingTime => _remainingTime;
  bool get canResendOtp => _canResendOtp;

  OtpNotifier() {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _remainingTime = 120; // Reset the timer
    _canResendOtp = false; // Disable resend option
    notifyListeners(); // Notify listeners about the state change

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime -= 1; // Decrement the remaining time
        notifyListeners(); // Notify listeners about the state change
      } else {
        _canResendOtp = true; // Enable resend option
        notifyListeners(); // Notify listeners about the state change
        timer.cancel(); // Stop the timer
      }
    });
  }
/*  void startTimer() {
    _timer?.cancel();
    _remainingTime = 120;
    _canResendOtp = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        _canResendOtp = true;
        notifyListeners();
        timer.cancel();
      } else {
        _remainingTime -= 1;
        notifyListeners();
      }
    });
  }*/

  void resendOtp() {
    if (_remainingTime == 0) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}