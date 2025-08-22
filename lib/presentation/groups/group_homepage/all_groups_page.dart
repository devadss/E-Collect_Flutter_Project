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

  // Function to get emoji based on group name
  String _getGroupEmoji(String groupName) {
    final name = groupName.toLowerCase();

    if (name.contains('family') || name.contains('fam')) {
      return '👨‍👩‍👧‍👦';
    } else if (name.contains('friend') || name.contains('buddy') || name.contains('pal')) {
      return '👥';
    } else if (name.contains('work') || name.contains('office') || name.contains('colleague') || name.contains('job')) {
      return '💼';
    } else if (name.contains('travel') || name.contains('trip') || name.contains('vacation')) {
      return '✈️';
    } else if (name.contains('sport') || name.contains('game') || name.contains('fitness')) {
      return '⚽';
    } else if (name.contains('food') || name.contains('dinner') || name.contains('lunch') || name.contains('restaurant')) {
      return '🍕';
    } else if (name.contains('event') || name.contains('party') || name.contains('celebration')) {
      return '🎉';
    } else if (name.contains('education') || name.contains('study') || name.contains('school') || name.contains('college')) {
      return '🎓';
    } else if (name.contains('health') || name.contains('medical') || name.contains('hospital')) {
      return '🏥';
    } else if (name.contains('shopping') || name.contains('store') || name.contains('market')) {
      return '🛒';
    } else if (name.contains('car') || name.contains('vehicle') || name.contains('auto')) {
      return '🚗';
    } else if (name.contains('home') || name.contains('house') || name.contains('apartment')) {
      return '🏠';
    } else if (name.contains('gift') || name.contains('present')) {
      return '🎁';
    } else if (name.contains('movie') || name.contains('film') || name.contains('cinema')) {
      return '🎬';
    } else if (name.contains('music')) {
      return '🎵';
    } else if (name.contains('book') || name.contains('read') || name.contains('library')) {
      return '📚';
    } else if (name.contains('saving') || name.contains('save') || name.contains('money')) {
      return '💰';
    } else if (name.contains('tech') || name.contains('computer') || name.contains('it')) {
      return '💻';
    } else if (name.contains('art') || name.contains('design') || name.contains('creative')) {
      return '🎨';
    } else if (name.contains('nature') || name.contains('environment') || name.contains('green')) {
      return '🌳';
    } else if (name.contains('pet') || name.contains('dog') || name.contains('cat')) {
      return '🐾';
    } else if (name.contains('baby') || name.contains('child') || name.contains('kid')) {
      return '👶';
    } else if (name.contains('wedding') || name.contains('marriage')) {
      return '💒';
    } else if (name.contains('holiday') || name.contains('festival')) {
      return '🎄';
    } else {
      return '👥'; // Default emoji
    }
  }

  // Function to get color based on group name
  Color _getGroupColor(String groupName) {
    final name = groupName.toLowerCase();

    if (name.contains('family')) {
      return Colors.deepPurple;
    } else if (name.contains('friend')) {
      return Colors.blue;
    } else if (name.contains('work')) {
      return Colors.indigo;
    } else if (name.contains('travel')) {
      return Colors.teal;
    } else if (name.contains('sport')) {
      return Colors.green;
    } else if (name.contains('food')) {
      return Colors.orange;
    } else if (name.contains('event')) {
      return Colors.pink;
    } else if (name.contains('education')) {
      return Colors.blueGrey;
    } else if (name.contains('health')) {
      return Colors.red;
    } else if (name.contains('shopping')) {
      return Colors.purple;
    } else if (name.contains('car')) {
      return Colors.deepOrange;
    } else if (name.contains('home')) {
      return Colors.brown;
    } else if (name.contains('gift')) {
      return Colors.cyan;
    } else if (name.contains('movie')) {
      return Colors.amber;
    } else if (name.contains('music')) {
      return Colors.lightBlue;
    } else if (name.contains('book')) {
      return Colors.lightGreen;
    } else if (name.contains('saving')) {
      return Colors.lime;
    } else {
      final index = name.length % Colors.primaries.length;
      return Colors.primaries[index]; // Default color based on name length
    }
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
            final emoji = _getGroupEmoji(group.groupName);
            final color = _getGroupColor(group.groupName);

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
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
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