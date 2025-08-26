// import 'dart:core';
//
// import 'package:flutter/material.dart';
// import 'package:collection_qr_flutter/core/colors.dart';
// import 'package:provider/provider.dart';
// import '../../../data/provider/group/group_list/group_list_preovider.dart';
// import '../../../data/storage/shared_pref_helper.dart';
// import '../../../domain/model/group/group_listing/group_list_model.dart';
// import '../creation/create_group_page.dart';
// import '../group_homepage/detail_page/group_detail_page.dart';
//
// class AllGroupsPage extends StatefulWidget {
//   const AllGroupsPage({super.key});
//
//   @override
//   State<AllGroupsPage> createState() => _AllGroupsPageState();
// }
//
// class _AllGroupsPageState extends State<AllGroupsPage> {
//   bool _isSearching = false;
//   String? _corpCode;
//   final TextEditingController _searchController = TextEditingController();
//   List<Group> _groups = [
//
//   ];
//   List<Group> _filteredGroups = [];
//
//   void loadSharedData() async {
//     //String custid = await SharedPref.shared.getCustId();
//     String corpCode = await SharedPref.shared.getCorpCode();
//     print("loadSharedData");
//     setState(() {
//       _corpCode = corpCode;
//     });
//     showProgressDialog(context);
//     getGroups();
//     _searchController.addListener(_filterGroups);
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
//   @override
//   void initState() {
//     super.initState();
//     loadSharedData();
//   }
//
//   Future<void> getGroups() async {
//     print("getGroups");
//     final groupProvider =
//         Provider.of<GroupListProvider>(context, listen: false);
//     await groupProvider.listGroupUnderUser();
//     if (groupProvider.groupListResponse != null) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pop(context);
//     }
//     final List<Group> fetchedGroups =
//         groupProvider.groupListResponse?.data ?? [];
//
//     // Filter groups by corpCode
//     final List<Group> filtered = fetchedGroups
//         // .where((group) => group.corpCode != null && group.corpCode == "MOBWER")
//         .where((group) => group.corpCode != null && group.corpCode == _corpCode)
//         .toList();
//
//     setState(() {
//       _groups = filtered;
//       _filteredGroups = filtered;
//     });
//   }
//
//   void _filterGroups() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredGroups = _groups
//           .where((group) => group.groupName.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: home1,
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const CreateGroupPage(groupName: '', amount: '', dueDate: '', groupId: 0,),
//               fullscreenDialog: true,
//             ),
//           );
//           if (result == "Reload") {
//             loadSharedData();
//           }
//         },
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: const Icon(Icons.add, color: white, size: 28),
//       ),
//       body: NestedScrollView(
//         headerSliverBuilder: (_, __) => [
//           SliverAppBar(
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//             floating: true,
//             pinned: true,
//             snap: true,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             flexibleSpace: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [home1, home2.withOpacity(0.9)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             title: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: _isSearching
//                   ? const SizedBox()
//                   : const Text(
//                       "Groups",
//                       style: TextStyle(
//                           color: white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22),
//                     ),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(_isSearching ? Icons.close : Icons.search,
//                     color: white),
//                 onPressed: () {
//                   setState(() {
//                     _isSearching = !_isSearching;
//                     if (!_isSearching) _searchController.clear();
//                   });
//                 },
//               ),
//             ],
//             bottom: _isSearching
//                 ? PreferredSize(
//                     preferredSize: const Size.fromHeight(60),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: TextField(
//                           controller: _searchController,
//                           autofocus: true,
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(vertical: 15),
//                             hintText: "Search groups...",
//                             border: InputBorder.none,
//                             prefixIcon: Icon(Icons.search, color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//         ],
//         body: _filteredGroups.isEmpty
//             ? _buildEmptyState()
//             : ListView.builder(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 itemCount: _filteredGroups.length,
//                 itemBuilder: (context, index) {
//                   final group = _filteredGroups[index];
//                   final color =
//                       Colors.primaries[index % Colors.primaries.length];
//                   const icon = Icons.group; // you can customize this if needed
//
//                   return TweenAnimationBuilder(
//                     tween: Tween<double>(begin: 0, end: 1),
//                     duration: Duration(milliseconds: 300 + (index * 80)),
//                     builder: (context, value, child) {
//                       return Transform.scale(
//                         scale: value,
//                         child: Opacity(opacity: value, child: child),
//                       );
//                     },
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16)),
//                       elevation: 4,
//                       shadowColor: color.withOpacity(0.3),
//                       child: ListTile(
//                         onTap: () async {
//                           final result = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => GroupDetailPage(
//                                 amount: group.defaultAmount.toStringAsFixed(0),
//                                 dueDate: group.defaultDueDate
//                                     .toLocal()
//                                     .toString()
//                                     .split(' ')[0],
//                                 groupId: group.groupId,
//                                 groupName: group.groupName,
//                               ),
//                             ),
//                           );
//                           if (result == "Reload") {
//                             loadSharedData();
//                           }
//                         },
//                         contentPadding: const EdgeInsets.all(16),
//                         leading: CircleAvatar(
//                           radius: 26,
//                           backgroundColor: color.withOpacity(0.15),
//                           child: Icon(icon, color: color, size: 26),
//                         ),
//                         title: Text(
//                           group.groupName,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         subtitle: Text(
//                           "Amount: ₹${group.defaultAmount.toStringAsFixed(0)} • Due: ${group.defaultDueDate.toLocal().toString().split(' ')[0]}",
//                           style: TextStyle(
//                               fontSize: 13, color: Colors.grey.shade600),
//                         ),
//                         trailing: Icon(Icons.chevron_right,
//                             color: Colors.grey.shade400),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.group_off, size: 72, color: home1.withOpacity(0.3)),
//           const SizedBox(height: 20),
//           Text(
//             _searchController.text.isEmpty
//                 ? "No groups created yet"
//                 : "No matching groups found",
//             style: TextStyle(
//                 fontSize: 18, color: home1.withOpacity(0.6), height: 1.4),
//             textAlign: TextAlign.center,
//           ),
//           if (_searchController.text.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: TextButton(
//                 onPressed: () => _searchController.clear(),
//                 style: TextButton.styleFrom(foregroundColor: home1),
//                 child: const Text("Clear search"),
//               ),
//             )
//         ],
//       ),
//     );
//   }
// }


