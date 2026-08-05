import 'dart:developer';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:collection_qr_flutter/data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import 'package:collection_qr_flutter/data/provider/cash_qr_provider.dart';
import 'package:collection_qr_flutter/data/provider/integrated_loan_detail_provider.dart';
import 'package:collection_qr_flutter/data/provider/integration_loan_list_provider.dart';
import 'package:collection_qr_flutter/data/provider/link_transcation_history_provider.dart';
import 'package:collection_qr_flutter/data/provider/loan_cash_coolection_provider.dart';
import 'package:collection_qr_flutter/data/provider/transfer_transaction_provider.dart';
import 'package:collection_qr_flutter/data/provider/whatsapp_share_provider.dart';
import 'package:collection_qr_flutter/data/repository/cash_qr_repo.dart';
import 'package:collection_qr_flutter/data/repository/e_collect_repository/payment_repository/payment_repository.dart';
import 'package:collection_qr_flutter/data/repository/integrated_loan_detail_repository.dart';
import 'package:collection_qr_flutter/data/repository/integration_loan_repository.dart';
import 'package:collection_qr_flutter/data/repository/loan_cash_collection_repository.dart';
import 'package:collection_qr_flutter/data/repository/payment_link_repository.dart';
import 'package:collection_qr_flutter/data/repository/transfer_history_repository.dart';
import 'package:collection_qr_flutter/data/repository/whats_app_share_repository.dart';
import 'package:collection_qr_flutter/domain/service/api_services.dart';
import 'package:collection_qr_flutter/presentation/test_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'core/utils.dart';
import 'data/customer_list_bloc/customer_list_bloc.dart';
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
import 'data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import 'data/repository/TransactionRepository.dart';
import 'data/repository/aadhaar_otp_request_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/cash_transcation_history_repository.dart';
import 'data/repository/cash_transcation_repository.dart';
import 'data/repository/collection_base_url_repo.dart';
import 'data/repository/create_order_repository.dart';
import 'data/repository/customer_list_repo/customer_list_repo.dart';
import 'data/repository/e_collect_repository/authentication_repository/authentication_repository.dart';
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
import 'data/repository/rdcl_due_list_repo/rdcl_due_list_repo.dart';
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
  if (printStatementStatus) {
    log("Handling a background message: ${message.messageId}");
  }
}

