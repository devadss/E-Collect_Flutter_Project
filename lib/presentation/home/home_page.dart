import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection_qr_flutter/data/provider/link_transcation_history_provider.dart';
import 'package:collection_qr_flutter/presentation/trancstion/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../data/provider/agent_transaction_provider.dart';
import '../../data/provider/cash_transcation_history_provider.dart';
import '../../data/provider/collection_summary_provider.dart';
import '../../data/provider/fetch_account_balance_provider.dart';
import '../../data/provider/qr_transcation_history_provider.dart';
import '../../data/provider/transaction_provider.dart';
import '../../data/repository/cust_reg_repository.dart';
import '../../domain/model/link_transaction_history_model.dart';
import '../../domain/model/qr_transaction_history_model.dart';

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
  String? fd;
  String? td;
  String? agentOriginId;
  String? mobNum;
  String? subAgentID;
  bool? isBannerAvailable;
  int _selectedTabIndex = 0;
  final List<String> bannerImages = [
    "assets/images/collection_splash_screen.jpg",
    "assets/images/collection_splash_screen.jpg",
    "assets/images/doodle.jpeg",
  ];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<QRTransactionHistoryProvider>(context, listen: false);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // midnight today

    final fromDate = today.subtract(const Duration(days: 30));
    final toDate = today;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);

    provider.getQrTranscationHistory(
        "THIS_MONTH", formattedFdate, formattedTdate, "COLLECTION");

    loadSharedPrefs(context);
  }
  void showDateRangeFilter() {
    final qrProvider = context.read<QRTransactionHistoryProvider>();
    final cashTransProvider = context.read<CashTransactionHistoryProvider>();
    final linkProvider = context.read<LinkTransactionHistoryProvider>();

    DateTime? fromDate;
    DateTime? toDate;
    int selectedIndex = 0; // 0=Today,1=This Week,...4=Custom

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) {
              Widget buildDatePickers() {
                String fmt(DateTime d) => DateFormat.yMMMd().format(d);
                return Row(
                  children: [
                    Expanded(
                      child: _DatePickerButton(
                        label: fromDate != null ? fmt(fromDate!) : 'From',
                        icon: Icons.calendar_today_outlined,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fromDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => fromDate = picked);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerButton(
                        label: toDate != null ? fmt(toDate!) : 'To',
                        icon: Icons.calendar_today_outlined,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: toDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => toDate = picked);
                        },
                      ),
                    ),
                  ],
                );
              }

              bool isApplyEnabled = selectedIndex == 4 && fromDate != null && toDate != null;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    selectedIndex == 4?
                    Text('Select Date Range', style: Theme.of(context).textTheme.titleLarge):
                    Text('Select Filter type', style: Theme.of(context).textTheme.titleLarge)
                    ,
                    const SizedBox(height: 16),

                    // Tabs
                    ToggleButtons(
                      hoverColor: home2,
                      splashColor: home1.withOpacity(0.7),
                      fillColor: home1.withOpacity(0.1),
                      selectedBorderColor: home1,
                      isSelected: List.generate(5, (i) => i == selectedIndex),
                      onPressed: (i) => setState(() {
                        selectedIndex = i;
                        if (i != 4) {
                          fromDate = null;
                          toDate = null;
                        }
                      }),
                      borderRadius: BorderRadius.circular(8),
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Today', style: TextStyle(color: Colors.black),)),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('This Week',style: TextStyle(color: Colors.black))),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('This Month',style: TextStyle(color: Colors.black))),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Last Month',style: TextStyle(color: Colors.black))),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Custom',style: TextStyle(color: Colors.black))),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Only show date pickers for Custom
                    if (selectedIndex == 4) buildDatePickers(),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: home1,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48)),
                      onPressed: () async {
                        Navigator.pop(context);

                        late String period;
                        String from = '', to = '';

                        switch (selectedIndex) {
                          case 0:
                            period = 'TODAY';
                            DateTime now = DateTime.now();
                            final formatted = DateFormat('yyyy-MM-dd').format(now);
                            await qrProvider.getQrTranscationHistory(
                                period, formatted, formatted, 'COLLECTION');
                            await cashTransProvider.getCashTranscationHistory(
                                period, formatted, formatted, 'COLLECTION_CASH', subAgentID);
                            await linkProvider.getLinkTransactionHistory(
                                period, formatted, formatted, subAgentID!);
                            break;
                          case 1:
                            period = 'THIS_WEEK';
                            DateTime today = DateTime.now();
                            DateTime lastDate = today.add(const Duration(days: 7));

                            final formattedFdate = DateFormat('yyyy-MM-dd').format(today);
                            final formattedTdate = DateFormat('yyyy-MM-dd').format(lastDate);
                            await qrProvider.getQrTranscationHistory(
                                period, formattedFdate, formattedTdate, 'COLLECTION');
                            await cashTransProvider.getCashTranscationHistory(
                                period, formattedFdate, formattedTdate, 'COLLECTION_CASH', subAgentID);

                            await linkProvider.getLinkTransactionHistory(
                                period, formattedFdate, formattedTdate, subAgentID!);

                            break;
                          case 2:
                            period = 'THIS_MONTH';
                            final now = DateTime.now();
                            final today = DateTime(now.year, now.month, now.day); // midnight today

                            final fromDate = today.subtract(const Duration(days: 30));
                            final toDate = today;
                            final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
                            final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);
                            await qrProvider.getQrTranscationHistory(
                                period, formattedFdate, formattedTdate, 'COLLECTION');
                            await cashTransProvider.getCashTranscationHistory(
                                period, formattedFdate, formattedTdate, 'COLLECTION_CASH', subAgentID);

                            await linkProvider.getLinkTransactionHistory(
                                period, formattedFdate, formattedTdate, subAgentID!);

                            break;
                          case 3:
                            period = 'LAST_MONTH';
                            final today = DateTime.now();
                            final firstDayLastMonth = DateTime(today.year, today.month - 1, 1);
                            final lastDayLastMonth = DateTime(today.year, today.month, 1).subtract(const Duration(days: 1));

                            final formattedFdate = DateFormat('yyyy-MM-dd').format(firstDayLastMonth);
                            final formattedTdate = DateFormat('yyyy-MM-dd').format(lastDayLastMonth);
                            await qrProvider.getQrTranscationHistory(
                                period, formattedFdate, formattedTdate, 'COLLECTION');
                            await cashTransProvider.getCashTranscationHistory(
                                period, formattedFdate, formattedTdate, 'COLLECTION_CASH', subAgentID);

                            await linkProvider.getLinkTransactionHistory(
                                period, formattedFdate, formattedTdate, subAgentID!);

                            break;
                          case 4:
                            period = 'CUSTOM';
                            from = DateFormat('yyyy-MM-dd').format(fromDate!);
                            to = DateFormat('yyyy-MM-dd').format(toDate!);

                            await qrProvider.getQrTranscationHistory(
                                period, from, to, 'COLLECTION');
                            await cashTransProvider.getCashTranscationHistory(
                                period, from, to,'COLLECTION_CASH', subAgentID);

                            await linkProvider.getLinkTransactionHistory(
                                period, from, to, subAgentID!);
                            break;
                        }

                        await qrProvider.getQrTranscationHistory(period, from, to, 'COLLECTION');
                        await cashTransProvider.getCashTranscationHistory(
                            period, from, to,'COLLECTION_CASH', subAgentID);
                        await linkProvider.getLinkTransactionHistory(period, from, to, subAgentID!);
                      },
                      // only enable 'Apply Filter' if custom and dates selected
                      // Otherwise always enabled - you control logic separately
                      onLongPress: null,
                      child: Text(selectedIndex == 4 ? 'Apply Filter' : 'Apply'),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }





  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchBalance() async {
    final fetchBalanceProvider = Provider.of<BalanceProvider>(
      context,
      listen: false,
    );
    await fetchBalanceProvider.getFetchBalance(
      entityId.toString(),
      token.toString(),
    );
  }

  Future<void> fetchTransaction() async {
    final transProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    await transProvider.fetchTransaction(
      "",
      "",
      entityId.toString(),
      token.toString(),
    );
    final provider = Provider.of<AgentTransactionProvider>(
      context,
      listen: false,
    );
    await provider.getTransactions(token.toString());
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "Invalid Date";
    return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
  }

  Future<void> loadSharedPrefs(BuildContext context) async {
    final name = await SharedPref().getSubAgentName();
    final entId = await SharedPref().getAgentId();
    final tok = await SharedPref().getTokenValue();
    final agentOrgID = await SharedPref().getAgentOriginId();
    final mobnum = await SharedPref().getParentAgentMobNum();
    final subAgID = await SharedPref().getSubAgentId();

    if (mounted) {
      setState(() {
        userName = name;
        entityId = entId;
        token = tok;
        agentOriginId = agentOrgID;
        mobNum = mobnum;
        subAgentID = subAgID;
      });
    }
    final linkProvider = Provider.of<LinkTransactionHistoryProvider>(
      context,
      listen: false,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // midnight today

    final fromDate = today.subtract(const Duration(days: 30));
    final toDate = today;
    final formattedFdate = DateFormat('yyyy-MM-dd').format(fromDate);
    final formattedTdate = DateFormat('yyyy-MM-dd').format(toDate);
    await linkProvider.getLinkTransactionHistory(
        "THIS_MONTH", formattedFdate, formattedTdate, subAgentID!);

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
        formattedNumber = formattedNumber.substring(
          0,
          formattedNumber.length - 3,
        );
      } else if (formattedNumber.endsWith('0')) {
        formattedNumber = formattedNumber.substring(
          0,
          formattedNumber.length - 1,
        );
      }
    }

    return formattedNumber;
  }

  Widget buildShimmerText({
    String text = "Loading Balance.....",
    double fontSize = 16,
  }) {
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
                Container(width: 180, height: 20, color: white),
                Container(width: 24, height: 24, color: white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildShimmerSummaryCard(), _buildShimmerSummaryCard()],
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
                  title: Container(width: 120, height: 16, color: white),
                  subtitle: Container(width: 80, height: 12, color: white),
                  trailing: Container(width: 60, height: 16, color: white),
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
          Container(width: 24, height: 24, color: white),
          const SizedBox(height: 8),
          Container(width: 80, height: 16, color: white),
          const SizedBox(height: 4),
          Container(width: 60, height: 16, color: white),
        ],
      ),
    );
  }

  Future<void> fetchCollection() async {
    final provider = Provider.of<CollectionSummaryProvider>(
      context,
      listen: false,
    );
    provider.getCollectionSummary("AGT12345", "$startDate", "$endDate", token!);
  }

  @override
  Widget build(BuildContext context) {
    final qrProvider = Provider.of<QRTransactionHistoryProvider>(context);
    final cashTranProvider = Provider.of<CashTransactionHistoryProvider>(context);
    final linkProvider = Provider.of<LinkTransactionHistoryProvider>(context);
    final size = MediaQuery.of(context).size;
    const Color backgroundColor = Color(0xFFF5F5F5); // Light grey

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern header with glass morphism effect
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [home1, home2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: home1.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting with modern layout
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        userName?.replaceFirst(
                              userName![0],
                              userName![0].toUpperCase(),
                            ) ??
                            "",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Modern carousel with indicator
                  SizedBox(
                    height: size.height * 0.20,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              height: size.height * 0.18,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration: const Duration(
                                milliseconds: 800,
                              ),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentBannerIndex = index;
                                });
                              },
                            ),
                            items: bannerImages.map((imagePath) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      black.withOpacity(0.2),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // Modern dot indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerImages.asMap().entries.map((entry) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: _currentBannerIndex == entry.key ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentBannerIndex == entry.key
                                    ? white
                                    : white.withOpacity(0.5),
                                boxShadow: [
                                  if (_currentBannerIndex == entry.key)
                                    BoxShadow(
                                      color: white.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content with modern scrolling effect
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: home1, width: 1),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildTabButton(0, Icons.qr_code, "QR Code"),
                            _buildTabButton(1, Icons.monetization_on, "Cash"),
                            _buildTabButton(2, Icons.link, "Link"),

                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            print("Tapped");
                      showDateRangeFilter();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: home2, width: 2),
                                  color: home2),
                              child: const Center(
                                child: Text(
                                  "Filter",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IndexedStack(
                        index: _selectedTabIndex,
                        children: [
                          // QR Transactions
                          qrProvider.errResponse != null?
                          _buildQRTransactionList(
                            qrProvider.qrTranscationHistoryModel,"ERROR"
                          ):
                          _buildQRTransactionList(
                            qrProvider.qrTranscationHistoryModel,""
                          )
                          ,
                          cashTranProvider.errResponse != null?
                          _buildCashTransactionList(
                            cashTranProvider.qrTranscationHistoryModel, "ERROR"
                          ):
                          _buildCashTransactionList(
                              cashTranProvider.qrTranscationHistoryModel, ""
                          ) ,

                          // Link Transactions
                          linkProvider.erResposne != null?
                          _buildLinkTransactionList(
                              linkProvider.linkTranscationHistoryModel, "ERROR"
                          ):
                          _buildLinkTransactionList(
                            linkProvider.linkTranscationHistoryModel,""
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRTransactionList(QrTranscationHistoryModel? qrTransactions,
      String? error)
  {
    if (qrTransactions == null && error == "") {

      return const Center(child: CircularProgressIndicator());
    }else if(
    qrTransactions == null && error == "ERROR"
    ){
      return _buildEmptyState(
        icon: Icons.qr_code,
        title: "No QR Transactions",
        message: "Your payment Qr transactions will appear here",
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: qrTransactions?.data!.length,
        itemBuilder: (context, index) {
          final transaction = qrTransactions!.data![index];
          return _buildQRTransactionItem(transaction);
        },
      ),
    );
  }
  Widget _buildCashTransactionList(QrTranscationHistoryModel? qrTransactions,
      String? error)
  {
    if (qrTransactions == null && error == "") {

      return const Center(child: CircularProgressIndicator());
    }else if(
    qrTransactions == null && error == "ERROR"
    ){
      return _buildEmptyState(
        icon: Icons.qr_code,
        title: "No QR Transactions",
        message: "Your payment Qr transactions will appear here",
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: qrTransactions?.data!.length,
        itemBuilder: (context, index) {
          final transaction = qrTransactions!.data![index];
          return _buildQRTransactionItem(transaction);
        },
      ),
    );
  }


  // Widget _buildCashTransactionList(
  //     CashTranscation? cashTranscation, String? errMsg)
  // {
  //   if (cashTranscation == null && errMsg == "") {
  //     return const Center(child: CircularProgressIndicator());
  //   }else if(cashTranscation == null &&errMsg == "ERROR"){
  //     return _buildEmptyState(
  //       icon: Icons.monetization_on_outlined,
  //       title: "No Cash Transactions",
  //       message: "Your payment cash transactions will appear here",
  //     );
  //   }
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height * 0.9,
  //     child: ListView.builder(
  //       padding: const EdgeInsets.symmetric(vertical: 8),
  //       itemCount: cashTranscation!. data!.length,
  //       itemBuilder: (context, index) {
  //         final transaction = linkTransactions.data![index];
  //         return _buildLinkTransactionItem(transaction);
  //       },
  //     ),
  //   );
  //
  //
  // }

  Widget _buildLinkTransactionList(
      LinkTranscationHistoryModel? linkTransactions, String? errMsg)
  {
    if (linkTransactions == null && errMsg == "") {
      return const Center(child: CircularProgressIndicator());
    }else if(linkTransactions == null &&errMsg == "ERROR"){
      return _buildEmptyState(
        icon: Icons.link,
        title: "No Link Transactions",
        message: "Your payment link transactions will appear here",
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: linkTransactions!.data!.length,
        itemBuilder: (context, index) {
          final transaction = linkTransactions.data![index];
          return _buildLinkTransactionItem(transaction);
        },
      ),
    );


  }

  Widget _buildQRTransactionItem(QrTransaction transaction) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: home1, width: 1),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.25))
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.qr_code, color: Colors.pink),
        title: Text(
         // transaction.customerName.toString().replaceAll("CustomerName.", ""),
          transaction.customerName.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - hh:mm a')
              .format(transaction.createdAt ?? DateTime.now()),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹${transaction.orderAmount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Text(
              transaction.orderStatus
                  .toString(),
                // transaction.orderStatus
                //   .toString()
                //   .replaceAll("OrderStatus.", ""),
              style: const TextStyle(
                fontSize: 12,
                color: green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
          const TransactionDetailsPage()));
          // Navigate to transaction details
        },
      ),
    );
  }

  Widget _buildLinkTransactionItem(LinkTransactions transaction) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: home1, width: 1),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
                color: Colors.black.withOpacity(0.25))
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.link, color: Colors.blue),
        title: Text(
          transaction.customerName!.toString().replaceAll("CustomerName.", ""),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - hh:mm a')
              .format(transaction.createdAt ?? DateTime.now()),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "₹${transaction.linkAmount}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Text(
              transaction.linkStatus!
                  .toString()
                  .replaceAll("OrderStatus.", ""),
              style: const TextStyle(
                fontSize: 12,
                color: green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to transaction details
        },
      ),
    );
  }

  Widget _buildEmptyState(
      {required IconData icon,
      required String title,
      required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String text) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: _selectedTabIndex == index
              ? home2.withOpacity(0.3)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _selectedTabIndex == index ? home1 : black,
              size: 25,
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                  color: _selectedTabIndex == index ? home1 : black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
class _DatePickerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DatePickerButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
// Helper methods for building transaction lists

// @override
// Widget build(BuildContext context) {
//   final fetchBalanceProvider = Provider.of<BalanceProvider>(
//     context,
//     listen: true,
//   );
//   final provider = Provider.of<AgentTransactionProvider>(
//     context,
//     listen: true,
//   );
//   final size = MediaQuery.of(context).size;
//   final collectionProvider = Provider.of<CollectionSummaryProvider>(
//     context,
//     listen: false,
//   );
//
//   // Define the color theme
//   const Color primaryColor = deepTeal;
//   const Color secondaryColor = Color(0xFF4CAF50); // Green
//   const Color accentColor = Color(0xFFFF9800); // Orange
//   const Color backgroundColor = Color(0xFFF5F5F5); // Light grey
//   const Color cardColor = white;
//   const Color textColor = Color(0xFF333333);
//   const Color secondaryTextColor = Color(0xFF666666);
//
//   return Scaffold(
//     backgroundColor: backgroundColor,
//     body: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [home1, home2],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//             image: const DecorationImage(
//               image: AssetImage("assets/images/doodle.jpeg"),
//               fit: BoxFit.fitWidth,
//               opacity: 0.15,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20),
//                       Text(
//                         "Hello, ${userName?.replaceFirst(userName![0], userName![0].toUpperCase())}",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: white,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       provider.agentPaymentTransctionModel == null
//                           ? buildShimmerText(
//                             text: "Loading balance...",
//                             fontSize: 16,
//                           )
//                           : Text(
//                             "Your Balance ₹${fetchBalanceProvider.fetchBalanceModel?.result?.isNotEmpty == true ? addCommasToNumber(fetchBalanceProvider.fetchBalanceModel!.result![0].balance!.toDouble()) : '0.00'}",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w700,
//                               color: white,
//                             ),
//                           ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//
//               // Banner Carousel
//               Container(
//                 height: size.height * 0.18,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: CarouselSlider(
//                     carouselController: _carouselController,
//                     options: CarouselOptions(
//                       height: size.height * 0.18,
//                       autoPlay: true,
//                       enlargeCenterPage: true,
//                       viewportFraction: 1,
//                       autoPlayInterval: const Duration(seconds: 4),
//                       autoPlayAnimationDuration: const Duration(
//                         milliseconds: 800,
//                       ),
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           _currentBannerIndex = index;
//                         });
//                       },
//                     ),
//                     items:
//                         bannerImages.map((imagePath) {
//                           return Image.asset(
//                             imagePath,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           );
//                         }).toList(),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:
//                     bannerImages.asMap().entries.map((entry) {
//                       return GestureDetector(
//                         onTap:
//                             () =>
//                                 _carouselController.animateToPage(entry.key),
//                         child: Container(
//                           width: 8,
//                           height: 8,
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color:
//                                 _currentBannerIndex == entry.key
//                                     ? white
//                                     : white.withOpacity(0.4),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ],
//           ),
//         ),
//
//         // Main Content
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Transaction History",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => _selectDateRange(context),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: cardColor,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: primaryColor.withOpacity(0.2),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: textColor,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Icon(
//                               Icons.calendar_today,
//                               size: 18,
//                               color: home1,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Summary Cards
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildSummaryCard(
//                       icon: Icons.send,
//                       title: "Initiated",
//                       amount:
//                           "${collectionProvider.collectionSummaryModel?.data?[0].pendingCollections ?? "0"}",
//                       color: accentColor,
//                       iconColor: accentColor,
//                       textColor: textColor,
//                     ),
//                     _buildSummaryCard(
//                       icon: Icons.currency_rupee,
//                       title: "Received",
//                       amount:
//                           "${collectionProvider.collectionSummaryModel?.data?[0].totalCollected ?? "0"}",
//                       color: secondaryColor,
//                       iconColor: secondaryColor,
//                       textColor: textColor,
//                     ),
//                   ],
//                 ),
//                 // Transaction List
//                 Expanded(
//                   child:
//                       provider.agentPaymentTransctionModel == null
//                           ? buildShimmerList()
//                           : ListView.separated(
//                             itemCount:
//                                 provider
//                                     .agentPaymentTransctionModel!
//                                     .data!
//                                     .length,
//                             separatorBuilder:
//                                 (_, __) =>
//                                     Divider(height: 1, color: grey[200]),
//                             itemBuilder: (context, index) {
//                               final transaction =
//                                   provider
//                                       .agentPaymentTransctionModel!
//                                       .data![index];
//                               return _buildTransactionItem(
//                                 transaction,
//                                 primaryColor: home2,
//                                 textColor: textColor,
//                                 secondaryTextColor: home1,
//                               );
//                             },
//                           ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildSummaryCard({
//   required IconData icon,
//   required String title,
//   required String amount,
//   required Color color,
//   required Color iconColor,
//   required Color textColor,
// }) {
//   return Expanded(
//     child: Container(
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, size: 20, color: iconColor),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "₹$amount",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _buildTransactionItem(
//   AgentTransaction transaction, {
//   required Color primaryColor,
//   required Color textColor,
//   required Color secondaryTextColor,
// }) {
//   return InkWell(
//     borderRadius: BorderRadius.circular(12),
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) =>
//                   TransactionHistoryPage(agentTransaction: transaction),
//         ),
//       );
//     },
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.currency_rupee,
//                 size: 24,
//                 color: primaryColor,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Payment from ${transaction.customerName ?? "Customer"}",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     formatTimestamp(transaction.createdAt),
//                     style: TextStyle(fontSize: 12, color: secondaryTextColor),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               "₹${transaction.linkAmount}",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: primaryColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// Date range selector with modern design
// Container(
//   padding: const EdgeInsets.symmetric(vertical: 8),
//   decoration: BoxDecoration(
//     color: cardColor,
//     borderRadius: BorderRadius.circular(15),
//     boxShadow: [
//       BoxShadow(
//         color: black.withOpacity(0.05),
//         blurRadius: 10,
//         offset: const Offset(0, 4),
//       ),
//     ],
//   ),
//   child: ListTile(
//     onTap: () => _selectDateRange(context),
//     leading: Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: home1.withOpacity(0.1),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         Icons.calendar_today,
//         color: home1,
//         size: 20,
//       ),
//     ),
//     title: Text(
//       "Transaction History",
//       style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: textColor,
//       ),
//     ),
//     subtitle: Text(
//       "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}",
//       style: TextStyle(
//         fontSize: 14,
//         color: secondaryTextColor,
//       ),
//     ),
//     trailing: Icon(
//       Icons.chevron_right,
//       color: secondaryTextColor,
//     ),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(15),
//     ),
//   ),
// ),
// const SizedBox(height: 20),
// Tab bar for QR Code and Link transactions
// final fetchBalanceProvider = Provider.of<BalanceProvider>(
//   context,
//   listen: true,
// );
// final provider = Provider.of<AgentTransactionProvider>(
//   context,
//   listen: true,
// );
// final collectionProvider = Provider.of<CollectionSummaryProvider>(
//   context,
//   listen: false,
// );
// Define the color theme (same as original)
// const Color cardColor = white;
// const Color textColor = Color(0xFF333333);
// const Color secondaryTextColor = Color(0xFF666666);