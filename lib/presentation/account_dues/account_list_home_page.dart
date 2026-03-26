import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/presentation/account_dues/widgets/account_detail_new.dart';
import '../../core/colors.dart';
import '../../data/provider/agent_customer_details_provider.dart';
import '../../data/storage/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/model/agent_customer_details_model.dart';
import '../loan_integrated/loan_list.dart';

class AccountListHomePage extends StatefulWidget {
  const AccountListHomePage({super.key});

  @override
  State<AccountListHomePage> createState() => _AccountListHomePageState();
}

class _AccountListHomePageState extends State<AccountListHomePage>  {
  String? agentId;
  String? corpCode;
  bool? showShadowLoan = false;
  bool? showShadowAcc = true;
  final TextEditingController searchController = TextEditingController();
  List<Customer>? _filteredCustomers;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterCustomers(searchController.text);
  }

  void _filterCustomers(String query) {
    final provider = Provider.of<AgentCustomerDetailsProvider>(
      context,
      listen: false,
    );
    final originalList = provider.agentCustomerDetailsModel?.data ?? [];

    if (query.isEmpty) {
      setState(() {
        _filteredCustomers = originalList;
      });
      return;
    }

    final filtered = originalList.where((customer) {
      return customer.custName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredCustomers = filtered;
    });
  }

  Future<void> _initializeData() async {
    try {
      final id = await SharedPref().getAgentOriginId();
      final crpCd = await SharedPref().getCorpCode();

      if (!mounted) return;

      setState(() {
        agentId = id;
        corpCode = crpCd;
        _isLoading = true;
      });

      final provider = Provider.of<AgentCustomerDetailsProvider>(
        context,
        listen: false,
      );

      await provider.getAgentCustomerDetails(agentId!);

      if (!mounted) return;

      setState(() {
        _filteredCustomers = provider.agentCustomerDetailsModel?.data;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Handle error appropriately
     // print("Error initializing data: $error");
    }
  }
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search customers...",
          hintStyle: TextStyle(color: Colors.grey.shade500),

          /// 🔍 Prefix Icon
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),

          /// ❌ Clear Button (modern UX)
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              searchController.clear();
            },
          )
              : null,

          filled: true,
          fillColor: Colors.grey.shade100,

          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // pill shape
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: home1.withOpacity(0.4),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
  // Widget _buildSearchField() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: TextField(
  //       controller: searchController,
  //       decoration: InputDecoration(
  //         hintText: "Search customer name",
  //         prefixIcon: Icon(Icons.search, color: home1.withAlpha(120)),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: home1.withAlpha(120)),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: home1.withAlpha(120)),
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(15),
  //           borderSide: BorderSide(color: home1),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildShimmerText(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
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

  Widget _buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerText(width: 150),
                    const SizedBox(height: 10),
                    _buildShimmerText(width: 100),
                    const SizedBox(height: 10),
                    _buildShimmerText(width: 180),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerList(List<Customer> customers) {
    return Expanded(
      child: customers.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final customer = customers[index];
                return _buildCustomerItem(customer);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No customers found",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  Widget _buildCustomerItem(Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToCustomerDetails(customer),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Avatar
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.blue),
              ),

              const SizedBox(width: 12),

              /// Main Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.custName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.account_balance,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        const Text(
                          "Account",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      customer.depGlobalAccNo,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              /// Action Button
              _buildCollectButton(),
            ],
          ),
        ),
      ),
    );
  }