import 'dart:core';

import 'package:flutter/material.dart';
import 'package:collection_qr_flutter/core/colors.dart';
import 'package:provider/provider.dart';
import '../../../data/provider/group/group_list/group_list_preovider.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/group/group_listing/group_list_model.dart';
import '../creation/create_group_page.dart';
import '../group_homepage/detail_page/group_detail_page.dart';

class AllGroupsPage extends StatefulWidget {
  const AllGroupsPage({super.key});

  @override
  State<AllGroupsPage> createState() => _AllGroupsPageState();
}

class _AllGroupsPageState extends State<AllGroupsPage> {
  bool _isSearching = false;
  String? _corpCode;
  final TextEditingController _searchController = TextEditingController();
  List<Group> _groups = [];
  List<Group> _filteredGroups = [];

  // Map of group names to icons and colors
  Map<String, Map<String, dynamic>> groupIconMap = {
    "premium members": {"icon": Icons.star, "color": Colors.amber},
    "morning session": {"icon": Icons.wb_sunny, "color": Colors.orange},
    "evening session": {"icon": Icons.nights_stay, "color": Colors.indigo},
    "personal training": {"icon": Icons.person, "color": Colors.purple},
    "yoga class": {"icon": Icons.self_improvement, "color": Colors.teal},
    "weight loss program": {
      "icon": Icons.monitor_weight,
      "color": Colors.green
    },
    "bodybuilding team": {"icon": Icons.fitness_center, "color": Colors.red},

    // --- Finance & Membership ---
    "gym monthly fees": {"icon": Icons.attach_money, "color": Colors.green},
    "annual membership": {"icon": Icons.calendar_month, "color": Colors.blue},
    "installment plan": {"icon": Icons.payments, "color": Colors.orange},
    "student discount": {"icon": Icons.school, "color": Colors.indigo},
    "family package": {
      "icon": Icons.family_restroom,
      "color": Colors.pinkAccent
    },

    // --- Tuition & Education ---
    "tuition - class 10": {"icon": Icons.menu_book, "color": Colors.deepPurple},
    "tuition - class 12": {"icon": Icons.book, "color": Colors.blueAccent},
    "coaching center": {"icon": Icons.school, "color": Colors.brown},
    "language class": {"icon": Icons.translate, "color": Colors.teal},
    "computer training": {"icon": Icons.computer, "color": Colors.blueGrey},
    "coding bootcamp": {"icon": Icons.code, "color": Colors.deepOrange},
    "drawing class": {"icon": Icons.brush, "color": Colors.purpleAccent},
    "dance academy": {"icon": Icons.music_video, "color": Colors.redAccent},
    "music class": {"icon": Icons.music_note, "color": Colors.orange},
    "guitar lessons": {"icon": Icons.queue_music, "color": Colors.green},
    "piano lessons": {"icon": Icons.piano, "color": Colors.indigo},
    "art workshop": {"icon": Icons.color_lens, "color": Colors.pink},

    // --- Fitness & Lifestyle ---
    "fitness 4 life": {"icon": Icons.favorite, "color": Colors.red},
    "wellness hub": {"icon": Icons.spa, "color": Colors.teal},
    "active seniors": {"icon": Icons.elderly, "color": Colors.brown},
    "kids zone": {"icon": Icons.child_friendly, "color": Colors.lightBlue},
    "ladies special batch": {"icon": Icons.woman, "color": Colors.pinkAccent},
    "gents training": {"icon": Icons.man, "color": Colors.indigoAccent},
    "outdoor bootcamp": {"icon": Icons.landscape, "color": Colors.green},
    "indoor batch": {"icon": Icons.home, "color": Colors.blueGrey},

    // --- Sports & Extra ---
    "football practice": {"icon": Icons.sports_soccer, "color": Colors.green},
    "cricket lovers": {"icon": Icons.sports_cricket, "color": Colors.blue},
    "basketball crew": {
      "icon": Icons.sports_basketball,
      "color": Colors.deepOrange
    },
    "swimming club": {"icon": Icons.pool, "color": Colors.cyan},
    "badminton group": {"icon": Icons.sports_tennis, "color": Colors.amber},
    "chess academy": {"icon": Icons.extension, "color": Colors.grey},

    // --- Special & Community ---
    "festive offers": {"icon": Icons.celebration, "color": Colors.deepOrange},
    "birthday batch": {"icon": Icons.cake, "color": Colors.pinkAccent},
    "holiday camp": {"icon": Icons.beach_access, "color": Colors.teal},
    "community club": {"icon": Icons.groups, "color": Colors.blue},
    "trainer's hub": {"icon": Icons.support, "color": Colors.purple},
    "exclusive circle": {"icon": Icons.lock, "color": Colors.black},
  };

