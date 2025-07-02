import 'package:collection_qr_flutter/presentation/account_dues/widgets/rdcl_account_due_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/colors.dart';
import '../../data/provider/rdcl_cust_list_provider.dart';
import '../../data/provider/rdcl_due_under_agent_provider.dart';
import '../../data/storage/shared_pref_helper.dart';

class RdclAccountListHomePage extends StatefulWidget {
  const RdclAccountListHomePage({super.key});

  @override
  State<RdclAccountListHomePage> createState() => _AccountListHomePageState();
}

class _AccountListHomePageState extends State<RdclAccountListHomePage> {
  String? agentId;
  String? corpCode;
  String? agentPhoneNumber;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSharedPrefs();
    });
    super.initState();
  }

  Future<void> loadSharedPrefs() async {
    final id = await SharedPref().getSubAgentCode();
    final crpCd = await SharedPref().getCorpCode();
    final number = await SharedPref().getParentAgentMobNum();
    if (mounted) {
      setState(() {
        agentId = id;
        agentPhoneNumber = number;
        corpCode = crpCd;
      });
      print(
          "----------------------------------AGENT ORIGIN ID---------------------------");
      print(agentId);
      final rdclDueUnderAgentProvider =
      Provider.of<RdclDueUnderAgentProvider>(context, listen: false);
      await rdclDueUnderAgentProvider.getRdclDueList(agentId!,"");
      final provider =
      Provider.of<RdclCustListProvider>(context, listen: false);
     //await provider.getRdclCustomerunderAgent(agentId!, "");
      print("bRanch code : ${rdclDueUnderAgentProvider.rdclDueUnderAgentModel!.data[0].brCode}");
      await provider.getRdclCustomerunderAgent("", rdclDueUnderAgentProvider.rdclDueUnderAgentModel!.data[0].brCode);

    }
  }

  Widget buildShimmerText(
      {double width = double.infinity, double height = 16}) {
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

  Widget buildShimmerList() {
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
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              "Customer List",
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 23, color: home2),
            )),
        backgroundColor: white,
        body: Consumer<RdclCustListProvider>(
            builder: (context, provider, child) {
              return provider.rdclCustomerListModel == null
                  ? buildShimmerList()
                  : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RdclAccountDueDetailsPage(
                                              custName: provider
                                                  .rdclCustomerListModel
                                                  ?.data[index]
                                                  .custName ??
                                                  "NAME",
                                              custAcNumber: provider
                                                  .rdclCustomerListModel
                                                  ?.data[index]
                                                  .rdclGlobalAccNo ??
                                                  "RDCL GLOBAL ACC NO",
                                               custPhoneNumber:
                                               agentPhoneNumber!,
                                              custId: provider
                                                  .rdclCustomerListModel
                                                  ?.data[index]
                                                  .custId ??
                                                  "CUSTID",
                                              custEmail: "",
                                              corpCode: corpCode.toString(), indexValue: index,
                                            )));
                              },
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height * 0.15,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: white,
                                    border:
                                    Border.all(color: home1, width: 1.2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          provider
                                              .rdclCustomerListModel
                                              ?.data[index]
                                              .custName ??
                                              "CUST NAME",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                              color: black),
                                        ),
                                        //const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Account Number : ${provider.rdclCustomerListModel?.data[index].rdclGlobalAccNo ?? "ACC No"}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: black87),
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 30,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      30),
                                                  border: Border.all(
                                                      color: home1,
                                                      width: 1)),
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/money.png",
                                                      color: home2,
                                                      scale: 25,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Text(
                                                      "View details",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          fontSize: 12,
                                                          color: home2),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //const SizedBox(height: 5),
                                        Text(
                                          "Scheme Name : ${provider.rdclCustomerListModel!.data[index].schName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: black87),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: provider.rdclCustomerListModel!
                            .data.length),
                  )
                ],
              );
            }));
  }
}
