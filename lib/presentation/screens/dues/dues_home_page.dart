
import 'package:collection_qr_flutter/data/storage/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/colors.dart';
import '../../../data/provider/agent_customer_details_provider.dart';
import 'dues_detail_page.dart';


class DuesHomePage extends StatefulWidget {
  const DuesHomePage({super.key});

  @override
  State<DuesHomePage> createState() => _DuesHomePageState();
}

class _DuesHomePageState extends State<DuesHomePage> {
  String agentID = "";
  @override
  void initState() {

    super.initState();
    getSharedData();
  }

void getSharedData()async{
    String agentId = await SharedPref.shared.getAgentOriginId();
    setState(() {
      agentID = agentId;
    });
    final provider =
    Provider.of<AgentCustomerDetailsProvider>(context, listen: false);
    provider.getAgentCustomerDetails(agentID);
   //provider.getAgentCustomerDetails("361");
}

  Widget buildShimmerText({double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500), // Ensures smooth animation
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
  Widget buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Important: Shrink to fit content
              children: [
                buildShimmerText(width: 150), // Name
                const SizedBox(height: 10),
                buildShimmerText(width: 100), // Customer ID
                const SizedBox(height: 10),
                buildShimmerText(width: 180), // Account Number
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 20,
                      color: deepTeal,
                    ),
                    SizedBox(width: 10), // Add space between icon and text
                    buildShimmerText(width: 120),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

/*  Widget buildShimmerList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
           //height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: buildShimmerText(width: 150)), // Name
                      const SizedBox(height: 10),
                      Flexible(child: buildShimmerText(width: 100)), // Customer ID
                      const SizedBox(height: 10),
                      Flexible(child: buildShimmerText(width: 180)), // Account Number
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Flexible(
                            child: Icon(
                              Icons.phone,
                              size: 20,
                              color: deepTeal,
                            ),
                          ),
                          Flexible(child: buildShimmerText(width: 120))
                        ],
                      )
                    ],
                  ),
                ),

            ),
          );
        },
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Consumer<AgentCustomerDetailsProvider>(
        builder: (context, provider, child) {
          final customerModel = provider.agentCustomerDetailsModel;
          final customers = customerModel?.customerList?.data;

          if (customerModel == null || customers == null) {
            return buildShimmerList(); // Show shimmer if data is loading
          }

          return Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: black, width: 2),
                    color: deepTeal,
                  ),
                  child: Center(
                    child: Text(
                      "Total Dues Collected : Rs 10,000",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: customers.length, // ✅ Fixed null-safety issue
                  itemBuilder: (context, index) {
                    final customer = customers[index]; // ✅ Store in a variable

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DuesDetailPage(
                                custName: customer.custName ?? "NAME",
                                custAcNumber: customer.accNo ?? "ACCNO",
                                custPhoneNumber: customer.mobile ?? "MOBILE",
                               // custId: '361',
                                custId: agentID,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: white,
                            border: Border.all(color: deepTeal, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  customer.custName ?? "CUST NAME",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    color: black,
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Account Number : ${customer.accNo ?? "ACC No"}",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: black87,
                                        ),
                                         // overflow: TextOverflow.ellipsis
                                      ),
                                      const Spacer(), // ✅ Moved correctly
                                      FittedBox(
                                        child: Container(
                                          height: 30,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(color: black, width: 1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/money.png",
                                                  scale: 25,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "Collect",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                    color: deepTeal,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Phone Number : ${customer.mobile ?? "MOBILE"}",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

/*  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Consumer<AgentCustomerDetailsProvider>(
            builder: (context, provider, child) {
          return provider.agentCustomerDetailsModel == null
              ?
          buildShimmerList()
              : Column(
                  children: [
                    const SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: black, width: 2),
                          color: deepTeal,
                        ),
                        child: Center(
                          child: Text(
                            "Total Dues Collected : Rs 10,000",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: white),
                          ),
                        ),
                      ),
                    ),
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
                                              DuesDetailPage(
                                                custName: provider.agentCustomerDetailsModel?.customerList?.data?[index].custName ?? "NAME" ,
                                                custAcNumber: provider.agentCustomerDetailsModel?.customerList?.data?[index].accNo ?? "ACCNO" ,
                                                custPhoneNumber: provider.agentCustomerDetailsModel?.customerList?.data?[index].mobile ?? "MOBILE",
                                                custId: '361',
                                               // custId: agentID,
                                              )));
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: white,
                                      border: Border.all(
                                          color: deepTeal, width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            provider
                                                    .agentCustomerDetailsModel
                                                    ?.customerList
                                                    ?.data?[index]
                                                    .custName ??
                                                "CUST NAME",
                                            style: GoogleFonts.inter(
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
                                                "Account Number : ${provider.agentCustomerDetailsModel?.customerList?.data?[index].accNo ?? "ACC No"}",
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: black87),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 30,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                        color: black,
                                                        width: 1)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/money.png",
                                                        scale: 25,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        "Collect",
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                                color:
                                                                    deepTeal),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Phone Number : ${provider.agentCustomerDetailsModel?.customerList?.data?[index].mobile ?? "MOBILE"}",
                                            style: GoogleFonts.inter(
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
                          itemCount: provider.agentCustomerDetailsModel!
                              .customerList!.data!.length),
                    )
                  ],
                );
        }));
  }*/
}
