import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

import '../creation/create_group_page.dart';

class GroupsHomePage extends StatefulWidget {
  const GroupsHomePage({super.key});

  @override
  State<GroupsHomePage> createState() => _GroupsHomePageState();
}

class _GroupsHomePageState extends State<GroupsHomePage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<String> _groups = [
    "Developers Squad",
    "Flutter Lovers",
    "Family Group",
    "Work Team",
    "Football Fans",
  ];
  List<String> _filteredGroups = [];

  @override
  void initState() {
    super.initState();
    _filteredGroups = List.from(_groups);

    _searchController.addListener(() {
      setState(() {
        _filteredGroups = _groups
            .where((group) => group
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateGroupPage()));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, color: home1),
          child: Center(
            child: Icon(
              Icons.add,
              color: white,
              size: 40,
              weight: 20,
            ),
          ),
        ),
      ),
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Groups",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: home2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row with Animated Search
            Row(
              children: [
                if (!_isSearching)
                  Expanded(
                    child: Text(
                      "My Groups",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: home1,
                      ),
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isSearching
                      ? MediaQuery.of(context).size.width - 32
                      : 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: home1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isSearching
                      ? TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Search groups...",
                            hintStyle: TextStyle(color: home1.withOpacity(0.5)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close, color: home1),
                              onPressed: () {
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                });
                              },
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() => _isSearching = true);
                          },
                          icon: Icon(Icons.search, color: home1, size: 22),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Group List with Animation
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _filteredGroups.isEmpty
                    ? Center(
                        child: Text(
                          "No groups found",
                          style: TextStyle(
                            fontSize: 14,
                            color: home1.withOpacity(0.6),
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredGroups.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: home1.withOpacity(0.15),
                                  child: Text(
                                    _filteredGroups[index][0],
                                    style: TextStyle(
                                      color: home1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _filteredGroups[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: home2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Last activity: 2 hrs ago",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: home1.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: home1.withOpacity(0.7),
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
