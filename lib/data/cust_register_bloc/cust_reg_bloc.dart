//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../domain/model/cust_register_model/cust_register_model.dart';
// import '../repository/cust_reg_repo/cust_register_repo.dart';
// import '../storage/shared_pref_helper.dart';
//
// part 'cust_reg_event.dart';
// part 'cust_reg_state.dart';
//
// class CustRegBloc extends Bloc<CustRegEvent, CustRegState>{
//   final CustRegisterRepo custRegisterRepo;
//   CustRegBloc(this.custRegisterRepo):super(CustRegInitialState()){
//     on<GetCustRegEvent>((event , emit) async {
//       emit(CustRegLoaderState());
//       final data = await custRegisterRepo.checkCustRegister(event.mobNum);
//
//       if(data is CustRegisterSuccess){
//         emit(CustRegSuccessState(data));
//         var datas =  data.registedCustomerModel.response.data;
//         if ( datas.customerType.isNotEmpty == true) {
//           if (datas.customerType == "COLLECTION_AGENT"&& datas.integrationStatus=="Y") {
//             SharedPref.shared.setEmail(datas.emailId);
//
//             SharedPref.shared.setCorpCode(datas.corpCode);
//             SharedPref.shared.setBranchCode(datas.branchCode,);
//             SharedPref.shared.setMpinValue(data.registedCustomerModel.mpin.toString());
//           }
//         }
//
//       }else if(data is CustRegisterFail){
//         emit(CustRegFailState(data));
//       }
//     });
//   }
// }