import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../data/provider/group/create_group/create_group_with_member_provider.dart';
import '../../../data/provider/group/update_group/group_update_repository.dart';
import '../../../data/storage/shared_pref_helper.dart';

class CreateGroupPage extends StatefulWidget {
  final String groupName;
  final String amount;
  final String dueDate;
  final int groupId;

  const CreateGroupPage(
      {super.key,
      required this.groupName,
      required this.amount,
      required this.dueDate, required this.groupId});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController feeCollectionDayController =
      TextEditingController();
  final TextEditingController feeCollectionStartDateController =
      TextEditingController();
  final TextEditingController groupDeactivationDateController =
      TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> selectedMembers = [];
  List<Map<String, dynamic>> filteredMembers = [];
  bool isSearching = false;
  String? _corpCode;
  String? _entityId;

  @override
  void initState() {
    super.initState();
    if (widget.groupName.isNotEmpty) {
      groupNameController.text = widget.groupName;
      amountController.text = widget.amount;
      feeCollectionDayController.text = widget.dueDate;
    }
    loadSharedData();
    filteredMembers = List.from(selectedMembers);
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMembers = selectedMembers.where((member) {
        return member["name"].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> updateGroup() async {
    var updateGroup = Provider.of<GroupUpdateProvider>(context, listen:false);
    await updateGroup.updateGroup(widget.groupId, widget.groupName, double.parse(widget.amount),widget.dueDate,_corpCode!, _corpCode!);
    if(updateGroup.groupUpdateResponse!.status == true){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(updateGroup.groupUpdateResponse!.message),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }

  }

  Future<void> _pickDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: home1,
              onPrimary: white,
              onSurface: home2,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: home1,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          // "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Future<void> _pickContact() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted && await FlutterContacts.requestPermission()) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        final fullContact = await FlutterContacts.getContact(contact.id);
        if (fullContact != null && fullContact.phones.isNotEmpty) {
          setState(() {
            for (var phone in fullContact.phones) {
              final cleanNumber = phone.number.replaceAll(RegExp(r'\s+'), '');

              // Optional: prevent exact duplicates
              bool exists = selectedMembers.any((member) =>
                  member["name"] == fullContact.displayName &&
                  member["mobileNumber"] == cleanNumber);

              if (!exists) {
                selectedMembers.add({
                  "name": fullContact.displayName,
                  "mobileNumber": cleanNumber,
                  "amountController": TextEditingController(),
                  "contactId": fullContact.id,
                });
                _listKey.currentState?.insertItem(selectedMembers.length - 1);
              }
            }
            filteredMembers = List.from(selectedMembers);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("No phone numbers found for ${contact.displayName}"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contacts permission is required to add members."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> _pickContact() async {
  //   PermissionStatus status = await Permission.contacts.status;
  //   if (!status.isGranted) {
  //     status = await Permission.contacts.request();
  //   }
  //
  //   if (status.isGranted) {
  //     if (await FlutterContacts.requestPermission()) {
  //       final contact = await FlutterContacts.openExternalPick();
  //
  //       // if (contact != null) {
  //       //   bool isDuplicate = selectedMembers
  //       //       .any((member) => member["name"] == contact.displayName);
  //       //
  //       //   if (isDuplicate) {
  //       //     ScaffoldMessenger.of(context).showSnackBar(
  //       //       SnackBar(
  //       //         content: Text("${contact.displayName} is already in the group"),
  //       //         behavior: SnackBarBehavior.floating,
  //       //         shape: RoundedRectangleBorder(
  //       //           borderRadius: BorderRadius.circular(10),
  //       //         ),
  //       //         backgroundColor: Colors.orange.shade600,
  //       //         duration: const Duration(seconds: 2),
  //       //       ),
  //       //     );
  //       //   } else {
  //       //     setState(() {
  //       //       selectedMembers.add({
  //       //         "name": contact.displayName,
  //       //         "amountController": TextEditingController(),
  //       //         "contactId": contact.id,
  //       //       });
  //       //       filteredMembers = List.from(selectedMembers);
  //       //       _listKey.currentState?.insertItem(selectedMembers.length - 1);
  //       //     });
  //       //   }
  //       // }
  //       if (contact != null) {
  //         final fullContact = await FlutterContacts.getContact(
  //             contact.id); // fetch full details
  //
  //         if (fullContact != null) {
  //           final phoneNumbers = fullContact.phones;
  //           String? mobileNumber;
  //
  //           // Optional: Try to pick the mobile number specifically
  //           if (phoneNumbers.isNotEmpty) {
  //             mobileNumber =
  //                 phoneNumbers.first.number; // You can refine this logic
  //           }
  //
  //           bool isDuplicate = selectedMembers.any((member) =>
  //               member["name"] == fullContact.displayName &&
  //               member["mobileNumber"] == mobileNumber);
  //
  //           if (isDuplicate) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text(
  //                     "${fullContact.displayName} is already in the group"),
  //                 behavior: SnackBarBehavior.floating,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 backgroundColor: Colors.orange.shade600,
  //                 duration: const Duration(seconds: 2),
  //               ),
  //             );
  //           } else {
  //             setState(() {
  //               selectedMembers.add({
  //                 "name": fullContact.displayName,
  //                 "mobileNumber": mobileNumber ?? "",
  //                 "amountController": TextEditingController(),
  //                 "contactId": fullContact.id,
  //               });
  //               filteredMembers = List.from(selectedMembers);
  //               _listKey.currentState?.insertItem(selectedMembers.length - 1);
  //             });
  //           }
  //         }
  //       }
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     _showPermissionDialog();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             const Text("Contacts permission is required to add members."),
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         backgroundColor: home1,
  //       ),
  //     );
  //   }
  // }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
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
                    child: Text(
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

  void _removeMember(int index) {
    final removedItem = selectedMembers[index];
    selectedMembers.removeAt(index);
    filteredMembers = List.from(selectedMembers);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildMemberTile(removedItem, index, animation),
      duration: const Duration(milliseconds: 300),
    );
  }

  void _editMemberAmount(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Amount for ${filteredMembers[index]["name"]}"),
        content: TextField(
          controller: filteredMembers[index]["amountController"],
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
            NumberInputFormatter(),
          ],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.currency_rupee, color: home1),
            hintText: "Enter new amount",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: home2)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: home1),
            onPressed: () {
              setState(() {
                final value = filteredMembers[index]["amountController"].text;
                if (value.isNotEmpty) {
                  final num = int.tryParse(value.replaceAll(',', '')) ?? 0;
                  filteredMembers[index]["amountController"].text =
                      NumberFormat('#,##0').format(num);
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(
      Map<String, dynamic> member, int index, Animation<double> animation) {
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
                      style: TextStyle(
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
                        style: TextStyle(
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
                    style: TextStyle(
                      color: home2,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
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
                      hintText: "0",
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
                        final num =
                            int.tryParse(value.replaceAll(',', '')) ?? 0;
                        member["amountController"].text =
                            NumberFormat('#,##0').format(num);
                        member["amountController"].selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: member["amountController"].text.length),
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

  Widget _buildStaticMemberTile(Map<String, dynamic> member, int index) {
    return Container(
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
                  style: TextStyle(
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
                    style: TextStyle(
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
                style: TextStyle(
                  color: home2,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
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
                  hintText: "0",
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
                    final num = int.tryParse(value.replaceAll(',', '')) ?? 0;
                    member["amountController"].text =
                        NumberFormat('#,##0').format(num);
                    member["amountController"].selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: member["amountController"].text.length),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Find the index in selectedMembers
                int selectedIndex = selectedMembers
                    .indexWhere((m) => m["contactId"] == member["contactId"]);
                if (selectedIndex != -1) {
                  _removeMember(selectedIndex);
                }
              },
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.person_add, color: home1, size: 28),
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
          icon: Icon(Icons.edit, color: home1, size: 28),
          onPressed: () {
            if (filteredMembers.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
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
                              decoration: InputDecoration(
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
                      child: Text("Cancel", style: TextStyle(color: home2)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: home1),
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

  // Future<void> createGroup() async {
  //   var createGroup =
  //       Provider.of<CreateGroupWithMemberProvider>(context, listen: false);
  //   for (var member in selectedMembers) {
  //     final name = member["name"];
  //     final amountText = member["amountController"].text.replaceAll(',', '');
  //     double amount = amountText.isEmpty ? double.parse(amountController.text.toString()) : amountText;
  //     final rawPhone = member["mobileNumber"] ?? "";
  //     final phone = rawPhone.replaceAll(RegExp(r'\s+'), '');
  //
  //     await createGroup.createGroupWitMember(
  //         groupNameController.text,
  //         _corpCode!,
  //         double.parse(amountController.text.toString()),
  //         feeCollectionDayController.text,
  //         _entityId!,
  //         name,
  //         phone,
  //         amount,
  //         feeCollectionDayController.text,
  //         feeCollectionStartDateController.text);
  //   }
  // }

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

  Future<void> createGroup() async {
    if (groupNameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        feeCollectionStartDateController.text.isNotEmpty &&
        feeCollectionDayController.text.isNotEmpty &&
        groupDeactivationDateController.text.isNotEmpty) {
      showProgressDialog(context);
      var createGroupProvider =
          Provider.of<CreateGroupWithMemberProvider>(context, listen: false);
      List<Map<String, dynamic>> members = [];

      for (var member in selectedMembers) {
        final name = member["name"] ?? "Unnamed";
        final rawPhone = member["mobileNumber"] ?? "";
        final phone = rawPhone.replaceAll(RegExp(r'\s+'), '');

        final amountText =
            member["amountController"]?.text.replaceAll(',', '') ?? "";
        final amount = amountText.isEmpty
            ? double.tryParse(amountController.text) ?? 0.0
            : double.tryParse(amountText) ?? 0.0;

        members.add({
          "entityId": _entityId ?? "",
          "memberName": name,
          "mobileNumber": phone,
          "amount": amount,
          "dueDate": feeCollectionDayController.text,
          "feeCollectionStartDate": feeCollectionStartDateController.text,
        });
      }

      final payload = {
        "groupName": groupNameController.text,
        "corpCode": _corpCode ?? "",
        "defaultAmount": double.tryParse(amountController.text) ?? 0.0,
        "defaultDueDate": feeCollectionDayController.text,
        "members": members,
      };

      // Send the full group creation request once
      await createGroupProvider.createGroupWitMember(payload);

      if (createGroupProvider.createGroupWithMemberResponse!.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  createGroupProvider.createGroupWithMemberResponse!.message)),
        );
        Navigator.pop(
          context,
        );
        Navigator.pop(context, "Reload");
      } else {
        Navigator.pop(
          context,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Empty Fields Not Allowed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void loadSharedData() async {
    String custid = await SharedPref.shared.getCustId();
    String corpCode = await SharedPref.shared.getCorpCode();

    setState(() {
      _entityId = custid;
      _corpCode = corpCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.dueDate.isNotEmpty ? "Update Group" : "Create a Group",
          style: const TextStyle(
              color: home2, fontWeight: FontWeight.w700, fontSize: 22),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: home2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildSectionTitle("Group Information"),
            const SizedBox(height: 16),
            _buildTextField(
              title: "Group Name",
              hintText: "Enter group name",
              controller: groupNameController,
              keyboardType: TextInputType.text,
              icon: Icon(Icons.group, color: home1),
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              title: "Amount",
              hintText: "Enter amount",
              controller: amountController,
              keyboardType: TextInputType.number,
              icon: Icon(Icons.currency_rupee_outlined, color: home1),
              isRequired: true,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Schedule"),
            const SizedBox(height: 16),
            _buildTextField(
              title: "Fee Collection Day",
              hintText: "Select fee collection day",
              controller: feeCollectionDayController,
              keyboardType: TextInputType.none,
              icon: Icon(Icons.calendar_month, color: home1),
              onTap: () => _pickDate(context, feeCollectionDayController),
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              title: "Fee Collection Start Date",
              hintText: "Select start date",
              controller: feeCollectionStartDateController,
              keyboardType: TextInputType.none,
              icon: const Icon(Icons.date_range, color: home1),
              onTap: () => _pickDate(context, feeCollectionStartDateController),
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              title: "Group Deactivation Date",
              hintText: "Select deactivation date",
              controller: groupDeactivationDateController,
              keyboardType: TextInputType.none,
              icon: const Icon(Icons.calendar_today, color: home1),
              onTap: () => _pickDate(context, groupDeactivationDateController),
            ),
            const SizedBox(height: 24),
            widget.groupName.isEmpty
                ? _buildSectionTitle("Group Members")
                : SizedBox(),
            const SizedBox(height: 16),
            if (selectedMembers.isEmpty && widget.groupName.isEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickContact,
                  icon: const Icon(Icons.person_add_alt_1,
                      color: white, size: 20),
                  label:
                      const Text("Add Members", style: TextStyle(color: white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: home1,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            if (selectedMembers.isNotEmpty && widget.groupName.isEmpty)
              _buildActionButtons(),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search members...",
                  prefixIcon: Icon(Icons.search, color: home1),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: home1),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        filteredMembers = List.from(selectedMembers);
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (isSearching)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  return _buildStaticMemberTile(filteredMembers[index], index);
                },
              )
            else
              AnimatedList(
                key: _listKey,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: selectedMembers.length,
                itemBuilder: (context, index, animation) {
                  return _buildMemberTile(
                      selectedMembers[index], index, animation);
                },
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: home1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  widget.groupName.isNotEmpty?
                  updateGroup():
                  createGroup();
                  // Handle create group logic
                },
                child: Text(
                  widget.dueDate.isNotEmpty ? "Update Group" : "Create Group",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
      required TextEditingController controller,
      required TextInputType keyboardType,
      int maxLines = 1,
      Icon? icon,
      VoidCallback? onTap,
      bool isRequired = false,
      required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: home2,
                ),
              ),
              if (isRequired)
                Text(
                  "*",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade400,
                  ),
                ),
            ],
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: onTap != null,
          onTap: onTap,
          style: TextStyle(color: home2),
          decoration: InputDecoration(
            prefixIcon: icon,
            prefixIconColor: home1,
            hintText: hintText,
            hintStyle: TextStyle(color: home1.withOpacity(0.5)),
            filled: true,
            fillColor: white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: home1.withOpacity(0.2), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: home1, width: 1.5),
            ),
          ),
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

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final num = int.tryParse(newValue.text.replaceAll(',', '')) ?? 0;
    final newText = NumberFormat('#,##0').format(num);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
