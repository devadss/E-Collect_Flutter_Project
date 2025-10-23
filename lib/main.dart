import 'dart:developer';
import 'package:collection_qr_flutter/data/provider/link_transcation_history_provider.dart';
import 'package:collection_qr_flutter/data/provider/loan_cash_coolection_provider.dart';
import 'package:collection_qr_flutter/data/provider/transfer_transaction_provider.dart';
import 'package:collection_qr_flutter/data/provider/whatsapp_share_provider.dart';
import 'package:collection_qr_flutter/data/repository/loan_cash_collection_repository.dart';
import 'package:collection_qr_flutter/data/repository/payment_link_repository.dart';
import 'package:collection_qr_flutter/data/repository/transfer_history_repository.dart';
import 'package:collection_qr_flutter/data/repository/whats_app_share_repository.dart';
import 'package:collection_qr_flutter/presentation/groups/homepage/payment_link_provider.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../data/provider/agent_customer_details_provider.dart';
import '../../data/provider/agent_transaction_provider.dart';
import '../../data/provider/cerate_order_provider.dart';
import '../../data/provider/collection_summary_provider.dart';
import '../../data/provider/delete_fcm_provider.dart';
import '../../data/provider/due_list_provider.dart';
import '../../data/provider/due_under_agent_provider.dart';
import '../../data/repository/agent_customer_details_repository.dart';
import '../../data/repository/agent_transaction_repository.dart';
import '../../data/repository/collection_summary_repository.dart';
import '../../data/repository/delete_fcm_repository.dart';
import '../../data/repository/due_list_repository.dart';
import '../../data/repository/due_under_agent_repository.dart';
import '../../data/repository/fetch_account_balance_repository.dart';
import '../../presentation/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'data/provider/aadhaar_otp_request_provider.dart';
import 'data/provider/auth_provider.dart';
import 'data/provider/cash_transcation_history_provider.dart';
import 'data/provider/cash_transcation_provider.dart';
import 'data/provider/collection_base_url_provider.dart';
import 'data/provider/fetch_account_balance_provider.dart';
import 'data/provider/get_loan_provider.dart';
import 'data/provider/group/bank_account_update_provider.dart';
import 'data/provider/group/bank_detail_provider.dart';
import 'data/provider/group/create_group/create_group_provider.dart';
import 'data/provider/group/create_group/create_group_with_member_provider.dart';
import 'data/provider/group/create_member/create_member_provider.dart';
import 'data/provider/group/delete_member/delete_member_provider.dart';
import 'data/provider/group/group_delte/group_delete_provider.dart';
import 'data/provider/group/group_list/group_list_preovider.dart';
import 'data/provider/group/group_status/group_status_provider.dart';
import 'data/provider/group/member_list/member_list_provider.dart';
import 'data/provider/group/member_update/member_update_provider.dart';
import 'data/provider/group/update_group/group_update_repository.dart';
import 'data/provider/group/update_group_provider.dart';
import 'data/provider/otp_request_provider.dart';
import 'data/provider/otp_verification_provider.dart';
import 'data/provider/parent_agent_detail_provider/parent_agent_detil_provider.dart';
import 'data/provider/parent_agent_detail_provider/parent_credential_provider/parent_credential_provider.dart';
import 'data/provider/qr_transcation_history_provider.dart';
import 'data/provider/rdcl_cust_list_provider.dart';
import 'data/provider/rdcl_due_under_agent_provider.dart';
import 'data/provider/set_mpin_provider.dart';
import 'data/provider/token_expiry_provider.dart';
import 'data/provider/token_request_provider.dart';
import 'data/provider/transaction_provider.dart';
import 'data/provider/verify_aadhaar_detail_provider.dart';
import 'data/repository/TransactionRepository.dart';
import 'data/repository/aadhaar_otp_request_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/cash_transcation_history_repository.dart';
import 'data/repository/cash_transcation_repository.dart';
import 'data/repository/collection_base_url_repo.dart';
import 'data/repository/create_order_repository.dart';
import 'data/repository/get_loan_repository.dart';
import 'data/repository/group/bank_account_update_repository.dart';
import 'data/repository/group/bank_detail_repository.dart';
import 'data/repository/group/create_group/create_group_repository.dart';
import 'data/repository/group/create_group/create_group_with_member_repository.dart';
import 'data/repository/group/create_member/create_member_repository.dart';
import 'data/repository/group/delete_group/delete_group_repository.dart';
import 'data/repository/group/group_list/group_list_repository.dart';
import 'data/repository/group/group_status/group_status_repository.dart';
import 'data/repository/group/group_update/group_update_repository.dart';
import 'data/repository/group/member_delete/member_delete_repository.dart';
import 'data/repository/group/member_list/member_list_repository.dart';
import 'data/repository/group/member_update_repository/member_update_repository.dart';
import 'data/repository/group/update_account_repository.dart';
import 'data/repository/link_transaction_history_repository.dart';
import 'data/repository/otp_request_repository.dart';
import 'data/repository/otp_verification_repository.dart';
import 'data/repository/parent_agent/fetch_parent_crentials/parent_agent_credential_repository.dart';
import 'data/repository/parent_agent/parent_agent_detail_repo.dart';
import 'data/repository/qr_transcation_history_repository.dart';
import 'data/repository/rdcl_custList_repo.dart';
import 'data/repository/rdcl_due_under_agent_repository.dart';
import 'data/repository/set_mpin_repository.dart';
import 'data/repository/token _repository.dart';
import 'data/repository/token_request_repository.dart';
import 'data/repository/verify_aadhaar_detail_repository.dart';
import 'data/service/notification_service/firebase_notification_services.dart';
import 'firebase_options.dart';
import 'data/provider/cust_register_provider.dart';
import 'data/repository/cust_reg_repository.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestLocationPermission();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'com.collection.qr', // Use a unique name
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationServiceQrCode().initialize();
  }
  catch (e) {
    // Handle already initialized or any Firebase-related error
    debugPrint("Firebase initialization error: $e");
  }

  await requestLocationPermission();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  try {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationServiceQrCode().initialize();
  } catch (e) {
    debugPrint("Firebase Messaging error: $e");
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CashTransactionHistoryProvider(CashTransactionHistoryRepository())),
    ChangeNotifierProvider(create: (_) => CashTranscationProvider(CashTranscationRepository())),
    ChangeNotifierProvider(create: (_) => RdclCustListProvider(RdclCustListRep())),
    ChangeNotifierProvider(create: (_) => RdclDueUnderAgentProvider(RdclDueUnderAgentRepo())),
    ChangeNotifierProvider(create: (_) => LinkTransactionHistoryProvider(LinkTransactionHistoryRepository())),
    ChangeNotifierProvider(create: (_) => CollectionBaseUrlProvider(CollectionBaseUrlRepo())),
    ChangeNotifierProvider(create: (_) => QRTransactionHistoryProvider(QRTransactionHistoryRepository())),
    ChangeNotifierProvider(create: (_) => CustRegisterProvider(CustRegRepository())),
    ChangeNotifierProvider(create: (_) => TokenRequestProvider(TokenRequestRepository())),
    ChangeNotifierProvider(create: (_) => OtpRequestProvider(OtpRequestRepository())),
    ChangeNotifierProvider(create: (_) => OtpVerificationProvider(OtpVerificationRepository())),
    ChangeNotifierProvider(create: (_) => SetMpinProvider(SetMpinRepository())),
    ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepository())),
    ChangeNotifierProvider(create: (_) => AgentCustomerDetailsProvider(AgentCustomerDetailsRepository())),
    ChangeNotifierProvider(create: (_) => CreateOrderProvider(OrderCreateRepository())),
    ChangeNotifierProvider(create: (_) => BalanceProvider(FetchAccountBalanceRepository())),
    ChangeNotifierProvider(create: (_) => DueListProvider(DueListRepository())),
    ChangeNotifierProvider(create: (_) => TransactionProvider(TransactionRepository())),
    ChangeNotifierProvider(create: (_) => AgentTransactionProvider(AgentTransactionRepository())),
    ChangeNotifierProvider(create: (_) => CollectionSummaryProvider(CollectionSummaryRepository())),
    ChangeNotifierProvider(create: (_) => DueUnderAgentProvider(DueUnderAgentRepository())),
    ChangeNotifierProvider(create: (_) => TokenExpiryProvider(TokenExpiryRepository())),
    ChangeNotifierProvider(create: (_) => DeleteFcmProvider(DeleteFcmTokenRepository())),
    ChangeNotifierProvider(create: (_) => ParentDetailAgentProvider(ParentAgentDetailRepository())),
    ChangeNotifierProvider(create: (_) => ParentAgentCredentialProvider(ParentAgentCredentialRepository())),
    ChangeNotifierProvider(create: (_) => GetLoanProvider(GetLoanRepository())),
    ChangeNotifierProvider(create: (_) => AadhaarOtpRequestProvider(AadhaarOtpRequestRepository())),
    ChangeNotifierProvider(create: (_) => VerifyAadhaarDetailProvider(VerifyAadhaarDetailRepository())),
    ChangeNotifierProvider(create: (_) => BankDetailProvider(BankAccountRepository())),
    ChangeNotifierProvider(create: (_) => BankAccountUpdateProvider(BankAccountUpdateRepository())),
    ChangeNotifierProvider(create: (_) => GroupListProvider(GroupListRepository())),
    ChangeNotifierProvider(create: (_) => MemberListProvider(MemberListRepository())),
    ChangeNotifierProvider(create: (_) => CreateGroupProvider(CreateGroupRepository())),
    ChangeNotifierProvider(create: (_) => CreateMemberProvider(CreateMemberRepository())),
    ChangeNotifierProvider(create: (_) => DeleteMemberProvider(MemberDeleteRepository())),
    ChangeNotifierProvider(create: (_) => WhatsAppShareProvider(WhatsAppShareRepository())),
    ChangeNotifierProvider(create: (_) => GroupDeleteProvider(DeleteGroupRepository())),
    ChangeNotifierProvider(create: (_) => CreateGroupWithMemberProvider(CreateGroupWithMemberRepository())),
    ChangeNotifierProvider(create: (_) => GroupUpdateProvider(GroupUpdateRepository())),
    ChangeNotifierProvider(create: (_) => UpdateGroupProvider(UpdateBankAccountRepository())),
    ChangeNotifierProvider(create: (_) => GroupStatusProvider(GroupStatusRepository())),
    ChangeNotifierProvider(create: (_) => MemberUpdateProvider(MemberUpdateRepository())),
    ChangeNotifierProvider(create: (_) => LoanCashCollectionProvider(LoanCashCollectionRepository())),
    ChangeNotifierProvider(create: (_) => TransferHistoryProvider(TransferHistoryRepository())),
    ChangeNotifierProvider(create: (_) => PaymentLinkProvider(PaymentLinkRepository())),

  ], child: const MyApp()));
}
Future<void> requestOverlayPermission() async {
  final isGranted = await FlutterOverlayWindow.isPermissionGranted();
  if (!isGranted) {
    await FlutterOverlayWindow.requestPermission();
  }
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
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard mobile size
      minTextAdapt: true, // Prevents text resizing
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Collection Qr',
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}

