import 'package:collection_qr_flutter/core/colors.dart';
import 'package:collection_qr_flutter/presentation/groups/creation/group_creation_page.dart';
import 'package:flutter/material.dart';

import '../creation/create_group_page.dart';

class GroupHomepage extends StatefulWidget {
  const GroupHomepage({super.key});

  @override
  State<GroupHomepage> createState() => _GroupHomepageState();
}

class _GroupHomepageState extends State<GroupHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      buildListView(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroupPage()));
      },
        child: const Icon(Icons.add, color: Colors.white,),
      backgroundColor: home1,),//buildGroupCreationColumn(),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: home1.withOpacity(0.2), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
              color: home1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.account_circle, color: home2,),
                      SizedBox(
                        width: 10,
                      ),
                      Text("My Group"),
                      Spacer(),
                      Text("10", style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(color: home1, thickness: 2,),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(children: [
                    Icon(Icons.do_not_disturb_on_total_silence, color: home1,
                      size: 12,),
                    SizedBox(width: 5,),
                    Text("Collected 8"),
                    Spacer(),
                    Icon(
                      Icons.do_not_disturb_on_total_silence_sharp, color: home2,
                      size: 12,),
                    SizedBox(width: 5,),
                    Text("Due 2")
                  ],),
                )
              ],
            ),
          ),
        );
      },

    );
  }

  Column buildGroupCreationColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Image.asset(
              "assets/images/group_image.png",
              height: 300,
              width: 300,
            )),
        const Text(
          "You have no active groups",
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text("Create a group to collect monthly payment"),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: home1,
                foregroundColor: Colors.white),
            onPressed: () {},
            child: const Text(
              "Create Group",
            ))
      ],
    );
  }
}
