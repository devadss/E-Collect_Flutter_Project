import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();

  ConnectivityService() {
    // Listen to connection changes
    InternetConnectionChecker.createInstance().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;
      _controller.add(hasConnection);

      // Show toast on status change
      if (hasConnection) {
        Fluttertoast.showToast(msg: "✅ Internet Connected");
      } else {
        Fluttertoast.showToast(msg: "❌ No Internet Connection");
      }
    });
  }

  Stream<bool> get connectionStream => _controller.stream;

  Future<bool> get hasConnection async {
    final checker = InternetConnectionChecker.createInstance();
    return await checker.hasConnection;
  }
  void dispose() {
    _controller.close();
  }
}
