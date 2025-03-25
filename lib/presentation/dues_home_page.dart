import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/colors.dart';
import 'dues_detail_page.dart';

class DuesHomePage extends StatefulWidget {
  const DuesHomePage({super.key});

  @override
  State<DuesHomePage> createState() => _DuesHomePageState();
}

class _DuesHomePageState extends State<DuesHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Column(
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DuesDetailPage()));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white,
                              border: Border.all(color: deepTeal, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    "Cust Name",
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
                                        "Total Due Amount : Rs 10000",
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
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: black, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
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
                                                    color: deepTeal),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //const SizedBox(height: 5),
                                  Text(
                                    "Due Date : 1/1/1000",
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
                  itemCount: 10),
            )
          ],
        ));
  }
}
