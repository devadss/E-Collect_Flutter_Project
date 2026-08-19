import 'dart:developer';
import 'package:collection_qr_flutter/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:collection_qr_flutter/data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import 'package:collection_qr_flutter/data/provider/integrated_loan_detail_provider.dart';
import 'package:collection_qr_flutter/data/provider/integration_loan_list_provider.dart';
import 'package:collection_qr_flutter/data/provider/loan_cash_coolection_provider.dart';
import 'package:collection_qr_flutter/data/repository/e_collect_repository/payment_repository/payment_repository.dart';
import 'package:collection_qr_flutter/data/repository/integrated_loan_detail_repository.dart';
import 'package:collection_qr_flutter/data/repository/integration_loan_repository.dart';
import 'package:collection_qr_flutter/data/repository/loan_cash_collection_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../../data/provider/agent_customer_details_provider.dart';
import '../../data/provider/delete_fcm_provider.dart';
import '../../data/repository/agent_customer_details_repository.dart';
import '../../data/repository/delete_fcm_repository.dart';
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
import 'data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import 'data/provider/cash_transcation_provider.dart';
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
import 'data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import 'data/repository/cash_transcation_repository.dart';
import 'data/repository/customer_list_repo/customer_list_repo.dart';
import 'data/repository/e_collect_repository/authentication_repository/authentication_repository.dart';
import 'data/repository/e_collect_repository/transation_report/transaction_reposrt_repository.dart';
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
import 'data/repository/rdcl_due_list_repo/rdcl_due_list_repo.dart';
import 'data/service/notification_service/firebase_notification_services.dart';
import 'firebase_options.dart';


final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (printStatementStatus) {
    log("Handling a background message: ${message.messageId}");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 // final apiService = ApiService(baseUrl);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  // ------------------------------------------------------------
  // Start Flutter UI immediately
  // ------------------------------------------------------------

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthenticationRepository()),
        RepositoryProvider(create: (_) => PaymentRepository()),
        RepositoryProvider(create: (_) => TransactionReportRepository()),
        RepositoryProvider(create: (_) => CustomerListRepo()),
        RepositoryProvider(create: (_) => RdclDueListRepo()),
        RepositoryProvider(create: (_) => CashTranscationRepository()),
        RepositoryProvider(create: (_) => AgentCustomerDetailsRepository()),
        RepositoryProvider(create: (_) => DeleteFcmTokenRepository()),
        RepositoryProvider(create: (_) => BankAccountRepository()),
        RepositoryProvider(create: (_) => BankAccountUpdateRepository()),
        RepositoryProvider(create: (_) => GroupListRepository()),
        RepositoryProvider(create: (_) => MemberListRepository()),
        RepositoryProvider(create: (_) => CreateGroupRepository()),
        RepositoryProvider(create: (_) => CreateMemberRepository()),
        RepositoryProvider(create: (_) => MemberDeleteRepository()),
        RepositoryProvider(create: (_) => DeleteGroupRepository()),
        RepositoryProvider(create: (_) => CreateGroupWithMemberRepository()),
        RepositoryProvider(create: (_) => GroupUpdateRepository()),
        RepositoryProvider(create: (_) => UpdateBankAccountRepository()),
        RepositoryProvider(create: (_) => GroupStatusRepository()),
        RepositoryProvider(create: (_) => MemberUpdateRepository()),
        RepositoryProvider(create: (_) => LoanCashCollectionRepository()),
        RepositoryProvider(create: (_) => IntegrationLoanRepository()),
        RepositoryProvider(create: (_) => IntegratedLoanDetailRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PaymentBloc(
              context.read<PaymentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CustomerListBloc(
              context.read<CustomerListRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) => RdclDuelistBloc(
              context.read<RdclDueListRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) => PaymentTransactionBloc(
              context.read<TransactionReportRepository>(),
            ),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CashTranscationProvider(
                CashTranscationRepository(),
              ),
            ),

            ChangeNotifierProvider(
              create: (_) => AgentCustomerDetailsProvider(
                AgentCustomerDetailsRepository(),
              ),
            ),

            ChangeNotifierProvider(
              create: (_) => DeleteFcmProvider(
                DeleteFcmTokenRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => BankDetailProvider(
                BankAccountRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => BankAccountUpdateProvider(
                BankAccountUpdateRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => GroupListProvider(
                GroupListRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => MemberListProvider(
                MemberListRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => CreateGroupProvider(
                CreateGroupRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => CreateMemberProvider(
                CreateMemberRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => DeleteMemberProvider(
                MemberDeleteRepository(),
              ),
            ),

            ChangeNotifierProvider(
              create: (_) => GroupDeleteProvider(
                DeleteGroupRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => CreateGroupWithMemberProvider(
                CreateGroupWithMemberRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => GroupUpdateProvider(
                GroupUpdateRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => UpdateGroupProvider(
                UpdateBankAccountRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => GroupStatusProvider(
                GroupStatusRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => MemberUpdateProvider(
                MemberUpdateRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => LoanCashCollectionProvider(
                LoanCashCollectionRepository(),
              ),
            ),

            ChangeNotifierProvider(
              create: (_) => IntegratedLoanListProvider(
                IntegrationLoanRepository(),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => IntegratedLoanDetailProvider(
                IntegratedLoanDetailRepository(),
              ),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );

  // ------------------------------------------------------------
  // Do NOT block UI with these
  // ------------------------------------------------------------

  _initializeBackgroundServices();
}
Future<void> _initializeBackgroundServices() async {
  // Firebase
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'com_collection_qr',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    await NotificationServiceQrCode().initialize();
  } catch (e) {
    if (printStatementStatus) {
      debugPrint("Firebase initialization error: $e");
    }
  }

  // Location
  try {
    await requestLocationPermission();
  } catch (e) {
    if (printStatementStatus) {
      debugPrint("Location permission error: $e");
    }
  }
}
Future<void> requestOverlayPermission() async {
  final isGranted = await FlutterOverlayWindow.isPermissionGranted();
  if (!isGranted) {
    await FlutterOverlayWindow.requestPermission();
  }
}

Future<void> requestLocationPermission() async {
  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }
}
// Future<void> requestLocationPermission() async {
//   // Check if location permission is denied and request it if necessary
//   await Permission.locationWhenInUse.isDenied.then((value) {
//     if (value) {
//       Permission.locationWhenInUse.request();
//     }
//   });
// }

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
       //   home: const TestPage(),

        );
      },
    );
  }
}