// import 'dart:developer';
// import '../../data/provider/agent_customer_details_provider.dart';
// import '../../data/provider/agent_transaction_provider.dart';
// import '../../data/provider/cerate_order_provider.dart';
// import '../../data/provider/collection_summary_provider.dart';
// import '../../data/provider/due_list_provider.dart';
// import '../../data/provider/due_under_agent_provider.dart';
// import '../../data/repository/agent_customer_details_repository.dart';
// import '../../data/repository/agent_transaction_repository.dart';
// import '../../data/repository/collection_summary_repository.dart';
// import '../../data/repository/due_list_repository.dart';
// import '../../data/repository/due_under_agent_repository.dart';
// import '../../data/repository/fetch_account_balance_repository.dart';
// import '../../presentation/splash_screen/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// import 'data/provider/auth_provider.dart';
// import 'data/provider/fetch_account_balance_provider.dart';
// import 'data/provider/otp_request_provider.dart';
// import 'data/provider/otp_verification_provider.dart';
// import 'data/provider/set_mpin_provider.dart';
// import 'data/provider/token_expiry_provider.dart';
// import 'data/provider/token_request_provider.dart';
// import 'data/provider/transaction_provider.dart';
// import 'data/repository/TransactionRepository.dart';
// import 'data/repository/auth_repository.dart';
// import 'data/repository/create_order_repository.dart';
// import 'data/repository/otp_request_repository.dart';
// import 'data/repository/otp_verification_repository.dart';
// import 'data/repository/set_mpin_repository.dart';
// import 'data/repository/token _repository.dart';
// import 'data/repository/token_request_repository.dart';
// import 'data/service/notification_service/firebase_notification_services.dart';
// import 'firebase_options.dart';
// import 'data/provider/cust_register_provider.dart';
// import 'data/repository/cust_reg_repository.dart';
//
// final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();
//
// /// Handles background push notifications
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   log("Handling a background message: ${message.messageId}");
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Request permissions
//   await requestLocationPermission();
//
//   // Device orientation and status bar
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//   ));
//
//   // ✅ Prevent duplicate Firebase initialization
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//
//   // Setup Firebase Messaging
//   await FirebaseMessaging.instance.getInitialMessage();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await NotificationServiceQrCode().initialize();
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CustRegisterProvider(CustRegRepository())),
//         ChangeNotifierProvider(create: (_) => TokenRequestProvider(TokenRequestRepository())),
//         ChangeNotifierProvider(create: (_) => OtpRequestProvider(OtpRequestRepository())),
//         ChangeNotifierProvider(create: (_) => OtpVerificationProvider(OtpVerificationRepository())),
//         ChangeNotifierProvider(create: (_) => SetMpinProvider(SetMpinRepository())),
//         ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepository())),
//         ChangeNotifierProvider(create: (_) => AgentCustomerDetailsProvider(AgentCustomerDetailsRepository())),
//         ChangeNotifierProvider(create: (_) => CreateOrderProvider(OrderCreateRepository())),
//         ChangeNotifierProvider(create: (_) => BalanceProvider(FetchAccountBalanceRepository())),
//         ChangeNotifierProvider(create: (_) => DueListProvider(DueListRepository())),
//         ChangeNotifierProvider(create: (_) => TransactionProvider(TransactionRepository())),
//         ChangeNotifierProvider(create: (_) => AgentTransactionProvider(AgentTransactionRepository())),
//         ChangeNotifierProvider(create: (_) => CollectionSummaryProvider(CollectionSummaryRepository())),
//         ChangeNotifierProvider(create: (_) => DueUnderAgentProvider(DueUnderAgentRepository())),
//         ChangeNotifierProvider(create: (_) => TokenExpiryProvider(TokenExpiryRepository())),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// Future<void> requestLocationPermission() async {
//   if (await Permission.locationWhenInUse.isDenied) {
//     await Permission.locationWhenInUse.request();
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: false,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Collection Qr',
//           builder: (context, child) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
//               child: child!,
//             );
//           },
//           home: const SplashScreen(),
//         );
//       },
//     );
//   }
// }
