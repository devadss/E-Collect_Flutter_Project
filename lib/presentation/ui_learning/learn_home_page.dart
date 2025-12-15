import 'package:flutter/material.dart';

class LearnHomePage extends StatefulWidget {
  const LearnHomePage({super.key});

  @override
  State<LearnHomePage> createState() => _LearnHomePageState();
}

class _LearnHomePageState extends State<LearnHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.cloud_sharp,
                        color: Colors.deepPurpleAccent,
                        size: 30,
                      ),
                      Positioned(
                          left: 43,
                          top: 5,
                          bottom: 0,
                          child: Text(
                            textAlign: TextAlign.center,
                            "28 C",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.purpleAccent.withAlpha(20),
                    child: Icon(Icons.person),
                  ),
        
                ],
              ),
              Text("Today's weather", style: TextStyle(color: Colors.grey, fontSize: 12),),
              SizedBox(height: 20,),
              Center(child: Text("Sweet Home", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),)),
             SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.withAlpha(25),
                      child: Icon(Icons.logout, color: Colors.blue,),
                    ),
                    SizedBox(height: 10,),
                    Text("Front Door",style: TextStyle(color: Colors.black, fontSize: 12),),
                    Text("Open", style: TextStyle(color: Colors.grey, fontSize: 10),)
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.orange.withAlpha(25),
                      child: Icon(Icons.light, color: Colors.orange,),
                    ),
                    SizedBox(height: 10,),
                    Text("2 Lights",style: TextStyle(color: Colors.black, fontSize: 12),),
                    Text("On", style: TextStyle(color: Colors.grey, fontSize: 10),)
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(radius: 30,
                      backgroundColor: Colors.green.withAlpha(25),
                      child: Icon(Icons.video_call, color: Colors.green,),
                    ),
                    SizedBox(height: 10,),

                    Text("Cameras",style: TextStyle(color: Colors.black, fontSize: 12),),
                    Text("Off", style: TextStyle(color: Colors.grey, fontSize: 10),)
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.purple.withAlpha(25),
                      child: Icon(Icons.video_call, color: Colors.purple,),
                    ),
                    SizedBox(height: 10,),

                    Text("Wifi",style: TextStyle(color: Colors.black, fontSize: 12),),
                    Text("Off", style: TextStyle(color: Colors.grey, fontSize: 10),)
                  ],
                ),
        
              ],),
              SizedBox(height: 20,),
              Divider(color: Colors.grey.withAlpha(15),thickness: 15,),
              SizedBox(
                height: 30,
              ),
              Text("Favourite Scenes", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  child: Container(
                  //  width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
        
                        // BoxShadow(
                        //     color: Colors.black12,
                        //     offset: Offset(0, 1),
                        //     spreadRadius: 2,
                        //     blurRadius: 8
                        // )
                      ],
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.home),
                        ),
                        Text("Good \nmorning")
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                   // width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //
                      //   BoxShadow(
                      //       color: Colors.black12,
                      //       offset: Offset(0, 1),
                      //       spreadRadius: 2,
                      //       blurRadius: 8
                      //   )
                      // ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.directions_walk),
                        ),
                        Text("Arrive \nHome")
                      ],
                    ),
                  ),
                ),
        
              ],),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Expanded(
                  child: Container(
                  //  width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //
                      //   BoxShadow(
                      //       color: Colors.black12,
                      //       offset: Offset(0, 1),
                      //       spreadRadius: 2,
                      //       blurRadius: 8
                      //   )
                      // ],
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.nordic_walking),
                        ),
                        Text("Leave \Home")
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                   // width: 150,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //
                      //   BoxShadow(
                      //       color: Colors.black12,
                      //       offset: Offset(0, 1),
                      //       spreadRadius: 2,
                      //       blurRadius: 8
                      //   )
                      // ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.nightlight),
                        ),
                        Text("Good \nNight")
                      ],
                    ),
                  ),
                ),
        
              ],),
              SizedBox(height: 20,),
              Divider(color: Colors.grey.withAlpha(15),thickness: 15,),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rooms", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),),
                  Text("see more")
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.purple.withAlpha(50),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.bed, color: Colors.purple.withAlpha(100),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text("Bed Rooms", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
                        ),
                        Text("6 devices", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent.withAlpha(50),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,

                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.soup_kitchen, color: Colors.orangeAccent.withAlpha(100),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text("Kitchen rooms", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
                        ),
                        Text("2 Devices", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.green.withAlpha(50),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.bed, color: Colors.green.withAlpha(100),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text("Dining Rooms", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
                        ),
                        Text("5 Devices", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.withAlpha(50),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.local_post_office, color: Colors.blue.withAlpha(100),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text("Office Rooms", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),),
                        ),
                        Text("3 Devices", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Divider(color: Colors.grey.withAlpha(15),thickness: 15,),
        
            ],
          ),
        ),
      ),
    );
  }
}
