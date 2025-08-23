import 'package:collection_qr_flutter/data/provider/group/bank_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:collection_qr_flutter/core/colors.dart';
import 'package:provider/provider.dart';
import '../../../data/provider/group/bank_account_update_provider.dart';
import '../../../data/provider/group/update_group_provider.dart';
import '../../../data/storage/shared_pref_helper.dart';

class BankDetailsScreen extends StatefulWidget {
  final String? status;

  const BankDetailsScreen({
    super.key,
    this.status,
  });

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? statusType;
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _confirmAccountNumberController =
      TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();

  Map<String, dynamic>? _selectedBank;
  bool _isSubmitting = false;
  String? _custId;
  String? _corpCode;
  String? groupId;
  String? userId;

  @override
  void dispose() {
    _panNumberController.dispose();
    _accountNumberController.dispose();
    _confirmAccountNumberController.dispose();
    _ifscCodeController.dispose();
    super.dispose();
  }

  void loadSharedData() async {
    String custid = await SharedPref.shared.getCustId();
    String corpCode = await SharedPref.shared.getCorpCode();

    setState(() {
      _custId = custid;
      _corpCode = corpCode;
    });
    if (widget.status == "EDIT") {
      getBankDetail();
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final bankDetailSubmitProvider =
          Provider.of<BankDetailProvider>(context, listen: false);
      final bankDetailUpdateProvider =
      Provider.of<UpdateGroupProvider>(context, listen: false);
      statusType == "EDIT"?


      await bankDetailUpdateProvider.updateBankDetails(
          int.parse(groupId!),
          userId!,
          _panNumberController.text,
          _accountNumberController.text,
          _ifscCodeController.text,
          _corpCode!,
          _corpCode!,
          _custId!):
      await bankDetailSubmitProvider.submitBankDetails(
          _custId.toString(),
          _panNumberController.text,
          _accountNumberController.text,
          _ifscCodeController.text,
          _corpCode.toString(),
          _corpCode.toString(),
          _custId.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${bankDetailUpdateProvider.groupUpdateResponse?.message.toString()}"),
          backgroundColor: home2,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${bankDetailSubmitProvider.bankAccountModel?.message.toString()}"),
          backgroundColor: home2,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

      );
      _panNumberController.clear();
      _accountNumberController.clear();
      _ifscCodeController.clear();
      _confirmAccountNumberController.clear();
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  Future<void> getBankDetail() async {
    final bankAccountUpdateProvider =
        Provider.of<BankAccountUpdateProvider>(context, listen: false);
    print("cust id passed = ${_custId}");
    await bankAccountUpdateProvider
        .getBankAccountDetails(int.parse(_custId.toString()));
    setState(() {
      if (bankAccountUpdateProvider.bankAccountUpdateResponse != null) {
        statusType = "EDIT";
        _panNumberController.text = bankAccountUpdateProvider
            .bankAccountUpdateResponse!.data[0].accountHolderName
            .toString();
        _accountNumberController.text = bankAccountUpdateProvider
            .bankAccountUpdateResponse!.data[0].accountNumber
            .toString();
        _confirmAccountNumberController.text = bankAccountUpdateProvider
            .bankAccountUpdateResponse!.data[0].accountNumber
            .toString();
        _ifscCodeController.text = bankAccountUpdateProvider
            .bankAccountUpdateResponse!.data[0].ifsc
            .toString();
        userId= bankAccountUpdateProvider.bankAccountUpdateResponse!.data[0].userId.toString();

        setState(() {
          groupId = bankAccountUpdateProvider
              .bankAccountUpdateResponse!.data[0].accountId.toString();
        });
      } else {
        statusType = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: widget.status == "EDIT" ? true : false,
        centerTitle: true,
        title: const Text(
          "Bank Details",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: home2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                widget.status == "EDIT" && statusType == "EDIT"
                    ? "Update your bank information"
                    : 'Enter your bank information',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Bank Selection with Logo
              //   _buildLabel('Select Your Bank'),
              //  const SizedBox(height: 8),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.grey[50],
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.grey[200]!),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: DropdownButtonFormField<Map<String, dynamic>>(
              //     value: _selectedBank,
              //     decoration: const InputDecoration(border: InputBorder.none),
              //     icon: Icon(Icons.arrow_drop_down, color: home2),
              //     style: TextStyle(color: home2, fontSize: 16),
              //     hint: Text('Select bank', style: TextStyle(color: Colors.grey[500])),
              //     items: _banks.map((bank) => DropdownMenuItem(
              //       value: bank,
              //       child: Row(
              //         children: [
              //           // Display bank logo
              //           CircleAvatar(
              //             radius: 12,
              //             backgroundImage: AssetImage(bank['logo']),
              //           ),
              //           const SizedBox(width: 12),
              //           Text(bank['name'], style: TextStyle(color: home2)),
              //         ],
              //       ),
              //     )).toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         _selectedBank = value;
              //         _ifscCodeController.clear();
              //       });
              //       _updateIfscCode();
              //     },
              //     validator: (value) => value == null ? 'Please select your bank' : null,
              //   ),
              // ),
              const SizedBox(height: 20),

              // PAN Card Field with Icon
              _buildTextField(
                controller: _panNumberController,
                label: 'Account Holder Name',
                hint: 'Account Holder',
                icon: Icons.account_circle_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  // if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value.toUpperCase())) {
                  //   return 'Invalid PAN format';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Account Number Field with Icon
              _buildTextField(
                controller: _accountNumberController,
                label: 'Account Number',
                hint: '1234567890',
                keyboardType: TextInputType.number,
                icon: Icons.account_balance,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length < 9 || value.length > 18) {
                    return 'Must be 9-18 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm Account Number with Icon
              _buildTextField(
                controller: _confirmAccountNumberController,
                label: 'Confirm Account Number',
                hint: '1234567890',
                keyboardType: TextInputType.number,
                icon: Icons.verified_user,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value != _accountNumberController.text) {
                    return 'Account numbers don\'t match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // IFSC Code Field with Icon and Auto-fill
              _buildTextField(
                controller: _ifscCodeController,
                label: 'IFSC Code',
                hint: 'ABCD0123456',
                icon: Icons.code,
                // readOnly: _selectedBank == null,
                // onTap: _selectedBank == null
                //     ? () {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             content: const Text('Please select bank first'),
                //             backgroundColor: home2,
                //           ),
                //         );
                //       }
                //     : null,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                      .hasMatch(value.toUpperCase())) {
                    return 'Invalid IFSC format';
                  }
                  return null;
                },
              ),
              if (_selectedBank != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Start with ${_selectedBank!['code']}0 followed by branch code',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: home1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.status == "EDIT" && statusType == "EDIT"
                              ? "UPDATE BANK DETAILS"
                              : 'SAVE BANK DETAILS',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: home2,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(color: home2, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: Icon(icon, color: home1),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: home2, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
// void _updateIfscCode() {
//   if (_selectedBank != null && _ifscCodeController.text.isEmpty) {
//     setState(() {
//       _ifscCodeController.text = '${_selectedBank!['code']}0XXXXXX';
//     });
//   }
// }
