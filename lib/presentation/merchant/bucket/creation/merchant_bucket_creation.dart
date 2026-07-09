import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../data/storage/shared_pref_helper.dart';

enum ReminderType {
  relative,
  custom,
}

// Add these new enums
enum ViewMode {
  card,
  compact,
  grid,
}

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
  final List<Map<String, dynamic>> items = [
    {"title": "WHATS APP", "checked": false},
    {"title": "SMS", "checked": true},
    {"title": "CALL", "checked": false},
  ];
  String _businessCat = "";
  ReminderType reminderType = ReminderType.relative;

  String selectedReminderOption = '1 day before';

  final List<String> reminderOptions = [
    '1 day before',
    '2 days before',
    '3 days before',
    '1 week before',
    '2 weeks before',
    '1 month before',
  ];
  // Member management
  List<Member> members = [];
  List<Member> filteredMembers = [];
  bool isLoanEntity = true;

  // New variables for filter, sort, view
  int selectedTabIndex = 0; // 0: Filter, 1: Sort, 2: View
  ViewMode currentViewMode = ViewMode.card;

  // Filter variables
  String? selectedTenure;
  String? selectedRepaymentType;
  String? selectedRiskCategory;
  double? minLoanAmount;
  double? maxLoanAmount;
  double? minInterestRate;
  double? maxInterestRate;
  double? minIncome;
  double? maxIncome;

  // Sort variables
  String? selectedSortBy;
  bool isAscending = true;
  final List<String> sortOptions = [
    'Loan Amount',
    'Interest Rate',
    'Tenure',
    'Income',
    'LDC Score'
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

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }

  double calculateEmi(double principleAmount, double interestRate, int tenure) {
    var monthlyInterest = (interestRate * 0.01) / 12;
    var emi = (principleAmount *
        monthlyInterest *
        pow((1 + monthlyInterest), tenure)) /
        ((pow((1 + monthlyInterest), tenure)) - 1);
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

  Future<void> loadSharedPrefs() async {
    final businessCat = await SharedPref().getBusinessCategory();
    setState(() {
      _businessCat = businessCat;
      if (businessCat == "Gold Loan") {
        isLoanEntity = true;
      } else {
        isLoanEntity = false;
      }
    });
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
      _applyFiltersAndSort();
    });
  }

  void _removeMember(int index) {
    setState(() {
      members[index].dispose();
      members.removeAt(index);
      _applyFiltersAndSort();
    });
  }

  // New method to apply filters and sorting
  void _applyFiltersAndSort() {
    filteredMembers = List.from(members);

    // Apply filters
    if (selectedTenure != null && selectedTenure!.isNotEmpty) {
      // Filter by tenure
    }
    if (selectedRepaymentType != null && selectedRepaymentType!.isNotEmpty) {
      // Filter by repayment type
    }
    if (selectedRiskCategory != null && selectedRiskCategory!.isNotEmpty) {
      // Filter by risk category
    }
    if (minLoanAmount != null) {
      filteredMembers = filteredMembers.where((m) {
        final amount = double.tryParse(m.amountController.text) ?? 0;
        return amount >= minLoanAmount!;
      }).toList();
    }
    if (maxLoanAmount != null) {
      filteredMembers = filteredMembers.where((m) {
        final amount = double.tryParse(m.amountController.text) ?? 0;
        return amount <= maxLoanAmount!;
      }).toList();
    }
    if (minInterestRate != null) {
      filteredMembers = filteredMembers.where((m) {
        final rate = double.tryParse(m.interestController.text) ?? 0;
        return rate >= minInterestRate!;
      }).toList();
    }
    if (maxInterestRate != null) {
      filteredMembers = filteredMembers.where((m) {
        final rate = double.tryParse(m.interestController.text) ?? 0;
        return rate <= maxInterestRate!;
      }).toList();
    }

    // Apply sorting
    if (selectedSortBy != null) {
      filteredMembers.sort((a, b) {
        double valueA = 0;
        double valueB = 0;

        switch (selectedSortBy) {
          case 'Loan Amount':
            valueA = double.tryParse(a.amountController.text) ?? 0;
            valueB = double.tryParse(b.amountController.text) ?? 0;
            break;
          case 'Interest Rate':
            valueA = double.tryParse(a.interestController.text) ?? 0;
            valueB = double.tryParse(b.interestController.text) ?? 0;
            break;
          case 'Tenure':
            valueA = double.tryParse(a.tenureController.text) ?? 0;
            valueB = double.tryParse(b.tenureController.text) ?? 0;
            break;
          default:
            return 0;
        }

        return isAscending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      });
    }

    setState(() {});
  }

  void _submitGroup() {
    var emi = calculateEmi(
        double.parse(members[0].amountController.text),
        double.parse(members[0].interestController.text),
        int.parse(members[0].tenureController.text));
    print(emi);
    print(
        "Total EMI : ${(emi) * int.parse(members[0].tenureController.text) - int.parse(members[0].amountController.text)}");
    // Validate
    if (groupNameController.text.isEmpty) {
      _showSnackBar('Please enter group name');
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

    _showSnackBar('Group created successfully!');

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

  // Bottom sheet for filters
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Borrowers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Loan Tenure
                    _buildFilterDropdown(
                      label: 'Loan Tenure',
                      value: selectedTenure,
                      items: ['3 Months', '6 Months', '12 Months', '24 Months'],
                      onChanged: (value) {
                        setStateBottomSheet(() {
                          selectedTenure = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Repayment Type
                    _buildFilterDropdown(
                      label: 'Repayment Type',
                      value: selectedRepaymentType,
                      items: ['Monthly', 'Quarterly', 'Half-Yearly', 'Yearly'],
                      onChanged: (value) {
                        setStateBottomSheet(() {
                          selectedRepaymentType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Risk Category
                    _buildFilterDropdown(
                      label: 'Risk Category',
                      value: selectedRiskCategory,
                      items: ['Low', 'Medium', 'High', 'Very High'],
                      onChanged: (value) {
                        setStateBottomSheet(() {
                          selectedRiskCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Loan Amount Range
                    _buildRangeFilter(
                      label: 'Loan Amount',
                      minValue: minLoanAmount,
                      maxValue: maxLoanAmount,
                      onMinChanged: (value) {
                        setStateBottomSheet(() {
                          minLoanAmount = value;
                        });
                      },
                      onMaxChanged: (value) {
                        setStateBottomSheet(() {
                          maxLoanAmount = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Interest Rate Range
                    _buildRangeFilter(
                      label: 'Interest Rate',
                      minValue: minInterestRate,
                      maxValue: maxInterestRate,
                      onMinChanged: (value) {
                        setStateBottomSheet(() {
                          minInterestRate = value;
                        });
                      },
                      onMaxChanged: (value) {
                        setStateBottomSheet(() {
                          maxInterestRate = value;
                        });
                      },
                      suffix: '%',
                    ),
                    const SizedBox(height: 16),

                    // Income Range
                    _buildRangeFilter(
                      label: 'Income',
                      minValue: minIncome,
                      maxValue: maxIncome,
                      onMinChanged: (value) {
                        setStateBottomSheet(() {
                          minIncome = value;
                        });
                      },
                      onMaxChanged: (value) {
                        setStateBottomSheet(() {
                          maxIncome = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setStateBottomSheet(() {
                                selectedTenure = null;
                                selectedRepaymentType = null;
                                selectedRiskCategory = null;
                                minLoanAmount = null;
                                maxLoanAmount = null;
                                minInterestRate = null;
                                maxInterestRate = null;
                                minIncome = null;
                                maxIncome = null;
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFiltersAndSort();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: home1,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select $label'),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRangeFilter({
    required String label,
    required double? minValue,
    required double? maxValue,
    required Function(double?) onMinChanged,
    required Function(double?) onMaxChanged,
    String suffix = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Min',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  suffixText: suffix,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  onMinChanged(double.tryParse(value));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Max',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  suffixText: suffix,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  onMaxChanged(double.tryParse(value));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Bottom sheet for sorting
  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sort Borrowers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...sortOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedSortBy,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setStateBottomSheet(() {
                          selectedSortBy = value;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Ascending'),
                          value: true,
                          groupValue: isAscending,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setStateBottomSheet(() {
                              isAscending = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Descending'),
                          value: false,
                          groupValue: isAscending,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setStateBottomSheet(() {
                              isAscending = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setStateBottomSheet(() {
                              selectedSortBy = null;
                              isAscending = true;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _applyFiltersAndSort();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: home1,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply Sort'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayMembers = filteredMembers.isEmpty && members.isNotEmpty
        ? members
        : filteredMembers;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA307B),
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      icon: Icons.business_center_outlined,
                    ),
                    const SizedBox(height: 12),
                    isLoanEntity == false
                        ? const SizedBox.shrink()
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Members Section with Segmented Control
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
                    const SizedBox(height: 12),

                    // Segmented Control
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _buildSegmentTab('Filter', 0),
                          _buildSegmentTab('Sort', 1),
                          _buildSegmentTab('View', 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Content based on selected tab
                    if (selectedTabIndex == 0)
                      _buildFilterContent()
                    else if (selectedTabIndex == 1)
                      _buildSortContent()
                    else if (selectedTabIndex == 2)
                        _buildViewContent(),

                    const SizedBox(height: 16),

                    // Member list
                    if (displayMembers.isEmpty)
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
                      _buildMemberListView(displayMembers),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Schedule Card (unchanged)
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
                    const SizedBox(height: 20),
                    _buildDateField(
                      controller: dueDateController,
                      label: 'Due Date',
                      hintText: 'Select due date',
                      icon: Icons.event_note,
                      onTap: () => _selectDate(context, dueDateController),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Reminder",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<ReminderType>(
                            value: ReminderType.relative,
                            groupValue: reminderType,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Before Due Date",
                              style: TextStyle(fontSize: 13),
                            ),
                            onChanged: (value) {
                              setState(() {
                                reminderType = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<ReminderType>(
                            value: ReminderType.custom,
                            groupValue: reminderType,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Custom Date",
                              style: TextStyle(fontSize: 13),
                            ),
                            onChanged: (value) {
                              setState(() {
                                reminderType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (reminderType == ReminderType.relative)
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
                            items: reminderOptions.map((option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedReminderOption = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    if (reminderType == ReminderType.custom)
                      _buildDateField(
                        controller: reminderDateController,
                        label: 'Reminder Date',
                        hintText: 'Select reminder date',
                        icon: Icons.notifications_active_outlined,
                        onTap: () => _selectDate(context, reminderDateController),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      "Notification Channels",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: List.generate(items.length, (index) {
                          return CheckboxListTile(
                            value: items[index]["checked"],
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: const Color(0xFF1A237E),
                            title: Text(
                              items[index]["title"],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                items[index]["checked"] = value!;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Members will receive reminders through the selected channels.",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
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

  Widget _buildSegmentTab(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
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
              const Icon(Icons.filter_list, size: 20, color: Color(0xFF1A237E)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedTenure != null || selectedRepaymentType != null ||
                      selectedRiskCategory != null || minLoanAmount != null ||
                      maxLoanAmount != null || minInterestRate != null ||
                      maxInterestRate != null
                      ? '${_getActiveFilterCount()} filters active'
                      : 'No active filters',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              TextButton(
                onPressed: _showFilterBottomSheet,
                child: const Text(
                  'Manage Filters',
                  style: TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_getActiveFilterCount() > 0)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (selectedTenure != null)
                  Chip(
                    label: Text('Tenure: $selectedTenure'),
                    onDeleted: () {
                      setState(() {
                        selectedTenure = null;
                        _applyFiltersAndSort();
                      });
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                    backgroundColor: Colors.white,
                  ),
                if (selectedRepaymentType != null)
                  Chip(
                    label: Text('Repayment: $selectedRepaymentType'),
                    onDeleted: () {
                      setState(() {
                        selectedRepaymentType = null;
                        _applyFiltersAndSort();
                      });
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                    backgroundColor: Colors.white,
                  ),
                if (selectedRiskCategory != null)
                  Chip(
                    label: Text('Risk: $selectedRiskCategory'),
                    onDeleted: () {
                      setState(() {
                        selectedRiskCategory = null;
                        _applyFiltersAndSort();
                      });
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                    backgroundColor: Colors.white,
                  ),
                if (minLoanAmount != null || maxLoanAmount != null)
                  Chip(
                    label: Text('Amount: ${minLoanAmount ?? ''} - ${maxLoanAmount ?? ''}'),
                    onDeleted: () {
                      setState(() {
                        minLoanAmount = null;
                        maxLoanAmount = null;
                        _applyFiltersAndSort();
                      });
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                    backgroundColor: Colors.white,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSortContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.sort, size: 20, color: Color(0xFF1A237E)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              selectedSortBy != null
                  ? 'Sorting by $selectedSortBy (${isAscending ? "Asc" : "Desc"})'
                  : 'No sorting applied',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: _showSortBottomSheet,
            child: const Text(
              'Manage Sort',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildViewOption(Icons.view_agenda, 'Card', ViewMode.card),
          _buildViewOption(Icons.view_list, 'Compact', ViewMode.compact),
          _buildViewOption(Icons.grid_view, 'Grid', ViewMode.grid),
        ],
      ),
    );
  }

  Widget _buildViewOption(IconData icon, String label, ViewMode mode) {
    final isSelected = currentViewMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentViewMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberListView(List<Member> displayMembers) {
    switch (currentViewMode) {
      case ViewMode.card:
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayMembers.length,
          separatorBuilder: (context, index) => const Divider(height: 16),
          itemBuilder: (context, index) {
            return _buildMemberCard(index, displayMembers[index]);
          },
        );
      case ViewMode.compact:
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayMembers.length,
          separatorBuilder: (context, index) => const Divider(height: 8),
          itemBuilder: (context, index) {
            return _buildCompactMemberCard(index, displayMembers[index]);
          },
        );
      case ViewMode.grid:
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: displayMembers.length,
          itemBuilder: (context, index) {
            return _buildGridMemberCard(index, displayMembers[index]);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCompactMemberCard(int index, Member member) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A237E),
            radius: 16,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.nameController.text.isEmpty ? 'Member ${index + 1}' : member.nameController.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '₹${member.amountController.text.isEmpty ? '0' : member.amountController.text}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeMember(index),
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMemberCard(int index, Member member) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A237E),
            radius: 20,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.nameController.text.isEmpty ? 'Member ${index + 1}' : member.nameController.text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '₹${member.amountController.text.isEmpty ? '0' : member.amountController.text}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          IconButton(
            onPressed: () => _removeMember(index),
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (selectedTenure != null) count++;
    if (selectedRepaymentType != null) count++;
    if (selectedRiskCategory != null) count++;
    if (minLoanAmount != null) count++;
    if (maxLoanAmount != null) count++;
    if (minInterestRate != null) count++;
    if (maxInterestRate != null) count++;
    if (minIncome != null) count++;
    if (maxIncome != null) count++;
    return count;
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
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.shade50),
                child: IconButton(
                  onPressed: () => _removeMember(index),
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
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
              : const SizedBox.shrink(),
          const SizedBox(height: 8),
          isLoanEntity == true
              ? _buildSimpleTextField(
            controller: member.emiController,
            hintText: 'EMI Amount',
            label: 'EMI Amount',
          )
              : const SizedBox.shrink(),
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
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: home1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {},
            child: const Text("Send Notification"),
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
      var monthlyInterest = (interest * 0.01) / 12;
      var emi =
          (amount * monthlyInterest * pow((1 + monthlyInterest), tenure)) /
              ((pow((1 + monthlyInterest), tenure)) - 1);

      emiController.text = emi.toString();
    } else {
      emiController.clear();
    }
  }

  TextEditingController calculateEmiNew(
      double principleAmount, double interestRate, int tenure) {
    var monthlyInterest = (interestRate * 0.01) / 12;
    var emi = (principleAmount *
        monthlyInterest *
        pow((1 + monthlyInterest), tenure)) /
        ((pow((1 + monthlyInterest), tenure)) - 1);

    emiController.text = emi.toString();
    return emiController;
  }
}

// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// import '../../../../core/colors.dart';
// import '../../../../data/storage/shared_pref_helper.dart';
// enum ReminderType {
//   relative,
//   custom,
// }
// class MerchantBucketCreationPage extends StatefulWidget {
//   final int selectedIndex;
//   final int groupId;
//
//   const MerchantBucketCreationPage({
//     super.key,
//     required this.selectedIndex,
//     required this.groupId,
//   });
//
//   @override
//   State<MerchantBucketCreationPage> createState() =>
//       _MerchantBucketCreationPageState();
// }
//
// class _MerchantBucketCreationPageState
//     extends State<MerchantBucketCreationPage> {
//   // Controllers for group info
//   final TextEditingController groupNameController = TextEditingController();
//   final TextEditingController groupAmountController = TextEditingController();
//   final TextEditingController dueDateController = TextEditingController();
//   final TextEditingController reminderDateController = TextEditingController();
//   final List<Map<String, dynamic>> items = [
//     {"title": "WHATS APP", "checked": false},
//     {"title": "SMS", "checked": true},
//     {"title": "CALL", "checked": false},
//   ];
//   String _businessCat = "";
//   ReminderType reminderType = ReminderType.relative;
//
//   String selectedReminderOption = '1 day before';
//
//   final List<String> reminderOptions = [
//     '1 day before',
//     '2 days before',
//     '3 days before',
//     '1 week before',
//     '2 weeks before',
//     '1 month before',
//   ];
//   // Member management
//   List<Member> members = [];
//   bool isLoanEntity = true;
//   // Selected reminder options
//
//   void updateEmi(Member member) {
//     final amount = double.tryParse(member.amountController.text) ?? 0;
//     final interest = double.tryParse(member.interestController.text) ?? 0;
//     final tenure = int.tryParse(member.tenureController.text) ?? 0;
//
//     if (amount > 0 && interest > 0 && tenure > 0) {
//       final emi = calculateEmi(amount, interest, tenure);
//       member.emiController.text = emi.toStringAsFixed(2);
//     } else {
//       member.emiController.clear();
//     }
//   }
// @override
//   void initState() {
//   loadSharedPrefs();
//     super.initState();
//   }
//   double calculateEmi(double principleAmount, double interestRate, int tenure) {
//     var monthlyInterest = (interestRate * 0.01) / 12;
//     var emi = (principleAmount *
//             monthlyInterest *
//             pow((1 + monthlyInterest), tenure)) /
//         ((pow((1 + monthlyInterest), tenure)) - 1);
//     return emi;
//   }
//
//   @override
//   void dispose() {
//     groupNameController.dispose();
//     groupAmountController.dispose();
//     dueDateController.dispose();
//     reminderDateController.dispose();
//     for (var member in members) {
//       member.dispose();
//     }
//     super.dispose();
//   }
// Future<void> loadSharedPrefs() async {
//   final businessCat = await SharedPref().getBusinessCategory();
//   setState(() {
//     _businessCat = businessCat;
//     if(businessCat == "Gold Loan"){
//       isLoanEntity = true;
//     }else{
//       isLoanEntity = false;
//     }
//   });
// }
//
//
//   Future<void> _selectDate(
//       BuildContext context, TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//
//     if (picked != null) {
//       setState(() {
//         controller.text = _formatDate(picked);
//       });
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
//
//   void _addMember() {
//     setState(() {
//       members.add(Member());
//     });
//   }
//
//   void _removeMember(int index) {
//     setState(() {
//       members[index].dispose();
//       members.removeAt(index);
//     });
//   }
//
//   void _submitGroup() {
//     var emi = calculateEmi(
//         double.parse(members[0].amountController.text),
//         double.parse(members[0].interestController.text),
//         int.parse(members[0].tenureController.text));
//     print(emi);
//     print(
//         "Total EMI : ${(emi) * int.parse(members[0].tenureController.text) - int.parse(members[0].amountController.text)}");
//     // Validate
//     if (groupNameController.text.isEmpty) {
//       _showSnackBar('Please enter group name');
//       return;
//     }
//     // if (groupAmountController.text.isEmpty) {
//     //   _showSnackBar('Please enter group amount');
//     //   return;
//     // }
//     if (members.isEmpty) {
//       _showSnackBar('Please add at least one member');
//       return;
//     }
//     if (dueDateController.text.isEmpty) {
//       _showSnackBar('Please select due date');
//       return;
//     }
//
//     // Collect member data
//     List<Map<String, dynamic>> memberData = [];
//     for (var member in members) {
//       if (member.nameController.text.isEmpty) {
//         _showSnackBar('Please enter name for all members');
//         return;
//       }
//       if (member.amountController.text.isEmpty) {
//         _showSnackBar('Please enter amount for all members');
//         return;
//       }
//       memberData.add({
//         'name': member.nameController.text,
//         'amount': double.tryParse(member.amountController.text) ?? 0,
//         'phone': member.phoneController.text,
//         'email': member.emailController.text,
//         'dueDate': dueDateController.text,
//         'reminderDate': reminderDateController.text,
//         'reminderOption': selectedReminderOption,
//       });
//     }
//
//     // Here you would save the data
//     _showSnackBar('Group created successfully!');
//
//     // Print for debugging
//     print('Group: ${groupNameController.text}');
//     print('Amount: ${groupAmountController.text}');
//     print('Due Date: ${dueDateController.text}');
//     print('Reminder Date: ${reminderDateController.text}');
//     print('Reminder Option: $selectedReminderOption');
//     print('Members: $memberData');
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFEA307B),
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           widget.selectedIndex == 889898493849
//               ? "Create a Bucket"
//               : "Update Bucket",
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _submitGroup,
//             child: const Text(
//               '',
//               style: TextStyle(
//                 color: Color(0xFF1A237E),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Group Information Card
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Group Information',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1A237E),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextField(
//                       controller: groupNameController,
//                       hintText: 'Enter bucket name',
//                       label: 'Bucket Name',
//                       icon: Icons.business_center_outlined,
//                     ),
//                     const SizedBox(height: 12),
//                     isLoanEntity == false
//                         ?SizedBox.shrink()
//                     // _buildTextField(
//                     //         controller: groupAmountController,
//                     //         hintText: 'Enter default amount',
//                     //         label: 'Default Amount',
//                     //         icon: Icons.currency_rupee,
//                     //         keyboardType: TextInputType.number,
//                     //       )
//                         : SizedBox.shrink(),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Members Section
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Text(
//                           'Members',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF1A237E),
//                           ),
//                         ),
//                         const Spacer(),
//                         TextButton.icon(
//                           onPressed: _addMember,
//                           icon: const Icon(Icons.add, size: 18),
//                           label: const Text('Add Member'),
//                           style: TextButton.styleFrom(
//                             foregroundColor: const Color(0xFF1A237E),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     if (members.isEmpty)
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 40),
//                         alignment: Alignment.center,
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.people_outline,
//                               size: 48,
//                               color: Colors.grey.shade400,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'No members added yet',
//                               style: TextStyle(
//                                 color: Colors.grey.shade500,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             TextButton(
//                               onPressed: _addMember,
//                               child: const Text('Add your first member'),
//                             ),
//                           ],
//                         ),
//                       )
//                     else
//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: members.length,
//                         separatorBuilder: (context, index) =>
//                             const Divider(height: 16),
//                         itemBuilder: (context, index) {
//                           final member = members[index];
//                           return _buildMemberCard(index, member);
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // Schedule Card
//             // Card(
//             //   elevation: 2,
//             //   shape: RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.circular(12),
//             //   ),
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(16),
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.start,
//             //       children: [
//             //         const Text(
//             //           'Schedule & Reminders',
//             //           style: TextStyle(
//             //             fontSize: 16,
//             //             fontWeight: FontWeight.w600,
//             //             color: Color(0xFF1A237E),
//             //           ),
//             //         ),
//             //         const SizedBox(height: 16),
//             //
//             //         _buildDateField(
//             //           controller: dueDateController,
//             //           label: 'Due Date',
//             //           hintText: 'Select due date',
//             //           icon: Icons.event_note,
//             //           onTap: () => _selectDate(context, dueDateController),
//             //         ),
//             //         const SizedBox(height: 12),
//             //
//             //         _buildDateField(
//             //           controller: reminderDateController,
//             //           label: 'Reminder Date',
//             //           hintText: 'Select reminder date',
//             //           icon: Icons.notifications,
//             //           onTap: () => _selectDate(context, reminderDateController),
//             //         ),
//             //         const SizedBox(height: 12),
//             //
//             //         // Reminder Dropdown
//             //         Container(
//             //           padding: const EdgeInsets.symmetric(horizontal: 12),
//             //           decoration: BoxDecoration(
//             //             border: Border.all(color: Colors.grey.shade300),
//             //             borderRadius: BorderRadius.circular(8),
//             //           ),
//             //           child: DropdownButtonHideUnderline(
//             //             child: DropdownButton<String>(
//             //               value: selectedReminderOption,
//             //               isExpanded: true,
//             //               icon: const Icon(Icons.keyboard_arrow_down),
//             //               style: const TextStyle(
//             //                   color: Colors.black87, fontSize: 14),
//             //               items: reminderOptions.map((String option) {
//             //                 return DropdownMenuItem<String>(
//             //                   value: option,
//             //                   child: Text(option),
//             //                 );
//             //               }).toList(),
//             //               onChanged: (String? newValue) {
//             //                 setState(() {
//             //                   selectedReminderOption = newValue!;
//             //                 });
//             //               },
//             //             ),
//             //           ),
//             //         ),
//             //         Text("Send notification via"),
//             //         SizedBox(
//             //           height: 150,
//             //           child: ListView.separated(
//             //             itemCount: items.length,
//             //             separatorBuilder: (_, __) => const SizedBox(height: 8),
//             //             itemBuilder: (context, index) {
//             //               return Container(
//             //                 padding: const EdgeInsets.symmetric(
//             //                   horizontal: 12,
//             //                   vertical: 6,
//             //                 ),
//             //                 decoration: BoxDecoration(
//             //                   color: Colors.grey.shade100,
//             //                   borderRadius: BorderRadius.circular(14),
//             //                   border: Border.all(
//             //                     color: Colors.grey.shade300,
//             //                   ),
//             //                 ),
//             //                 child: Row(
//             //                   children: [
//             //                     Checkbox(
//             //                       value: items[index]["checked"],
//             //                       shape: RoundedRectangleBorder(
//             //                         borderRadius: BorderRadius.circular(5),
//             //                       ),
//             //                       activeColor: Colors.blue,
//             //                       visualDensity: VisualDensity.compact,
//             //                       materialTapTargetSize:
//             //                       MaterialTapTargetSize.shrinkWrap,
//             //                       onChanged: (value) {
//             //                         setState(() {
//             //                           items[index]["checked"] = value!;
//             //                         });
//             //                       },
//             //                     ),
//             //                     const SizedBox(width: 8),
//             //                     Expanded(
//             //                       child: Text(
//             //                         items[index]["title"],
//             //                         style: TextStyle(
//             //                           fontSize: 14,
//             //                           fontWeight: FontWeight.w500,
//             //                           decoration: items[index]["checked"]
//             //                               ? TextDecoration.lineThrough
//             //                               : TextDecoration.none,
//             //                           color: items[index]["checked"]
//             //                               ? Colors.grey
//             //                               : Colors.black87,
//             //                         ),
//             //                       ),
//             //                     ),
//             //                   ],
//             //                 ),
//             //               );
//             //             },
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Schedule & Reminders',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1A237E),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Due Date
//                     _buildDateField(
//                       controller: dueDateController,
//                       label: 'Due Date',
//                       hintText: 'Select due date',
//                       icon: Icons.event_note,
//                       onTap: () => _selectDate(context, dueDateController),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     const Text(
//                       "Reminder",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     Row(
//                       children: [
//                         Expanded(
//                           child: RadioListTile<ReminderType>(
//                             value: ReminderType.relative,
//                             groupValue: reminderType,
//                             dense: true,
//                             contentPadding: EdgeInsets.zero,
//                             title: const Text(
//                               "Before Due Date",
//                               style: TextStyle(fontSize: 13),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 reminderType = value!;
//                               });
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: RadioListTile<ReminderType>(
//                             value: ReminderType.custom,
//                             groupValue: reminderType,
//                             dense: true,
//                             contentPadding: EdgeInsets.zero,
//                             title: const Text(
//                               "Custom Date",
//                               style: TextStyle(fontSize: 13),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 reminderType = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     if (reminderType == ReminderType.relative)
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey.shade300),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: selectedReminderOption,
//                             isExpanded: true,
//                             items: reminderOptions.map((option) {
//                               return DropdownMenuItem(
//                                 value: option,
//                                 child: Text(option),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedReminderOption = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//
//                     if (reminderType == ReminderType.custom)
//                       _buildDateField(
//                         controller: reminderDateController,
//                         label: 'Reminder Date',
//                         hintText: 'Select reminder date',
//                         icon: Icons.notifications_active_outlined,
//                         onTap: () => _selectDate(context, reminderDateController),
//                       ),
//
//                     const SizedBox(height: 20),
//
//                     const Text(
//                       "Notification Channels",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         children: List.generate(items.length, (index) {
//                           return CheckboxListTile(
//                             value: items[index]["checked"],
//                             dense: true,
//                             controlAffinity: ListTileControlAffinity.leading,
//                             activeColor: const Color(0xFF1A237E),
//                             title: Text(
//                               items[index]["title"],
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 items[index]["checked"] = value!;
//                               });
//                             },
//                           );
//                         }),
//                       ),
//                     ),
//
//                     const SizedBox(height: 8),
//
//                     Text(
//                       "Members will receive reminders through the selected channels.",
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Submit Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: home1,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 0,
//                   shadowColor: home1.withValues(alpha: 0.3),
//                 ),
//                 onPressed: _submitGroup,
//                 child: Text(
//                   widget.selectedIndex == 889898493849
//                       ? "Create Group"
//                       : "Update Group",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMemberCard(int index, Member member) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: const Color(0xFF1A237E),
//                 radius: 18,
//                 child: Text(
//                   (index + 1).toString(),
//                   style: const TextStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'Member ${index + 1}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.red.shade50),
//                 child: IconButton(
//                   onPressed: () => _removeMember(index),
//                   icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildSimpleTextField(
//                   controller: member.nameController,
//                   hintText: 'Full name',
//                   label: 'Name',
//                 ),
//               ),
//               const SizedBox(width: 8),
//               isLoanEntity == true
//                   ? Expanded(
//                       child: _buildSimpleTextField(
//                         controller: member.amountController,
//                         hintText: 'Enter Loan Amount',
//                         label: 'Loan Amount',
//                         keyboardType: TextInputType.number,
//                       ),
//                     )
//                   : Expanded(
//                       child: _buildSimpleTextField(
//                         controller: member.amountController,
//                         hintText: 'Amount',
//                         label: 'Amount',
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           isLoanEntity == true
//               ? Row(
//                   children: [
//                     Expanded(
//                       child: _buildSimpleTextField(
//                         controller: member.interestController,
//                         hintText: '% Interest Rate',
//                         label: 'Interest Rate',
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _buildSimpleTextField(
//                         controller: member.tenureController,
//                         hintText: 'Enter Loan Tenure',
//                         label: 'Loan Tenure',
//                         keyboardType: TextInputType.number,
//                       ),
//                     )
//                   ],
//                 )
//               : SizedBox.shrink(),
//           const SizedBox(height: 8),
//           isLoanEntity == true
//               ? _buildSimpleTextField(
//                   controller: member.emiController,
//                   hintText: 'EMI Amount',
//                   label: 'EMI Amount',
//                 )
//               : SizedBox.shrink(),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildSimpleTextField(
//                   controller: member.phoneController,
//                   hintText: 'Phone number',
//                   label: 'Phone',
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: _buildSimpleTextField(
//                   controller: member.emailController,
//                   hintText: 'Email address',
//                   label: 'Email',
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//
//           ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: home1,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10))),
//               onPressed: () {},
//               child: Text("Send Notification"))
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSimpleTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required String label,
//     TextInputType? keyboardType,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(fontSize: 14),
//       decoration: InputDecoration(
//         hintText: hintText,
//         labelText: label,
//         hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
//         labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFF1A237E)),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         isDense: true,
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(fontSize: 14),
//       decoration: InputDecoration(
//         hintText: hintText,
//         labelText: label,
//         prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 20),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Color(0xFF1A237E)),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         isDense: true,
//       ),
//     );
//   }
//
//   Widget _buildDateField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 20),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFF1A237E)),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           isDense: true,
//         ),
//         child: Text(
//           controller.text.isEmpty ? hintText : controller.text,
//           style: TextStyle(
//             color:
//                 controller.text.isEmpty ? Colors.grey.shade400 : Colors.black87,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Member Model
// class Member {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController interestController = TextEditingController();
//   final TextEditingController tenureController = TextEditingController();
//   final TextEditingController emiController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//   void dispose() {
//     nameController.dispose();
//     amountController.dispose();
//     interestController.dispose();
//     tenureController.dispose();
//     emiController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//   }
//
//   Member() {
//     amountController.addListener(_updateEmi);
//     interestController.addListener(_updateEmi);
//     tenureController.addListener(_updateEmi);
//   }
//
//   void _updateEmi() {
//     final amount = double.tryParse(amountController.text) ?? 0;
//     final interest = double.tryParse(interestController.text) ?? 0;
//     final tenure = int.tryParse(tenureController.text) ?? 0;
//
//     if (amount > 0 && interest > 0 && tenure > 0) {
//       var monthlyInterest = (interest * 0.01) / 12;
//       var emi =
//           (amount * monthlyInterest * pow((1 + monthlyInterest), tenure)) /
//               ((pow((1 + monthlyInterest), tenure)) - 1);
//
//       emiController.text = emi.toString();
//     } else {
//       emiController.clear();
//     }
//   }
//
//   TextEditingController calculateEmiNew(
//       double principleAmount, double interestRate, int tenure) {
//     var monthlyInterest = (interestRate * 0.01) / 12;
//     var emi = (principleAmount *
//             monthlyInterest *
//             pow((1 + monthlyInterest), tenure)) /
//         ((pow((1 + monthlyInterest), tenure)) - 1);
//
//     emiController.text = emi.toString();
//     return emiController;
//   }
// }
