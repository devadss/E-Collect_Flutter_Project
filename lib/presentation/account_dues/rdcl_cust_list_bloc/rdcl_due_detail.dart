import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/rdcl_duelist_bloc/rdcl_duelist_bloc.dart';

class RdclDueDetail extends StatefulWidget {
  final String branchCode;
  final String customeName;
  const RdclDueDetail({super.key, required this.branchCode, required this.customeName});

  @override
  State<RdclDueDetail> createState() => _RdclDueDetailState();
}

class _RdclDueDetailState extends State<RdclDueDetail> {


  @override
  void initState() {
    super.initState();
    context.read<RdclDuelistBloc>().add(RdclDueListFetchEvent("", widget.branchCode, "", widget.customeName));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("RDCL Account Details",
        style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: BlocBuilder<RdclDuelistBloc , RdclDuelistState>(
              builder: (BuildContext context, RdclDuelistState state) {
                if(state is RdclDueListLoaderState){
                  return const Center(child: CircularProgressIndicator());
                }
                if(state is RdclDueListSuccessState){
                  return  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                    BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 8, offset: Offset(0, 1))
                        ]
                    ),child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Customer name : "),
                          Text(state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[0].name??"")
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Account Number : "),
                          Text(state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[0].accNo??"")
                        ],
                      ),
                    ],
                  ),

                  );
                }
                return SizedBox.shrink();

              },

            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BlocBuilder<RdclDuelistBloc , RdclDuelistState>(
              builder: (BuildContext context, RdclDuelistState state) {
                if(state is RdclDueListSuccessState){
                  return Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)
                ],
                color: Colors.grey.shade100,
                ),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Text("Due amount: ${state.rdclDulistSuccess.rdclduesListSuccessModel.data[0].name}"),
                Text("Installement amount: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[0].installAmt}"),
                Text("Loan Type: RDCL"),
                Text("Total Installment: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[0].totalInstallment}"),
                Text("Pain Installment: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[0].paidInstallments}"),
                Text("Due Installment: ${state.rdclDulistSuccess.rdclduesListSuccessModel.rdclDuesList1?.data[0].dueAmount}"),
                ],),
                );
                }

                return SizedBox.shrink();

              },

            ),
          )
        ],
      ),
    );
  }
}
