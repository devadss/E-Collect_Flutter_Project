import 'dart:async';
import 'package:collection_qr_flutter/data/provider/cash_transcation_provider.dart';
import 'package:collection_qr_flutter/data/provider/rdcl_due_under_agent_provider.dart';
import 'package:collection_qr_flutter/domain/model/due_model/rdcl_due_under_agent_model.dart';
import 'package:collection_qr_flutter/presentation/dues/widgets/new_qr_code_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:pager/pager.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/alerts.dart';
import '../../core/colors.dart';
import '../../data/repository/payment_link_repository.dart';
import '../../data/repository/payment_session_id_repository.dart';
import '../../data/storage/shared_pref_helper.dart';
import '../../domain/model/account_list_model.dart';
import '../../domain/model/cash_transcation_model.dart';
import '../profile/widgets/recipect_page.dart';

class RdclDuesHomePage extends StatefulWidget {
  const RdclDuesHomePage({super.key});

  @override
  State<RdclDuesHomePage> createState() => _DuesHomePageState();
}

class _DuesHomePageState extends State<RdclDuesHomePage>
    with TickerProviderStateMixin {
  final Map<String, Map<int, bool>> _checkboxStates = {};
  String? _expandedAccNo;
  String? token;
  String? agentOriginId;
  String? agentId;
  String? selectedFilterType;
  String? subagentId;
  RdclCustomerListModel? _rdclCustomerListModel;
  String? agentPhoneNumber;
  String? subagentPhoneNumber;
  String? agentName;
  String? agentEmail;
  String? corpCode;
  String? branchCode;
  final GlobalKey _filterIconKey = GlobalKey();
  String? agentBranchCode;
  String? subAgentCodeNew;
  Timer? _debounce; // Declare this at the class level

  String? paymentSessionId;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();
  final bool _isLoading = false;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  double totalListCount = 0;
  double? totalListCountNew;
  int itemPerPage = 50;

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _fadeController.forward();
        _scaleController.forward();
      } else {
        _fadeController.reverse();
        _scaleController.reverse();
      }

      // Debounce the API call
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 900), () async {
        final searchText = _searchController.text.trim();
        if (searchText.isNotEmpty) {
          showProgressDialog(context);
         await doSearchByApi(searchText);
        } else {
          final providerTwo =
              Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
          await providerTwo.getRdclDueList(
              "", agentBranchCode!, "", _currentPage, itemPerPage, "");
        }
      });
    });
  }
  String _getBankNameFromCorpCode(String corpCode) {
    // Map corpcode to bank name
    final Map<String, String> corpCodeToBankName = {
      "BNKKRMR": "KURUMATHUR SERVICE CO OPERATIVE BANK LTD",
      "BNKPDVR": "PIDAVOOR SCB",
      "BNKKNPRM": "Kannapuram SCB",
      "BNKTRK": "Thrikkakkara SCB",
      "BNKKVRY": "KOOVERY SERVICE CO OPERATIVE BANK LTD",
      "BNKKPM": "Kaipamangalam SCB",
      "BNKKPMF": "Kaipamangalam Fisherman SCB",
      "BNKPRK": "Peringottukara SCB",
      "BNKPYPL": "POOYAPALLY SCB",
      "BNKVLMK": "VELIMUKKU SCB",
      "BNKPLKL": "PALLICKAL SCB",
      "BNKCRKT": "CHERUKALATHUR SCB",
      "BNKCLNR": "CHELANNUR SERVICE CO OPERATIVE BANK",
      "BNKPPNS": "Pappinissery Rural Bank",
      "BNKELYR": "ELAYAVOOR SERVICE CO OPERATIVE BANK LTD",
      "BNKKTM": "KOTTAYAM SERVICE CO OPERATIVE BANK LTD",
      "BNKAVN": "Avinissery SCB",
      "BNKDMDM": "DHARMADAM SERVICE CO OPERATIVE BANK LTD",
      "BNKPTVM": "PATTUVAM SERVICE CO OPERATIVE BANK",
      "BNKKUTGM": "KUTTUMUGHAM SERVICE CO OPERATIVE BANK LTD",
      "BNKERKT": "ERAMAM KUTTUR SERVICE CO OPERATIVE BANK LTD",
      "BNKKDKD": "KODAKKAD SERVICE CO OPERATIVE BANK LTD",
      "BNKPMP": "PMP SERVICE CO OPERATIVE BANK",
      "BNKSKMB": "SRI KAMBILAYA MUTUAL NIDHI LIMITED",
      "BNKTSSCB": "Thuravoor South SCB",
      "BNKVBGR": "VIBGYOR NIDHI LIMITED",
      "BNKPPL": "PERUMPILLY SCB",
      "BNKKTRM": "KAITHARAM SCB",
      "BNKKZPL": "KUZHUPPILLY SCB",
      "BNKNABL": "NAYARAMBALAM SCB",
      "BNKELR": "ELOOR SCB",
      "BNKERYD": "ERIYAD SCB",
      "BNKPYVR": "PAYYAVOOR SCB",
      "BNKVDKRA": "VADAKKEKKARA SCB",
      "BNKPRVR": "PARAVUR SCB",
      "BNKVLLR": "Velloor Service Co Operative Bank",
      "BNKMANK": "Manakunnam SCB",
      "BNKAZKD": "AZHIKODE SCB",
      "BNKTHRNL": "Thirunaloor SCB",
      "BNKVDYR": "VADAYAR",
      "BNKKDKPL": "KADAKKARAPALLY SCB",
      "BNKUCMSA": "URBAN CARE MULTI STATE AGRO CSL",
      "BNKKKYR": "KOKKAYAR SCB",
      "BNKMFF": "MILK FARMERS AND FISHERIES",
      "BNKCORDL": "Cordial Gramin Development Foundation",
      "BNKCHLVR": "CHELAVUR SCB",
      "BNKVRND": "VARANAD SCB",
      "BNKVBGRK": "VIBGYOR NIDHI LIMITED KOOTTILANGADI",
      "BNKKNKRA": "KUNNUKARA SCB",
      "BNKEDVNKD": "EDAVANAKKAD",
      "BNKKRDM": "KARTHEDOM SCB",
      "BNKAROOR": "AROOR SCB",
      "BNKGMSA": "Gramin Multi State Agro Co Operative Society Ltd",
      "BNKICCSL": "Indian Cooperative Credit Society Limited",
      "BNKNNDR": "Neendoor scb",
      "BNKCOB": "Co operative bhavan",
      "BNKCHMG": "Chathamangalam SCB",
      "BNKCXTX": "COXTAX",
      "BNKORNTL": "ORIENTAL AGRO MULTISTATE CO OP SOCIETY",
      "BNKTSRA": "Thushara Nidhi",
      "BNKPRTR": "PURATHUR SCB",
      "BNKCLBT": "CLUB T",
      "BNKPNP": "Pearls N Petals",
      "BNKVLKD": "Vellarkkad SCB",
      "BNKMDS": "Medi Soft",
      "BNKPLSCB": "Pulakode service cooperative Bank",
      "BNKMNCHL": "MEENACHIL SCB",
      "BNKOMSRY": "Omassery SCB",
      "BNKPTKL": "Pothukal SCB",
      "BNKFPMC": "FAPMCO MSCS",
      "BNKMULKD": "Mullakkodi Co-operative Bank",
    };

    // Return the bank name if found, otherwise return a default value
    return corpCodeToBankName[corpCode] ?? "Unknown Bank";
  }
  @override
  void dispose() {
    _fadeController.dispose();
    _searchFocusNode.dispose();
    _scaleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  //THE SEARCH IS DONE IF THE CUSTOMER IS NOT FOUND IN THE CURRENT LANDING PAGE...
  Future<void> doSearchByApi(String custNameSearch) async {
    print("Inside doSearchByApi");
    //showProgressDialog(context);
    final providerTwo =
        Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
    await providerTwo.getRdclDueList(
        "", agentBranchCode!, "", 0, 0, custNameSearch);
    if(providerTwo.rdclDueUnderAgentModel != null){
      Navigator.pop(context);
    }
  }

  List<dynamic> _filterDues(List<dynamic> allDues, String query) {
    if (query.isEmpty) return allDues;

    return allDues.where((due) {
      final accNo = due.accNo?.toLowerCase() ?? '';
      final name = due.name?.toLowerCase() ?? '';
      final custId = due.custId?.toLowerCase() ?? '';
      final openDate = due.openDate?.toLowerCase() ?? '';

      return accNo.contains(query.toLowerCase()) ||
          name.contains(query.toLowerCase()) ||
          custId.contains(query.toLowerCase()) ||
          openDate.contains(query.toLowerCase());
    }).toList();
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: home2),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> loadSharedPrefs() async {
    final name = await SharedPref().getParentAgentName();
    final id = await SharedPref().getAgentId();
    final originId = await SharedPref().getSubAgentCode();
    final subAgentID = await SharedPref().getSubAgentId();
    final code = await SharedPref().getCorpCode();
    final brCode = await SharedPref().getBranchCode();
    final email = await SharedPref().getEmail();
    final number = await SharedPref().getParentAgentMobNum();
    final tok = await SharedPref().getTokenValue();
    final sub_AgentCodeNew = await SharedPref().getSubAgentCodeNew();
    final subagentNum = await SharedPref().getSubAgentMobNum();
    if (mounted) {
      setState(() {
        subagentId = subAgentID;
        agentName = name;
        agentEmail = email;
        subagentPhoneNumber = subagentNum;
        agentId = id;
        agentOriginId = originId;
        corpCode = code;
        branchCode = brCode;
        agentPhoneNumber = number;
        token = tok;
        subAgentCodeNew = sub_AgentCodeNew;
      });
    }
    print("subagentId $subagentId");
    print("agentId $agentId");
    print("agentOriginId $agentOriginId");
    showProgressDialog(context);
    setState(() {
      agentBranchCode = subAgentCodeNew;
    });

    final providerTwo =
        Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
    await providerTwo.getRdclDueList(
        "", agentBranchCode!, "", _currentPage, itemPerPage, "");
    totalListCount = double.parse(
        providerTwo.rdclDueUnderAgentModel?.data[0].totalCount.toString()?? "");
    if(providerTwo.rdclDueUnderAgentModel == null && providerTwo.rdclDueUnderAgentError != null){
      showToast(message: providerTwo.rdclDueUnderAgentError.toString(), color: Colors.red);
    }
    if (totalListCount > 1) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
    setState(() {
      var result = totalListCount / itemPerPage.toDouble();
      result % 2 == 0
          ? totalListCountNew = result
          : totalListCountNew = result + 1;
    });

    print("totalListCount = $totalListCount");

    print("totalListCount = $totalListCountNew");
  }

  Future<void> getCashTrans(
      {required String? token,
      required String? customerName,
      required String? custPhoneNumber,
      required String? custAcNumber,
      required String? custId,
      required String? custEmail,
      required String? amount,
      required String? phoneNumber,
      required String? entityId,
      required String? note}) async
  {
    final cashPaymentProvider =
        Provider.of<CashTranscationProvider>(context, listen: false);
    final cash = await cashPaymentProvider.getTranscations(
        agentName: agentName,
        agentId: agentId,
        agentOriginId: agentOriginId,
        agentPhone: phoneNumber,
        agentEmail: agentEmail,
        subAgentId: subagentId,
        customerName: customerName,
        customerPhone: "",
        customerAccNo: custAcNumber,
        customerId: custId,
        customerEmail: "",
        amount: amount,
        note: note,
        corpCode: corpCode,
        cardRefNum: "",
        token: token,
        subagentBranchCode: subAgentCodeNew,
        branchCode: branchCode);
    cash.fold((err) {
      print("getCashTrans $err");
    }, (success) {
      print("getCashTrans $success");
      showDialog(
        context: context,
        builder: (context) => TransactionSuccessDialog(
          success: success,
          onViewReceipt: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
                  amount: success.amount.toString(),
                  bankName: _getBankNameFromCorpCode(corpCode!) ?? "XYZ BANK",
                  agentName: agentName ?? "Name",
                  agentPhone: agentPhoneNumber ?? "agentPhone",
                  custName: customerName!,
                  custPhone: custPhoneNumber!,
                  custId: custId!,
                  txnId: success.transactionId.toString(),
                  txnType: "CASH",
                ),
              ),
            );
          },
        ),
      );
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: const Text("Transaction Result"),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text("Status: ${success.status ?? 'N/A'}"),
      //           const SizedBox(height: 8),
      //           Text("Transaction ID: ${success.transactionId ?? 'N/A'}"),
      //           const SizedBox(height: 8),
      //           Text("Message: ${success.message ?? 'N/A'}"),
      //         ],
      //       ),
      //       actions: [
      //         TextButton(
      //
      //           onPressed: () => {Navigator.pop(context),
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => ReceiptPage(
      //               amount: success.amount.toString(),
      //               bankName: _getBankNameFromCorpCode(corpCode!)?? "XYZ BANK",
      //               agentName: agentName ?? "Name",
      //               agentPhone:
      //               agentPhoneNumber ?? "agentPhone",
      //               custName: customerName!,
      //               custPhone: custPhoneNumber!,
      //               custId: custId!, txnId: success.transactionId.toString(), txnType: "CASH",
      //             )))},
      //           child: const Text("OK"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    });
  }

  Future<void> getPaymentSessionId(
      {required String? token,
      required String? customerName,
      required String? custPhoneNumber,
      required String? custAcNumber,
      required String? custId,
      required String? custEmail,
      required String? amount,
      required String? phoneNumber,
      required String? entityId,
      required String? note,
      required String? subAgentBranchCode}) async {
    print("--------------------INSIDE getPaymentSessionId---------------------");
    print("--------------------TOKEN---------------------");
    print(token);
    print("---------------------AMOUNT--------------------");
    print(amount);
    print("---------------------PHONENUMBER--------------------");
    print(phoneNumber);
    print("---------------------ENTITYID--------------------");
    print(entityId);
    print("---------------------NOTE--------------------");
    print(note);
    final paymentSession = await CreatePaymentSessionIdRepository()
        .getPaymentSessionId(
            agentOriginId: agentOriginId,
            agentEmail: agentEmail,
            customerName: customerName,
            customerPhone: custPhoneNumber,
            customerAccno: custAcNumber,
            customerId: custId,
            customerEmail: custEmail,
            corpCode: corpCode,
            cardRefNum: "",
            token: token,
            amount: amount,
            agentPhone: agentPhoneNumber,
            agentId: agentId,
            note: "Payment For Agent $agentName",
            subAgentId: subagentId,
            agentName: agentName,
            subAgentBranchCode: subAgentBranchCode);
    paymentSession.fold((error) {
      print(
          "---------------------------------ERROR PAYMENT---------------------------");
      print(error);
    }, (sessionId) async {
      paymentSessionId = sessionId.paymentSessionId ?? "";
      if (paymentSessionId!.isNotEmpty &&
          paymentSessionId != null &&
          paymentSessionId != "") {
        if (!mounted) return;
        Navigator.pop(context);

        if (!mounted) return;
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewQrCodePage(
              paymentSessionId: paymentSessionId!,
              amount: amount ?? "",
              token: token!,
              custName: customerName ?? "custName",
              custPhone: custPhoneNumber ?? "custNumber",
              custId: custId ?? "CustId",
            ),
          ),
        );
        if (!mounted) return;
        if (result == "fetch_balance") {
          // Navigator.pop(context);
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);

        showToast(message: "Session id is null", color: black);
      }
    });
  }

  Widget buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer.fromColors(
              baseColor: grey[300]!,
              highlightColor: grey[100]!,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: white,
                  border: Border.all(color: grey[300]!, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: black45,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildShimmerText(width: 150), // Name
                      const SizedBox(height: 10),
                      buildShimmerText(width: 100), // Customer ID
                      const SizedBox(height: 10),
                      buildShimmerText(width: 180), // Account Number
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildShimmerText({
    double width = double.infinity,
    double height = 16,
  }) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500), // Ensures smooth animation
      baseColor: grey[300]!,
      highlightColor: grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Future<void> _clearSearch() async {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "RDCL Due List",
            style: TextStyle(
              fontSize: 23,
              color: home2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: home2.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isSearchFocused = hasFocus;
                      });
                    },
                    child:
                        // TextField(
                        //   controller: _searchController,
                        //   decoration: InputDecoration(
                        //     hintText: 'Search accounts...',
                        //     hintStyle: TextStyle(
                        //       color: Colors.grey[600],
                        //       fontSize: 14,
                        //     ),
                        //     prefixIcon: AnimatedSwitcher(
                        //       duration: const Duration(milliseconds: 300),
                        //       child: _isSearchFocused
                        //           ? const Icon(Icons.search, color: home2, size: 24)
                        //           : Icon(
                        //               Icons.search_rounded,
                        //               color: home2.withOpacity(0.7),
                        //               size: 24,
                        //             ),
                        //     ),
                        //     suffixIcon: _searchController.text.isNotEmpty
                        //         ? FadeTransition(
                        //             opacity: _fadeAnimation,
                        //             child: ScaleTransition(
                        //               scale: _scaleAnimation,
                        //               child: IconButton(
                        //                 icon: const Icon(Icons.close, color: home2),
                        //                 onPressed: _clearSearch,
                        //               ),
                        //             ),
                        //           )
                        //         : AnimatedSwitcher(
                        //             duration: const Duration(milliseconds: 300),
                        //             child: _isSearchFocused
                        //                 ? IconButton(
                        //                     icon: const Icon(Icons.tune_rounded,
                        //                         color: home2),
                        //                     onPressed: () {},
                        //                   )
                        //                 : const SizedBox.shrink(),
                        //           ),
                        //     border: InputBorder.none,
                        //     contentPadding:
                        //         const EdgeInsets.symmetric(vertical: 18),
                        //   ),
                        //   style: const TextStyle(
                        //     color: Colors.black87,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        //   onChanged: (value) async {
                        //     _filterDues(provider.rdclDueUnderAgentModel!.data,value);
                        //     // if (value.length == 8) {
                        //     //   await _searchMethod(value);
                        //     // }
                        //   },
                        // ),
                        TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      // Add this focus node
                      decoration: InputDecoration(
                        hintText: 'Search accounts...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isSearchFocused
                              ? const Icon(Icons.search, color: home2, size: 24)
                              : Icon(
                                  Icons.search_rounded,
                                  color: home2.withOpacity(0.7),
                                  size: 24,
                                ),
                        ),
                        suffixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _searchController.text.isNotEmpty
                              ? FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.close, color: home2),
                                      onPressed: _clearSearch,
                                    ),
                                  ),
                                )
                              : _isSearchFocused
                                  ? IconButton(
                                      key: _filterIconKey,
                                      icon: const Icon(Icons.tune_rounded,
                                          color: home2),
                                      onPressed: () {
                                        final RenderBox renderBox =
                                            _filterIconKey.currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                        final Offset offset = renderBox
                                            .localToGlobal(Offset.zero);
                                        final Size size = renderBox.size;

                                        showMenu<String>(
                                          color: Colors.white,
                                          shadowColor: home1,
                                          requestFocus: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          menuPadding: const EdgeInsets.all(10),
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            offset.dx,
                                            offset.dy + size.height + 10,
                                            offset.dx + size.width,
                                            offset.dy,
                                          ),
                                          items: [
                                            PopupMenuItem<String>(
                                              value: 'agent',
                                              child: Text(
                                                'Filter by Agent',
                                                style: TextStyle(
                                                    color: selectedFilterType !=
                                                            "agentid"
                                                        ? Colors.black
                                                        : home1),
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'branch',
                                              child: Text('Filter by Branch',
                                                  style: TextStyle(
                                                      color:
                                                          selectedFilterType !=
                                                                  "branchid"
                                                              ? Colors.black
                                                              : home1)),
                                            ),
                                          ],
                                        ).then((value) async {
                                          if (value == 'agent') {
                                            setState(() {
                                              selectedFilterType = "agentid";
                                            });

                                            print("Filter by Agent ID");
                                            showProgressDialog(context);
                                            await provider.getRdclDueList(
                                                agentOriginId!,
                                                "",
                                                "",
                                                _currentPage,
                                                itemPerPage,
                                                "");
                                            _filterDues(
                                                provider.rdclDueUnderAgentModel!
                                                    .data,
                                                "");
                                            Navigator.pop(context);
                                          } else if (value == 'branch') {
                                            setState(() {
                                              selectedFilterType = "branchid";
                                            });
                                            print("Filter by Branch ID");
                                            showProgressDialog(context);

                                            await provider.getRdclDueList(
                                                "",
                                                agentBranchCode.toString(),
                                                "",
                                                _currentPage,
                                                itemPerPage,
                                                "");
                                            _filterDues(
                                                provider.rdclDueUnderAgentModel!
                                                    .data,
                                                "");
                                            if (mounted) {
                                              Navigator.pop(context);
                                            }
                                          }
                                        });
                                      },
                                    )
                                  : const SizedBox.shrink(),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 18),
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) async {
                        _filterDues(
                            provider.rdclDueUnderAgentModel!.data, value);
                      },
                      onTap: () {
                        setState(() {
                          _isSearchFocused = true;
                        });
                      },
                    ),
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<RdclDueUnderAgentProvider>(
              builder: (context, provider, child) {
                final data = provider.rdclDueUnderAgentModel?.data ?? [];
                final filteredData = _filterDues(data, _searchController.text);

                if (provider.rdclDueUnderAgentModel == null) {
                  return buildShimmerList();
                } else if (filteredData.isEmpty) {
                  return const Text("No data found");
                  // doSearchByApi(_searchController.text);
                }

                final groupedData = <String, List<dynamic>>{};
                for (var due in filteredData) {
                  groupedData.putIfAbsent(due.accNo, () => []).add(due);
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: groupedData.keys.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final accNo = groupedData.keys.elementAt(index);
                    final dues = groupedData[accNo]!;
                    final totalDue = dues.fold<num>(
                      0,
                      (sum, item) => sum + (item.dueAmount ?? 0),
                    );

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: white,
                        border: Border.all(
                            color: home2.withOpacity(0.7), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            color: black.withOpacity(0.08),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: transparent,
                          highlightColor: transparent,
                          dividerColor: transparent,
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedAccNo = expanded ? accNo : null;
                            });
                          },
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Number",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                accNo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: home1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    size: 18,
                                    color: black87,
                                  ),
                                  Text(
                                    "Total Due: ₹$totalDue",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: dues.asMap().entries.map((entry) {
                            final dueIndex = entry.key;
                            final due = entry.value;

                              print("due values : ${due}");


                            _checkboxStates.putIfAbsent(accNo, () => {});
                            _checkboxStates[accNo]!.putIfAbsent(
                              dueIndex,
                              () => false,
                            );

                            final isEnabled = _expandedAccNo == null ||
                                _expandedAccNo == accNo;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _checkboxStates[accNo]![dueIndex],
                                    onChanged: isEnabled
                                        ? (bool? value) {
                                            setState(() {
                                              // Uncheck all other account numbers
                                              _checkboxStates.forEach((
                                                key,
                                                map,
                                              ) {
                                                if (key != accNo) {
                                                  map.updateAll(
                                                    (_, __) => false,
                                                  );
                                                }
                                              });

                                              // Update current checkbox state
                                              _checkboxStates[accNo]![
                                                  dueIndex] = value ?? false;
                                              _expandedAccNo = accNo;
                                            });

                                            // Calculate the selected amount only for current group
                                            num modalSelectedAmount = 0;
                                            final map = _checkboxStates[accNo];
                                            if (map != null) {
                                              map.forEach((i, isChecked) {
                                                if (isChecked) {
                                                  modalSelectedAmount +=
                                                      dues[i].installAmt ?? 0;
                                                }
                                              });
                                            }

                                            final hasAnyChecked =
                                                modalSelectedAmount > 0;

                                            if (!hasAnyChecked) return;

                                            final controller =
                                                TextEditingController(
                                              text: modalSelectedAmount
                                                  .toStringAsFixed(2),
                                            );

                                            String selectedMethod =
                                                // "Link"; // Default selection
                                                "Cash"; // Default selection

                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(
                                                    20,
                                                  ),
                                                ),
                                              ),
                                              backgroundColor: white,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (
                                                    context,
                                                    setModalState,
                                                  ) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 20,
                                                        left: 20,
                                                        right: 20,
                                                        bottom: MediaQuery.of(
                                                              context,
                                                            )
                                                                .viewInsets
                                                                .bottom +
                                                            20,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  height: 60,
                                                                  width: 60,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      10,
                                                                    ),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color:
                                                                          black54,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      // selectedMethod == "Link"
                                                                      //     ? Image.asset(
                                                                      //         "assets/icons/web-link.png",
                                                                      //         scale:
                                                                      //             12,
                                                                      //         color:
                                                                      //             home2,
                                                                      //       )
                                                                      //            :
                                                                      selectedMethod ==
                                                                              "QR Code"
                                                                          ? Image
                                                                              .asset(
                                                                              "assets/icons/qr-code.png",
                                                                              scale: 12,
                                                                              color: home2,
                                                                            )
                                                                          : Image
                                                                              .asset(
                                                                              "assets/images/rupee_6414183.png",
                                                                              scale: 10,
                                                                            ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      FittedBox(
                                                                        fit:BoxFit.scaleDown,
                                                                        child: Text(
                                                                          "Collect Payment Using",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts
                                                                              .inter(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                black87,
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        selectedMethod,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              black,
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              24),
                                                                        ),
                                                                      ),
                                                                      builder:
                                                                          (ctx) =>
                                                                              Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                16),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            // drag handle
                                                                            Container(
                                                                              width: 40,
                                                                              height: 5,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey.shade300,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 16),
                                                                            // ListTile(
                                                                            //   leading: const Icon(Icons.link, color: Colors.blueAccent),
                                                                            //   title: const Text(
                                                                            //     "Link",
                                                                            //     style: TextStyle(
                                                                            //       fontWeight: FontWeight.w600,
                                                                            //       fontSize: 16,
                                                                            //     ),
                                                                            //   ),
                                                                            //   trailing: const Icon(Icons.chevron_right),
                                                                            //   onTap: () {
                                                                            //     setModalState(() => selectedMethod = "Link");
                                                                            //     Navigator.pop(ctx);
                                                                            //   },
                                                                            // ),
                                                                            const Divider(
                                                                                indent: 16,
                                                                                endIndent: 16),
                                                                            ListTile(
                                                                              leading: const Icon(Icons.qr_code, color: Colors.green),
                                                                              title: const Text(
                                                                                "QR Code",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                              trailing: const Icon(Icons.chevron_right),
                                                                              onTap: () {
                                                                                print("selected method = $selectedMethod");
                                                                                setModalState(() => selectedMethod = "QR Code");
                                                                                Navigator.pop(ctx);
                                                                              },
                                                                            ),
                                                                            const Divider(
                                                                                indent: 16,
                                                                                endIndent: 16),
                                                                            ListTile(
                                                                              leading: const Icon(Icons.money, color: Colors.deepOrange),
                                                                              title: const Text(
                                                                                "Cash",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                              trailing: const Icon(Icons.chevron_right),
                                                                              onTap: () {
                                                                                print("selected method = $selectedMethod");
                                                                                setModalState(() => selectedMethod = "Cash");
                                                                                Navigator.pop(ctx);
                                                                              },
                                                                            ),
                                                                            const SizedBox(height: 12),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child: Text(
                                                                      "Change Method >",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts
                                                                          .inter(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .underline,
                                                                        decorationColor:
                                                                            home2,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        color:
                                                                            home2,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            const FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child:  Text(
                                                                "Installment Details",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: home2,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Text(
                                                              "Open Date: ${due.openDate}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              // "Paid Installments: ${provider.rdclDueUnderAgentModel?.data[index].paidInstallments}",
                                                              "Paid Installments: ${due.paidInstallments}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "Edit Total Selected Amount",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    grey[800],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  controller,
                                                              keyboardType:
                                                                  const TextInputType
                                                                      .numberWithOptions(
                                                                decimal: true,
                                                                signed: true,
                                                              ),
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    home2,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10,
                                                                  ),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color:
                                                                        deepTeal,
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    10,
                                                                  ),
                                                                  borderSide:
                                                                      const BorderSide(
                                                                    color:
                                                                        deepTeal,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      14,
                                                                  vertical: 12,
                                                                ),
                                                                prefixIcon:
                                                                    const Icon(
                                                                  Icons
                                                                      .currency_rupee,
                                                                  color: white,
                                                                ),
                                                              ),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            CustomSliderButton(
                                                              token: token!,
                                                              label:
                                                                  "Slide to Collect Using $selectedMethod",
                                                              backgroundColor:
                                                                  home2,
                                                              buttonColor:
                                                                  Colors.white,
                                                                onConfirmed: () async {
                                                                  if (selectedMethod == "Cash") {
                                                                    bool confirmed = await paymentConfirmation(
                                                                      context,
                                                                      due.name,
                                                                      due.accNo,
                                                                      due.custId,

                                                                      controller.text,
                                                                    );

                                                                    if (!confirmed) {
                                                                      // User cancelled the confirmation
                                                                      return;
                                                                    }
                                                                  } else {
                                                                    print("Selected QR");
                                                                    // ✅ This runs only after confirmation (or if non-cash method)
                                                                    getPaymentSessionId(
                                                                      token: token,
                                                                      customerName: due.name,
                                                                      custPhoneNumber: "",
                                                                      custAcNumber: due.accNo,
                                                                      custId: due.custId,
                                                                      custEmail: "",
                                                                      phoneNumber: "$agentPhoneNumber",
                                                                      entityId: agentId,
                                                                      note: "Payment For Agent $agentName",
                                                                      amount: controller.text,
                                                                      subAgentBranchCode: subAgentCodeNew,
                                                                    );
                                                                  }


                                                                }

                                                              /*  onConfirmed:
                                                                  () async {
                                                                // selectedMethod ==
                                                                //         "Link"
                                                                //     ? sendLinkFunction(
                                                                //         provider.rdclDueUnderAgentModel!.data[
                                                                //             index],
                                                                //         controller
                                                                //             .text)
                                                                //     :

                                                                selectedMethod ==
                                                                            "Cash"
                                                                        ?
                                                                        paymentConfirmation(
                                                                            context,
                                                                            due
                                                                                .name,
                                                                            due
                                                                                .accNo,
                                                                            due
                                                                                .custId,
                                                                            controller
                                                                                .text)
                                                                        // getCashTrans(
                                                                        //             token:
                                                                        //                 token,
                                                                        //             //customerName: provider.rdclDueUnderAgentModel?.data[index].name,
                                                                        //             customerName:
                                                                        //                 due.name,
                                                                        //             custPhoneNumber:
                                                                        //                 "",
                                                                        //             // custAcNumber: provider.rdclDueUnderAgentModel?.data[index].accNo,
                                                                        //             custAcNumber:
                                                                        //                 due.accNo,
                                                                        //             //custId: provider.rdclDueUnderAgentModel?.data[index].custId,
                                                                        //             custId:
                                                                        //                 due.custId,
                                                                        //             custEmail:
                                                                        //                 "",
                                                                        //             phoneNumber:
                                                                        //                 "$agentPhoneNumber",
                                                                        //             entityId:
                                                                        //                 agentId,
                                                                        //             note:
                                                                        //                 "Payment For Agent $agentName",
                                                                        //             amount:
                                                                        //                 controller.text,
                                                                        //           )
                                                                        : print(
                                                                            "Selecetd QR");
                                                                getPaymentSessionId(
                                                                  token: token,
                                                                  // customerName: provider.rdclDueUnderAgentModel?.data[index].name,
                                                                  customerName:
                                                                      due.name,
                                                                  custPhoneNumber:
                                                                      "",
                                                                  //custAcNumber: provider.rdclDueUnderAgentModel?.data[index].accNo,
                                                                  custAcNumber:
                                                                      due.accNo,
                                                                  // custId: provider.rdclDueUnderAgentModel?.data[index].custId,
                                                                  custId: due
                                                                      .custId,
                                                                  custEmail: "",
                                                                  phoneNumber:
                                                                      "$agentPhoneNumber",
                                                                  entityId:
                                                                      agentId,
                                                                  note:
                                                                      "Payment For Agent $agentName",
                                                                  amount:
                                                                      controller
                                                                          .text,
                                                                  subAgentBranchCode:
                                                                      subAgentCodeNew,
                                                                );
                                                              },*/
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: home1,
                                          width: 1.5,
                                        ),
                                        color: grey[50],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Installment: ₹${due.installAmt}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            // "Name: ${provider.rdclDueUnderAgentModel!.data[index].name}",
                                            "Name: ${due.name ?? ''}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            //"Open Date: ${provider.rdclDueUnderAgentModel!.data[index].openDate}",
                                            "Open Date: ${due.openDate ?? ''}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            // "Paid Installemnts: ${provider.rdclDueUnderAgentModel!.data[index].paidInstallments}",
                                            "Paid Installemnts: ${due.paidInstallments ?? ''}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            //"DueInstallments: ${provider.rdclDueUnderAgentModel!.data[index].dueInstallments}",
                                            "DueInstallments: ${due.dueInstallments ?? ''}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            // "TotalInstallment: ${provider.rdclDueUnderAgentModel!.data[index].totalInstallment}",
                                            "TotalInstallment: ${due.totalInstallment ?? ''}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          totalListCountNew != null
              ? pagerWidget(totalListCountNew!.toInt())
              : pagerWidget(3),
        ],
      ),
    );
  }

  Container pagerWidget(int totPage) {
    final provider =
        Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: home2.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: home1.withOpacity(0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Pager(
          pageChangeIconColor: home1,
          currentPage: _currentPage,
          totalPages: totPage,
          numberTextSelectedColor: Colors.white,
          numberButtonSelectedColor: home1,
          pagesView: 4,
          currentItemsPerPage: 1,
          onPageChanged: (page) async {
            _searchController.clear();
            showProgressDialog(context);
            setState(() {
              print("page : $page");
              _currentPage = page;
            });
            await provider.getRdclDueList(
                "", agentBranchCode!, "", _currentPage, itemPerPage, "");
            if (provider.showDialog == false) {
              if (mounted) {
                Navigator.pop(context);
              }
            }

            // Optional: Scroll to top if you want user to see the beginning of the new data
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }

  Future<void> sendLinkFunction(
      RDCLDueAccount custDetails, String amount) async {
    if (agentName == null ||
        agentId == null ||
        agentOriginId == null ||
        token == null) {
      print("One or more required fields are null.");
      return; // or handle the error appropriately
    }

    final send = await PaymentLinkRepository().getPaymentLink(
        agentName: agentName!,
        agentId: agentId!,
        agentOriginId: agentOriginId!,
        agentPhone: agentPhoneNumber!,
        agentEmail: agentEmail!,
        customerEmail: "",
        customerPhone: agentPhoneNumber!,
        customerAccountNumber: custDetails.accNo,
        customerId: custDetails.custId,
        linkAmount: num.parse(amount),
        note: "Payment for Order #1234",
        corpCode: corpCode!,
        cardRefNum: "",
        token: token!,
        subAgentId: subagentId!,
        customerName: custDetails.name);
    send.fold(
      (error) {
        print("-------------------ERROR---------------------");
        print(error);
      },
      (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          Share.share("Here is your payment link: ${sendLink.linkUrl}");
        } else {
          print("Payment link is empty or null");
        }
      },
    );
  }
  Future<bool> paymentConfirmation(
      BuildContext context,
      String name,
      String accNo,
      String custId,
      String amt,
      ) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Payment Confirmation",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Do you wish to proceed with the payment?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false); // 🚫 User said NO
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: home1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: white,
                        ),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(
                            color: home1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          getCashTrans(
                            token: token,
                            customerName: name,
                            custPhoneNumber: "",
                            custAcNumber: accNo,
                            custId: custId,
                            custEmail: "",
                            phoneNumber: "$agentPhoneNumber",
                            entityId: agentId,
                            note: "Payment For Agent $agentName",
                            amount: amt,
                          );
                          Navigator.pop(context, true); // ✅ User confirmed
                          Navigator.pop(context, true); // ✅ User confirmed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontWeight: FontWeight.w500,
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
    ).then((value) => value ?? false); // default to false if dismissed
  }
}

