import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/utils.dart';

class PtpPage extends StatefulWidget {
  const PtpPage({super.key});

  @override
  State<PtpPage> createState() => _PtpPageState();
}
class _PtpPageState extends State<PtpPage> {

  TextEditingController amountController =
  TextEditingController();

  TextEditingController remarkController =
  TextEditingController();

  Map<String, dynamic> ptpData = {
    "Customer Name": "Ravi Kumar",
    "Loans No": "LN092020",
    "Due Amount": "Rs 12,500",
    "Bucket": 4
  };

  String newPromiseDate =
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

  DateTime from_date = DateTime.now();
  DateTime to_date = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: const Color(0xffF4F7FC),

      appBar: ptp_bucket_appbar("PTP"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// CUSTOMER DETAILS CARD
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),

              child: Column(
                children: [

                  /// TOP
                  Row(
                    children: [

                      Container(
                        padding:
                        const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          Colors.indigo.shade50,
                        ),

                        child: const Icon(
                          Icons.person,
                          color: Colors.indigo,
                          size: 26,
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
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Loan No : LN092020",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              30),
                          color:
                          Colors.orange.shade100,
                        ),

                        child: const Text(
                          "B4",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DUE AMOUNT
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
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        const Text(
                          "Due Amount",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        Text(
                          "₹ 12,500",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// DATE TITLE
            const Text(
              "Select Promise Date",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            /// DATE DISPLAY
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(18),

                color: home1.withOpacity(.08),

                border: Border.all(
                  color: home1.withOpacity(.15),
                ),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    backgroundColor: home1,
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "New Promise Date : $newPromiseDate",
                      style: const TextStyle(
                        color: home1,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// DATE PICKER
            Container(
              height: 220,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),

              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,

                initialDateTime: DateTime.now(),

                onDateTimeChanged:
                    (DateTime newDateTime) {

                  setState(() {
                    newPromiseDate =
                    "${newDateTime.day}-${newDateTime.month}-${newDateTime.year}";
                  });
                },
              ),
            ),

            const SizedBox(height: 28),

            /// PROMISE AMOUNT TITLE
            const Text(
              "Promise Amount",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 14),

            buildTextField(
              amountController,
              "Enter Promise Amount",
            ),

            const SizedBox(height: 22),

            const Text(
              "Remarks",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 14),

            buildTextField(
              remarkController,
              "Enter Remarks",
            ),

            const SizedBox(height: 32),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor: home1,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {
                  validateFields();
                },

                child: const Text(
                  "Save PTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  TextField buildTextField(
      TextEditingController controller,
      String labelName,
      )
  {

    bool isRemark =
    labelName.contains("Remarks");

    return TextField(
      controller: controller,

      maxLength: isRemark ? 50 : 8,

      keyboardType: isRemark
          ? TextInputType.text
          : TextInputType.number,

      decoration: InputDecoration(
        counterText: "",

        hintText: labelName,

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),

        prefixIcon: Container(
          margin: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: isRemark
                ? Colors.indigo.shade50
                : Colors.green.shade50,

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: Icon(
            isRemark
                ? Icons.notes_rounded
                : Icons.currency_rupee_rounded,

            color: isRemark
                ? Colors.indigo
                : Colors.green,
          ),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide(
            color: home1,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  void validateFields() {

    if (amountController.text.isNotEmpty &&
        remarkController.text.isNotEmpty) {

      showNotification(
        context,
        "Success",
        Colors.green,
        Colors.white,
      );

    } else {

      showNotification(
        context,
        "Fill empty fields",
        Colors.orange,
        Colors.black,
      );
    }
  }

  ListView buildListView({
    required Map<String, dynamic> ptpD,
  }) {

    return ListView.builder(
      itemCount: ptpD.keys.length,

      itemBuilder:
          (BuildContext context, int index) {

        return Padding(
          padding: const EdgeInsets.all(3.0),

          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Text(
                ptpD.keys.elementAt(index),
              ),

              Text(
                ptpD.values
                    .elementAt(index)
                    .toString(),
              ),
            ],
          ),
        );
      },
    );
  }
}
/*class _PtpPageState extends State<PtpPage> {
  TextEditingController amountController =  TextEditingController();
  TextEditingController remarkController =  TextEditingController();
  Map<String, dynamic> ptpData = {
    "Customer Name": "Ravi Kumar",
    "Loans No": "LN092020",
    "Due Amount": "Rs 12,500",
    "Bucket": 4
  };
  String newPromiseDate = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  DateTime from_date = DateTime.now();
  DateTime to_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: ptp_bucket_appbar("PTP"),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: buildListView(
                  ptpD: ptpData,
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color: home1.withAlpha(30)),
                child: Text(
                  "New Promise Date :- $newPromiseDate",
                  style: const TextStyle(
                      color: home1,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      if(printStatementStatus){
                        print(
                            "${newDateTime.day}-${newDateTime.month}-${newDateTime.year}");
                      }

                      setState(() {
                        newPromiseDate =
                            "${newDateTime.day}-${newDateTime.month}-${newDateTime.year}"
                                .toString();
                      });
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Promise Amount",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              buildTextField(amountController, "Enter Promise Amount"),
              SizedBox(
                height: 20,
              ),
              buildTextField(remarkController, "Remarks"),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: home1,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        validateFields();
                      },
                      child: const Text("Save PTP")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String labelName) {
    return TextField(
              controller: controller,
              maxLength: labelName.contains("Remarks")? 50:8,
              keyboardType: labelName.contains("Remarks")? TextInputType.text:TextInputType.number,
              decoration: InputDecoration(
                counterText: "",
                  label:  Text(labelName),
                  prefixIcon: labelName.contains("Remarks")? Icon(Icons.book):Icon(Icons.currency_rupee_rounded),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none)),
            );
  }

  void validateFields(){
if(amountController.text.isNotEmpty && remarkController.text.isNotEmpty){
  showNotification(context, "Success", Colors.green, Colors.white);
}else{
  showNotification(context, "Fill empty fields", Colors.orange, Colors.black);
}
  }

  ListView buildListView({required Map<String, dynamic> ptpD}) {
    return ListView.builder(
      itemCount: ptpD.keys.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ptpD.keys.elementAt(index)),
              Text(ptpD.values.elementAt(index).toString()),
            ],
          ),
        );
      },
    );
  }
}*/
