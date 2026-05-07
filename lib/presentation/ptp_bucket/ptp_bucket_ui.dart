import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

class PtpBucketUi extends StatefulWidget {
  const PtpBucketUi({super.key});

  @override
  State<PtpBucketUi> createState() => _PtpBucketUiState();
}

class _PtpBucketUiState extends State<PtpBucketUi> {
  Map<String, List<dynamic>> headerContent = {
    "Due Customers": ["120", Colors.orange.shade100],
    "Total PTP": ["315", Colors.yellow.shade100],
    "Broken PTP": ["102", Colors.cyan.shade100]
  };
  List<String> bucketFilterCode = ["All", "B1", "B2", "B3", "B4"];
  int? selectedIndex;
  int? selectedCodeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "PTP-BUCKET",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: home1.withAlpha(180),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: headerContent.length,
                    itemBuilder: (BuildContext context, int index) {
                      return headerWidget(
                          headerContent.keys.elementAt(index),
                          headerContent.values.elementAt(index).first,
                          headerContent.values.elementAt(index).last);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Bucket Filters",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: bucketFilterCode.length,
                  itemBuilder: (BuildContext context, int index) {
                    return bucketWidgetCodes(bucketFilterCode[index], index);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedIndex = index;
                        });

                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(color: Colors.grey.shade200),
                            color: selectedIndex == index? grey.shade200:Colors.white,
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: selectedIndex == index?Colors.white:Colors.black12,
                            //       blurRadius: 3,
                            //       spreadRadius: 2),
                            // ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Customer name",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.orange.shade100),
                                    child: Text(
                                      "B1",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Due Amount"),
                                Text("PTP"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rs 2,450.00",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text("19-01-2026"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: home1,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    onPressed: () {}, child: Text("Call")),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: home2,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    onPressed: () {}, child: Text("PTP")),
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

  InkWell bucketWidgetCodes(String codes, int indexes) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCodeIndex = indexes;
        });

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: selectedCodeIndex == indexes?
            Colors.grey:Colors.white,
            border: Border.all(color: selectedCodeIndex == indexes?Colors.white:Colors.grey)),
        child: Center(child: Text(codes, style: TextStyle(color: selectedCodeIndex == indexes?Colors.white:Colors.black, fontWeight: FontWeight.w700),)),
      ),
    );
  }

  Padding headerWidget(String headOne, String headTwo, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 2)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headOne),
            Text(
              headTwo,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