//   Future<void> paymentConfirmation(
//     BuildContext context,
//     String name,
//     String accNo,
//     String custId,
//     String amt,
//   ) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Animated icon
//                 TweenAnimationBuilder(
//                   duration: const Duration(milliseconds: 500),
//                   tween: Tween<double>(begin: 0, end: 1),
//                   builder: (context, value, child) {
//                     return Transform.scale(scale: value, child: child);
//                   },
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.redAccent.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     // child: Lottie.asset("assets/animations/logout.json"),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 Text(
//                   "Payment Confirmation",
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Do you wish to proceed with the payment ?",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 Row(
//                   children: [
//                     // Cancel button
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () =>{},
//                             //Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           side: const BorderSide(color: home1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           backgroundColor: white,
//                         ),
//                         child: Text(
//                           "No",
//                           style: GoogleFonts.poppins(
//                             color: home1,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//
//                     // Logout button
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           getCashTrans(
//                             token: token,
//                             customerName: name,
//                             custPhoneNumber: "",
//                             custAcNumber: accNo,
//                             custId: custId,
//                             custEmail: "",
//                             phoneNumber: "$agentPhoneNumber",
//                             entityId: agentId,
//                             note: "Payment For Agent $agentName",
//                             amount: amt,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.redAccent,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: Text(
//                           "Yes",
//                           style: GoogleFonts.poppins(
//                             color: white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class CustomSliderButton extends StatefulWidget {
  final Future<void> Function() onConfirmed;
  final String label;
  final Color backgroundColor;
  final Color buttonColor;
  final String token;

  const CustomSliderButton({
    super.key,
    required this.onConfirmed,
    required this.label,
    required this.backgroundColor,
    required this.buttonColor,
    required this.token,
  });

  @override
  State<CustomSliderButton> createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;

    return Container(
      width: width,
      height: 70,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: widget.buttonColor.withOpacity(0.25),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragPosition += details.delta.dx;
                  _dragPosition = _dragPosition.clamp(0.0, width - 70);
                });
              },
              onHorizontalDragEnd: (_) async {
                if (_dragPosition > (width - 70) * 0.5) {
                  setState(() {
                    _isConfirmed = true;
                    _dragPosition = width - 70;
                  });

                  await widget.onConfirmed();

                  setState(() {
                    _dragPosition = 0.0;
                    _isConfirmed = false;
                  });
                } else {
                  setState(() {
                    _dragPosition = 0.0;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    transitionBuilder: (child, animation) => RotationTransition(
                      turns: Tween(
                        begin: 0.75,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                    child: Image.asset(
                      "assets/icons/arrow.png",
                      key: const ValueKey('arrow-icon'),
                      scale: 20,
                      color: home2,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShakeTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const ShakeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.offset = 10,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value * offset * math.sin(value * math.pi * 2),
            0,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class BounceTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const BounceTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}


class TransactionSuccessDialog extends StatelessWidget {
  final CashTranscation success;
  final VoidCallback onViewReceipt;

  const TransactionSuccessDialog({
    Key? key,
    required this.success,
    required this.onViewReceipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            _buildHeader(context),
            const SizedBox(height: 24),

            // Transaction Details
            _buildTransactionDetails(),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Transaction Completed",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(
          label: "Status",
          value: success.status ?? 'N/A',
          valueColor: _getStatusColor(success.status),
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          label: "Transaction ID",
          value: success.transactionId ?? 'N/A',
          isImportant: true,
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          label: "Message",
          value: success.message ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required String label,
    required String value,
    Color? valueColor,
    bool isImportant = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isImportant ? FontWeight.w600 : FontWeight.w400,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "CLOSE",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onViewReceipt,
            style: ElevatedButton.styleFrom(
              backgroundColor: home1,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "VIEW RECEIPT",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/*      Expanded(
            child: Consumer<RdclDueUnderAgentProvider>(
              builder: (context, provider, child) {
                final allData = provider.rdclDueUnderAgentModel?.data ?? [];
                final filteredData = _filterDues(allData, _searchController.text);

                if (provider.rdclDueUnderAgentModel == null) {
                  return buildShimmerList();
                }
                else if (filteredData.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? "No data found"
                          : "No results found for '${_searchController.text}'",
                      style: TextStyle(color: grey[600]),
                    ),
                  );
                }

                final groupedData = <String, List<dynamic>>{};
                for (var due in filteredData) {
                  groupedData.putIfAbsent(due.accNo, () => []).add(due);
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  itemCount: groupedData.keys.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final accNo = groupedData.keys.elementAt(index);
                    final dues = groupedData[accNo]!;
                    final totalDue = dues.fold<num>(
                      0,
                          (sum, item) => sum + (item.dueAmount ?? 0),
                    );

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: white,
                        border: Border.all(
                            color: home2.withOpacity(0.7), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            color: black.withOpacity(0.08),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: transparent,
                          highlightColor: transparent,
                          dividerColor: transparent,
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedAccNo = expanded ? accNo : null;
                            });
                          },
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account Number",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                accNo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: home1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    size: 18,
                                    color: black87,
                                  ),
                                  Text(
                                    "Total Due: ₹$totalDue",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: dues.asMap().entries.map((entry) {
                            final dueIndex = entry.key;
                            final due = entry.value;

                            _checkboxStates.putIfAbsent(accNo, () => {});
                            _checkboxStates[accNo]!.putIfAbsent(
                              dueIndex,
                                  () => false,
                            );

                            final isEnabled = _expandedAccNo == null ||
                                _expandedAccNo == accNo;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _checkboxStates[accNo]![dueIndex],
                                    onChanged: isEnabled
                                        ? (bool? value) {
                                      setState(() {
                                        // Uncheck all other account numbers
                                        _checkboxStates.forEach((
                                            key,
                                            map,
                                            ) {
                                          if (key != accNo) {
                                            map.updateAll(
                                                  (_, __) => false,
                                            );
                                          }
                                        });

                                        // Update current checkbox state
                                        _checkboxStates[accNo]![
                                        dueIndex] = value ?? false;
                                        _expandedAccNo = accNo;
                                      });

                                      // Calculate the selected amount only for current group
                                      num modalSelectedAmount = 0;
                                      final map = _checkboxStates[accNo];
                                      if (map != null) {
                                        map.forEach((i, isChecked) {
                                          if (isChecked) {
                                            modalSelectedAmount +=
                                                dues[i].installAmt ?? 0;
                                          }
                                        });
                                      }

                                      final hasAnyChecked =
                                          modalSelectedAmount > 0;

                                      if (!hasAnyChecked) return;

                                      final controller =
                                      TextEditingController(
                                        text: modalSelectedAmount
                                            .toStringAsFixed(2),
                                      );

                                      String selectedMethod =
                                          "Link"; // Default selection

                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape:
                                        const RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.vertical(
                                            top: Radius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: white,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (
                                                context,
                                                setModalState,
                                                ) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  top: 20,
                                                  left: 20,
                                                  right: 20,
                                                  bottom: MediaQuery.of(
                                                    context,
                                                  )
                                                      .viewInsets
                                                      .bottom +
                                                      20,
                                                ),
                                                child:
                                                SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                10,
                                                              ),
                                                              border:
                                                              Border
                                                                  .all(
                                                                color:
                                                                black54,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: selectedMethod ==
                                                                "Link"
                                                                ? Image
                                                                .asset(
                                                              "assets/icons/web-link.png",
                                                              scale:
                                                              12,
                                                              color:
                                                              home2,
                                                            )
                                                                : selectedMethod ==
                                                                "QR Code"
                                                                ? Image
                                                                .asset(
                                                              "assets/icons/qr-code.png",
                                                              scale: 12,
                                                              color: home2,
                                                            )
                                                                : Image
                                                                .asset(
                                                              "assets/images/rupee_6414183.png",
                                                              scale: 10,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  "Collect Payment Using",
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                  style: GoogleFonts
                                                                      .inter(
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                    color:
                                                                    black87,
                                                                    fontSize:
                                                                    15,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  selectedMethod,
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                  style: GoogleFonts
                                                                      .inter(
                                                                    fontWeight:
                                                                    FontWeight.w700,
                                                                    color:
                                                                    black,
                                                                    fontSize:
                                                                    15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                context:
                                                                context,
                                                                backgroundColor:
                                                                Colors
                                                                    .white,
                                                                shape:
                                                                const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.vertical(
                                                                    top: Radius.circular(
                                                                        24),
                                                                  ),
                                                                ),
                                                                builder:
                                                                    (ctx) =>
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                          16),
                                                                      child:
                                                                      Column(
                                                                        mainAxisSize:
                                                                        MainAxisSize.min,
                                                                        children: [
                                                                          // drag handle
                                                                          Container(
                                                                            width: 40,
                                                                            height: 5,
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.grey.shade300,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 16),
                                                                          ListTile(
                                                                            leading: const Icon(Icons.link, color: Colors.blueAccent),
                                                                            title: const Text(
                                                                              "Link",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                            trailing: const Icon(Icons.chevron_right),
                                                                            onTap: () {
                                                                              setModalState(() => selectedMethod = "Link");
                                                                              Navigator.pop(ctx);
                                                                            },
                                                                          ),
                                                                          const Divider(
                                                                              indent: 16,
                                                                              endIndent: 16),
                                                                          ListTile(
                                                                            leading: const Icon(Icons.qr_code, color: Colors.green),
                                                                            title: const Text(
                                                                              "QR Code",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                            trailing: const Icon(Icons.chevron_right),
                                                                            onTap: () {
                                                                              setModalState(() => selectedMethod = "QR Code");
                                                                              Navigator.pop(ctx);
                                                                            },
                                                                          ),
                                                                          const Divider(
                                                                              indent: 16,
                                                                              endIndent: 16),
                                                                          ListTile(
                                                                            leading: const Icon(Icons.money, color: Colors.deepOrange),
                                                                            title: const Text(
                                                                              "Cash",
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                            trailing: const Icon(Icons.chevron_right),
                                                                            onTap: () {
                                                                              setModalState(() => selectedMethod = "Cash");
                                                                              Navigator.pop(ctx);
                                                                            },
                                                                          ),
                                                                          const SizedBox(height: 12),
                                                                        ],
                                                                      ),
                                                                    ),
                                                              );
                                                            },
                                                            child: Text(
                                                              "Change Method >",
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                decoration:
                                                                TextDecoration
                                                                    .underline,
                                                                decorationColor:
                                                                home2,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w800,
                                                                color:
                                                                home2,
                                                                fontSize:
                                                                12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      const Text(
                                                        "Installment Details",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          color: home2,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "Open Date: ${due.openDate}",
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        "Paid Installments: ${provider.rdclDueUnderAgentModel?.data[index].paidInstallments}",
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Edit Total Selected Amount",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color:
                                                          grey[800],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                        controller,
                                                        keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                          decimal: true,
                                                          signed: true,
                                                        ),
                                                        decoration:
                                                        InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                          home2,
                                                          border:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                              10,
                                                            ),
                                                            borderSide:
                                                            const BorderSide(
                                                              color:
                                                              deepTeal,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                              10,
                                                            ),
                                                            borderSide:
                                                            const BorderSide(
                                                              color:
                                                              deepTeal,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                            14,
                                                            vertical: 12,
                                                          ),
                                                          prefixIcon:
                                                          const Icon(
                                                            Icons
                                                                .currency_rupee,
                                                            color: white,
                                                          ),
                                                        ),
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          color: white,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      CustomSliderButton(
                                                        token: token!,
                                                        label:
                                                        "Slide to Collect Using $selectedMethod",
                                                        backgroundColor:
                                                        home2,
                                                        buttonColor:
                                                        Colors.white,
                                                        onConfirmed:
                                                            () async {
                                                          selectedMethod ==
                                                              "Link"
                                                              ? sendLinkFunction(
                                                              provider.rdclDueUnderAgentModel!
                                                                  .data[
                                                              index],
                                                              controller
                                                                  .text)
                                                              : selectedMethod ==
                                                              "Cash"
                                                              ? getCashTrans(
                                                            token:
                                                            token,
                                                            customerName:
                                                            provider.rdclDueUnderAgentModel?.data[index].name,
                                                            custPhoneNumber:
                                                            "",
                                                            custAcNumber:
                                                            provider.rdclDueUnderAgentModel?.data[index].accNo,
                                                            custId:
                                                            provider.rdclDueUnderAgentModel?.data[index].custId,
                                                            custEmail:
                                                            "",
                                                            phoneNumber:
                                                            "$agentPhoneNumber",
                                                            entityId:
                                                            agentId,
                                                            note:
                                                            "Payment For Agent $agentName",
                                                            amount:
                                                            controller.text,
                                                          )
                                                              : getPaymentSessionId(
                                                            token:
                                                            token,
                                                            customerName:
                                                            provider.rdclDueUnderAgentModel?.data[index].name,
                                                            custPhoneNumber:
                                                            "",
                                                            custAcNumber:
                                                            provider.rdclDueUnderAgentModel?.data[index].accNo,
                                                            custId:
                                                            provider.rdclDueUnderAgentModel?.data[index].custId,
                                                            custEmail:
                                                            "",
                                                            phoneNumber:
                                                            "$agentPhoneNumber",
                                                            entityId:
                                                            agentId,
                                                            note:
                                                            "Payment For Agent $agentName",
                                                            amount:
                                                            controller.text,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: home1,
                                          width: 1.5,
                                        ),
                                        color: grey[50],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Installment: ₹${due.installAmt}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Name: ${provider.rdclDueUnderAgentModel!.data[index].name}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Open Date: ${provider.rdclDueUnderAgentModel!.data[index].openDate}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Paid Installemnts: ${provider.rdclDueUnderAgentModel!.data[index].paidInstallments}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "DueInstallments: ${provider.rdclDueUnderAgentModel!.data[index].dueInstallments}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "TotalInstallment: ${provider.rdclDueUnderAgentModel!.data[index].totalInstallment}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),*/

///currently the api is not used....
// Future<void> _searchMethod(String query) async {
//   final provider =
//       Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
//   setState(() => _isLoading = true);
//   await provider.getRdclDueList("", "", query);
//   setState(() => _isLoading = false);
// }

// Future<void> _clearSearch() async {
//   final provider =
//       Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
//   _searchController.clear();
//   setState(() => _isLoading = true);
//   await provider.getRdclDueList(agentOriginId!, "", "");
//   setState(() => _isLoading = false);
// }
