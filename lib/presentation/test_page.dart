import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<String> itemList = ["Item1", "Item 2", "Item 3", "Item 4", "Item 5"];
String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150, // Optional: give height to match icon size
                    decoration: BoxDecoration(
                      color: home2,
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: home1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Add spacing between avatar and text column
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Abhilash K R",
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 200,
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                      Text("abhilassurendran@gmail.com",
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 200,
                        child: Divider(color: home2, thickness: 1),
                      ),
                      Text("+91 9898091250", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            ListWidgetMethod(itms: itemList, selectedItem: selectedItem.toString(),)
          ],
        ));
  }
}




void showDialogNotification(BuildContext context, int no, String itemSelction, List<String>itms) {
showDialog(context: context, builder: (BuildContext context){
  return AlertDialog(
    title: Text("Selection"),
    content: DropdownMenu<String>(
        label: Text("Select any"),
        initialSelection: itemSelction,
        dropdownMenuEntries: itms.map((itms)=>DropdownMenuEntry(value: itms, label: itms)).toList(),
    ),
    actions: [
      TextButton(onPressed: (){}, child: Text("d sd sd sd"))
    ],
  );
});
}

class ListWidgetMethod extends StatelessWidget {
  final String selectedItem;
  final List<String> itms;
   const ListWidgetMethod({
    super.key,required this.selectedItem, required this.itms
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 70,
                child: GestureDetector(
                  onTap: (){
                    showDialogNotification(context, index, selectedItem,itms );
                  },
                  child: Card(
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10)),
                    elevation: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.ac_unit,
                              color: home1,
                            ),
                            SizedBox(
                                width: 430,
                                child: Text("Content No is : $index"))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
