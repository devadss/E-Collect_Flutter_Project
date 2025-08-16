import 'package:collection_qr_flutter/core/alerts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this to pubspec.yaml if not already
import '../../../core/colors.dart'; // Assuming `home1` color is defined there

class BankAccoutDetailPage extends StatefulWidget {
  const BankAccoutDetailPage({super.key});

  @override
  State<BankAccoutDetailPage> createState() => _BankAccoutDetailPageState();
}

class _BankAccoutDetailPageState extends State<BankAccoutDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _panNoController = TextEditingController();
  final TextEditingController _bnkAccController = TextEditingController();
  final TextEditingController _confirmBnkAccController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final _panFocusNode = FocusNode();
  final _bnkAccFocusNode = FocusNode();
  final _confirmBnkAccFocusNode = FocusNode();
  final _ifscFocusNode = FocusNode();
  AutovalidateMode _panAutoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _confirmBnkAccAutoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _bnkAccAutoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode _ifscAutoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    // TODO
    super.initState();

    _panFocusNode.addListener(() {
      if (!_panFocusNode.hasFocus) {
        setState(() {
          _panAutoValidateMode = AutovalidateMode.always;
        });
      }
    });

    _bnkAccFocusNode.addListener(() {
      if (!_bnkAccFocusNode.hasFocus) {
        setState(() {
          _bnkAccAutoValidateMode = AutovalidateMode.always;
        });
      }
    });

    _confirmBnkAccFocusNode.addListener(() {
      if (!_confirmBnkAccFocusNode.hasFocus) {
        setState(() {
          _confirmBnkAccAutoValidateMode = AutovalidateMode.always;
        });
      }
    });

    _ifscFocusNode.addListener(() {
      if (!_ifscFocusNode.hasFocus) {
        setState(() {
          _ifscAutoValidateMode = AutovalidateMode.always;
        });
      }
    });
  }

  bool isValidPan(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    return panRegex.hasMatch(pan);
  }

  bool isValidIFSC(String ifsc) {
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    return ifscRegex.hasMatch(ifsc);
  }

  @override
  void dispose() {
    _panNoController.dispose();
    _bnkAccController.dispose();
    _confirmBnkAccController.dispose();
    _ifscController.dispose();

    _panFocusNode.dispose();
    _bnkAccFocusNode.dispose();
    _confirmBnkAccFocusNode.dispose();
    _ifscFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Bank Details"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("PAN Number"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: "PAN Number",
                    icon: Icons.credit_card,
                    contrlr: _panNoController,
                    fieldName: 'pan',
                    focusNode: _panFocusNode,
                    autoValidateMode: _panAutoValidateMode,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Bank Account Number"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: "Enter bank account number",
                    icon: Icons.account_balance_wallet,
                    contrlr: _bnkAccController,
                    fieldName: 'bnk_no',
                    focusNode: _bnkAccFocusNode,
                    autoValidateMode: _bnkAccAutoValidateMode,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Confirm Account Number"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: "Re-enter account number",
                    icon: Icons.repeat,
                    contrlr: _confirmBnkAccController,
                    fieldName: 're_bnk_no',
                    focusNode: _confirmBnkAccFocusNode,
                    autoValidateMode: _confirmBnkAccAutoValidateMode,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("IFSC Code"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: "Enter IFSC code",
                    icon: Icons.qr_code,
                    contrlr: _ifscController,
                    fieldName: 'ifsc',
                    focusNode: _ifscFocusNode,
                    autoValidateMode: _ifscAutoValidateMode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: home1,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if(_bnkAccController.text != _confirmBnkAccController.text){
              showToast(message: "Account no mis-match", color: Colors.red);
            }else{
              if (_formKey.currentState!.validate()) {
              } else {
                print("_bnkAccController : ${_bnkAccController.text}");
                print("_confirmBnkAccController : ${_confirmBnkAccController.text}");

                showToast(message: "Empty fields not allowed", color: Colors.red);
              }
            }


            // Add your validation logic here
          },
          child: const Text(
            "Proceed",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController contrlr,
    required String fieldName,
    required FocusNode focusNode,
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled,
  }) {
    return TextFormField(
      keyboardType: fieldName == "bnk_no"
          ? TextInputType.number
          : fieldName == "re_bnk_no"
              ? TextInputType.number
              : TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      maxLength: fieldName == "pan"
          ? 10
          : fieldName == "ifsc"
              ? 11
              : 18,
      controller: contrlr,
      focusNode: focusNode,
      autovalidateMode: autoValidateMode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          switch (fieldName) {
            case 'pan':
              return "PAN number is required";
            case 'bnk_no':
              return "Bank account number is required";
            case 're_bnk_no':
              return "Confirm Bank account number is required";
            case 'ifsc':
              return "IFSC code is required";
          }
        } else {
          switch (fieldName) {
            case "pan":
              if (isValidPan(value) == false) {
                return "Invalid pan";
              }
            case "ifsc":
              if (isValidIFSC(value) == false) {
                return "Invalid Ifsc";
              }
          }
        }
        return null;
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: hint,
        prefixIcon: Icon(icon, color: home1),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: home1, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
