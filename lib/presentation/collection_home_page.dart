import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_qr_flutter/presentation/home_page.dart';
import 'package:collection_qr_flutter/presentation/search_filter_page.dart';
import '../../../core/colors.dart';
import 'bottom_nav_bar_page.dart';

class CollectionHomePage extends StatelessWidget {
  const CollectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        const BottomNavScreen()));
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 100),
              Container(
                height: MediaQuery.of(context).size.height *0.08,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: deepTeal,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 20,
                      spreadRadius: 0,
                      color: black.withOpacity(0.25)
                    )
                  ],
                  border: Border.all(color: black,width:0.5)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Today's Collection : Rs.10,000",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: white
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: white,
                        border: Border.all(color: deepTeal, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: deepTeal),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Account Number",
                                  hintStyle: TextStyle(color:black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Add some spacing between the input and search icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchFilterPage()));
                    },
                    child: const Icon(Icons.search, color: deepTeal, size: 40),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


