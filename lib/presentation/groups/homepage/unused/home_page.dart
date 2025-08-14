// import 'package:collection_qr_flutter/core/colors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class FeeHomePage extends StatefulWidget {
//   const FeeHomePage({super.key});
//
//   @override
//   State<FeeHomePage> createState() => _FeeHomePageState();
// }
//
// class _FeeHomePageState extends State<FeeHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               "Ainsteen",
//               style:
//                   TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
//             )),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Container(
//               height: 200,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: BoxBorder.all(color: home1.withOpacity(0.1)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: home1.withOpacity(0.1),
//                       blurRadius: 3,
//                       offset: Offset(0, 1),
//                     )
//                   ],
//                   color: Colors.white),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Text("Overview"),
//                         Spacer(),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: home1.withOpacity(0.1),
//                           ),
//                           child: const Padding(
//                             padding:  EdgeInsets.all(8.0),
//                             child: Text(
//                               "Month",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//
//                         decoration:
//                             BoxDecoration(color: home1.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Column(
//                             children: [
//                               Icon(Icons.auto_mode),
//                               Text("1200"),
//                               Text("Collected Amount")
//                             ],
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration:
//                             BoxDecoration(color: home1.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Column(
//                             children: [
//                               Icon(Icons.auto_mode),
//                               Text("1200"),
//                               Text("Collected Amount")
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
