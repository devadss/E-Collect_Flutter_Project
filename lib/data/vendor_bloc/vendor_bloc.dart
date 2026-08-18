//
// import 'package:collection_qr_flutter/data/parent_credential_bloc/parent_credential_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../domain/model/vendor_model/vendor_model.dart';
// import '../repository/vendor_repo/vendor_repo.dart';
// import '../storage/shared_pref_helper.dart';
//
// part 'vendor_event.dart';
// part 'vendor_state.dart';
//
//
// class VendorBloc extends Bloc<VendorEvent, VendorState>{
//   final VendorRepo vendorRepo;
//
//   VendorBloc(this.vendorRepo):super(VendorInitialState()){
//     on<VendorEventUrl>((event, emit) async {
//       final data = await vendorRepo.fetchVendorUrl(event.mobNUmber);
//
//       if(data is VendorSuccessModel){
//         var datas = data.vendorSuccessResponse;
//         emit(VendorSuccessState(data));
//         SharedPref.shared.setRdclCustomerVendorUrl(datas.getCustomerRdclUrl
//             .toString());
//         SharedPref.shared.setDueListRdclUrl(datas.getDueListRdclUrl
//             .toString());
//         SharedPref.shared.setCustomerRdUrl(datas.getCustomerRdUrl
//             .toString());
//         SharedPref.shared.setDueListRdUrl(datas.getDueListRdUrl
//             .toString());
//         SharedPref.shared.setCustomerLoanUrl(datas.getCustomerLoanUrl
//             .toString());
//         SharedPref.shared.setDueListLoanUrl(datas.getDueListLoanUrl
//             .toString());
//         SharedPref.shared.setLoanAccountHolderUrl(datas.getLoanAccountHolderUrl
//             .toString());
//
//         SharedPref.shared.setUserType(datas.userType
//             .toString());
//       }else if(data is VendorFailModel){
//         emit(VendorFailState(data));
//       }
//     });
//   }
// }