/*  Widget _buildCustomerItem(Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _navigateToCustomerDetails(customer),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          height: MediaQuery.of(context).size.height * 0.16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 3)
            ],
            border: Border.all(color: home1.withAlpha(70), width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
mainAxisAlignment:
                  MainAxisAlignment.start,
                  children: [
                    Container(decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Colors.blue.shade50,),
padding: EdgeInsets.all(8),
                      child: Icon(Icons.person, color: Colors.blue,),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      customer.custName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Colors.orange.shade50,),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.account_balance, color: Colors.orange,),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        "Account Number",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3,),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green.shade50
                        ),
                        child: Text(
                          customer.depGlobalAccNo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.green,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],),

                   Spacer(flex: 1,),
                    _buildCollectButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/
  Widget _buildCollectButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: home1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/money.png",
            height: 16,
            width: 16,
            color: home1,
          ),
          const SizedBox(width: 6),
          Text(
            "Collect",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: home1,
            ),
          ),
        ],
      ),
    );
  }
/*  Widget _buildCollectButton() {
    return Container(
      height: 30,
      width: 90,
      decoration: BoxDecoration(
        color: home1.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: home1.withAlpha(55), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/money.png",
              color: home1,
              scale: 25,
            ),
            const SizedBox(width: 5),
            const Text(
              "Collect",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  void _navigateToCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailNew(
          custName: customer.custName,
          accNo: customer.depGlobalAccNo,
          scheme: customer.schName,
          custId: customer.custId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title:
            // SegmentedTabControl(
            //
            //     barDecoration: BoxDecoration(
            //         shape: BoxShape.rectangle,
            //         border: Border.all(color: Colors.grey, ),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black12,
            //               blurRadius: 2,
            //               spreadRadius: 8,
            //               offset: Offset(1, 0))
            //         ],
            //         borderRadius: BorderRadius.circular(30)),
            //     tabs: [
            //       SegmentTab(
            //         splashColor: home1,
            //           textColor: Colors.black,
            //         color: home1,
            //           backgroundColor: Colors.black12,
            //           selectedTextColor: Colors.white,
            //           label: "RD LIST"),
            //       SegmentTab(
            //
            //           splashColor: home1,
            //         textColor: Colors.black,
            //           color: home1,
            //           backgroundColor: Colors.grey.shade200,
            //           selectedTextColor: Colors.white,
            //           label: "LOAN LIST")
            //     ])

            SegmentedTabControl(
              barDecoration: BoxDecoration(
                color: Colors.grey.shade100, // soft background
                borderRadius: BorderRadius.circular(30),
              ),
              tabs: [
                SegmentTab(
                  label: "RD LIST",

                  /// Active color
                  color: home1,

                  /// Inactive
                  backgroundColor: Colors.transparent,

                  textColor: Colors.grey.shade700,
                  selectedTextColor: Colors.white,

                  splashColor: home1.withOpacity(0.2),
                ),
                SegmentTab(
                  label: "LOAN LIST",

                  color: home1,
                  backgroundColor: Colors.transparent,

                  textColor: Colors.grey.shade700,
                  selectedTextColor: Colors.white,

                  splashColor: home1.withOpacity(0.2),
                ),
              ],
            )
            ),
        backgroundColor: white,
        body:TabBarView(children: [
          Consumer<AgentCustomerDetailsProvider>(
            builder: (context, provider, child) {
              if (_isLoading || provider.agentCustomerDetailsModel == null) {
                return Column(
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 20),
                    _buildShimmerList(),
                  ],
                );
              }

              final customers =
                  _filteredCustomers ?? provider.agentCustomerDetailsModel!.data;

              return Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: 20),
                  _buildCustomerList(customers),
                ],
              );
            },
          ),
          LoanList()
        ])


      ),
    );
  }
}
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//   InkWell(
//     onTap: (){
//       setState(() {
//         showShadowLoan = false;
//         showShadowAcc = true;
//       });
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(color:
//           showShadowAcc == true?
//           home1.withAlpha(60): Colors.white, blurRadius: 9, spreadRadius: 1),
//
//         ]
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: const Text(
//           //"Account List",
//           "RD List",
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 23,
//             color: home2,
//           ),
//         ),
//       ),
//     ),
//   ),
//     InkWell(
//       onTap: (){
//         setState(() {
//           showShadowLoan = true;
//           showShadowAcc = false;
//         });
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoanList()));
//         showShadowLoan = false;
//         showShadowAcc = true;
//       },
//       child: Container(
//
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(color:
//               showShadowLoan == true?
//               Colors.black12:Colors.white, blurRadius: 8, spreadRadius: 2),
//
//             ]
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: const Text(
//             "Loan List",
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 23,
//               color: home2,
//             ),
//           ),
//         ),
//       ),
//     ),
// ],)
// class AccountListHomePage extends StatefulWidget {
//   const AccountListHomePage({super.key});
//
//   @override
//   State<AccountListHomePage> createState() => _AccountListHomePageState();
// }
//
// class _AccountListHomePageState extends State<AccountListHomePage> {
//   String? agentId;
//   String? corpCode;
//   TextEditingController searchController = TextEditingController();
//   List<Customer>? _agentCustomerDetailsFilteredModel;
//   AgentCustomerDetailsModel? agentCustomerDetailsModel;
//
//   void searchNames() {
//     var query = searchController.text.toLowerCase();
//
//     setState(() {
//       if (query.isEmpty) {
//         // Reset to full list
//         _agentCustomerDetailsFilteredModel =
//             agentCustomerDetailsModel?.data.toList();
//       } else {
//         // Filter only CustomerData list
//         _agentCustomerDetailsFilteredModel =
//             agentCustomerDetailsModel!.data
//                 .where((item) =>
//                 item.custName.toLowerCase().contains(query))
//                 .toList();
//       }
//     });
//   }
//
//
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadSharedPrefs();
//     });
//     super.initState();
//   }
//
//   Future<void> loadSharedPrefs() async {
//     final id = await SharedPref().getAgentOriginId();
//     final crpCd = await SharedPref().getCorpCode();
//     if (mounted) {
//       setState(() {
//         agentId = id;
//         corpCode = crpCd;
//       });
//       print(
//           "----------------------------------AGENT ORIGIN ID---------------------------");
//       print(agentId);
//       final provider =
//           Provider.of<AgentCustomerDetailsProvider>(context, listen: false);
//       provider.getAgentCustomerDetails(agentId!);
//
//       setState(() {
//         agentCustomerDetailsModel = provider.agentCustomerDetailsModel;
//         _agentCustomerDetailsFilteredModel =
//             agentCustomerDetailsModel!.data; // original list
//       });
//
//
//     }
//   }
//
//   Widget buildShimmerText(
//       {double width = double.infinity, double height = 16}) {
//     return Shimmer.fromColors(
//       period: const Duration(milliseconds: 1500), // Ensures smooth animation
//       baseColor: grey[300]!,
//       highlightColor: grey[100]!,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: grey[300],
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//     );
//   }
//
//   Widget buildShimmerList() {
//     return Expanded(
//       child: ListView.separated(
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: 10,
//         separatorBuilder: (context, index) => const SizedBox(height: 10),
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.15,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: white,
//                 border: Border.all(color: grey[300]!, width: 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: black45,
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     buildShimmerText(width: 150), // Name
//                     const SizedBox(height: 10),
//                     buildShimmerText(width: 100), // Customer ID
//                     const SizedBox(height: 10),
//                     buildShimmerText(width: 180), // Account Number
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             backgroundColor: white,
//             automaticallyImplyLeading: false,
//             centerTitle: true,
//             title: const Text(
//               "Account List",
//               style: TextStyle(
//                   fontWeight: FontWeight.w700, fontSize: 23, color: home2),
//             )),
//         backgroundColor: white,
//         body: Consumer<AgentCustomerDetailsProvider>(
//             builder: (context, provider, child) {
//           return provider.agentCustomerDetailsModel == null
//               ? buildShimmerList()
//               : Column(
//                   children: [
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       child: TextField(
//                         onChanged: (_)=>searchNames(),
//                         keyboardType: TextInputType.name,
//                         decoration: InputDecoration(
//                           hint: Text("Customer name"),
//                           prefixIcon: Icon(Icons.search, color: home1.withAlpha(120),),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: home1.withAlpha(120))
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: home1.withAlpha(120))
//                           ),
//                           border: OutlineInputBorder(
//
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(color: home1)
//                           )
//                         ),
//                       ),
//                     ),
// SizedBox(height: 20,),
//                     Expanded(
//                       child: ListView.separated(
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 20),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                           AccountDetailNew(custName: _agentCustomerDetailsFilteredModel![index].custName,
//                                             accNo: _agentCustomerDetailsFilteredModel![index].depGlobalAccNo,
//                                             scheme: _agentCustomerDetailsFilteredModel![index].schName,
//                                             custId: _agentCustomerDetailsFilteredModel![index].custId,)
//                                               // AccountDueDetailsPage(
//                                               //   custName: provider
//                                               //           .agentCustomerDetailsModel
//                                               //
//                                               //           ?.data[index]
//                                               //           .custName ??
//                                               //       "NAME",
//                                               //   custAcNumber:
//                                               //   provider
//                                               //           .agentCustomerDetailsModel
//                                               //
//                                               //           ?.data[index]
//                                               //           .depGlobalAccNo ??
//                                               //       "ACCNO",
//                                               //   custPhoneNumber:
//                                               //   // provider
//                                               //   //         .agentCustomerDetailsModel
//                                               //   //         ?.customerList
//                                               //   //         ?.data?[index]
//                                               //   //         .mobile ??
//                                               //       "MOBILE",
//                                               //   custId:
//                                               //   // provider
//                                               //   //         .agentCustomerDetailsModel
//                                               //   //         ?.customerList
//                                               //   //         ?.data?[index]
//                                               //   //         .custId ??
//                                               //       "CUSTID",
//                                               //   custEmail: "",
//                                               //   corpCode: corpCode.toString(),
//                                               // )
//
//                                       )
//                                   );
//                                 },
//                                 child: Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.15,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: white,
//                                       border:
//                                           Border.all(color: home1, width: 1.2)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10),
//                                     child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             _agentCustomerDetailsFilteredModel![index]
//                                                     .custName ??
//                                                 "CUST NAME",
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w700,
//                                                 fontSize: 17,
//                                                 color: black),
//                                           ),
//                                           //const SizedBox(height: 5),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 "Account Number : ${_agentCustomerDetailsFilteredModel![index].depGlobalAccNo ?? "ACC No"}",
//                                                 style: const TextStyle(
//                                                     fontWeight: FontWeight.w700,
//                                                     fontSize: 14,
//                                                     color: black87),
//                                               ),
//                                               const Spacer(),
//                                               Container(
//                                                 height: 30,
//                                                 width: 90,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             30),
//                                                     border: Border.all(
//                                                         color: home1,
//                                                         width: 1)),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(horizontal: 5),
//                                                   child: Row(
//                                                     children: [
//                                                       Image.asset(
//                                                         "assets/images/money.png",
//                                                         color: home2,
//                                                         scale: 25,
//                                                       ),
//                                                       const SizedBox(width: 5),
//                                                       const Text(
//                                                         "Collect",
//                                                         style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.w700,
//                                                             fontSize: 12,
//                                                             color: home2),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           //const SizedBox(height: 5),
//                                           // Text(
//                                           //   "Phone Number : ${provider.agentCustomerDetailsModel?.customerList?.data?[index].mobile ?? "MOBILE"}",
//                                           //   style: const TextStyle(
//                                           //       fontWeight: FontWeight.w700,
//                                           //       fontSize: 14,
//                                           //       color: black87),
//                                           // ),
//                                         ]),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return const SizedBox(height: 10);
//                           },
//                           itemCount: _agentCustomerDetailsFilteredModel?.length ?? 0
//                       ),
//                     )
//                   ],
//                 );
//         }));
//   }
// }
