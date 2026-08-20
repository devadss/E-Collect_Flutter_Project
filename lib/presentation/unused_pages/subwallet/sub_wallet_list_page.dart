// import 'package:e_Collect/core/colors.dart';
// import 'package:e_Collect/subwallet/sub_wallet_creation_page.dart';
// import 'package:flutter/material.dart';
//
// class  SubWalletListPage extends StatefulWidget {
//   const  SubWalletListPage({super.key});
//
//   @override
//   State< SubWalletListPage> createState() => _SubWalletListPageState();
// }
//
// class _SubWalletListPageState extends State< SubWalletListPage> {
//    double progress =  0.8 ;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//
//           topCardWidget(),
//           SizedBox(height: 20,),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [Text("My Sub-Wallets", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
//             IconButton.filledTonal(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=> SubWalletCreationPage()));
//
//             },
//                 style: IconButton.styleFrom(backgroundColor: home1.withAlpha(170), foregroundColor: Colors.white),
//                 icon: const Icon(Icons.add))
//             ],),
//           ),
//           _subWalletList()
//
//         ],
//       ),
//     );
//   }
//
//   Flexible _subWalletList() {
//     return Flexible(
//           child: ListView.builder(
//             padding: EdgeInsets.zero,
//             itemBuilder: (BuildContext context, int index) {
//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: LinearGradient(colors: [
//                         home1.withAlpha(15), home2.withAlpha(20)
//                       ]),
//                       boxShadow: [
//                         BoxShadow(color: Colors.white, spreadRadius: 3, blurRadius: 8)
//                       ]
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(children: [
//                           const Icon(Icons.flight),
//                           Text("Travel", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),)
//                         ],),
//                         SizedBox(height: 10,),
//                         Container(
//                             height: 20,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Row(
//                                   children: [
//
//                                     Expanded(
//                                       flex: (progress * 100).toInt(),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [home1, home2],
//                                           ),
//                                           borderRadius: BorderRadius.horizontal(
//                                             left: const Radius.circular(30),
//                                             right: progress == 1
//                                                 ? const Radius.circular(30)
//                                                 : Radius.zero,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//
//                                     // Remaining part
//                                     Expanded(
//                                       flex: 100 - (progress * 100).toInt(),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: home2.withAlpha(100),
//                                           borderRadius: BorderRadius.horizontal(
//                                             right: const Radius.circular(30),
//                                             left: progress == 1
//                                                 ? const Radius.circular(30)
//                                                 : Radius.zero,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//
//                                 // Center text
//                                 Center(
//                                   child: Text(
//                                     '${(progress * 100).toInt()}%',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         SizedBox(height: 10,),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("₹ 2500/ ₹ 5000"),
//                             Text("₹ 2,500 left")
//                           ],)
//
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//
//           ),
//         );
//   }
//
//   Container topCardWidget() {
//     return Container(
//               width: double.infinity,
//               height: 250,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
//               gradient:LinearGradient(colors: [
//                 home1.withAlpha(50), home2.withAlpha(80)
//               ])
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 30, right: 30, top: 80, bottom: 30),
//                 child: Container(
//                   width: double.infinity,
//                   height: 100,
//
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//                   gradient: LinearGradient(colors: [
//                     home1, home2
//                   ]),
//                   boxShadow: [
//                     BoxShadow(color:Colors.black12, spreadRadius: 3, blurRadius: 8, offset: Offset(0, 1))
//                   ],
//
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text("Main Wallet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),),
//                       Text("₹ 12,300", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),)
//                     ],
//                   ),
//                 ),
//               ),
//             );
//   }
// }
