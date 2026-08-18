
import 'dart:math';

import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/core/utils.dart';
import 'package:collection_qr_flutter/data/e_collect_bloc/authentication_bloc/authentication_bloc.dart';
import 'package:collection_qr_flutter/domain/model/e_collect/merchant_registation_model/request/merchant_request_model.dart';
import 'package:collection_qr_flutter/presentation/auth/login/mobile_number_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // ==================== MANDATORY FIELDS ====================
  final TextEditingController merchantNameController = TextEditingController();
  final TextEditingController registeredPhoneController =
      TextEditingController();
  final TextEditingController registeredEmailController =
      TextEditingController();
  final TextEditingController businessAddressController =
      TextEditingController();
  final TextEditingController entityPanController = TextEditingController();
  final TextEditingController nameOnPanController = TextEditingController();

  // Settlement Account (Mandatory)
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();

  // ==================== OPTIONAL FIELDS ====================
  final TextEditingController merchantLegalNameController =
      TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController monthlyVolumeController = TextEditingController();
  final TextEditingController monthlyTransactionsController =
      TextEditingController();
  final TextEditingController averageTicketSizeController =
      TextEditingController();

  // Optional: Secondary Contact / Authorized Signatory
  final TextEditingController secondaryContactNameController =
      TextEditingController();
  final TextEditingController secondaryContactPhoneController =
      TextEditingController();
  final TextEditingController secondaryContactEmailController =
      TextEditingController();

  String? selectedBusinessCategory;
  String? selectedEntityType;
  String? selectedAccountType;
  String? selectedBankName;
  String? selectedBranchName;
  String? ifscStored;
  bool ifscCalled = false;

  // Document Uploads (Mandatory based on entity type)
  final Map<String, String?> uploadedFiles = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> businessCategories = const [
    'Education',
    'Tuition Centre',
    'School',
    'College',
    'Gym',
    'Healthcare',
    'Retail',
    'Restaurant',
    'E-Commerce',
    'Finance',
    "Chitty",
    'NBFC',
    'Gold Loan',
    'Travel',
    'Hotel',
    'NGO',
    'Others'
  ];

  final List<String> entityTypes = const [
    'Individual',
    'Proprietorship',
    'Partnership',
    'Private Limited',
    'LLP',
    'Trust',
    'Society'
  ];

  final List<String> accountTypes = const ['Savings', 'Current'];

  @override
  void initState() {
    super.initState();
    monthlyVolumeController.addListener(calculateTicketSize);
    monthlyTransactionsController.addListener(calculateTicketSize);
  }

  void calculateTicketSize() {
    final volume = double.tryParse(monthlyVolumeController.text) ?? 0;
    final transactions = int.tryParse(monthlyTransactionsController.text) ?? 0;
    if (transactions > 0) {
      averageTicketSizeController.text =
          (volume / transactions).toStringAsFixed(2);
    } else {
      averageTicketSizeController.clear();
    }
  }

  Future<void> _pickFile(String key) async {
    final result = await FilePicker.pickFiles();
    if (result != null) {
      setState(() {
        uploadedFiles[key] = result.files.single.name;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print(selectedBusinessCategory);

      await SharedPref.shared
          .setBusinessCategory(selectedBusinessCategory.toString());
      // Log mandatory fields collected
      print('Onboarding completed with mandatory fields only');

      var settModel = SettlementAccount(
          accountHolderName: accountHolderNameController.text,
          accountNumber: accountNumberController.text,
          accountType: selectedAccountType!,
          bankName: selectedBankName!,
          bankBranch: selectedBranchName!,
          ifsCCode: ifscCodeController.text,
          isPrimary: true,
          isActive: true);

      var merchRegReqModel = MerchantRegistrationRequestModel(
          merchantName: merchantNameController.text,
          merchantLegalName: merchantNameController.text,
          registeredEmail: registeredEmailController.text,
          registeredPhone: registeredPhoneController.text,
          businessCategory: selectedBusinessCategory!,
          entityType: selectedEntityType!,
          registeredAddress: businessAddressController.text,
          entityPAN: entityPanController.text,
          nameOnPAN: nameOnPanController.text,
          gstNumber: gstController.text.isEmpty
              ? generateRandomGST()
              : gstController.text,
          gstState: "KERALA",
          username: merchantNameController.text,
          password: "${merchantNameController.text}@1234",
          confirmPassword: "${merchantNameController.text}@1234",
          settlementAccounts: [settModel], integrationStatus: 'Y');
      merchRegReqModel.printValues();
      if (!mounted) return;
      context.read<AuthenticationBloc>().add(OnboardingEvent(merchRegReqModel));
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MobileNumberVerificationPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Merchant Onboarding',
            style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 12,
        backgroundColor: home1,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (BuildContext context, AuthenticationState state) {
                  if(state is OnboardingStatusLoaderState){
                    showProgressDialog(context);
                  }
                  if (state is OnboardingStatusSuccessState) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.iOnboardOkModel
                            .merchantRegistrationSuccess.message)));
                    merchantNameController.clear();
                    registeredPhoneController.clear();
                    registeredEmailController.clear();
                    businessAddressController.clear();
                    entityPanController.clear();
                    nameOnPanController.clear();
                    accountHolderNameController.clear();
                    accountNumberController.clear();
                    ifscCodeController.clear();
                    merchantLegalNameController.clear();
                    websiteUrlController.clear();
                    gstController.clear();
                    registrationNumberController.clear();
                    monthlyVolumeController.clear();
                    monthlyTransactionsController.clear();
                    averageTicketSizeController.clear();
                    secondaryContactNameController.clear();
                    secondaryContactPhoneController.clear();
                    secondaryContactEmailController.clear();
                  }else if (state is OnboardingStatusFailureState){
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.onboardFailModel.merchantRegistrationFailResponse.message)));
                  }
                },
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (BuildContext context, AuthenticationState state) {
                  if (state is IfscBranchLoaderState) {
                    showProgressDialog(context);
                  }
                  if (state is IfscBranchSuccessState) {
                    Navigator.pop(context);
                    print(state.ifscCodeOkModel.bankIfscSuccessModel.bank);
                    print(state.ifscCodeOkModel.bankIfscSuccessModel.branch);

                    setState(() {
                      ifscStored =
                          state.ifscCodeOkModel.bankIfscSuccessModel.ifsc;
                      selectedBranchName =
                          state.ifscCodeOkModel.bankIfscSuccessModel.branch;
                      selectedBankName =
                          state.ifscCodeOkModel.bankIfscSuccessModel.bank;
                    });
                  } else if (state is IfscBranchFailureState) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      state.ifscCodeFailModel.ifscCodeFail,
                    )));
                  }
                },
              ),
            ],
            child: Column(
              children: [
                _buildMandatorySection(),
                const SizedBox(height: 24),
                _buildOptionalSection(),
                const SizedBox(height: 24),
                _buildDocumentUploadSection(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String generateRandomGST() {
    final random = Random();

    // 1. Random State Code (01 to 37)
    final stateCode = (random.nextInt(37) + 1).toString().padLeft(2, '0');

    // 2. Random PAN Structure (5 Letters + 4 Digits + 1 Letter)
    final panLetters = List.generate(5, (_) => _randomChar('ABCDEFGHIJKLMNOPQRSTUVWXYZ', random)).join();
    final panDigits = List.generate(4, (_) => _randomChar('0123456789', random)).join();
    final panLastLetter = _randomChar('ABCDEFGHIJKLMNOPQRSTUVWXYZ', random);
    final pan = '$panLetters$panDigits$panLastLetter';

    // 3. Random Entity Code (1-9 or A-Z)
    final entityCode = _randomChar('123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', random);

    // 4. Default Character
    const defaultZ = 'Z';

    // 5. Random Checksum Character
    final checksum = _randomChar('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', random);

    return '$stateCode$pan$entityCode$defaultZ$checksum';
  }

  String _randomChar(String pool, Random random) {
    return pool[random.nextInt(pool.length)];
  }
  // ==================== SECTION 1: MANDATORY FIELDS ====================
  Widget _buildMandatorySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Required Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Merchant Name
            _buildTextField(
              controller: merchantNameController,
              label: 'Merchant Name *',
              hint: 'Enter merchant name',
              icon: Icons.person,
            ),

            // Registered Phone Number
            _buildTextField(
              controller: registeredPhoneController,
              label: 'Registered Phone Number *',
              hint: 'Enter phone number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
                if (!phoneRegex.hasMatch(value)) {
                  return 'Enter a valid 10-digit mobile number';
                }
                return null;
              },
            ),

            // Registered Business Email
            _buildTextField(
              controller: registeredEmailController,
              label: 'Registered Business Email *',
              hint: 'Enter business email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email';
                }
                final emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            // Business Category
            _buildDropdown(
              value: selectedBusinessCategory,
              items: businessCategories,
              label: 'Business Category *',
              icon: Icons.category,
              onChanged: (value) =>
                  setState(() => selectedBusinessCategory = value),
            ),

            // Entity Type
            _buildDropdown(
              value: selectedEntityType,
              items: entityTypes,
              label: 'Entity Type *',
              icon: Icons.business_center,
              onChanged: (value) => setState(() {
                selectedEntityType = value;
                _updateDocumentList();
              }),
            ),

            // Business Address
            _buildTextField(
              controller: businessAddressController,
              label: 'Business Address *',
              hint: 'Enter complete address',
              icon: Icons.location_on,
              keyboardType: TextInputType.streetAddress,
            ),

            // PAN (Mandatory for all entity types)
            _buildTextField(
              controller: entityPanController,
              label: 'PAN *',
              hint: 'ABCDE1234F',
              icon: Icons.credit_card,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter PAN';
                }
                if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                    .hasMatch(value.trim().toUpperCase())) {
                  return 'Please enter a valid PAN (e.g., ABCDE1234F)';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: nameOnPanController,
              label: 'Name as on PAN',
              hint: 'Enter Name',
              icon: Icons.personal_injury_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter Name as on PAN';
                }
                return null;
              },
            ),

            // Settlement Bank Account
            const SizedBox(height: 8),
            const Text(
              'Settlement Bank Account *',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),

            _buildTextField(
              controller: accountHolderNameController,
              label: 'Account Holder Name *',
              hint: 'Enter account holder name',
              icon: Icons.person,
            ),

            _buildTextField(
              controller: accountNumberController,
              label: 'Account Number *',
              hint: 'Enter account number',
              icon: Icons.account_balance,
              keyboardType: TextInputType.number,
            ),

            _buildDropdown(
              value: selectedAccountType,
              items: accountTypes,
              label: 'Account Type *',
              icon: Icons.merge_type,
              onChanged: (value) => setState(() => selectedAccountType = value),
            ),

            _buildTextField(
              controller: ifscCodeController,
              label: 'IFSC Code *',
              hint: 'SBIN0001234',
              icon: Icons.pin,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter IFSC Code';
                }
                if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                    .hasMatch(value.trim().toUpperCase())) {
                  return 'Please enter a valid IFSC Code';
                } else {
                  print("match");
                  print("ifscStored?.isEmpty ${ifscStored?.isEmpty}");
                  print("ifscStored != value ${ifscStored != value}");
                  if (ifscStored?.isNotEmpty == null) {
                    context
                        .read<AuthenticationBloc>()
                        .add(IfscBranchEvent(value));
                  }
                  if (ifscStored?.isNotEmpty == true) {
                    if (!ifscStored!.contains(value) == true) {
                      context
                          .read<AuthenticationBloc>()
                          .add(IfscBranchEvent(value));
                    }
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 2: OPTIONAL FIELDS ====================
  Widget _buildOptionalSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: const Text(
                    'Additional Information (Optional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These fields are optional and can be completed later. '
                      'Providing them now helps us serve you better.',
                      style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Merchant Legal Name
            // _buildTextField(
            //   controller: merchantLegalNameController,
            //   label: 'Merchant Legal Name (Optional)',
            //   hint: 'Enter legal name if different',
            //   icon: Icons.person_outline,
            //   isRequired: false,
            // ),
            //
            // // Website URL
            // _buildTextField(
            //   controller: websiteUrlController,
            //   label: 'Website URL (Optional)',
            //   hint: 'https://example.com',
            //   icon: Icons.web,
            //   isRequired: false,
            // ),

            // GST
            _buildTextField(
              controller: gstController,
              label: 'GST (Optional)',
              hint: 'Enter GST number if applicable',
              icon: Icons.numbers,
              isRequired: false,
            ),

            // Registration Number
            _buildTextField(
              controller: registrationNumberController,
              label: 'Registration Number (Optional)',
              hint: 'Enter registration number if applicable',
              icon: Icons.document_scanner,
              isRequired: false,
            ),

            // Expected Volume & Transactions
            // const SizedBox(height: 8),
            // const Text(
            //   'Business Projections',
            //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            // ),
            // const SizedBox(height: 8),
            //
            // _buildTextField(
            //   controller: monthlyVolumeController,
            //   label: 'Monthly Expected Volume (Optional)',
            //   hint: 'Enter expected monthly volume',
            //   icon: Icons.currency_rupee,
            //   isRequired: false,
            //   keyboardType: TextInputType.number,
            // ),
            //
            // _buildTextField(
            //   controller: monthlyTransactionsController,
            //   label: 'Monthly Expected Transactions (Optional)',
            //   hint: 'Enter expected number of transactions',
            //   icon: Icons.transfer_within_a_station,
            //   isRequired: false,
            //   keyboardType: TextInputType.number,
            // ),
            //
            // _buildTextField(
            //   controller: averageTicketSizeController,
            //   label: 'Average Ticket Size',
            //   hint: 'Auto-calculated from above values',
            //   icon: Icons.calculate,
            //   readOnly: true,
            //   isRequired: false,
            // ),

            // Secondary Contact Details (Optional)
            // const SizedBox(height: 16),
            // const Text(
            //   'Secondary Contact / Authorized Signatory (Optional)',
            //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            // ),
            // const SizedBox(height: 8),
            //
            // _buildTextField(
            //   controller: secondaryContactNameController,
            //   label: 'Name (Optional)',
            //   hint: 'Enter contact person name',
            //   icon: Icons.person_add,
            //   isRequired: false,
            // ),
            //
            // _buildTextField(
            //   controller: secondaryContactPhoneController,
            //   label: 'Phone (Optional)',
            //   hint: 'Enter phone number',
            //   icon: Icons.phone_android,
            //   isRequired: false,
            //   keyboardType: TextInputType.phone,
            // ),
            //
            // _buildTextField(
            //   controller: secondaryContactEmailController,
            //   label: 'Email (Optional)',
            //   hint: 'Enter email address',
            //   icon: Icons.email_outlined,
            //   isRequired: false,
            //   keyboardType: TextInputType.emailAddress,
            // ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 3: DOCUMENTS (Mandatory) ====================
  Widget _buildDocumentUploadSection() {
    if (selectedEntityType == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.upload_file, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'Required Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            ..._getDocumentKeys().map((key) => _buildUploadTile(key, key)),
          ],
        ),
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    bool isRequired = true,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: home1) : null,
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEA307B), width: 2),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[100] : Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: validator ??
            (isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  }
                : null),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    IconData? icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: home1) : null,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEA307B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildUploadTile(String title, String key) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEA307B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.upload_file,
                color: const Color(0xFFEA307B), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                if (uploadedFiles[key] != null)
                  Text(
                    uploadedFiles[key]!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _pickFile(key),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEA307B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(80, 32),
            ),
            child: Text(uploadedFiles[key] != null ? 'Update' : 'Upload'),
          ),
        ],
      ),
    );
  }

  List<String> _getDocumentKeys() {
    if (selectedEntityType == null) return [];

    switch (selectedEntityType) {
      case 'Individual':
        return ['PAN Card', 'Aadhaar Card'];
      case 'Proprietorship':
        return ['PAN Card', 'GST Certificate'];
      case 'Partnership':
        return ['PAN Card', 'GST Certificate', 'Partnership Deed'];
      case 'Private Limited':
        return ['PAN Card', 'GST Certificate', 'Certificate of Incorporation'];
      case 'LLP':
        return ['PAN Card', 'GST Certificate', 'LLP Certificate'];
      case 'Trust':
        return ['PAN Card', 'Trust Registration Certificate'];
      case 'Society':
        return ['PAN Card', 'Society Registration Certificate'];
      default:
        return ['PAN Card'];
    }
  }

  void _updateDocumentList() {
    setState(() {
      uploadedFiles.clear();
      final documentKeys = _getDocumentKeys();
      for (var key in documentKeys) {
        uploadedFiles[key] = null;
      }
    });
  }

  // ==================== SUBMIT BUTTON ====================
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEA307B),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: const Text(
          'Complete Onboarding',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Mandatory Controllers
    merchantNameController.dispose();
    registeredPhoneController.dispose();
    registeredEmailController.dispose();
    businessAddressController.dispose();
    entityPanController.dispose();
    nameOnPanController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();

    // Optional Controllers
    merchantLegalNameController.dispose();
    websiteUrlController.dispose();
    gstController.dispose();
    registrationNumberController.dispose();
    monthlyVolumeController.dispose();
    monthlyTransactionsController.dispose();
    averageTicketSizeController.dispose();
    secondaryContactNameController.dispose();
    secondaryContactPhoneController.dispose();
    secondaryContactEmailController.dispose();

    super.dispose();
  }
}
