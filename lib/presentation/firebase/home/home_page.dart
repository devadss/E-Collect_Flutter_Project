import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeeHomePage extends StatefulWidget {
  const FeeHomePage({super.key});

  @override
  State<FeeHomePage> createState() => _FeeHomePageState();
}

class _FeeHomePageState extends State<FeeHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerRight,
            child: Text("Ainsteen", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white38,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    )
                  ],
                color: home1.withOpacity(0.1)
              ),
            ),
          )
        ],
      ),
    );
  }
}
