// import 'package:carousel_slider/carousel_slider.dart';
// import '../../data/repository/cust_reg_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../core/colors.dart';
// import '../../../data/storage/shared_pref_helper.dart';
// import '../../../core/general.dart';
// import '../../data/provider/agent_transaction_provider.dart';
// import '../../data/provider/collection_summary_provider.dart';
// import '../../data/provider/fetch_account_balance_provider.dart';
// import '../../data/provider/transaction_provider.dart';
// import '../trancstion/transction_history_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   // final bool _isCardDetailsVisible = false;
//   int test = 0;
//
//   //bool _isCvvVisible = false;
//   String? userName;
//   String? entityId;
//   String? token;
//   String? agentOriginId;
//   String? mobNum;
//   bool? isBannerAvailable;
//   final List<String> bannerImages = [
//     "assets/images/collection_splash_screen.jpg",
//     "assets/images/collection_splash_screen.jpg",
//     "assets/images/doodle.jpeg",
//   ];
//   DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
//   DateTime endDate = DateTime.now();
//
//   Future<void> _selectDateRange(BuildContext context) async {
//     DateTime today = DateTime.now();
//     DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
//
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: oneMonthAgo,
//       lastDate: today,
//       initialDateRange: DateTimeRange(start: startDate, end: endDate),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: deepTeal,
//             colorScheme: const ColorScheme.light(primary: deepTeal),
//             buttonTheme:
//                 const ButtonThemeData(textTheme: ButtonTextTheme.primary),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked.duration.inDays <= 30) {
//       setState(() {
//         startDate = picked.start;
//         endDate = picked.end;
//       });
//
//       fetchCollection();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select a date range within one month."),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }
//
//   // List<Result> result = [];
//   @override
//   void initState() {
//     super.initState();
//     loadSharedPrefs();
//   }
//
//   void showProgressDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: SingleChildScrollView(
//               child: Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(50),
//                   child: Column(
//                     children: [
//                       const CircularProgressIndicator(color: home2),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Please wait....",
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   Future<void> fetchBalance() async {
//     final fetchBalanceProvider =
//         Provider.of<BalanceProvider>(context, listen: false);
//     await fetchBalanceProvider.getFetchBalance(
//         entityId.toString(), token.toString());
//   }
//
//   Future<void> fetchTransaction() async {
//     final transProvider =
//         Provider.of<TransactionProvider>(context, listen: false);
//     await transProvider.fetchTransaction(
//         "", "", entityId.toString(), token.toString());
//     final provider =
//         Provider.of<AgentTransactionProvider>(context, listen: false);
//     await provider.getTransactions(token.toString());
//   }
//
//   String formatTimestamp(DateTime? timestamp) {
//     if (timestamp == null) return "Invalid Date";
//     return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
//   }
//
//   Future<void> loadSharedPrefs() async {
//     final name = await SharedPref().getAgentName();
//     final entId = await SharedPref().getAgentId();
//     final tok = await SharedPref().getTokenValue();
//     final agentOrgID = await SharedPref().getAgentOriginId();
//     final mobnum = await SharedPref().getMobNum();
//     printLog("-------------------USERNAME---------------");
//     print(name);
//
//     // Trigger rebuild after fetching the userName
//     if (mounted) {
//       setState(() {
//         userName = name;
//         entityId = entId;
//         token = tok;
//         agentOriginId = agentOrgID;mobNum = mobnum;
//       });
//     }
//     fetchBalance();
//     fetchTransaction();
//     fetchCollection();
//     fetchBannerImages();
//
//   }
//
//   Future<void> fetchBannerImages() async {
//     final images = await CustRegRepository().checkRegCust(int.parse(mobNum!));
//     images.fold(
//             (error){
//               printLog("-----------------------ERROR----------------------");
//               printLog(error);
//           print("NO BANNER IMAGE IS FOUND");
//           isBannerAvailable = false;
//         },
//             (image){
//           final data = image.response?.images;
//           if (data != null) {
//             print("BANNER IMAGE IS FOUND");
//             bannerImages.add(data.banner1.toString());
//             bannerImages.add(data.banner2.toString());
//             bannerImages.add(data.banner3.toString());
//             bannerImages.add(data.banner4.toString());
//             setState(() {
//               isBannerAvailable = true;
//             });
//           }}
//     );
//     // final provider = Provider.of<CustRegisterProvider>(context, listen: false);
//     // await provider.checkRegCust(int.parse(mobNum.toString()));
//     // final data = provider.registedCustomerModel?.response?.images;
//
//     // if (data != null) {
//     //   print("BANNER IMAGE IS FOUND");
//     //   bannerImages.add(data.banner1.toString());
//     //   bannerImages.add(data.banner2.toString());
//     //   bannerImages.add(data.banner3.toString());
//     //   bannerImages.add(data.banner4.toString());
//     //   setState(() {
//     //     isBannerAvailable = true;
//     //   });
//     // } else {
//     //   print("NO BANNER IMAGE IS FOUND");
//     //   isBannerAvailable = false;
//     // }
//   }
//
//
//
//   String addCommasToNumber(num number) {
//     final formatter = NumberFormat('#,##0.##');
//     String formattedNumber = formatter.format(number);
//
//     // Truncate instead of rounding
//     if (number is double) {
//       formattedNumber = number.toStringAsFixed(2);
//       if (formattedNumber.endsWith('.00')) {
//         formattedNumber =
//             formattedNumber.substring(0, formattedNumber.length - 3);
//       } else if (formattedNumber.endsWith('0')) {
//         formattedNumber =
//             formattedNumber.substring(0, formattedNumber.length - 1);
//       }
//     }
//
//     return formattedNumber;
//   }
//
//   Widget buildShimmerText(
//       {String text = "Loading Balance.....", double fontSize = 16}) {
//     return Shimmer.fromColors(
//       baseColor: grey[400]!, // Darker base color
//       highlightColor: grey[100]!, // Lighter highlight color
//       child: Text(
//           textAlign: TextAlign.start,
//           text,
//           style: TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: grey[300],
//           )),
//     );
//   }
//
//   Widget buildShimmerList() {
//     return Shimmer.fromColors(
//         baseColor: grey[400]!,
//         highlightColor: grey[100]!,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Image.asset(
//                     "assets/icons/calender.png",
//                     scale: 15,
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildSummaryCard(
//                   image: "assets/images/money_initated.png",
//                   title: "Total Initiated",
//                   amount: "",
//                 ),
//                 _buildSummaryCard(
//                   image: "assets/images/salary_17531132.png",
//                   title: "Total Received",
//                   amount: "",
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: 5,
//                 separatorBuilder: (_, __) => const Divider(thickness: 1),
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: lightGreen.shade200,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: black),
//                       ),
//                       child: Image.asset(
//                         "assets/images/payment_recived.png",
//                         scale: 20,
//                         color: black,
//                       ),
//                     ),
//                     title: Text(
//                       "Please wait....",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     subtitle: Text(
//                       "Please wait....",
//                       style: TextStyle(fontSize: 10, color: grey),
//                     ),
//                     trailing: Text(
//                       "₹....",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w800,
//                         color: green,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
//
//   Future<void> fetchCollection() async {
//     printLog("---------------------------Start Date------------------");
//     printLog(startDate);
//     printLog("---------------------------End Date------------------");
//     printLog(endDate);
//
//     final provider =
//         Provider.of<CollectionSummaryProvider>(context, listen: false);
//     provider.getCollectionSummary(
//         "AGT12345", "${startDate}", "${endDate}", token!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final fetchBalanceProvider =
//         Provider.of<BalanceProvider>(context, listen: true);
//     final provider =
//         Provider.of<AgentTransactionProvider>(context, listen: true);
//     return Scaffold(
//       backgroundColor: white,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [deepTeal, yellowGreen],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Hello, ${userName?.replaceFirst(userName![0], userName![0].toUpperCase())}",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: white,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   provider.agentPaymentTransctionModel == null
//                       ? buildShimmerText()
//                       : Text(
//                           "Your Balance: ₹ ${fetchBalanceProvider.fetchBalanceModel?.result?.isNotEmpty == true ? addCommasToNumber(fetchBalanceProvider.fetchBalanceModel!.result![0].balance!.toDouble()) : ' '}",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: white,
//                           ),
//                         )
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// **Agent Card**
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: CarouselSlider(
//                 options: CarouselOptions(
//                   height: MediaQuery.of(context).size.height * 0.20,
//                   // Same height as previous container
//                   autoPlay: true,
//                   enlargeCenterPage: true,
//                   viewportFraction: 1,
//                   // Ensure full width
//                   autoPlayInterval: const Duration(seconds: 4),
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                 ),
//                 items: bannerImages.map((imagePath) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.asset(
//                       imagePath,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             /// **Transaction History Title**
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "Transaction History",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: white,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// **Transaction History List**
//             Flexible(
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 decoration: const BoxDecoration(
//                   color: white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25),
//                     topRight: Radius.circular(25),
//                   ),
//                 ),
//                 child: provider.agentPaymentTransctionModel == null
//                     ?
//                     // CircularProgressIndicator(color: home2)
//                     buildShimmerList()
//                     : Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 15,
//                                       color: black),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     _selectDateRange(context);
//                                   },
//                                   child: Image.asset(
//                                     "assets/icons/calender.png",
//                                     scale: 15,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Consumer<CollectionSummaryProvider>(
//                               builder: (context, provider, child) {
//                             print(
//                                 "---------------------INITATED AMOUNT-------------------------");
//                             print(provider.collectionSummaryModel?.data?[0]
//                                 .pendingCollections);
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 _buildSummaryCard(
//                                   image: "assets/images/money_initated.png",
//                                   title: "Total Initiated",
//                                   amount:
//                                       "Rs. ${provider.collectionSummaryModel?.data?[0].pendingCollections}",
//                                 ),
//                                 _buildSummaryCard(
//                                   image: "assets/images/salary_17531132.png",
//                                   title: "Total Received",
//                                   amount:
//                                       "Rs. ${provider.collectionSummaryModel?.data?[0].totalCollected}",
//                                 ),
//                               ],
//                             );
//                           }),
//                           Expanded(
//                             child: ListView.separated(
//                               itemCount: provider
//                                   .agentPaymentTransctionModel!.data!.length,
//                               separatorBuilder: (_, __) =>
//                                   const Divider(thickness: 1),
//                               itemBuilder: (context, index) {
//                                 final transaction = provider
//                                     .agentPaymentTransctionModel!.data![index];
//                                 return GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 TransactionHistoryPage(
//                                                     agentTransaction: provider
//                                                         .agentPaymentTransctionModel!
//                                                         .data![index])));
//                                   },
//                                   child: ListTile(
//                                     leading: Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: BoxDecoration(
//                                         color: lightGreen.shade200,
//                                         shape: BoxShape.circle,
//                                         border: Border.all(color: black),
//                                       ),
//                                       child: Image.asset(
//                                         "assets/images/payment_recived.png",
//                                         scale: 20,
//                                         color: black,
//                                       ),
//                                     ),
//                                     title: Text(
//                                       "Payment Received from ${provider.agentPaymentTransctionModel?.data?[index].customerName ?? "Unknown"}",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                       formatTimestamp(transaction.createdAt),
//                                       style: TextStyle(
//                                           fontSize: 10, color: grey),
//                                     ),
//                                     trailing: Text(
//                                       "₹ ${transaction.linkAmount}",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w800,
//                                         color: green,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSummaryCard(
//       {required String image, required String title, required String amount}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       decoration: BoxDecoration(
//         color: deepTeal,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: black, width: 1),
//         boxShadow: const [
//           BoxShadow(
//             color: black12,
//             blurRadius: 10,
//             spreadRadius: 1,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             image,
//             scale: 15,
//           ),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 13, color: white),
//               ),
//               Text(
//                 amount,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:carousel_slider/carousel_slider.dart';
import '../../data/repository/cust_reg_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../data/provider/agent_transaction_provider.dart';
import '../../data/provider/collection_summary_provider.dart';
import '../../data/provider/fetch_account_balance_provider.dart';
import '../../data/provider/transaction_provider.dart';
import '../../domain/model/agent_transction_model.dart';
import '../trancstion/transction_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int test = 0;
  String? userName;
  String? entityId;
  String? token;
  String? agentOriginId;
  String? mobNum;
  bool? isBannerAvailable;
  final List<String> bannerImages = [
    "assets/images/collection_splash_screen.jpg",
    "assets/images/collection_splash_screen.jpg",
    "assets/images/doodle.jpeg",
  ];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;


  Future<void> _selectDateRange(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime oneMonthAgo = today.subtract(const Duration(days: 30));

    final picked = await showDateRangePicker(
      context: context,
      firstDate: oneMonthAgo,
      lastDate: today,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: home2,            // selection color (date picked)
              onPrimary: Colors.white,   // text on selected date
              surface: Colors.white,
              onSurface: Colors.black,   // text for other dates
            ),
            dialogBackgroundColor: Colors.white,
            datePickerTheme: const DatePickerThemeData(
              rangeSelectionBackgroundColor: home1, // highlighted range
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked.duration.inDays <= 30) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      fetchCollection();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select a date range within one month."),
          backgroundColor: errorColor[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }



  // Future<void> _selectDateRange(BuildContext context) async {
  //   DateTime today = DateTime.now();
  //   DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
  //
  //   final picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: oneMonthAgo,
  //     lastDate: today,
  //     initialDateRange: DateTimeRange(start: startDate, end: endDate),
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: deepTeal,
  //           colorScheme: const ColorScheme.light(primary: deepTeal),
  //           buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null && picked.duration.inDays <= 30) {
  //     setState(() {
  //       startDate = picked.start;
  //       endDate = picked.end;
  //     });
  //     fetchCollection();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text("Please select a date range within one month."),
  //         backgroundColor: errorColor[400],
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          backgroundColor: white,
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: home2),
                SizedBox(height: 20),
                Text(
                  "Please wait...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: black87,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchBalance() async {
    final fetchBalanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    await fetchBalanceProvider.getFetchBalance(entityId.toString(), token.toString());
  }

  Future<void> fetchTransaction() async {
    final transProvider = Provider.of<TransactionProvider>(context, listen: false);
    await transProvider.fetchTransaction("", "", entityId.toString(), token.toString());

    final provider = Provider.of<AgentTransactionProvider>(context, listen: false);
    await provider.getTransactions(token.toString());
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "Invalid Date";
    return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    final mobnum = await SharedPref().getMobNum();

    if (mounted) {
      setState(() {
        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
        mobNum = mobnum;
      });
    }
    fetchBalance();
    fetchTransaction();
    fetchCollection();
    fetchBannerImages();
  }

  Future<void> fetchBannerImages() async {
    final images = await CustRegRepository().checkRegCust(int.parse(mobNum!));
    images.fold(
          (error) {
        print("NO BANNER IMAGE IS FOUND");
        isBannerAvailable = false;
      },
          (image) {
        final data = image.response?.images;
        if (data != null) {
          print("BANNER IMAGE IS FOUND");
          bannerImages.add(data.banner1.toString());
          bannerImages.add(data.banner2.toString());
          bannerImages.add(data.banner3.toString());
          bannerImages.add(data.banner4.toString());
          setState(() {
            isBannerAvailable = true;
          });
        }
      },
    );
  }

  String addCommasToNumber(num number) {
    final formatter = NumberFormat('#,##0.##');
    String formattedNumber = formatter.format(number);

    if (number is double) {
      formattedNumber = number.toStringAsFixed(2);
      if (formattedNumber.endsWith('.00')) {
        formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
      } else if (formattedNumber.endsWith('0')) {
        formattedNumber = formattedNumber.substring(0, formattedNumber.length - 1);
      }
    }

    return formattedNumber;
  }

  Widget buildShimmerText({String text = "Loading Balance.....", double fontSize = 16}) {
    return Shimmer.fromColors(
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: grey[300],
        ),
      ),
    );
  }

  Widget buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180,
                  height: 20,
                  color: white,
                ),
                Container(
                  width: 24,
                  height: 24,
                  color: white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerSummaryCard(),
              _buildShimmerSummaryCard(),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Container(
                    width: 120,
                    height: 16,
                    color: white,
                  ),
                  subtitle: Container(
                    width: 80,
                    height: 12,
                    color: white,
                  ),
                  trailing: Container(
                    width: 60,
                    height: 16,
                    color: white,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSummaryCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            color: white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 16,
            color: white,
          ),
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 16,
            color: white,
          ),
        ],
      ),
    );
  }

  Future<void> fetchCollection() async {
    final provider = Provider.of<CollectionSummaryProvider>(context, listen: false);
    provider.getCollectionSummary("AGT12345", "$startDate", "$endDate", token!);
  }
  @override
  Widget build(BuildContext context) {
    final fetchBalanceProvider = Provider.of<BalanceProvider>(context, listen: true);
    final provider = Provider.of<AgentTransactionProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;
    final collectionProvider = Provider.of<CollectionSummaryProvider>(context,listen: false);

    // Define the color theme
    const Color primaryColor = deepTeal;
    const Color secondaryColor = Color(0xFF4CAF50); // Green
    const Color accentColor = Color(0xFFFF9800); // Orange
    const Color backgroundColor = Color(0xFFF5F5F5); // Light grey
    const Color cardColor = white;
    const Color textColor = Color(0xFF333333);
    const Color secondaryTextColor = Color(0xFF666666);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Doodle Background
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [home1,home2],begin: Alignment.topLeft,end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/doodle.jpeg"),
                fit: BoxFit.fitWidth,
                opacity: 0.15,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Hello, ${userName?.replaceFirst(userName![0], userName![0].toUpperCase())}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        provider.agentPaymentTransctionModel == null
                            ? buildShimmerText(text: "Loading balance...", fontSize: 16)
                            : Text(
                          "Your Balance ₹${fetchBalanceProvider.fetchBalanceModel?.result?.isNotEmpty == true ? addCommasToNumber(fetchBalanceProvider.fetchBalanceModel!.result![0].balance!.toDouble()) : '0.00'}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Banner Carousel
                Container(
                  height: size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: size.height * 0.18,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                      ),
                      items: bannerImages.map((imagePath) {
                        return Image.asset(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerImages.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentBannerIndex == entry.key
                              ? white
                              : white.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Collection Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDateRange(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primaryColor.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: home1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Summary Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryCard(
                        icon: Icons.send,
                        title: "Initiated",
                        amount: "${collectionProvider.collectionSummaryModel?.data?[0].pendingCollections ?? "0"}",
                        color: accentColor,
                        iconColor: accentColor,
                        textColor: textColor,
                      ),
                      _buildSummaryCard(
                        icon: Icons.currency_rupee,
                        title: "Received",
                        amount: "${collectionProvider.collectionSummaryModel?.data?[0].totalCollected ?? "0"}",
                        color: secondaryColor,
                        iconColor: secondaryColor,
                        textColor: textColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    "Transaction History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  // Transaction List
                  Expanded(
                    child: provider.agentPaymentTransctionModel == null
                        ? buildShimmerList()
                        : ListView.separated(
                      itemCount: provider.agentPaymentTransctionModel!.data!.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: grey[200],
                      ),
                      itemBuilder: (context, index) {
                        final transaction = provider.agentPaymentTransctionModel!.data![index];
                        return _buildTransactionItem(
                          transaction,
                          primaryColor: home2,
                          textColor: textColor,
                          secondaryTextColor: home1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
    required Color iconColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "₹$amount",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      AgentTransaction transaction, {
        required Color primaryColor,
        required Color textColor,
        required Color secondaryTextColor,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionHistoryPage(agentTransaction: transaction),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_rupee,
                  size: 24,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment from ${transaction.customerName ?? "Customer"}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatTimestamp(transaction.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "₹${transaction.linkAmount}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}