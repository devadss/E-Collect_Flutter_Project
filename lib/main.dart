import 'dart:developer';

import 'package:collection_qr_flutter/data/provider/agent_transaction_provider.dart';
import 'package:collection_qr_flutter/data/provider/cash_deposit_provider.dart';
import 'package:collection_qr_flutter/data/provider/collection_summary_provider.dart';
import 'package:collection_qr_flutter/data/provider/delete_fcm_provider.dart';
import 'package:collection_qr_flutter/data/provider/update_dop_provider.dart';
import 'package:collection_qr_flutter/data/provider/update_password_provider.dart';
import 'package:collection_qr_flutter/data/repository/agent_transaction_repository.dart';
import 'package:collection_qr_flutter/data/repository/cash_deposit_repository.dart';
import 'package:collection_qr_flutter/data/repository/collection_summary_repository.dart';
import 'package:collection_qr_flutter/data/repository/delete_fcm_repository.dart';
import 'package:collection_qr_flutter/data/repository/update_dop_repository.dart';
import 'package:collection_qr_flutter/data/repository/update_password_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection_qr_flutter/data/provider/auth_provider.dart';
import 'package:collection_qr_flutter/data/provider/balance_provider.dart';
import 'package:collection_qr_flutter/data/provider/otp_request_provider.dart';
import 'package:collection_qr_flutter/data/provider/otp_verification_provider.dart';
import 'package:collection_qr_flutter/data/provider/set_mpin_provider.dart';
import 'package:collection_qr_flutter/data/provider/token_expiry_provider.dart';
import 'package:collection_qr_flutter/data/provider/token_request_provider.dart';
import 'package:collection_qr_flutter/data/provider/transaction_provider.dart';
import 'package:collection_qr_flutter/data/repository/TransactionRepository.dart';
import 'package:collection_qr_flutter/data/repository/agent_customer_details_repository.dart';
import 'package:collection_qr_flutter/data/repository/auth_repository.dart';
import 'package:collection_qr_flutter/data/repository/balance_repository.dart';
import 'package:collection_qr_flutter/data/repository/due_list_repository.dart';
import 'package:collection_qr_flutter/data/repository/order_create_repository.dart';
import 'package:collection_qr_flutter/data/repository/otp_request_repository.dart';
import 'package:collection_qr_flutter/data/repository/otp_verification_repository.dart';
import 'package:collection_qr_flutter/data/repository/set_mpin_repository.dart';
import 'package:collection_qr_flutter/data/repository/token%20_repository.dart';
import 'package:collection_qr_flutter/data/repository/token_request_repository.dart';
import 'package:collection_qr_flutter/presentation/splash_screen/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'data/provider/agent_customer_details_provider.dart';
import 'data/provider/create_order_provider.dart';
import 'data/provider/due_list_provider.dart';
import 'data/service/notification_service/firebase_notification_services.dart';
import 'data/service/notification_service/firebase_options.dart';
import 'data/provider/cust_register_provider.dart';
import 'data/repository/cust_reg_repository.dart';



final GlobalKey<ScaffoldMessengerState> snackBarKey =
GlobalKey<ScaffoldMessengerState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
    //   await Firebase.initializeApp(
    //   name: 'com.collection.qr',  // Replace this with your package name
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'com.collection.qr', // Use a unique name
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationServiceQrCode().initialize();


  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => CustRegisterProvider(CustRegRepository())),
  ChangeNotifierProvider(
  create: (_) => TokenRequestProvider(TokenRequestRepository())),
  ChangeNotifierProvider(
  create: (_) => OtpRequestProvider(OtpRequestRepository())),
  ChangeNotifierProvider(
  create: (_) => OtpVerificationProvider(OtpVerificationRepository())),
    ChangeNotifierProvider(
  create: (_) => SetMpinProvider(SetMpinRepository())),
    ChangeNotifierProvider(
  create: (_) => AuthProvider(AuthRepository())),
 ChangeNotifierProvider(
  create: (_) => TokenExpiryProvider(TokenExpiryRepository())),
 ChangeNotifierProvider(
  create: (_) => TransactionProvider(TransactionRepository())),
    ChangeNotifierProvider(
  create: (_) => BalanceProvider(BalanceRepository())),
    ChangeNotifierProvider(
  create: (_) => AgentCustomerDetailsProvider(AgentCustomerDetailsRepository())),
    ChangeNotifierProvider(
  create: (_) => DueListProvider(DueListRepository())),
  ChangeNotifierProvider(
  create: (_) => CreateOrderProvider(OrderCreateRepository())),
  ChangeNotifierProvider(
  create: (_) => CashDepositProvider(CashDepositRepository())),
    ChangeNotifierProvider(
  create: (_) => UpdateDopProvider(UpdateDopRepository())),
   ChangeNotifierProvider(
  create: (_) => UpdatePasswordProvider(UpdatePasswordRepository())),
    ChangeNotifierProvider(
  create: (_) => AgentTransactionProvider(AgentTransactionRepository())),
    ChangeNotifierProvider(
  create: (_) => DeleteFcmProvider(DeleteFcmTokenRepository())),
    ChangeNotifierProvider(
  create: (_) => CollectionSummaryProvider(CollectionSummaryRepository())),


  ], child: const MyApp()));
}


Future<void> requestLocationPermission() async {
  // Check if location permission is denied and request it if necessary
  await Permission.locationWhenInUse.isDenied.then((value) {
    if (value) {
      Permission.locationWhenInUse.request();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Collection Qr',
        home: SplashScreen());
  }
}
