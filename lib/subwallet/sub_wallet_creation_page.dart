import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

class SubWalletCreationPage extends StatefulWidget {
  const SubWalletCreationPage({super.key});

  @override
  State<SubWalletCreationPage> createState() => _SubWalletCreationPageState();
}

class _SubWalletCreationPageState extends State<SubWalletCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Create new Sub-Wallet",
          style: TextStyle(fontSize: 20,
              color: home1,
              fontWeight: FontWeight.w700),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sub-Wallet Name"),
            TextField(
              decoration: InputDecoration(
                hint: Text("e.g., Travel"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),

                )
              ),
            ),
            SizedBox(height: 20,),
            Text("Enter amount"),
            TextField(
              decoration: InputDecoration(
                 prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),

                  )
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: ElevatedButton(onPressed: (){},

            style: ElevatedButton.styleFrom(backgroundColor: home1, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
            ),
            child: Text("Create wallet", style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