  // Function to get icon and color based on group name
  Map<String, dynamic> _getGroupIconAndColor(String groupName) {
    final name = groupName.toLowerCase();

    // Check for exact matches first
    if (groupIconMap.containsKey(name)) {
      return groupIconMap[name]!;
    }

    // Check for partial matches
    for (var key in groupIconMap.keys) {
      if (name.contains(key)) {
        return groupIconMap[key]!;
      }
    }

    // Default values if no match found
    return {
      "icon": Icons.group,
      "color": Colors.primaries[name.length % Colors.primaries.length]
    };
  }

  void loadSharedData() async {
    String corpCode = await SharedPref.shared.getCorpCode();
    print("loadSharedData");
    setState(() {
      _corpCode = corpCode;
    });
    showProgressDialog(context);
    getGroups();
    _searchController.addListener(_filterGroups);
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

  @override
  void initState() {
    super.initState();
    loadSharedData();
  }

  Future<void> getGroups() async {
    print("getGroups");
    final groupProvider =
    Provider.of<GroupListProvider>(context, listen: false);
    await groupProvider.listGroupUnderUser();
    if (groupProvider.groupListResponse != null) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
    final List<Group> fetchedGroups =
        groupProvider.groupListResponse?.data ?? [];

    // Filter groups by corpCode
    final List<Group> filtered = fetchedGroups
        .where((group) => group.corpCode != null && group.corpCode == _corpCode)
        .toList();

    setState(() {
      _groups = filtered;
      _filteredGroups = filtered;
    });
  }

  void _filterGroups() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGroups = _groups
          .where((group) => group.groupName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: home1,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateGroupPage(groupName: '', amount: '', dueDate: '', groupId: 0,),
              fullscreenDialog: true,
            ),
          );
          if (result == "Reload") {
            loadSharedData();
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: white, size: 28),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [home1, home2.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isSearching
                  ? const SizedBox()
                  : const Text(
                "Groups",
                style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search,
                    color: white),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) _searchController.clear();
                  });
                },
              ),
            ],
            bottom: _isSearching
                ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      hintText: "Search groups...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            )
                : null,
          ),
        ],
        body: _filteredGroups.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: _filteredGroups.length,
          itemBuilder: (context, index) {
            final group = _filteredGroups[index];
            final iconData = _getGroupIconAndColor(group.groupName)["icon"] as IconData;
            final color = _getGroupIconAndColor(group.groupName)["color"] as Color;

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 80)),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: color.withOpacity(0.3),
                child: ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupDetailPage(
                          amount: group.defaultAmount.toStringAsFixed(0),
                          dueDate: group.defaultDueDate
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                          groupId: group.groupId,
                          groupName: group.groupName,
                        ),
                      ),
                    );
                    if (result == "Reload") {
                      loadSharedData();
                    }
                  },
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(iconData, color: color, size: 26),
                  ),
                  title: Text(
                    group.groupName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Amount: ₹${group.defaultAmount.toStringAsFixed(0)} • Due: ${group.defaultDueDate.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: Colors.grey.shade400),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 72, color: home1.withOpacity(0.3)),
          const SizedBox(height: 20),
          Text(
            _searchController.text.isEmpty
                ? "No groups created yet"
                : "No matching groups found",
            style: TextStyle(
                fontSize: 18, color: home1.withOpacity(0.6), height: 1.4),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () => _searchController.clear(),
                style: TextButton.styleFrom(foregroundColor: home1),
                child: const Text("Clear search"),
              ),
            )
        ],
      ),
    );
  }
}