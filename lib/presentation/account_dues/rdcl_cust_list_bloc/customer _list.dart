import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/presentation/account_dues/rdcl_cust_list_bloc/rdcl_due_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/customer_list_bloc/customer_list_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/customer_list_model/customer_list_success.dart' as prefix0;

class CustomerList extends StatefulWidget {

  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}
class _CustomerListState extends State<CustomerList> {
  String? branchid;
  String? agentPhoneNumber;
  String? agentIdValue;
  final searchController = TextEditingController();
  bool iconSwitch = false;

  // Add focus node for better UX
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  Future<void> loadSharedPrefs() async {
    final branchID = await SharedPref().getSubAgentCodeNew();
    final number = await SharedPref().getParentAgentMobNum();
    final custId = await SharedPref().getAgentId();

    setState(() {
      branchid = branchID;
      agentPhoneNumber = number;
      agentIdValue = custId;
    });

    context.read<CustomerListBloc>().add(
      CustomerListFetchEvent("", branchid.toString(), "0", "0", ""),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearch() {
    setState(() {
      iconSwitch = !iconSwitch;
      if (!iconSwitch) {
        searchController.clear();
      }
    });

    context.read<CustomerListBloc>().add(
      CustomerListFetchEvent(
        "",
        branchid.toString(),
        "0",
        "0",
        iconSwitch ? searchController.text : "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: home1),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Customer List",
          style: TextStyle(
            color: home1,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Modern Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[100],
              ),
              child: TextField(
                controller: searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Search customers by name...",
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: home1, size: 24),
                  suffixIcon: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        iconSwitch ? Icons.close_rounded : Icons.send_rounded,
                        key: ValueKey(iconSwitch),
                        color: iconSwitch ? Colors.red : home1,
                        size: 22,
                      ),
                    ),
                    onPressed: _handleSearch,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _handleSearch(),
              ),
            ),
          ),

