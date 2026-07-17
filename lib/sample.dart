import 'package:collection_qr_flutter/sample_utils/sample_utils.dart';
import 'package:flutter/material.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  TextEditingController principleAmountController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  List<TextEditingController> installmentController = [];
  List<DateTime> selectedInstallmentDatesUnFormatted = [];
  List<String> selectedDateCopy = [];
  var beginDateFormatted = "";
  int dayDifferenceValue = 0;
  DateTime? beginDateUnFormatedValue;
  double? dailyInterest;

  @override
  void initState() {
    super.initState();
    installmentController.add(TextEditingController());
  }

  ///This will add new amount controller fields....
  void addItem() {
    setState(() {
      installmentController.add(TextEditingController());
    });
    // for (var x in installmentController) {
    //   print(x.text);
    // }
  }

  ///This will remove new amount controller fields....
  void removeItem(int index) {
    setState(() {
      installmentController.removeAt(index);
    });
  }

  Future<void> showBeginDateDialog() async {
    var date = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2060));
    setState(() {
      beginDateUnFormatedValue = date;

      ///The value with date and time....
      beginDateFormatted = "${date?.day}/${date?.month}/${date?.year}";

      /// Only dd-mm-yyyy
    });
  }

  ///This shows date-picker on installment scheme updates...
  Future<void> showCalender() async {
    var date = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2060));
    setState(() {
      ///Only added if selected date is not found in the below list...
      if (!selectedInstallmentDatesUnFormatted.contains(date)) selectedInstallmentDatesUnFormatted.add(date!);
    });
    if (selectedInstallmentDatesUnFormatted.length == 1 && selectedInstallmentDatesUnFormatted.isNotEmpty) {
      ///This will give the no of days between the loan start date and first installment date...
      dayDifferenceValue = date!.difference(beginDateUnFormatedValue!).inDays;
    } else if (selectedInstallmentDatesUnFormatted.length > 1 && selectedInstallmentDatesUnFormatted.isNotEmpty) {
      ///This will give the no of dats b/w first installment and the next installment...
      dayDifferenceValue = date!.difference(selectedInstallmentDatesUnFormatted.first).inDays;
    }
    print("${date}-${selectedInstallmentDatesUnFormatted.first}");
    print("DAYS: $dayDifferenceValue");
    print("Daily interest amount Total for $dayDifferenceValue is : ${(dailyInterest! * dayDifferenceValue)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: textFieldsWidget(principleAmountController,
                      Icon(Icons.monetization_on_outlined), "Principle amount"),
                ),
                Expanded(
                  child: textFieldsWidget(
                      interestController, Icon(Icons.percent), "Interest rate"),
                ),
              ],
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    showBeginDateDialog();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade100),
                  child: beginDateFormatted.isNotEmpty
                      ? Text(beginDateFormatted)
                      : Text("SELECT DATE")),
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      dailyInterestRateCalculation(
                          double.tryParse(
                              principleAmountController.text.toString()),
                          double.tryParse(interestController.text.toString()));
                    },
                    child: Text("Daily Interest Rate"))),
            SizedBox(
              height: 10,
            ),
            dailyInterest != null?
            Center(
                child: Text(
              "Daily ${dailyInterest?.roundToDouble()} % of interest will be added",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
            )):SizedBox.shrink(),
            IconButton(
                onPressed: () {
                  addItem();
                },
                icon: Icon(Icons.add_box)),
            Expanded(
              child: ListView.builder(
                itemCount: installmentController.length,
                itemBuilder: (BuildContext context, int index) {
                  var dateOfInstallments =
                  index == selectedInstallmentDatesUnFormatted.length?
                  selectedInstallmentDatesUnFormatted[index]:
                  selectedInstallmentDatesUnFormatted[index-1]
                  ;
                  return Row(
                    children: [
                      Expanded(
                        child: textFieldsWidget(
                            installmentController[index],
                            Icon(Icons.monetization_on_outlined),
                            "Installment"),
                      ),
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                showCalender();
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100),
                              child: selectedInstallmentDatesUnFormatted.isNotEmpty
                                  ? Text(
                                      "${dateOfInstallments.day}-${dateOfInstallments.month}-${dateOfInstallments.year}")
                                  : Text("SELECT DATE"))),
                      IconButton(
                          onPressed: () {
                            removeItem(index);
                          },
                          icon: Icon(Icons.delete))
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding textFieldsWidget(
      TextEditingController controller, Icon iconData, String label) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: iconData,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          label: Text(label),
        ),
      ),
    );
  }

  void dailyInterestRateCalculation(double? principle, double? interest) {
    var d = interest! / 100;
    var di = (principle! * d) / 365;
    setState(() {
      dailyInterest = di;
    });
  }
}
