// import 'package:collection_qr_flutter/core/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class GroupCreationPage extends StatefulWidget {
//   const GroupCreationPage({super.key});
//
//   @override
//   State<GroupCreationPage> createState() => _GroupCreationPageState();
// }
//
// class _GroupCreationPageState extends State<GroupCreationPage> {
//   DateTime? _selectedPaymentCollectionDate, _selectedPaymentStartDate;
//   TextEditingController? collectionDateController = TextEditingController();
//   TextEditingController? startDateController = TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//
//   }
//
//   Future<void> requestPermission() async {
//     var status = await Permission.contacts.status;
//     if (!status.isGranted) {
//       await Permission.contacts.request();
//     }
//   }
//
//
//   Future<void> fetchContacts() async {
//     // Iterable<Contact> contacts = await ContactsService.getContacts();
//     // for (var contact in contacts) {
//     //   print(contact.displayName);
//     //   for (var phone in contact.phones ?? []) {
//     //     print(phone.value);
//     //   }
//     // }
//   }
//
//
//
//
//   void openCalander(String type) async {
//     DateTime? pickDateTime = await showDatePicker(
//         context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
//
//     if (pickDateTime != null) {
//       setState(() {
//         _selectedPaymentCollectionDate = pickDateTime;
//         if(type == "COLLECTION__START_DATE"){
//           startDateController?.text = '${_selectedPaymentCollectionDate!.toLocal()}'.split(' ')[0];;
//         }
//         if(type == "COLLECTION_DATE"){
//           collectionDateController?.text = '${_selectedPaymentCollectionDate!.toLocal()}'.split(' ')[0];
//
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Create group",
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Text(
//               "Group Name",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: TextFormField(
//               decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.drive_file_rename_outline,
//                     color: home1,
//                   ),
//                   fillColor: home1.withOpacity(0.1),
//                   // Adjust opacity (0.0 to 1.0)
//                   filled: true,
//                   focusedBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1)),
//                   hint: const Text("Please enter your group Name",
//                       style: TextStyle(color: Colors.grey)),
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1)),
//                   border: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1))),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Text(
//               "Amount",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: TextFormField(
//               decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.currency_rupee,
//                     color: home1,
//                   ),
//                   fillColor: home1.withOpacity(0.1),
//                   // Adjust opacity (0.0 to 1.0)
//                   filled: true,
//                   focusedBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1)),
//                   hint: const Text("Please enter the due amount",
//                       style: TextStyle(color: Colors.grey)),
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1)),
//                   border: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1))),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Text(
//               "Collection Date",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: InkWell(
//               onTap: () {
//                 openCalander("COLLECTION_DATE");
//               },
//               child: TextFormField(
//                 controller: collectionDateController,
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.date_range,
//                       color: home1,
//                     ),
//                     enabled: false,
//                     fillColor: home1.withOpacity(0.1),
//                     // Adjust opacity (0.0 to 1.0)
//                     filled: true,
//                     focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: home1)),
//                     hint: const Text("Please select payment collection date",
//                         style: TextStyle(color: Colors.grey)),
//                     enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: home1)),
//                     border: const OutlineInputBorder(
//                         borderSide: BorderSide(color: home1))),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Text(
//               "Collection Start Date",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: InkWell(
//               onTap: (){
//                 openCalander("COLLECTION__START_DATE");
//
//               },
//               child: TextFormField(
//                 enabled: false,
//                 controller: startDateController,
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.date_range,
//                       color: home1,
//                     ),
//                     fillColor: home1.withOpacity(0.1),
//                     // Adjust opacity (0.0 to 1.0)
//                     filled: true,
//                     focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: home1)),
//                     hint: const Text(
//                         "Please select payment collection start date",
//                         style: TextStyle(color: Colors.grey)),
//                     enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(color: home1)),
//                     border: const OutlineInputBorder(
//                         borderSide: BorderSide(color: home1))),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: const Text(
//               "Payment link will be sent after the start date",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Text(
//               "Deactivation Date",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 17),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: TextFormField(
//               decoration: InputDecoration(
//                   prefixIcon: const Icon(
//                     Icons.date_range,
//                     color: home1,
//                   ),
//                   fillColor: home1.withOpacity(0.1),
//                   // Adjust opacity (0.0 to 1.0)
//                   filled: true,
//                   focusedBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1)),
//                   hint: const Text("Please select group deactivation date",
//                       style: TextStyle(color: Colors.grey)),
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1)),
//                   border: const OutlineInputBorder(
//                       borderSide: BorderSide(color: home1))),
//             ),
//           ),
//           const Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10),
//             child: const Text(
//               "Group will get deactivated after the giver date",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ),
//           Row(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 10, top: 20),
//                 child: Text(
//                   "Members",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17),
//                 ),
//               ),
//               const Spacer(),
//               InkWell(
//                 onTap: (){
//                   fetchContacts();
//                 },
//                 child: const Icon(
//                   Icons.person_add,
//                   color: home1,
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(right: 10, left: 5),
//                 child: Icon(
//                   Icons.search,
//                   color: home1,
//                 ),
//               )
//             ],
//           ),
//           Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10),
//               height: 300,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: home1.withOpacity(0.1),
//               ),
//               child: ListView.builder(
//                 itemCount: 5,
//                 itemBuilder: (_, index) {
//                   return Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10, right: 10),
//                         child: Row(
//                           children: [
//                             Text("Person 1"),
//                             Spacer(),
//                             Expanded(
//                                 child: TextFormField(
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   Icons.currency_rupee,
//                                   color: home1,
//                                   size: 15,
//                                 ),
//                               ),
//                             ))
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20, right: 20),
//                         child: Divider(
//                           color: home1.withOpacity(0.3),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       )
//                     ],
//                   );
//                 },
//               ))
//         ],
//       ),
//     );
//   }
// }
