import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/presentation/ptp_bucket/ptp_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils.dart';

class PtpBucketUi extends StatefulWidget {

  const PtpBucketUi({super.key});
  @override
  State<PtpBucketUi> createState() => _PtpBucketUiState();

}

class _PtpBucketUiState extends State<PtpBucketUi> {
  TextEditingController amountController = TextEditingController();

  final Map<String, List<dynamic>> headerContent = {
    "Due Customers": ["5", Colors.deepOrange],
    "Total PTP": ["315", Colors.amber],
    "Broken PTP": ["102", Colors.cyan],
    "Kept PTP": ["2", Colors.green],
  };
final Map<String , dynamic> bfc = {
  "All":Colors.white,
  "B1(1-30 DPD)":Colors.orange,
  "B2(31-60 DPD)":Colors.amber,
  "B3(61-90 DPD)":Colors.red.shade300,
  "B4(91+ DPD)":Colors.red,
};

  int? selectedIndex;
  int? selectedCodeIndex;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCodeIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar:ptp_bucket_appbar("LOAN-BUCKET"),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER CARDS
              SizedBox(
                width: double.infinity,
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: headerContent.length,
                  itemBuilder: (BuildContext context, int index) {
                    return headerWidget(
                      headerContent.keys.elementAt(index),
                      headerContent.values.elementAt(index).first,
                      headerContent.values.elementAt(index).last,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10 ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  "Bucket Filters",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// FILTER CHIPS
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bfc.length,
                  itemBuilder: (BuildContext context, int index) {
                    return bucketWidgetCodes(
                      index,bfc
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// LIST
              Expanded(
                child: contentListWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView contentListWidget() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                border: Border.all(
                  color: selectedIndex == index
                      ? home1.withAlpha(70)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),

              child: Column(
                children: [

                  /// TOP SECTION
                  Row(
                    children: [

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo.shade50,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.indigo,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Ravi Kumar",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),

                             SizedBox(height: 4),

                            Text(
                              "PTP : 19-01-2026",
                              style: TextStyle(
                                color: home1,
                                fontSize: 13,
                              ),
                            ),

                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(30),
                          color: Colors.orange.shade100,
                        ),
                        child:  Text(
                          bfc.keys.elementAt(index),
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DUE AMOUNT BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(18),
                      color: Colors.orange.shade50,
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [

                            Container(
                              padding:
                              const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.currency_rupee,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 10),

                            const Text(
                              "Due Amount",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const Text(
                          "₹ 2,450",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTONS
                  Row(
                    children: [

                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: home1,
                            foregroundColor: Colors.white,
                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),

                          onPressed: () {
                            _makePhoneCall(
                                'tel:9090998987');
                          },

                          icon: const Icon(Icons.call),
                          label: const Text(
                            "Call",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: home1,
                            side: BorderSide(
                              color: home1,
                            ),
                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) =>
                                    PtpPage(),
                              ),
                            );
                          },

                          icon: const Icon(
                            Icons.calendar_month,
                          ),

                          label: const Text(
                            "PTP",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  GestureDetector bucketWidgetCodes(

      int indexes,
      Map<String , dynamic> bfc
      ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCodeIndex = indexes;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 10,
        ),

        margin: const EdgeInsets.only(right: 12),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),

          color: selectedCodeIndex == indexes
              ? home2
              : bfc.values.elementAt(indexes),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),

        child: Center(
          child: Text(
            bfc.keys.elementAt(indexes),
            style: TextStyle(
              color: selectedCodeIndex == indexes
                  ? Colors.white
                  : bfc.keys.elementAt(indexes) =="All"?Colors.black:Colors.white,
              fontWeight: selectedCodeIndex == indexes ?FontWeight.w800:FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Padding headerWidget(
      String headOne,
      String headTwo,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),

      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(.75),
              color,
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            )
          ],
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            Text(
              headOne,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              headTwo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

