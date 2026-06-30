import 'package:flutter/material.dart';

class TransactionDetailsPage extends StatefulWidget {
  final String? amountValue;
  final String? custName;
  final String? orderid;
  final String? tranStatus;
  final String? brCode;
  final String? corpName;
  const TransactionDetailsPage({super.key, this.amountValue,
  this.custName,
  this.orderid,
    this.tranStatus,
    this.brCode,
    this.corpName
  });

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Transaction Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
              width: double.infinity,
               height: 300,
              decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    buildRow("Customer Name", widget.custName.toString()),
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildRow("Amount", "${widget.amountValue.toString()} Rs"),
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildRow("Order ID", widget.orderid.toString()),
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildRow("Transaction Status", widget.tranStatus.toString()),
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildRow("Branch Code",widget.brCode.toString()),
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildRow("Corp Name", widget.corpName.toString()),
                    const Divider(
                      color: Colors.black12,
                      height: 1,
                    ),
                  ],
                ),
              )),
        ));
  }

  Row buildRow(String key, String value) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$key : ",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
            textAlign: TextAlign.center,value),
      ],
    );
  }
}
