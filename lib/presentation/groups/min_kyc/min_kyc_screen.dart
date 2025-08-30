import 'dart:convert';
import 'dart:math';
import 'package:collection_qr_flutter/core/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pointycastle/export.dart' as pc;

import '../../../core/colors.dart';
import '../../../core/constants.dart';
import '../../../data/provider/cust_register_provider.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../select_category_screen.dart';

class MinKycScreen extends StatefulWidget {
  final String mobileNum;
  final String tokenValue;
  final String fullName;
  final String aadhaarNumber;
  final String gender;
  final String address;
  final String fatherName;
  final String dob;
  final String houseName;
  final String street;
  final String state;
  final String pincode;
  final String city;
  final String area;

  const MinKycScreen(
      {super.key,
      required this.mobileNum,
      required this.tokenValue,
      required this.fullName,
      required this.aadhaarNumber,
      required this.gender,
      required this.address,
      required this.fatherName,
      required this.dob,
      required this.houseName,
      required this.street,
      required this.state,
      required this.pincode,
      required this.city,
      required this.area});

  @override
  State<MinKycScreen> createState() => _MinKycScreenState();
}

class _MinKycScreenState extends State<MinKycScreen>
    with TickerProviderStateMixin {
  String? _selectedTile;
  String? _selectedGender;
  String? _selectedMaritalstatus;
  String? _selectedDocument;
  bool _showOtpField = false;
  bool _isOtpSent = false;
  final TextEditingController _otpController = TextEditingController();
  String _generatedOtp = '';
  bool _showRequestOtpButton = false;
  bool _isSubmitting = false;
  double _progressValue = 0.7;
  String? generatedEntityId;
  String? generatedCorpCode;
  String secretKey = "770A8A65DA156D24EE2A093277530142";
  String initialVector = "1234567890123456";

  // Animation controllers
  late AnimationController _titleAnimationController;
  late Animation<double> _titleAnimation;
  late AnimationController _submitButtonController;
  late Animation<double> _submitButtonAnimation;

  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _permanentHouseNameController =
      TextEditingController();
  final TextEditingController _permanentStreetLocalityController =
      TextEditingController();
  final TextEditingController _permanentAreaNameController =
      TextEditingController();
  final TextEditingController _permanentCityNameController =
      TextEditingController();
  final TextEditingController _permanentStateNameController =
      TextEditingController();
  final TextEditingController _permanentPinCodeController =
      TextEditingController();
  final TextEditingController _communicationHouseNameController =
      TextEditingController();
  final TextEditingController _communicationStreetLocalityController =
      TextEditingController();
  final TextEditingController _communicationAreaNameController =
      TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _stateNameController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController textControllerDD = TextEditingController();
  final TextEditingController textControllerMM = TextEditingController();
  final TextEditingController textControllerYYYY = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();

  bool _sameAsPermanentAddress = false;
  bool _isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String?> splitName(String fullName) {
    List<String> parts = fullName.trim().split(RegExp(r'\s+'));

    String? first;
    String? middle;
    String? last;

    if (parts.isEmpty) {
      return {'first': null, 'middle': null, 'last': null};
    }

    if (parts.length == 1) {
      first = parts[0];
    } else if (parts.length == 2) {
      first = parts[0];
      last = parts[1];
    } else {
      first = parts[0];
      last = parts.last;
      middle = parts.sublist(1, parts.length - 1).join(' ');
    }

    return {
      'first': first,
      'middle': middle,
      'last': last,
    };
  }

  @override
  void initState() {
    super.initState();
    Map<String, String?> nameParts = splitName(widget.fullName);
    generatedEntityId = generateEntityId();
    generatedCorpCode = generateCorpCode().toString();
    String? firstName = nameParts['first'];
    String? middleName = nameParts['middle'];
    String? lastName = nameParts['last'];
    _firstNameController.text = firstName ?? "";
    _middleNameController.text = middleName ?? "";
    _lastNameController.text = lastName ?? "";
    _aadharNumberController.text = widget.aadhaarNumber;
    widget.gender == "M"
        ? _selectedTile = "Mr"
        : widget.gender == "F"
            ? _selectedTile = "Mrs"
            : _selectedTile = "Ms";
    widget.gender == "M"
        ? _selectedGender = "Male"
        : widget.gender == "F"
            ? _selectedGender = "Female"
            : _selectedGender = "Others";
    List<String> parts = widget.dob.split('-');
    // Assign to variables
    String day = parts[0];
    String month = parts[1];
    String year = parts[2];
    textControllerDD.text = day;
    textControllerMM.text = month;
    textControllerYYYY.text = year;
    _permanentHouseNameController.text = widget.houseName;
    _permanentStreetLocalityController.text = widget.street;
    _permanentCityNameController.text = widget.city;
    _permanentStateNameController.text = widget.state;
    _permanentPinCodeController.text = widget.pincode;
    _permanentAreaNameController.text = widget.area;
    _phoneNumberController.text = widget.mobileNum;
    _phoneNumberController.addListener(_checkPhoneNumberLength);
    _selectedDocument = "AADHAAR";
    _documentNumberController.text = widget.aadhaarNumber;
    _showRequestOtpButton = _phoneNumberController.text.isNotEmpty;

    // Initialize animations
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _titleAnimation = CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    );

    _submitButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _submitButtonAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _submitButtonController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _titleAnimationController.forward();
  }
  String generateEntityId() {
    final random = Random();
    String randomNumber = '';
    // Generate each digit of the random number
    for (int i = 0; i < 10; i++) {
    //for (int i = 0; i < 9; i++) {
      randomNumber +=
          random.nextInt(10).toString(); // Generate a random digit (0-9)
    }
    return randomNumber;
  }

  //**************************************************
  String generateCorpCode() {
    final random = Random();
    String randomNumber = '';
    // Generate each digit of the random number
    for (int i = 0; i < 6; i++) {
      randomNumber +=
          random.nextInt(10).toString(); // Generate a random digit (0-9)
    }
    return randomNumber;
  }

  //****************************************************************


  Future<void> kycOtpRequest() async {

   // EasyLoading.show(status: "Please wait...");
    const url = '${baseUrl}api/GenerateOtp';
    final data = {
      'entityId': generatedEntityId,
      'mobileNumber': '+91${widget.mobileNum}'
    };

    print("kycOtpRequest = $data");
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print("response = ${response.body}");
    print("kycOtpRequest = ${response.statusCode}");
    if (response.statusCode == 200) {
     // EasyLoading.dismiss();
      print("kycOtpRequest = $response");
      setState(() {
        _isOtpSent = true;
        _showOtpField = true;
        _showRequestOtpButton = false;
      });
      // EasyLoading.showToast('OTP Requested',
      //     toastPosition: EasyLoadingToastPosition.center);
    }
    if (response.statusCode == 401) {
     // EasyLoading.dismiss();
      if (response.body.contains("Mobile Number Already Registered")) {
        print("Mobile Number Already Registered");
        // EasyLoading.showToast('Mobile Number Already Registered',
        //     toastPosition: EasyLoadingToastPosition.bottom);
      }
    }
  }

  @override
  void dispose() {
    _phoneNumberController.removeListener(_checkPhoneNumberLength);
    _titleAnimationController.dispose();
    _submitButtonController.dispose();
    super.dispose();
  }

  void _checkPhoneNumberLength() {
    setState(() {
      _showRequestOtpButton = _phoneNumberController.text.length == 10;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: FadeTransition(
          opacity: _titleAnimation,
          child: ScaleTransition(
            scale: _titleAnimation,
            child: const Text(
              "MIN KYC",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: home2,
                fontSize: 22,
                letterSpacing: 0.8,
              ),
            ),
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
              _buildProgressIndicator(),
              const SizedBox(height: 24),

              // Personal Information Section
              _buildSectionHeader("Personal Information", Icons.person_outline),
              const SizedBox(height: 16),
              _buildTitleSelection(),
              const SizedBox(height: 30),
              _buildNameFields(),
              const SizedBox(height: 20),
              _buildDateOfBirthField(),
              const SizedBox(height: 20),
              _buildGenderSelection(),
              const SizedBox(height: 20),
              _buildMaritalStatusSelection(),
              const SizedBox(height: 20),

              // Permanent Address Section
              _buildSectionHeader("Permanent Address", Icons.home_outlined),
              const SizedBox(height: 16),
              _buildAddressFields(
                houseController: _permanentHouseNameController,
                streetController: _permanentStreetLocalityController,
                areaController: _permanentAreaNameController,
                cityController: _permanentCityNameController,
                stateController: _permanentStateNameController,
                pinCodeController: _permanentPinCodeController,
              ),
              const SizedBox(height: 20),

              // Communication Address Section
              _buildSectionHeader("Communication Address", Icons.mail_outline),
              const SizedBox(height: 16),
              _buildSameAsPermanentCheckbox(),
              _buildAddressFields(
                houseController: _communicationHouseNameController,
                streetController: _communicationStreetLocalityController,
                areaController: _communicationAreaNameController,
                cityController: _cityNameController,
                stateController: _stateNameController,
                pinCodeController: _pinCodeController,
                enabled: !_sameAsPermanentAddress,
              ),
              const SizedBox(height: 20),

              // Contact Information Section
              _buildSectionHeader(
                  "Contact Information", Icons.phone_iphone_outlined),
              const SizedBox(height: 16),
              _buildPhoneNumberField(),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),

              // Document Verification Section
              _buildSectionHeader(
                  "Document Verification", Icons.verified_outlined),
              const SizedBox(height: 16),
              _buildDocumentTypeSelection(),

              // Terms and Conditions
              _buildTermsAndConditions(),

              // Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: _progressValue),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(home1),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.easeOut,
      )),
      child: Row(
        children: [
          Icon(icon, color: home1, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TITLE/HONORIFIC",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildChoiceChip("Mr", _selectedTile),
            _buildChoiceChip("Mrs", _selectedTile),
            _buildChoiceChip("Ms", _selectedTile),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, String? selectedValue) {
    final isSelected = selectedValue == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selectedValue == _selectedTile) {
              _selectedTile = label;
            } else if (selectedValue == _selectedGender) {
              _selectedGender = label;
            } else if (selectedValue == _selectedMaritalstatus) {
              _selectedMaritalstatus = label;
            } else if (selectedValue == _selectedDocument) {
              _selectedDocument = label;
            }
          });
        },
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : home1,
          fontWeight: FontWeight.w600,
        ),
        selectedColor: home1,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isSelected ? home1 : Colors.grey[300]!),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "GENDER",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildChoiceChip("Male", _selectedGender),
            _buildChoiceChip("Female", _selectedGender),
            _buildChoiceChip("Others", _selectedGender),
          ],
        ),
      ],
    );
  }

  Widget _buildMaritalStatusSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MARITAL STATUS",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildChoiceChip("Married", _selectedMaritalstatus),
            _buildChoiceChip("Single", _selectedMaritalstatus),
          ],
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Column(
      children: [
        _buildModernTextField(
          controller: _firstNameController,
          labelText: "First Name",
          isRequired: true,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _middleNameController,
          labelText: "Middle Name",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _lastNameController,
          labelText: "Last Name",
          isRequired: true,
          icon: Icons.person_outline,
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DATE OF BIRTH",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildModernTextField(
                icon: Icons.calendar_month,
                controller: textControllerDD,
                labelText: "DD",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernTextField(
                icon: Icons.calendar_month,
                controller: textControllerMM,
                labelText: "MM",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernTextField(
                icon: Icons.calendar_month,
                controller: textControllerYYYY,
                labelText: "YYYY",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            IconButton(
              icon:const Icon(Icons.calendar_today, color: home1),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:const ColorScheme.light(
              primary: home1, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: home1, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        textControllerDD.text = picked.day.toString().padLeft(2, '0');
        textControllerMM.text = picked.month.toString().padLeft(2, '0');
        textControllerYYYY.text = picked.year.toString();
      });
    }
  }

  Widget _buildAddressFields({
    required TextEditingController houseController,
    required TextEditingController streetController,
    required TextEditingController areaController,
    required TextEditingController cityController,
    required TextEditingController stateController,
    required TextEditingController pinCodeController,
    bool enabled = true,
  }) {
    return Column(
      children: [
        _buildModernTextField(
          controller: houseController,
          labelText: "House Name",
          isRequired: enabled,
          enabled: enabled,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: streetController,
          labelText: "Street/Locality",
          isRequired: enabled,
          enabled: enabled,
          icon: Icons.place_outlined,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: areaController,
          labelText: "Area",
          isRequired: enabled,
          enabled: enabled,
          icon: Icons.map_outlined,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: cityController,
          labelText: "City",
          isRequired: enabled,
          enabled: enabled,
          icon: Icons.location_city_outlined,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: stateController,
          labelText: "State",
          isRequired: enabled,
          enabled: enabled,
          icon: Icons.flag_outlined,
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: pinCodeController,
          labelText: "PIN Code",
          isRequired: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [LengthLimitingTextInputFormatter(6)],
          enabled: enabled,
          icon: Icons.numbers_outlined,
        ),
      ],
    );
  }

  Widget _buildSameAsPermanentCheckbox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CheckboxListTile(
        title: Text(
          "Same as permanent address",
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _sameAsPermanentAddress,
        onChanged: (value) {
          setState(() {
            _sameAsPermanentAddress = value ?? false;
            if (_sameAsPermanentAddress) {
              _communicationHouseNameController.text =
                  _permanentHouseNameController.text;
              _communicationStreetLocalityController.text =
                  _permanentStreetLocalityController.text;
              _communicationAreaNameController.text =
                  _permanentAreaNameController.text;
              _cityNameController.text = _permanentCityNameController.text;
              _stateNameController.text = _permanentStateNameController.text;
              _pinCodeController.text = _permanentPinCodeController.text;
            }
          });
        },
        activeColor: home1,
        checkColor: Colors.white,
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernTextField(
          controller: _phoneNumberController,
          labelText: "Phone Number",
          isRequired: true,
          keyboardType: TextInputType.phone,
          prefixText: "+91 ",
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
          icon: Icons.phone_iphone_outlined,
        ),
        if (_isOtpSent && _showOtpField) ...[
          const SizedBox(height: 16),
          _buildOtpVerificationField(),
        ] else if (_showRequestOtpButton && !_isOtpSent) ...[
          const SizedBox(height: 16),

          _buildRequestOtpButton(),
        ],
      ],
    );
  }

  Widget _buildRequestOtpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => kycOtpRequest(),
        style: ElevatedButton.styleFrom(
          backgroundColor: home1,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          "REQUEST OTP",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _requestOtp() {
    // Generate a random 6-digit OTP
    _generatedOtp = (100000 + Random().nextInt(900000)).toString();

    // In a real app, you would send this OTP to the user's phone
    debugPrint("OTP for ${_phoneNumberController.text}: $_generatedOtp");

    setState(() {
      _isOtpSent = true;
      _showOtpField = true;
      _showRequestOtpButton = false;
    });

    // Show animated success message
    _showAnimatedSnackBar(
      "OTP sent successfully",
      icon: Icons.check_circle,
      color: Colors.green,
    );
  }

  Widget _buildOtpVerificationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ENTER 6-DIGIT OTP",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildModernTextField(
                controller: _otpController,
                labelText: "OTP",
                isRequired: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                icon: Icons.lock_outline,
              ),
            ),
            const SizedBox(width: 12),
            // SizedBox(
            //   height: 56,
            //   child: ElevatedButton(
            //     onPressed: () => _verifyOtp(),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: home1,
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.symmetric(horizontal: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: const Text(
            //       "VERIFY",
            //       style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _resendOtp(),
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  color: home1,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void  _verifyOtp() {
    if (_otpController.text == _generatedOtp) {
      _showAnimatedSnackBar(
        "OTP verified successfully",
        icon: Icons.verified,
        color: Colors.green,
      );
      setState(() {
        _showOtpField = false;
      });
    } else {
      _showAnimatedSnackBar(
        "Invalid OTP, please try again",
        icon: Icons.error_outline,
        color: Colors.red,
      );
    }
  }

  void _resendOtp() {
    kycOtpRequest();
    _otpController.clear();
  }

  Widget _buildEmailField() {
    return _buildModernTextField(
      controller: _emailController,
      labelText: "Email Address",
      isRequired: true,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.alternate_email_outlined,
    );
  }

  Widget _buildDocumentTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DOCUMENT TYPE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildChoiceChip("PAN", _selectedDocument)),
            const SizedBox(width: 12),
            Expanded(child: _buildChoiceChip("AADHAAR", _selectedDocument)),
          ],
        ),
        if (_selectedDocument != null) ...[
          const SizedBox(height: 16),
          _buildModernTextField(
            controller: _selectedDocument == "PAN"
                ? _panNumberController
                : _aadharNumberController,
            labelText:
                _selectedDocument == "PAN" ? "PAN Number" : "Aadhaar Number",
            isRequired: true,
            keyboardType: TextInputType.text,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  _selectedDocument == "PAN" ? 10 : 12),
            ],
            icon: _selectedDocument == "PAN"
                ? Icons.credit_card_outlined
                : Icons.badge_outlined,
          ),
        ],
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CheckboxListTile(
        title: RichText(
          text: TextSpan(
            text: "I agree to the ",
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: "Terms and Conditions",
                style: TextStyle(
                  color: home1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        value: _isChecked,
        onChanged: (value) => setState(() => _isChecked = value ?? false),
        activeColor: home1,
        checkColor: Colors.white,
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScaleTransition(
      scale: _submitButtonAnimation,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (_isChecked) {
                    //  kycSubmitData();
                      if(_selectedMaritalstatus?.isNotEmpty == true &&
                          _otpController.text.isNotEmpty
                      ){
                        print("calling kkyc submit data");
                        kycSubmitData();

                      }else{
                        print("select martial status");
                        _otpController.text.isEmpty?
                        _showAnimatedSnackBar(
                          "Otp is required",
                          icon: Icons.warning_amber_rounded,
                          color: Colors.red,
                        ):
                        _showAnimatedSnackBar(
                          "Select Marital status",
                          icon: Icons.warning_amber_rounded,
                          color: Colors.red,
                        )
                        ;
                      }

                    } else {
                      _showAnimatedSnackBar(
                        "Please accept the Terms and Conditions",
                        icon: Icons.warning_amber_rounded,
                        color: Colors.orange,
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: home1,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  "SUBMIT KYC",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
        ),
      ),
    );
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 8) {
      return phoneNumber; // Handle cases with too short numbers
    }

    String visibleStart = phoneNumber.substring(0, 4);
    String visibleEnd = phoneNumber.substring(phoneNumber.length - 4);
    return '$visibleStart****$visibleEnd';
  }
  String? encryptString(
      String textToEncrypt, String? secretKey, String? initialVector) {
    if (textToEncrypt.isEmpty || secretKey == null || initialVector == null) {
      return null;
    }

    try {
      final secretKeyBytes = Uint8List.fromList(secretKey.codeUnits);
      final iv = Uint8List.fromList(initialVector.codeUnits);
      final key = pc.KeyParameter(secretKeyBytes);
      final params = pc.ParametersWithIV(key, iv);
      final cipher = pc.CBCBlockCipher(pc.AESFastEngine());
      cipher.init(true, params);

      final textBytes = Uint8List.fromList(textToEncrypt.codeUnits);
      final paddedText = padPKCS7(textBytes);

      final encryptedBytes = cipher.process(paddedText);

      return base64.encode(encryptedBytes);
    } catch (e) {
      return null;
    }
  }
  Uint8List padPKCS7(Uint8List input) {
    final padLength = 16 - (input.length % 16);
    final output = Uint8List(input.length + padLength)..setAll(0, input);
    for (var i = input.length; i < output.length; i++) {
      output[i] = padLength;
    }
    return output;
  }
    Future<void> saveUserData(String entityID) async {
    print("saveUserData $entityID");
    const url = '${baseUrl}api/BusinessLogin';
    final data = {
      'EntityId': entityID,
      'BusinessCode': "MOBM2P",
      'BusinessName': 'ABCDSEFG',
      'ReferralCodeUsed': "",
      'PhoneNumber': '+91${_phoneNumberController.text}',
      'Locality': 'RANDOMLOCALITY',
      'UserName':"name",
      'Status': 'active',
      'Password':encryptString("${_firstNameController.text}@${textControllerYYYY.text}",secretKey , initialVector) ,
      'BusinessType': 'B',
      'UpdateTime': '',
      'MobPassword': encryptString("${_firstNameController.text}@${textControllerYYYY.text}",secretKey , initialVector),
    };
    print(data);
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
     // checkIfRegistered();
      final custRegisterProvider = Provider.of<CustRegisterProvider>(
        context,
        listen: false,
      );
      final response = await custRegisterProvider.checkRegCust(int.parse(
          _phoneNumberController.text
              .replaceAll("+91", "")));
      response.fold(
              (error) {
            print("Error: ${error.message}");

          },
              (customer) async {

              SharedPref.shared.setEmail(
                customer.response!.data!['emailId'].toString(),
              );
              SharedPref.shared.setCustId(
                customer.response!.data!['CustId'].toString(),
              );
              SharedPref.shared.setCorpCode(
                customer.response!.data!['CorpCode'].toString(),
              );
              SharedPref.shared.setBranchCode(
                customer.response!.data!['BranchCode'].toString(),
              );
              SharedPref.shared.setSubAgentMobNum (
                customer.response!.data!['contactNo'].toString(),
              );
              SharedPref.shared.setAgentName(
                customer.response!.data!['firstName'].toString(),
              );
              SharedPref.shared.setMpinValue(customer.mpin.toString());

              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SelectCategoryScreen()));

          }
      );

    }
  }
  void showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: home2),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please wait....",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
  Future<void> kycSubmitData() async {

    var monthValue = '';
    var dayValue = '';

    int.parse(textControllerMM.text) < 10 && !textControllerMM.text.startsWith('0')
        ? monthValue = '0${textControllerMM.text}'
        : textControllerMM.text!= "00"?
    monthValue =  textControllerMM.text:
    textControllerMM.clear();

    int.parse(textControllerDD.text) < 10 && !textControllerDD.text.startsWith('0')
        ? dayValue = '0${textControllerDD.text}'
        : textControllerDD.text!= "00"?
    dayValue = textControllerDD.text:
    textControllerDD.clear();
    showProgressDialog(context);

   // EasyLoading.show(status: "Please wait...");
    const url = '${baseUrl}api/PersonalizedRegister_V1';
   // const url = '';

    Map<String, dynamic> communicationInfo = {
      'contactNo': "+91${_phoneNumberController.text}",
      'emailId': _emailController.text,
    };
    Map<String, dynamic> kitInfo = {
      //'cardType': 'VIRTUAL',
      'cardType': 'PHYSICAL',
      'cardCategory': 'PREPAID',
      'cardRegStatus': 'ACTIVE'
    };
    Map<String, dynamic> kycInfo = {
      // 'documentExpiry': 'null',
      'documentExpiry': "2030-12-12",
      'documentNo': _selectedDocument == "PAN"
          ? _panNumberController.text
          : maskPhoneNumber(_aadharNumberController.text),
      'documentType': _selectedDocument
    };

    Map<String, dynamic> dateInfo = {
      'dateType': 'DOB',
      'date': "${textControllerYYYY.text}-$monthValue-$dayValue"
    };

    Map<String, dynamic> addressInfo = {
      'addressCategory': 'PERMANENT',
      'address1': _permanentStreetLocalityController.text,
      'address2': _permanentAreaNameController.text,
      'address3': _permanentHouseNameController.text,
      'city': _cityNameController.text,
      'state': _stateNameController.text,
      'country': "INDIA",
      'pinCode': _pinCodeController.text
    };

    Map<String, dynamic> minKycPostData = {
     // 'CorpCode': 'MOBM2P',
      'CorpCode': generatedCorpCode,
      //'BranchCode': 'MOBM2P',
      'BranchCode': generatedCorpCode,
      'addressInfo': [addressInfo],
      'entityId': generatedEntityId,
      'channelName': 'MIN_KYC',
      'entityType': 'CUSTOMER',
      'businessType': 'TCADSS',
      'businessId': generatedEntityId,
      // 'otp': otpController.text,
      'otp': _otpController.text,
      'title': _selectedTile,
      'firstName': _firstNameController.text,
      'middleName': _middleNameController.text,
      'lastName': _lastNameController.text,
      'gender': _selectedGender == 'Male'
          ? 'M'
          : _selectedGender == 'Female'
          ? 'F'
          : _selectedGender == 'Others'
          ? 'O'
          : '',
      'maritalStatus': _selectedMaritalstatus,
      'countryCode': '+91',
      'communicationInfo': [communicationInfo],
      'kitInfo': [kitInfo],
      'kycInfo': [kycInfo],
      'dateInfo': [dateInfo]
    };

    print(minKycPostData);
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(minKycPostData),
        headers: {'Content-Type': 'application/json'},
      );
      print('KYC ${response.body}');
      print('KYC ${response.statusCode}');
      Navigator.pop(context);
      if (response.statusCode == 404) {
      //  EasyLoading.dismiss();
      }

      if (response.statusCode == 200) {
       // EasyLoading.dismiss();
        var responses = response.body;

        if (responses.contains("kitNo")) {
          _submitForm();
          ///GETTING THE TOKEN VALUE.......
         // checkIfRegistered();
           saveUserData(generatedEntityId!);
          showToast(message: "MIN KYC COMPLETED SUCCESS", color: Colors.green);

        }

        if (responses.contains('Invalid OTP')) {

          showToast(message: "Invalid OTP", color: Colors.red);

        }
        if (responses.contains('Not a valid AADHAAR number')) {
          showToast(message: "Not a valid AADHAAR number", color: Colors.red);

        }

        if (response.body.contains('Valid kits not found')) {

          showToast(message: "Valid kits not found", color: Colors.red);
        }
        print('KYC $responses');
      }
      if (response.statusCode == 401) {
      //  EasyLoading.dismiss();
        // checkIfRegistered();
        if (response.body.contains("Mobile Number Already Registered")) {
          //checkIfRegistered();
          // saveUserData(generatedEntityID);
          // EasyLoading.showToast("Mobile Number Already Registered",
          //     toastPosition: EasyLoadingToastPosition.bottom);
          showToast(message: "Mobile Number Already Registered", color: Colors.red);
        }
      }
      if (response.statusCode == 500) {
        //EasyLoading.dismiss();
      }
    } catch (e) {
     // EasyLoading.dismiss();
    }
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String labelText,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    required IconData icon,
    String? prefixText,
    VoidCallback? onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixText: prefixText,
          labelText: isRequired ? "$labelText *" : labelText,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          floatingLabelStyle:const TextStyle(
            color: home1,
            fontWeight: FontWeight.w600,
          ),
          enabled: enabled,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:const BorderSide(color: home1, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: enabled ? home1 : Colors.grey[400],
          ),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: isRequired
            ? (value) =>
                value?.isEmpty ?? true ? "This field is required" : null
            : null,
        style: TextStyle(
          color: enabled ? Colors.grey[800] : Colors.grey[600],
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    _showAnimatedSnackBar(
      "KYC submitted successfully!",
      icon: Icons.check_circle_outline,
      color: Colors.green,
    );

    // Show success dialog
    _showSuccessDialog();
  }

  void _showAnimatedSnackBar(String message,
      {required IconData icon, required Color color}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  "KYC Submitted!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: home1,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your KYC information has been successfully submitted for verification.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SelectCategoryScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: home1,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "DONE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
