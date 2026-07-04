import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/colors.dart';

class MerchantBucketCreationPage extends StatefulWidget {
  final int selectedIndex;
  final int groupId;

  const MerchantBucketCreationPage({
    super.key,
    required this.selectedIndex,
    required this.groupId,
  });

  @override
  State<MerchantBucketCreationPage> createState() =>
      _MerchantBucketCreationPageState();
}

class _MerchantBucketCreationPageState
    extends State<MerchantBucketCreationPage> {
  // Controllers for group info
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupAmountController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController reminderDateController = TextEditingController();

  // Member management
  List<Member> members = [];
  bool isLoanEntity = true;
  // Selected reminder options
  String selectedReminderOption = '1 day before';
  final List<String> reminderOptions = [
    '1 day before',
    '2 days before',
    '3 days before',
    '1 week before',
    '2 weeks before',
    '1 month before',
  ];
  void updateEmi(Member member) {
    final amount = double.tryParse(member.amountController.text) ?? 0;
    final interest = double.tryParse(member.interestController.text) ?? 0;
    final tenure = int.tryParse(member.tenureController.text) ?? 0;

    if (amount > 0 && interest > 0 && tenure > 0) {
      final emi = calculateEmi(amount, interest, tenure);
      member.emiController.text = emi.toStringAsFixed(2);
    } else {
      member.emiController.clear();
    }
  }
  double calculateEmi(double principleAmount, double interestRate, int tenure) {
    var monthlyInterest = (interestRate*0.01) / 12;
    var emi = (principleAmount * monthlyInterest *
        pow((1 + monthlyInterest), tenure))
        / ((pow((1 + monthlyInterest), tenure)) - 1);
    return emi;
  }

  @override
  void dispose() {
    groupNameController.dispose();
    groupAmountController.dispose();
    dueDateController.dispose();
    reminderDateController.dispose();
    for (var member in members) {
      member.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addMember() {
    setState(() {
      members.add(Member());
    });
  }

  void _removeMember(int index) {
    setState(() {
      members[index].dispose();
      members.removeAt(index);
    });
  }

  void _submitGroup() {
    var emi = calculateEmi(
        double.parse(members[0].amountController.text),
        double.parse(members[0].interestController.text),
        int.parse(members[0].tenureController.text));
    print(emi);
    print("Total EMI : ${(emi)*int.parse(members[0].tenureController.text)-int.parse(members[0].amountController.text)}");
    // Validate
    if (groupNameController.text.isEmpty) {
      _showSnackBar('Please enter group name');
      return;
    }
    if (groupAmountController.text.isEmpty) {
      _showSnackBar('Please enter group amount');
      return;
    }
    if (members.isEmpty) {
      _showSnackBar('Please add at least one member');
      return;
    }
    if (dueDateController.text.isEmpty) {
      _showSnackBar('Please select due date');
      return;
    }

    // Collect member data
    List<Map<String, dynamic>> memberData = [];
    for (var member in members) {
      if (member.nameController.text.isEmpty) {
        _showSnackBar('Please enter name for all members');
        return;
      }
      if (member.amountController.text.isEmpty) {
        _showSnackBar('Please enter amount for all members');
        return;
      }
      memberData.add({
        'name': member.nameController.text,
        'amount': double.tryParse(member.amountController.text) ?? 0,
        'phone': member.phoneController.text,
        'email': member.emailController.text,
        'dueDate': dueDateController.text,
        'reminderDate': reminderDateController.text,
        'reminderOption': selectedReminderOption,
      });
    }

    // Here you would save the data
    _showSnackBar('Group created successfully!');

    // Print for debugging
    print('Group: ${groupNameController.text}');
    print('Amount: ${groupAmountController.text}');
    print('Due Date: ${dueDateController.text}');
    print('Reminder Date: ${reminderDateController.text}');
    print('Reminder Option: $selectedReminderOption');
    print('Members: $memberData');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFFEA307B),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.selectedIndex == 889898493849
              ? "Create a Bucket"
              : "Update Bucket",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A237E)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submitGroup,
            child: const Text(
              '',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Information Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: groupNameController,
                      hintText: 'Enter bucket name',
                      label: 'Bucket Name',
                      icon: Icons.group,
                    ),
                    const SizedBox(height: 12),
                    isLoanEntity == false
                        ? _buildTextField(
                            controller: groupAmountController,
                            hintText: 'Enter default amount',
                            label: 'Default Amount',
                            icon: Icons.currency_rupee,
                            keyboardType: TextInputType.number,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Members Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _addMember,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Member'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (members.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No members added yet',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: _addMember,
                              child: const Text('Add your first member'),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 16),
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return _buildMemberCard(index, member);
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Schedule Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule & Reminders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      controller: dueDateController,
                      label: 'Due Date',
                      hintText: 'Select due date',
                      icon: Icons.event_note,
                      onTap: () => _selectDate(context, dueDateController),
                    ),
                    const SizedBox(height: 12),

                    _buildDateField(
                      controller: reminderDateController,
                      label: 'Reminder Date',
                      hintText: 'Select reminder date',
                      icon: Icons.notifications,
                      onTap: () => _selectDate(context, reminderDateController),
                    ),
                    const SizedBox(height: 12),

                    // Reminder Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedReminderOption,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 14),
                          items: reminderOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedReminderOption = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: home1,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  shadowColor: home1.withValues(alpha: 0.3),
                ),
                onPressed: _submitGroup,
                child: Text(
                  widget.selectedIndex == 889898493849
                      ? "Create Group"
                      : "Update Group",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(int index, Member member) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF1A237E),
                radius: 18,
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Member ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeMember(index),
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSimpleTextField(
                  controller: member.nameController,
                  hintText: 'Full name',
                  label: 'Name',
                ),
              ),
              const SizedBox(width: 8),
              isLoanEntity == true
                  ? Expanded(
                      child: _buildSimpleTextField(
                        controller: member.amountController,
                        hintText: 'Enter Loan Amount',
                        label: 'Loan Amount',
                        keyboardType: TextInputType.number,
                      ),
                    )
                  : Expanded(
                      child: _buildSimpleTextField(
                        controller: member.amountController,
                        hintText: 'Amount',
                        label: 'Amount',
                        keyboardType: TextInputType.number,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          isLoanEntity == true
              ? Row(
                  children: [
                    Expanded(
                      child: _buildSimpleTextField(
                        controller: member.interestController,
                        hintText: '% Interest Rate',
                        label: 'Interest Rate',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSimpleTextField(
                        controller: member.tenureController,
                        hintText: 'Enter Loan Tenure',
                        label: 'Loan Tenure',
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                )
              : SizedBox.shrink(),
          const SizedBox(height: 8),
          isLoanEntity == true
              ? _buildSimpleTextField(
                  controller: member.emiController,
                  hintText: 'EMI Amount',
                  label: 'EMI Amount',
                )
              : SizedBox.shrink(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSimpleTextField(
                  controller: member.phoneController,
                  hintText: 'Phone number',
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSimpleTextField(
                  controller: member.emailController,
                  hintText: 'Email address',
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1A237E)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1A237E)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1A237E)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          isDense: true,
        ),
        child: Text(
          controller.text.isEmpty ? hintText : controller.text,
          style: TextStyle(
            color:
                controller.text.isEmpty ? Colors.grey.shade400 : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// Member Model
class Member {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();
  final TextEditingController emiController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void dispose() {
    nameController.dispose();
    amountController.dispose();
    interestController.dispose();
    tenureController.dispose();
    emiController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
  Member() {
    amountController.addListener(_updateEmi);
    interestController.addListener(_updateEmi);
    tenureController.addListener(_updateEmi);
  }

  void _updateEmi() {
    final amount = double.tryParse(amountController.text) ?? 0;
    final interest = double.tryParse(interestController.text) ?? 0;
    final tenure = int.tryParse(tenureController.text) ?? 0;

    if (amount > 0 && interest > 0 && tenure > 0) {
      var monthlyInterest = (interest*0.01) / 12;
      var emi = (amount * monthlyInterest *
          pow((1 + monthlyInterest), tenure))
          / ((pow((1 + monthlyInterest), tenure)) - 1);

      emiController.text = emi.toString();
    } else {
      emiController.clear();
    }
  }
    TextEditingController calculateEmiNew(double principleAmount, double interestRate, int tenure) {
    var monthlyInterest = (interestRate*0.01) / 12;
    var emi = (principleAmount * monthlyInterest *
        pow((1 + monthlyInterest), tenure))
        / ((pow((1 + monthlyInterest), tenure)) - 1);

    emiController.text = emi.toString();
    return emiController;
  }
}
