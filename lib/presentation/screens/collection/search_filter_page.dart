import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/colors.dart';
import '../../../data/provider/agent_customer_details_provider.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/agent_customer_details_model.dart' as agent;

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  agent.AgentCustomerDetailsModel? agentCustomerDetailsModel =
      agent.AgentCustomerDetailsModel();
  agent.AgentCustomerDetailsModel? _agentCustomerDetailsModel =
      agent.AgentCustomerDetailsModel();
  List<agent.Datum>? _originalCustomerList;
  String phoneNumber = "";
  String name = "";
  String accNo = "";
  int listLen = 0;
  String custId = "";
  String agentID = "";
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSharedData();
      //fetchCustName();
    });
  }

  void getSharedData() async {
    String agentId = await SharedPref.shared.getAgentOriginId();
    setState(() {
      agentID = agentId;
    });
    fetchCustName();
  }

  // Function to launch the dialer with a given phone number
  void _callNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    try {
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

  Future<void> fetchCustName() async {
    //showProgressDialog(context);
    final provider =
        Provider.of<AgentCustomerDetailsProvider>(context, listen: false);

    await provider.getAgentCustomerDetails("361");
    // await provider.getAgentCustomerDetails(agentID);

    if (!mounted) return; // ✅ Prevent setState if widget is disposed
    if (provider.agentCustomerDetailsModel?.customerList?.data?.isNotEmpty ==
        true) {
      //Navigator.pop(context);
      setState(() {
        _agentCustomerDetailsModel = provider.agentCustomerDetailsModel;
        agentCustomerDetailsModel = _agentCustomerDetailsModel;

        // 🔹 Save the original list
        _originalCustomerList =
            List.from(agentCustomerDetailsModel!.customerList!.data!);
      });
    } else {
      // Navigator.pop(context);
    }
  }

/*
  Future<void> fetchCustName() async {
    showProgressDialog(context);
    final provider =
        Provider.of<AgentCustomerDetailsProvider>(context, listen: false);

    await provider.getAgentCustomerDetails("361");

    if (!mounted) return; // ✅ Prevent setState if widget is disposed
    if (provider.agentCustomerDetailsModel?.customerList?.data?.isNotEmpty ==
        true) {
      Navigator.pop(context);
      setState(() {
        _agentCustomerDetailsModel = provider.agentCustomerDetailsModel;
        agentCustomerDetailsModel = _agentCustomerDetailsModel;

      });
    } else {
      Navigator.pop(context);
    }
  }
*/

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
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: deepTeal),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: GoogleFonts.inter(
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

  void onSubmitClick() {
    if (_originalCustomerList == null) {
      print("❌ Original customer list is null");
      return;
    }

    setState(() {
      agentCustomerDetailsModel = _agentCustomerDetailsModel;
    });

    if (nameController.text.isNotEmpty) {
      showProgressDialog(context);
      String searchQuery = nameController.text.trim().toLowerCase();

      print("Searching for customer name: $searchQuery");

      // 🔹 Always search in the original list
      List<agent.Datum> filteredList = _originalCustomerList!
          .where((customer) =>
              customer.custName!.trim().toLowerCase().contains(searchQuery))
          .toList();

      Navigator.pop(context);

      setState(() {
        agentCustomerDetailsModel!.customerList!.data = filteredList;
      });

      if (filteredList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No customer found with the given name."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    buildShimmerText(width: 150), // Name
                    const SizedBox(width: 30,),
                    buildShimmerText(width: 100), // Name

                  ],),
                  const SizedBox(height: 10,),
                  Row(children: [
                    buildShimmerText(width: 150), // Name
                    const SizedBox(width: 30,),
                    buildShimmerText(width: 50), // Name

                  ],),
                  const SizedBox(height: 10,),
                  Row(children: [
                    buildShimmerText(width: 150), // Name
                    const SizedBox(width: 30,),
                    buildShimmerText(width: 120), // Name

                  ],),
                  const SizedBox(height: 10,),
                  Row(children: [
                    buildShimmerText(width: 150), // Name
                    const SizedBox(width: 30,),
                    buildShimmerText(width: 160), // Name

                  ],),// Account Number
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      buildShimmerText(width: 30),
                      const Icon(
                        Icons.phone,
                        size: 20,
                        color: deepTeal,
                      ),
                    ],
                  )
                ],
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
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Search Account",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: deepTeal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter Account Name",
                  hintStyle: const TextStyle(color: black45),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: deepTeal, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: deepTeal, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    onSubmitClick();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: deepTeal,
                        border: Border.all(color: black, width: 2)),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: deepTeal,
                      border: Border.all(color: black, width: 2)),
                  child: Center(
                    child: Text(
                      "CANCEL",
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            agentCustomerDetailsModel?.customerList?.data?.isNotEmpty == true
                ? Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                  context,
                                  agentCustomerDetailsModel
                                      ?.customerList?.data![index].accNo);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: white,
                                  border: Border.all(color: deepTeal, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Customer Name : ${agentCustomerDetailsModel?.customerList?.data![index].custName}",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: deepTeal),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Customer Id : ${agentCustomerDetailsModel?.customerList?.data![index].custId}",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: black87),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Account Number : ${agentCustomerDetailsModel?.customerList?.data![index].accNo}",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: black87),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(
                                          child: Text(
                                            "Phone Number : +91 ${agentCustomerDetailsModel?.customerList?.data![index].mobile}",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: black87),
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () => _callNumber(
                                              "${agentCustomerDetailsModel?.customerList?.data![index].mobile}"),
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border:
                                                    Border.all(color: black)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 20,
                                                    color: deepTeal,
                                                  ),
                                                  Text(
                                                    "Call",
                                                    style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: agentCustomerDetailsModel!
                            .customerList!.data!.length))
                : buildShimmerList()
            //const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
/*  void onSubmitClick() {
    setState(() {
      agentCustomerDetailsModel = _agentCustomerDetailsModel;

    });
    if (nameController.text.isNotEmpty) {
      showProgressDialog(context);
      String searchQuery = nameController.text.trim().toLowerCase();

      if (agentCustomerDetailsModel?.customerList?.data != null) {
        print("Searching for customer name: $searchQuery");

        List<agent.Datum> filteredList = agentCustomerDetailsModel!
            .customerList!.data!
            .where((customer) =>
                customer.custName!.trim().toLowerCase().contains(searchQuery))
            .toList();

        Navigator.pop(context);

        setState(() {
          agentCustomerDetailsModel!.customerList!.data = filteredList;
        });

        if (filteredList.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No customer found with the given name."),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        Navigator.pop(context);
        print("❌ agentCustomerDetailsModel.customerList.data is null");
      }
    }
  }*/
