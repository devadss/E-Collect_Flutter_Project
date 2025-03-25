import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/colors.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {

  String phoneNumber = "9999999999";


  // Function to launch the dialer with a given phone number
  void _callNumber(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    try {
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                value: null, // Default value (shows hint)
                hint: const Text(
                  "Select Branch",
                  style: TextStyle(color: Colors.black45),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: deepTeal),
                items: const [
                  DropdownMenuItem(value: "Branch 1", child: Text("Branch 1")),
                  DropdownMenuItem(value: "Branch 2", child: Text("Branch 2")),
                  DropdownMenuItem(value: "Branch 3", child: Text("Branch 3")),
                ],
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 10),
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
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                value: null, // Default value (shows hint)
                hint: const Text(
                  "Select Account Type",
                  style: TextStyle(color: Colors.black45),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: deepTeal),
                items: const [
                  DropdownMenuItem(value: "Account 1", child: Text("Account 1")),
                  DropdownMenuItem(value: "Account 2", child: Text("Account 2")),
                  DropdownMenuItem(value: "Account 3", child: Text("Account 3")),
                ],
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *0.06,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: deepTeal,
                    border: Border.all(color: black,width: 2)
                  ),
                  child: Center(
                    child: Text(
                        "SUBMIT",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: white
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: MediaQuery.of(context).size.height *0.06,
                  width: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: deepTeal,
                      border: Border.all(color: black,width: 2)
                  ),
                  child: Center(
                    child: Text(
                      "CANCEL",
                      style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: white
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context,index){
                      return Container(
                        height: MediaQuery.of(context).size.height *0.15,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                          border: Border.all(color: deepTeal,width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        ),
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Cust Name",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: deepTeal
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Cust Id : 1234567" ,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: black87
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Account Number : 123456789012" ,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: black87
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phone Number : +91-$phoneNumber" ,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: black87
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => _callNumber(phoneNumber),
                                    child: Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: black)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.phone,size: 20,color: deepTeal,),
                                            Text(
                                                "Call",
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: black
                                              ),
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
                      );
                    },
                    separatorBuilder: (context,index){
                      return const SizedBox(height: 10);
                    },
                    itemCount: 10
                )
            ),
          ],
        ),
      ),
    );
  }
}