void main() async {
  final apiService = ApiService(baseUrl);

  WidgetsFlutterBinding.ensureInitialized();
  requestLocationPermission();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'com_collection_qr', // Use a unique name
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationServiceQrCode().initialize();
  } catch (e) {
    // Handle already initialized or any Firebase-related error
    if (printStatementStatus) {
      debugPrint("Firebase initialization error: $e");
    }
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
    if (printStatementStatus) {
      debugPrint("Firebase Messaging error: $e");
    }
  }

  runApp(
    // Layer 1: All Repositories (Dependency Injection)
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthenticationRepository()),
        RepositoryProvider(create: (_) => PaymentRepository()),
        RepositoryProvider(create: (_) => CustomerListRepo()),
        RepositoryProvider(create: (_) => RdclDueListRepo()),
        // Add all your existing repositories
        RepositoryProvider(create: (_) => CashTransactionHistoryRepository()),
        RepositoryProvider(create: (_) => CashTranscationRepository()),
        RepositoryProvider(create: (_) => RdclCustListRep()),
        RepositoryProvider(create: (_) => RdclDueUnderAgentRepo()),
        RepositoryProvider(create: (_) => LinkTransactionHistoryRepository()),
        RepositoryProvider(create: (_) => CollectionBaseUrlRepo()),
        RepositoryProvider(create: (_) => QRTransactionHistoryRepository()),
        RepositoryProvider(create: (_) => CustRegRepository()),
        RepositoryProvider(create: (_) => TokenRequestRepository()),
        RepositoryProvider(create: (_) => OtpRequestRepository()),
        RepositoryProvider(create: (_) => OtpVerificationRepository()),
        RepositoryProvider(create: (_) => SetMpinRepository()),
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => AgentCustomerDetailsRepository()),
        RepositoryProvider(create: (_) => OrderCreateRepository()),
        RepositoryProvider(create: (_) => FetchAccountBalanceRepository()),
        RepositoryProvider(create: (_) => CashQrRepository()),
        RepositoryProvider(create: (_) => DueListRepository()),
        RepositoryProvider(create: (_) => TransactionRepository()),
        RepositoryProvider(create: (_) => AgentTransactionRepository()),
        RepositoryProvider(create: (_) => CollectionSummaryRepository()),
        RepositoryProvider(create: (_) => DueUnderAgentRepository()),
        RepositoryProvider(create: (_) => TokenExpiryRepository()),
        RepositoryProvider(create: (_) => DeleteFcmTokenRepository()),
        RepositoryProvider(create: (_) => ParentAgentDetailRepository()),
        RepositoryProvider(create: (_) => ParentAgentCredentialRepository()),
        RepositoryProvider(create: (_) => GetLoanRepository(apiService)),
        RepositoryProvider(create: (_) => AadhaarOtpRequestRepository()),
        RepositoryProvider(create: (_) => VerifyAadhaarDetailRepository()),
        RepositoryProvider(create: (_) => BankAccountRepository()),
        RepositoryProvider(create: (_) => BankAccountUpdateRepository()),
        RepositoryProvider(create: (_) => GroupListRepository()),
        RepositoryProvider(create: (_) => MemberListRepository()),
        RepositoryProvider(create: (_) => CreateGroupRepository()),
        RepositoryProvider(create: (_) => CreateMemberRepository()),
        RepositoryProvider(create: (_) => MemberDeleteRepository()),
        RepositoryProvider(create: (_) => WhatsAppShareRepository()),
        RepositoryProvider(create: (_) => DeleteGroupRepository()),
        RepositoryProvider(create: (_) => CreateGroupWithMemberRepository()),
        RepositoryProvider(create: (_) => GroupUpdateRepository()),
        RepositoryProvider(create: (_) => UpdateBankAccountRepository()),
        RepositoryProvider(create: (_) => GroupStatusRepository()),
        RepositoryProvider(create: (_) => MemberUpdateRepository()),
        RepositoryProvider(create: (_) => LoanCashCollectionRepository()),
        RepositoryProvider(create: (_) => TransferHistoryRepository()),
        RepositoryProvider(create: (_) => PaymentLinkRepository()),
        RepositoryProvider(create: (_) => IntegrationLoanRepository()),
        RepositoryProvider(create: (_) => IntegratedLoanDetailRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          // Layer 2: All BLoCs
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(context.read<AuthenticationRepository>())),
          BlocProvider(
              create: (context) =>
                  PaymentBloc(context.read<PaymentRepository>())),
          BlocProvider(
              create: (context) =>
                  CustomerListBloc(context.read<CustomerListRepo>())),
          BlocProvider(
              create: (context) =>
                  RdclDuelistBloc(context.read<RdclDueListRepo>())),
          // Add BLoCs for your existing providers (if you migrate them)
          // Example: BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())),
        ],
        child: MultiProvider(
          // Layer 3: All ChangeNotifier Providers
          providers: [
            ChangeNotifierProvider(
                create: (_) => CashTransactionHistoryProvider(
                    CashTransactionHistoryRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    CashTranscationProvider(CashTranscationRepository())),
            ChangeNotifierProvider(
                create: (_) => RdclCustListProvider(RdclCustListRep())),
            ChangeNotifierProvider(
                create: (_) =>
                    RdclDueUnderAgentProvider(RdclDueUnderAgentRepo())),
            ChangeNotifierProvider(
                create: (_) => LinkTransactionHistoryProvider(
                    LinkTransactionHistoryRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    CollectionBaseUrlProvider(CollectionBaseUrlRepo())),
            ChangeNotifierProvider(
                create: (_) => QRTransactionHistoryProvider(
                    QRTransactionHistoryRepository())),
            ChangeNotifierProvider(
                create: (_) => CustRegisterProvider(CustRegRepository())),
            ChangeNotifierProvider(
                create: (_) => TokenRequestProvider(TokenRequestRepository())),
            ChangeNotifierProvider(
                create: (_) => OtpRequestProvider(OtpRequestRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    OtpVerificationProvider(OtpVerificationRepository())),
            ChangeNotifierProvider(
                create: (_) => SetMpinProvider(SetMpinRepository())),
            ChangeNotifierProvider(
                create: (_) => AuthProvider(AuthRepository())),
            ChangeNotifierProvider(
                create: (_) => AgentCustomerDetailsProvider(
                    AgentCustomerDetailsRepository())),
            ChangeNotifierProvider(
                create: (_) => CreateOrderProvider(OrderCreateRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    BalanceProvider(FetchAccountBalanceRepository())),
            ChangeNotifierProvider(
                create: (_) => CashQrProvider(CashQrRepository())),
            ChangeNotifierProvider(
                create: (_) => DueListProvider(DueListRepository())),
            ChangeNotifierProvider(
                create: (_) => TransactionProvider(TransactionRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    AgentTransactionProvider(AgentTransactionRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    CollectionSummaryProvider(CollectionSummaryRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    DueUnderAgentProvider(DueUnderAgentRepository())),
            ChangeNotifierProvider(
                create: (_) => TokenExpiryProvider(TokenExpiryRepository())),
            ChangeNotifierProvider(
                create: (_) => DeleteFcmProvider(DeleteFcmTokenRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    ParentDetailAgentProvider(ParentAgentDetailRepository())),
            ChangeNotifierProvider(
                create: (_) => ParentAgentCredentialProvider(
                    ParentAgentCredentialRepository())),
            ChangeNotifierProvider(
                create: (_) => GetLoanProvider(GetLoanRepository(apiService))),
            ChangeNotifierProvider(
                create: (_) =>
                    AadhaarOtpRequestProvider(AadhaarOtpRequestRepository())),
            ChangeNotifierProvider(
                create: (_) => VerifyAadhaarDetailProvider(
                    VerifyAadhaarDetailRepository())),
            ChangeNotifierProvider(
                create: (_) => BankDetailProvider(BankAccountRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    BankAccountUpdateProvider(BankAccountUpdateRepository())),
            ChangeNotifierProvider(
                create: (_) => GroupListProvider(GroupListRepository())),
            ChangeNotifierProvider(
                create: (_) => MemberListProvider(MemberListRepository())),
            ChangeNotifierProvider(
                create: (_) => CreateGroupProvider(CreateGroupRepository())),
            ChangeNotifierProvider(
                create: (_) => CreateMemberProvider(CreateMemberRepository())),
            ChangeNotifierProvider(
                create: (_) => DeleteMemberProvider(MemberDeleteRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    WhatsAppShareProvider(WhatsAppShareRepository())),
            ChangeNotifierProvider(
                create: (_) => GroupDeleteProvider(DeleteGroupRepository())),
            ChangeNotifierProvider(
                create: (_) => CreateGroupWithMemberProvider(
                    CreateGroupWithMemberRepository())),
            ChangeNotifierProvider(
                create: (_) => GroupUpdateProvider(GroupUpdateRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    UpdateGroupProvider(UpdateBankAccountRepository())),
            ChangeNotifierProvider(
                create: (_) => GroupStatusProvider(GroupStatusRepository())),
            ChangeNotifierProvider(
                create: (_) => MemberUpdateProvider(MemberUpdateRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    LoanCashCollectionProvider(LoanCashCollectionRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    TransferHistoryProvider(TransferHistoryRepository())),
            //ChangeNotifierProvider(create: (_) => PaymentLinkProvider(PaymentLinkRepository())),
            ChangeNotifierProvider(
                create: (_) =>
                    IntegratedLoanListProvider(IntegrationLoanRepository())),
            ChangeNotifierProvider(
                create: (_) => IntegratedLoanDetailProvider(
                    IntegratedLoanDetailRepository())),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
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
          title: 'e-Collect',
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            );
          },
          home: const SplashScreen(),
         // home: const NavTest(),
        // home: const OnboardingScreen(),
         // home: const Sample(),
        );
      },
    );
  }
}
