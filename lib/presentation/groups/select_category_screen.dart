import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/presentation/groups/bnk_account_details/bank_accout_detail_page.dart';
import 'package:flutter/material.dart';

import 'bnk_account_details/bank_details_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final List<Map<String, dynamic>> _allCategories = [
    {'name': 'Fitness Center', 'icon': '🏋️'},
    {'name': 'Tuition Center', 'icon': '📚'},
    {'name': 'Yoga Studio', 'icon': '🧘'},
    {'name': 'Dance Academy', 'icon': '💃'},
    {'name': 'Music School', 'icon': '🎵'},
    {'name': 'Art Gallery', 'icon': '🎨'},
    {'name': 'Library', 'icon': '📖'},
    {'name': 'Co-working Space', 'icon': '💻'},
    {'name': 'Sports Club', 'icon': '⚽'},
    {'name': 'Swimming Pool', 'icon': '🏊'},
    {'name': 'Gymnasium', 'icon': '🏋️‍♂️'},
    {'name': 'Martial Arts Dojo', 'icon': '🥋'},
    {'name': 'Cooking Class', 'icon': '🍳'},
    {'name': 'Language School', 'icon': '🗣️'},
    {'name': 'Photography Studio', 'icon': '📷'},
    {'name': 'Theater Group', 'icon': '🎭'},
    {'name': 'Book Club', 'icon': '📚'},
    {'name': 'Tech Hub', 'icon': '💻'},
    {'name': 'Medical Center', 'icon': '🏥'},
    {'name': 'Dental Clinic', 'icon': '🦷'},
    {'name': 'Spa & Wellness', 'icon': '💆'},
    {'name': 'Beauty Salon', 'icon': '💄'},
    {'name': 'Barber Shop', 'icon': '✂️'},
    {'name': 'Pet Care Center', 'icon': '🐕'},
    {'name': 'Veterinary Clinic', 'icon': '🐾'},
  ];

  List<Map<String, dynamic>> _filteredCategories = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(_allCategories); // Create a new list from _allCategories
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories
          .where((category) => category['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Select Category",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: home2,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _searchFocusNode.hasFocus ? home2 : Colors.transparent,
                  width: 2.0,
                ),
              ),
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: home2),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Selected Category Chip
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Selected: ',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Chip(
                    backgroundColor: home1.withOpacity(0.2),
                    label: Text(
                      _selectedCategory!,
                      style: const TextStyle(color: home2),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18, color: home2),
                    onDeleted: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Categories Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  final isSelected = _selectedCategory == category['name'];

                  return GestureDetector(
                    onTap: () => _selectCategory(category['name']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? home2 : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: isSelected ? home2 : Colors.black87,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category['icon'],
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : home2,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isSelected)
                           const Padding(
                              padding:  EdgeInsets.only(top: 8),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Confirm Button
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: home1,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const  BankDetailsScreen(
                      status:""
                  )));
                 // Navigator.pop(context, _selectedCategory);
                },
                child: const Text(
                  'CONFIRM SELECTION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }
}