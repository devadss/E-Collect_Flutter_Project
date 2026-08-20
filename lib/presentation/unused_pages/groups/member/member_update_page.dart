// import 'package:e_Collect/data/provider/group/member_update/member_update_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/colors.dart';
// import '../../../data/storage/shared_pref_helper.dart';
//
// class UpdateMemberPage extends StatefulWidget {
//   final int memberId;
//   final String memberName;
//   final String memberNumber;
//   final double amount;
//   final DateTime dueDate;
//   final int groupId;
//
//   const UpdateMemberPage({
//     super.key,
//     required this.memberId,
//     required this.memberName,
//     required this.memberNumber,
//     required this.amount,
//     required this.dueDate,
//     required this.groupId,
//   });
//
//   @override
//   State<UpdateMemberPage> createState() => _UpdateMemberPageState();
// }
//
// class _UpdateMemberPageState extends State<UpdateMemberPage>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   DateTime? _selectedDueDate;
//   String? _custid;
//   String? _corpCode;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.memberName;
//     _mobileController.text = widget.memberNumber;
//     _amountController.text = widget.amount.toString();
//     _selectedDueDate = widget.dueDate;
//     loadSharedData();
//     // Initialize animations
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
//       ),
//     );
//
//     _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
//       ),
//     );
//
//     _animationController.forward();
//
//     // _nameController = TextEditingController(text: widget.memberName);
//     // _mobileController = TextEditingController(text: widget.memberNumber);
//     // _amountController = TextEditingController(text: widget.amount.toString());
//     // _selectedDueDate = widget.dueDate;
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _nameController.dispose();
//     _mobileController.dispose();
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   void loadSharedData() async {
//     String custid = await SharedPref.shared.getCustId();
//     String corpCode = await SharedPref.shared.getCorpCode();
//
//     setState(() {
//       _custid = custid;
//       _corpCode = corpCode;
//     });
//
//   }
//
//   Future<void> updateMember() async {
//     showProgressDialog(context);
//     var updateMember =
//         Provider.of<MemberUpdateProvider>(context, listen: false);
//     await updateMember.updateMember(
//         widget.memberId,
//         widget.groupId,
//         _nameController.text,
//         _mobileController.text,
//         double.parse(_amountController.text.toString()),
//         formatDate( _selectedDueDate.toString()),
//         formatDate(_selectedDueDate.toString()),
//         _corpCode!,
//         _corpCode!,
//         _custid!);
//     if(updateMember.errMsg?.isNotEmpty == true){
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred while updating the member")));
//     }else{
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(updateMember.memberResponse!.message)));
//     }
//   }
//
//   String formatDate(String date){
//     DateTime dateTime = DateTime.parse(date);
//     String formattedDate = '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
//     return formattedDate; // Output: 2025-08-25
//   }
//
//   void showProgressDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(
//             child: SingleChildScrollView(
//               child: Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: const Padding(
//                   padding: EdgeInsets.all(50),
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(
//                         color: deepTeal,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Please wait....",
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//
//   Future<void> _selectDueDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDueDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: home1,
//               onPrimary: Colors.white,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDueDate) {
//       setState(() {
//         _selectedDueDate = picked;
//       });
//     }
//   }
//
//   void _updateMember() {
//     if (_formKey.currentState!.validate()) {
//       // Here you would typically call your API to update the member
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Member updated successfully'),
//           backgroundColor: home1,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//       Navigator.pop(context, "Reload");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: home2),
//         title: const Text(
//           "Update Member",
//           style: TextStyle(
//             color: home2,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Opacity(
//             opacity: _fadeAnimation.value,
//             child: Transform.translate(
//               offset: Offset(0, _slideAnimation.value),
//               child: child,
//             ),
//           );
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//
//                 // Header with icon
//                 Center(
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: home1.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.person_outline,
//                       size: 40,
//                       color: home1,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Member Name Field
//                 SlideInAnimation(
//                   delay: 100,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Member Name",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: home2.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: Colors.grey.shade200),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 8,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _nameController,
//                           style: const TextStyle(color: home2, fontSize: 16),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                             hintText: "Enter member name",
//                             hintStyle: TextStyle(color: Colors.grey.shade500),
//                             prefixIcon: Container(
//                               margin: const EdgeInsets.only(right: 10),
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   right: BorderSide(
//                                     color: Colors.grey.shade300,
//                                     width: 1,
//                                   ),
//                                 ),
//                               ),
//                               child: Icon(Icons.person_outline,
//                                   size: 20, color: home1),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter member name';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Mobile Number Field
//                 SlideInAnimation(
//                   delay: 200,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Mobile Number",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: home2.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: Colors.grey.shade200),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 8,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _mobileController,
//                           keyboardType: TextInputType.phone,
//                           style: const TextStyle(color: home2, fontSize: 16),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                             hintText: "Enter mobile number",
//                             hintStyle: TextStyle(color: Colors.grey.shade500),
//                             prefixIcon: Container(
//                               margin: const EdgeInsets.only(right: 10),
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   right: BorderSide(
//                                     color: Colors.grey.shade300,
//                                     width: 1,
//                                   ),
//                                 ),
//                               ),
//                               child: Icon(Icons.phone_iphone,
//                                   size: 20, color: home1),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter mobile number';
//                             }
//                             if (value.length != 10) {
//                               return 'Please enter a valid 10-digit number';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Amount Field
//                 SlideInAnimation(
//                   delay: 300,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Amount",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: home2.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: Colors.grey.shade200),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 8,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _amountController,
//                           keyboardType: TextInputType.number,
//                           style: const TextStyle(color: home2, fontSize: 16),
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                             hintText: "Enter amount",
//                             hintStyle: TextStyle(color: Colors.grey.shade500),
//                             prefixIcon: Container(
//                               margin: const EdgeInsets.only(right: 10),
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   right: BorderSide(
//                                     color: Colors.grey.shade300,
//                                     width: 1,
//                                   ),
//                                 ),
//                               ),
//                               child: Icon(Icons.currency_rupee,
//                                   size: 20, color: home1),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter amount';
//                             }
//                             if (double.tryParse(value) == null) {
//                               return 'Please enter a valid amount';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Due Date Field
//                 SlideInAnimation(
//                   delay: 400,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Due Date",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: home2.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: () => _selectDueDate(context),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade50,
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(color: Colors.grey.shade200),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                           child: Row(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(right: 12),
//                                 child: Icon(Icons.calendar_today,
//                                     size: 20, color: home1),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   _selectedDueDate != null
//                                       ? DateFormat('dd MMM yyyy')
//                                           .format(_selectedDueDate!)
//                                       : "Select due date",
//                                   style: TextStyle(
//                                     color: _selectedDueDate != null
//                                         ? home2
//                                         : Colors.grey.shade500,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.arrow_drop_down,
//                                 color: home1,
//                                 size: 24,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//
//                 // Update Member Button
//                 SlideInAnimation(
//                   delay: 500,
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: (){ updateMember();},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: home1,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         elevation: 2,
//                         shadowColor: home1.withOpacity(0.3),
//                       ),
//                       child: const Text(
//                         "Update Member",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Animation Widget for staggered entrance
// class SlideInAnimation extends StatefulWidget {
//   final Widget child;
//   final int delay;
//
//   const SlideInAnimation({super.key, required this.child, this.delay = 0});
//
//   @override
//   _SlideInAnimationState createState() => _SlideInAnimationState();
// }
//
// class _SlideInAnimationState extends State<SlideInAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOut,
//       ),
//     );
//
//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) {
//         _controller.forward();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: widget.child,
//       ),
//     );
//   }
// }
