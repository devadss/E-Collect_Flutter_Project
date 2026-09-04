import 'dart:developer';
import 'package:e_Collect/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:e_Collect/data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import 'package:e_Collect/data/provider/integrated_loan_detail_provider.dart';
import 'package:e_Collect/data/provider/integration_loan_list_provider.dart';
import 'package:e_Collect/data/repository/e_collect_repository/payment_repository/payment_repository.dart';
import 'package:e_Collect/data/repository/integrated_loan_detail_repository.dart';
import 'package:e_Collect/data/repository/integration_loan_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../../data/provider/delete_fcm_provider.dart';
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
import 'data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';
import 'data/repository/e_collect_repository/authentication_repository/authentication_repository.dart';
import 'data/repository/e_collect_repository/customer_list_repo/customer_list_repo.dart';
import 'data/repository/e_collect_repository/rdcl_due_list_repo/rdcl_due_list_repo.dart';
import 'data/repository/e_collect_repository/transation_report/transaction_reposrt_repository.dart';
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
        RepositoryProvider(create: (_) => DeleteFcmTokenRepository()),
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
              create: (_) => DeleteFcmProvider(
                DeleteFcmTokenRepository(),
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
          //home: const PtpBucketUi(),
        );
      },
    );
  }
}


// ChangeNotifierProvider(
//   create: (_) => CashTranscationProvider(
//     CashTranscationRepository(),
//   ),
// ),

// ChangeNotifierProvider(
//   create: (_) => AgentCustomerDetailsProvider(
//     AgentCustomerDetailsRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => BankDetailProvider(
//     BankAccountRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => BankAccountUpdateProvider(
//     BankAccountUpdateRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => GroupListProvider(
//     GroupListRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => MemberListProvider(
//     MemberListRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => CreateGroupProvider(
//     CreateGroupRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => CreateMemberProvider(
//     CreateMemberRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => DeleteMemberProvider(
//     MemberDeleteRepository(),
//   ),
// ),
//
// ChangeNotifierProvider(
//   create: (_) => GroupDeleteProvider(
//     DeleteGroupRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => CreateGroupWithMemberProvider(
//     CreateGroupWithMemberRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => GroupUpdateProvider(
//     GroupUpdateRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => UpdateGroupProvider(
//     UpdateBankAccountRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => GroupStatusProvider(
//     GroupStatusRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => MemberUpdateProvider(
//     MemberUpdateRepository(),
//   ),
// ),
// ChangeNotifierProvider(
//   create: (_) => LoanCashCollectionProvider(
//     LoanCashCollectionRepository(),
//   ),
// ),

//RepositoryProvider(create: (_) => CashTranscationRepository()),
// RepositoryProvider(create: (_) => AgentCustomerDetailsRepository()),
// RepositoryProvider(create: (_) => BankAccountRepository()),
//  RepositoryProvider(create: (_) => BankAccountUpdateRepository()),
//  RepositoryProvider(create: (_) => GroupListRepository()),
//  RepositoryProvider(create: (_) => MemberListRepository()),
//  RepositoryProvider(create: (_) => CreateGroupRepository()),
//  RepositoryProvider(create: (_) => CreateMemberRepository()),
//  RepositoryProvider(create: (_) => MemberDeleteRepository()),
//  RepositoryProvider(create: (_) => DeleteGroupRepository()),
//  RepositoryProvider(create: (_) => CreateGroupWithMemberRepository()),
//  RepositoryProvider(create: (_) => GroupUpdateRepository()),
//  RepositoryProvider(create: (_) => UpdateBankAccountRepository()),
//  RepositoryProvider(create: (_) => GroupStatusRepository()),
//  RepositoryProvider(create: (_) => MemberUpdateRepository()),
// RepositoryProvider(create: (_) => LoanCashCollectionRepository()),
