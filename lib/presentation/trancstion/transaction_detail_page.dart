import 'package:flutter/material.dart';

class TransactionDetailsPage extends StatelessWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Transaction Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
         // height: 400,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10)
          ),
          child: const Stack(
            fit: StackFit.expand,
          children: [
            Row(children: [
              Text("Data!"),
              Text("Data")
            ],),
            Row(children: [
              Text("Data@"),
              Text("Data")
            ],)
          ],
          ),
        ),
      )
    );
  }
}
