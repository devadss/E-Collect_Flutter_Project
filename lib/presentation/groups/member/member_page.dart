import 'package:collection_qr_flutter/data/provider/group/create_member/create_member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/colors.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../creation/create_group_page.dart';

class MemberPage extends StatefulWidget {
  final int groupId;
  final int contactId;
  final double amount;
  final String dueDate;
  final String status;
  final String memberName;
  final String memberNumber;


  const MemberPage({super.key, required this.groupId, required this.amount, required this.dueDate, required this.status, required this.memberName, required this.memberNumber, required this.contactId});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<Map<String, dynamic>> selectedMembers = [];
  List<Map<String, dynamic>> filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  String? _corpCode;
  String? _custid;


  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    loadSharedData();

    filteredMembers = List.from(selectedMembers);
    _searchController.addListener(_filterMembers);
  }
  void loadSharedData() async {
    String custid = await SharedPref.shared.getCustId();
    String corpCode = await SharedPref.shared.getCorpCode();

    setState(() {
      _custid= custid;
      _corpCode = corpCode;
    });
    setState(() {
      if(widget.status == "EDIT"){
        selectedMembers.add({
          "name": widget.memberName,
          "phone": widget.memberNumber,
          "amountController": TextEditingController(),
          "contactId": widget.contactId,
        });
        filteredMembers = List.from(selectedMembers);
        _listKey.currentState?.insertItem(selectedMembers.length - 1);
      }

    });

  }
  Future<void> addMember() async {
    showProgressDialog(context);
    var addMember = Provider.of<CreateMemberProvider>(context, listen: false);
    for (var member in selectedMembers) {
      final name = member["name"];
      final phone = member["phone"];
      final amountText = member["amountController"].text.replaceAll(',', '');
      double amount = amountText.isEmpty ? widget.amount : amountText;

          await addMember.createMember(
          widget.groupId,
          name,
          phone,
          double.parse(amount.toString()),
          widget.dueDate,
          widget.dueDate,
          _corpCode!,
          _corpCode!,
          _custid!,
        );


    }
    if(addMember.createMemberResponse?.status==true){

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(addMember.createMemberResponse!.message)),
      );

      _removeAllMembers();
     Navigator.pop(context, "Reload");

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(addMember.err.toString()))
      );
      Navigator.pop(context, "Reload");
    }

  }
  void _removeAllMembers() {
    final itemCount = selectedMembers.length;

    for (int i = itemCount - 1; i >= 0; i--) {
      _listKey.currentState?.removeItem(
        i,
            (context, animation) => _buildMemberTile(selectedMembers[i], i, animation),
        duration: const Duration(milliseconds: 300),
      );
    }

    selectedMembers.clear();
    filteredMembers.clear();

    setState(() {});
    Navigator.pop(context);
  }


  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMembers = selectedMembers.where((member) {
        return member["name"].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _removeMember(int index) {
    final removedItem = selectedMembers[index];
    selectedMembers.removeAt(index);
    filteredMembers = List.from(selectedMembers);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) =>
          _buildMemberTile(removedItem, index, animation),
      duration: const Duration(milliseconds: 300),
    );
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
                      CircularProgressIndicator(
                        color: deepTeal,
                      ),
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

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48,
                      color: Colors.red.shade400),
                  const SizedBox(height: 16),
                 const  Text(
                    "Permission Required",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: home2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Contacts permission is permanently denied. Please enable it from settings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child:const Text(
                          "Cancel",
                          style: TextStyle(color: home2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: home1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          openAppSettings();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Open Settings",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member, int index,
      Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: home1,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        home1.withOpacity(0.8),
                        home1.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      member["name"].substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: home2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Member ${index + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          color: home1.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: home1.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: home1.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: member["amountController"],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                      NumberInputFormatter(),
                    ],
                    style: const TextStyle(
                      color: home2,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding:  EdgeInsets.only(left: 8, right: 4),
                        child: Icon(
                          Icons.currency_rupee,
                          size: 18,
                          color: home1,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      hintText: widget.amount.toString(),
                      hintStyle: TextStyle(
                        color: home1.withOpacity(0.4),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final num = int.tryParse(value.replaceAll(',', '')) ??
                            0;
                        member["amountController"].text =
                            NumberFormat('#,##0').format(num);
                        member["amountController"].selection =
                            TextSelection.fromPosition(
                              TextPosition(
                                  offset: member["amountController"].text
                                      .length),
                            );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeMember(index),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.red.shade400,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: home1.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: home1, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style:const TextStyle(
              fontSize: 12,
              color: home2,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickContact() async {
    PermissionStatus status = await Permission.contacts.status;

    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      if (await FlutterContacts.requestPermission()) {
        final contact = await FlutterContacts.openExternalPick();

        if (contact != null) {
          // Fetch full details (important to access phone numbers)
          final fullContact =
          await FlutterContacts.getContact(contact.id, withProperties: true);

          if (fullContact != null) {
            final name = fullContact.displayName;

            // Grab the first number if available
            final number = fullContact.phones.isNotEmpty
                ? fullContact.phones.first.number
                : 'No number';

            // Check for duplicates by name or number
            bool isDuplicate = selectedMembers.any((member) =>
            member["name"] == name || member["phone"] == number);

            if (isDuplicate) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$name is already in the group"),
                  backgroundColor: Colors.orange.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else {
              setState(() {
                selectedMembers.add({
                  "name": name,
                  "phone": number,
                  "amountController": TextEditingController(),
                  "contactId": fullContact.id,
                });
                filteredMembers = List.from(selectedMembers);
                _listKey.currentState?.insertItem(selectedMembers.length - 1);
              });
            }
          }
        }
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Contacts permission is required to add members."),
          backgroundColor: home1,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildStyledActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: home1.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: home1.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionIcon(
            icon: Icons.person_add,
            label: "Add",
           onTap: _pickContact,

          ),
          _actionIcon(
            icon: isSearching ? Icons.close : Icons.search,
            label: isSearching ? "Close" : "Search",
            onTap: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  _searchController.clear();
                  filteredMembers = List.from(selectedMembers);
                }
              });
            },
          ),
          // _actionIcon(
          //   icon: Icons.edit,
          //   label: "Edit",
          //   onTap: () {
          //     if (filteredMembers.isNotEmpty) {
          //       _showEditAmountsDialog();
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: const Text("No members to edit"),
          //           backgroundColor: Colors.orange.shade600,
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  void _showEditAmountsDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Edit Member"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Name",
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 220,
                              child: TextField(
                                controller: filteredMembers[index]["amountController"],
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter.singleLineFormatter,
                                  LengthLimitingTextInputFormatter(5),
                                  NumberInputFormatter(),
                                ],
                                decoration:  InputDecoration(hintText: filteredMembers[index]["name"],
                                  prefixIcon: const Icon(Icons.person, size: 18),
                                  contentPadding:
                                 const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  isDense: true,
                                  border:const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                       const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Number",
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 220,
                              child: TextField(
                                controller: filteredMembers[index]["amountController"],
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter.singleLineFormatter,
                                  LengthLimitingTextInputFormatter(5),
                                  NumberInputFormatter(),
                                ],
                                decoration:  InputDecoration(hintText: filteredMembers[index]["phone"],
                                  prefixIcon:const Icon(Icons.phone_iphone, size: 18),
                                  contentPadding:
                                 const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  isDense: true,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Amount",
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: 220,
                              child: TextField(
                                controller: _searchController,
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter.singleLineFormatter,
                                  LengthLimitingTextInputFormatter(5),
                                  NumberInputFormatter(),
                                ],
                                decoration:  InputDecoration(hintText: widget.amount.toString(),
                                  prefixIcon:const Icon(Icons.currency_rupee, size: 18),
                                  contentPadding:
                                 const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  isDense: true,
                                  border:const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: home2)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: home1),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                    "Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Group Members"),
              const SizedBox(height: 12),

              /// New: Styled action card
              _buildStyledActionButtons(),

              const SizedBox(height: 20),

              Expanded(
                child: filteredMembers.isEmpty
                    ? Center(
                  child: Text(
                    "No members added yet.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                )
                    : AnimatedList(
                  key: _listKey,
                  initialItemCount: filteredMembers.length,
                  itemBuilder: (context, index, animation) {
                    final member = filteredMembers[index];
                    return _buildMemberTile(member, index, animation);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// Bottom Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: home1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
            ),
            onPressed: () {
              // Handle create group logic
              addMember();
            },
            child:  Text(
              widget.status == "EDIT"?"Update Member":
              "Add Member",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.person_add, color: home1, size: 28),
          onPressed: _pickContact,
          tooltip: "Add Members",
        ),
        IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.search,
              color: home1, size: 28),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) {
                _searchController.clear();
                filteredMembers = List.from(selectedMembers);
              }
            });
          },
          tooltip: isSearching ? "Close Search" : "Search Members",
        ),
        IconButton(
          icon:  const Icon(Icons.edit, color: home1, size: 28),
          onPressed: () {
            if (filteredMembers.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: const Text("Edit Amounts"),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(filteredMembers[index]["name"]),
                              trailing: SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: filteredMembers[index]
                                  ["amountController"],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(5),
                                    NumberInputFormatter(),
                                  ],
                                  decoration:const InputDecoration(
                                    prefixIcon:
                                    Icon(Icons.currency_rupee, size: 18),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child:const Text("Cancel", style: TextStyle(color: home2)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: home1),
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("Save",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("No members to edit"),
                  backgroundColor: Colors.orange.shade600,
                ),
              );
            }
          },
          tooltip: "Edit Amounts",
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: home2,
      ),
    );
  }
}
