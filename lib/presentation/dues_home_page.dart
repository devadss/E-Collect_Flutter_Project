
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/colors.dart';
import '../data/provider/agent_customer_details_provider.dart';
import 'dues_detail_page.dart';

class DuesHomePage extends StatefulWidget {
  const DuesHomePage({super.key});

  @override
  State<DuesHomePage> createState() => _DuesHomePageState();
}

class _DuesHomePageState extends State<DuesHomePage> {
  @override
  void initState() {
    final provider =
        Provider.of<AgentCustomerDetailsProvider>(context, listen: false);
    provider.getAgentCustomerDetails("361");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Consumer<AgentCustomerDetailsProvider>(
            builder: (context, provider, child) {
          return provider.agentCustomerDetailsModel == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: deepTeal,
                  ),
                )
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
                                                name: provider.agentCustomerDetailsModel?.customerList?.data?[index].custName ?? "NAME" ,
                                                acNumber: provider.agentCustomerDetailsModel?.customerList?.data?[index].accNo ?? "ACCNO" ,
                                                phNumber: provider.agentCustomerDetailsModel?.customerList?.data?[index].mobile ?? "MOBILE" ,
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
                                          //const SizedBox(height: 5),
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
  }
}