          // Customer List or Status
          Expanded(
            child: BlocBuilder<CustomerListBloc, CustomerListState>(
              builder: (context, state) {
                prefix0.CustomerList? data;

                if (state is CustomerListLoaderState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: home1.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: home1,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Loading customers...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CustomerListFailState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Oops! Something went wrong",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.customerListFailModel.customerListFailResponse.error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is CustomerListSuccessState) {
                  data = state.customerListSuccessModel.customerListSuccessResponse.customerList;

                  if (data?.data == null || data!.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.people_outline_rounded,
                              color: Colors.grey[400],
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "No customers found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try adjusting your search",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data?.totalCount ?? 0,
                    itemBuilder: (context, index) {
                      final customer = data?.data?[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RdclDueDetail(
                                    branchCode: branchid.toString(),
                                    customeName: customer?.custName ?? "",
                                    custPhoneNumber: agentPhoneNumber.toString(),
                                    custIdNew: customer?.custId.toString() ?? "",
                                    custAcNumber: customer?.rdclGlobalAccNo.toString() ?? "",
                                    custId: agentIdValue ?? "",
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Customer Name Section
                                  Row(
                                    children: [
                                      Container(
                                         padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.green.withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.green.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          customer?.custName ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Account Number Section
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.blue.withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          Icons.account_balance_rounded,
                                          color: Colors.blue.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Account Number",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              customer?.rdclGlobalAccNo ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: home1,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Scheme Name Section
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.orange.withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          Icons.category_rounded,
                                          color: Colors.orange.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Scheme Name",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              customer?.schName ?? "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
// class _CustomerListState extends State<CustomerList> {
//   String? branchid;
//   String? agentPhoneNumber;
//   String? agentIdValue;
//   TextEditingController searchController = TextEditingController();
//   bool iconSwitch = false;
//   @override
//   void initState() {
//     super.initState();
//     loadSharedPrefs();
//     // context.read<CustomerListBloc>().add(
//     //   CustomerListFetchEvent("", "15", "0", "0", ""),
//     // );
//   }
//   Future<void> loadSharedPrefs() async {
//
//     final branchID = await SharedPref().getSubAgentCodeNew();
//     final number = await SharedPref().getParentAgentMobNum();
//     final custId = await SharedPref().getAgentId();
//
//     setState(() {
//       branchid = branchID;
//       agentPhoneNumber = number;
//       agentIdValue = custId;
//
//     });
//     context.read<CustomerListBloc>().add(
//       CustomerListFetchEvent("", branchid.toString(), "0", "0", ""),
//     );
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     searchController.dispose();
//     iconSwitch = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Customer List",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//             fontSize: 25,
//           ),
//         ),
//       ),
//
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hint: Text("Search by name"),
//                 suffixIcon: InkWell(
//                     onTap: (){
//                       setState(() {
//                         if(iconSwitch == false){
//                           iconSwitch = true;
//                         }else{
//                           iconSwitch = false;
//                           searchController.clear();
//
//                         }
//                       });
//                       iconSwitch == false?
//                       context.read<CustomerListBloc>().add(CustomerListFetchEvent("", branchid.toString(), "0", "0", ""),):
//                       context.read<CustomerListBloc>().add(CustomerListFetchEvent("", branchid.toString(), "0", "0", searchController.text),);
//                     },
//                     child: Icon(
//                         iconSwitch == true?
//                         Icons.clear: Icons.send, color: home1,)),
//                 prefixIcon: Icon(Icons.search, color: home1,),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5)
//                 )
//               ),
//             ),
//           ),
//
//
//           Expanded(
//             child: BlocBuilder<CustomerListBloc, CustomerListState>(
//               builder: (BuildContext context, state) {
//                 prefix0.CustomerList? data;
//                 if (state is CustomerListLoaderState) {
//                   return const Center(child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(color: home1,),
//                       SizedBox(height: 10,),
//                       Text("Please wait...")
//                     ],
//                   ));
//                 }
//                 if (state is CustomerListFailState) {
//                   return Center(
//                     child: Text(
//                       state.customerListFailModel
//                           .customerListFailResponse
//                           .error,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 }
//                 if (state is CustomerListSuccessState) {
//                   data = state
//                       .customerListSuccessModel
//                       .customerListSuccessResponse
//                       .customerList;
//                   if (data?.data == null || data!.data!.isEmpty) {
//                     return const Center(
//                       child: Text("No customers found"),
//                     );
//                   }
//                   return ListView.builder(
//                     itemCount: data?.totalCount??0,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 10,
//                         ),
//                         child: InkWell(
//                           onTap: (){
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>RdclDueDetail(branchCode: branchid.toString(), customeName: data?.data?[index].custName??"",
//                               custPhoneNumber: agentPhoneNumber.toString(), custIdNew: data?.data?[index].custId.toString()??"",
//                               custAcNumber: data?.data?[index].rdclGlobalAccNo.toString()??"", custId: agentIdValue??"",)));
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(15),
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(color: home2.withAlpha(20),
//                                 blurRadius: 7, spreadRadius: 3)
//                               ],
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                               border: Border.all(color: home1.withAlpha(50)),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsetsGeometry.all(10),
//                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.greenAccent.shade100.withAlpha(90)),
//                                         child: Icon(Icons.person, color:  Colors.greenAccent,)),
//                                     SizedBox(width: 10,),
//                                     Text(data?.data?[index].custName.toString() ?? "", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),),
//                                   ],
//                                 ),
//                                 Divider(),
//                                 SizedBox(height: 5,),
//                                 Row(
//                                   children: [
//                                     Container(
//                                         padding: EdgeInsetsGeometry.all(10),
//                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue.shade100.withAlpha(90)),
//                                         child: Icon(Icons.account_balance, color:  Colors.blue,)),
//                                     SizedBox(width: 10,),
//                                     Text(
//                                       "Acc No: ${data?.data?[index].rdclGlobalAccNo.toString() ?? ""}",style: TextStyle(color: home1, fontWeight: FontWeight.w700, fontSize: 13),
//                                     )
//                                   ],
//                                 ),
//                                 Divider(),
//                                 SizedBox(height: 5,),
//                                 Row(
//                                   children: [
//                                     Container(
//                                         padding: EdgeInsetsGeometry.all(10),
//                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange.shade100.withAlpha(90)),
//                                         child: Icon(Icons.type_specimen_sharp, color:  Colors.orange,)),
//                                     SizedBox(width: 10,),
//                                     Text(
//                                       "Scheme Name : \n${data?.data?[index].schName.toString() ?? ""}",style: TextStyle(fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//                 return SizedBox.shrink();
//
//
//
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
