import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

import '../data/storage/shared_pref_helper.dart';

class TestProfilePage extends StatefulWidget {
  const TestProfilePage({super.key});

  @override
  State<TestProfilePage> createState() => _TestProfilePageState();
}

class _TestProfilePageState extends State<TestProfilePage> {
  String name = "Unknown User";
  String mobNum = "No Number";
  final ScrollController _scrollController = ScrollController();

  Future<void> loadSharedData() async {
    String? username = await SharedPref.shared.getSubAgentName();
    String? usermobNum = await SharedPref.shared.getSubAgentMobNum();

    if (mounted) {
      setState(() {
        name = username ?? "Unknown User";
        mobNum = usermobNum ?? "No Number";
      });
    }
  }

  void doAutoScroll(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      doAutoScroll();
    });
    loadSharedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/images/new_profile_bg.png",
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 330,
                ),
                Positioned(
                    top: 200,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        "assets/images/new_profile.png",
                        scale: 2,
                        fit: BoxFit.fill,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              textAlign: TextAlign.center,
              name,
              style: TextStyle(color: home1, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            Text(mobNum, style: TextStyle(fontSize: 12),),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "We're here to help",
                  style: TextStyle(fontWeight: FontWeight.w700, color: home1, fontSize: 17),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Reach out to our support team with your inquiries",
                  style: TextStyle( color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Divider(),
            ),
            SizedBox(height: 20,),
            SingleChildScrollView(
             // scrollDirection: Axis.vertical,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Container(
                        height: 100,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12.withAlpha(20),
                                    offset: Offset(1, 0),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ]),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                            Container(
                              decoration: BoxDecoration(
                                color: home1.withAlpha(40),
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.call,
                                  color: home1,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
        
                                Text("Contact Us",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                                Text("6AM - 6PM Mon to Fri", maxLines: null,softWrap: true,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10),)
                              ],
                            )
                          ],)
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12.withAlpha(20),
                                    offset: Offset(1, 0),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ]),
                          child:    Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: home1.withAlpha(40),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.email,
                                    color: home1,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("Email Us",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                                  Text("cards@transcorpint.com", overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10),)
                                ],
                              )
                            ],)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Terms & Conditions",
                  style: TextStyle(fontWeight: FontWeight.w500, color: home1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Divider(),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width : double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withAlpha(20),
                          offset: Offset(0, 1),
                          blurRadius: 8, spreadRadius: 2
                      )
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        decoration: BoxDecoration(
                          color: home1.withAlpha(40),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.notes,color: home1,),
                        )),
                    SizedBox(width: 10,),
                    Text("English version")
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width : double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withAlpha(20),
                          offset: Offset(0, 3),
                          blurRadius: 9, spreadRadius: 1
                      )
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10,),
                    Container(
                        decoration: BoxDecoration(
                          color: home1.withAlpha(40),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.notes,color: home1,),
                        )),
                    SizedBox(width: 10,),
                    Text("Hindi version")
                  ],
                ),
              ),
            ),
SizedBox(height: 20,),
ElevatedButton(onPressed: (){},
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: home1,
      foregroundColor: Colors.white
    ),
    child: Text("Logout", style: TextStyle(fontWeight: FontWeight.w700),))
          ],
        ),
      ),
    );
  }
}
