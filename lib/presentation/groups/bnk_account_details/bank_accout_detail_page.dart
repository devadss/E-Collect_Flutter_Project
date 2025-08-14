import 'package:flutter/material.dart';

import '../../../core/colors.dart';

class BankAccoutDetailPage extends StatefulWidget {
  const BankAccoutDetailPage({super.key});

  @override
  State<BankAccoutDetailPage> createState() => _BankAccoutDetailPageState();
}

class _BankAccoutDetailPageState extends State<BankAccoutDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Submit Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("PAN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter your PAN number",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: home1)
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Bank Account"),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Bank account number",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: home1)
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Re-enter bank account number",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: home1)
                  )),
              ),
              const SizedBox(height: 16),
              TextFormField(

                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: home1)
                  ),
                  hintText: "Enter IFSC code",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: home1)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
              backgroundColor: home1, foregroundColor: Colors.white),
          onPressed: () {},
          child: Text("Proceed")),
    );
  }
}
