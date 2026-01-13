import 'package:collection_qr_flutter/presentation/account_dues/rdcl_cust_list_bloc/rdcl_due_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:tye/model/customer_list_model/customer_list_success.dart' as prefix0;

import '../../../data/customer_list_bloc/customer_list_bloc.dart';
import '../../../data/storage/shared_pref_helper.dart';
import '../../../domain/model/customer_list_model/customer_list_success.dart' as prefix0;

class CustomerList extends StatefulWidget {

  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String? branchid;
  TextEditingController searchController = TextEditingController();
  bool iconSwitch = false;
  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    // context.read<CustomerListBloc>().add(
    //   CustomerListFetchEvent("", "15", "0", "0", ""),
    // );
  }
  Future<void> loadSharedPrefs() async {

    final branchID = await SharedPref().getSubAgentCodeNew();
    setState(() {
      branchid = branchID;
    });
    context.read<CustomerListBloc>().add(
      CustomerListFetchEvent("", branchid.toString(), "0", "0", ""),
    );
  }
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    iconSwitch = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Customer List",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hint: Text("Search by name"),
                suffixIcon: InkWell(
                    onTap: (){
                      setState(() {
                        if(iconSwitch == false){
                          iconSwitch = true;
                        }else{
                          iconSwitch = false;
                          searchController.clear();

                        }
                      });
                      iconSwitch == false?
                      context.read<CustomerListBloc>().add(CustomerListFetchEvent("", "15", "0", "0", ""),):
                      context.read<CustomerListBloc>().add(CustomerListFetchEvent("", "15", "0", "0", searchController.text),);
                    },
                    child: Icon(
                        iconSwitch == true?
                        Icons.clear: Icons.send)),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
            ),
          ),
    

          Expanded(
            child: BlocBuilder<CustomerListBloc, CustomerListState>(
              builder: (BuildContext context, state) {
                prefix0.CustomerList? data;

                if (state is CustomerListLoaderState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CustomerListFailState) {
                  return Center(
                    child: Text(
                      state.customerListFailModel
                          .customerListFailResponse
                          .error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is CustomerListSuccessState) {
                  data = state
                      .customerListSuccessModel
                      .customerListSuccessResponse
                      .customerList;
                  if (data?.data == null || data!.data!.isEmpty) {
                    return const Center(
                      child: Text("No customers found"),
                    );
                  }
                  return ListView.builder(
                    itemCount: data?.totalCount??0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RdclDueDetail(branchCode: '15', customeName: data?.data?[index].custName??"",)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data?.data?[index].custName.toString() ?? ""),
                                Text(
                                  "Acc No: ${data?.data?[index].rdclGlobalAccNo.toString() ?? ""}",
                                ),
                                Text(
                                  "Scheme Name : ${data?.data?[index].schName.toString() ?? ""}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return SizedBox.shrink();



              },
            ),
          ),
        ],
      ),
    );
  }
}
