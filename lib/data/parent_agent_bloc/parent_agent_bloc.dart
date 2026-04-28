
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/parent_agent_model/parent_agent_model.dart';
import '../cust_register_bloc/cust_reg_bloc.dart';
import '../parent_credential_bloc/parent_credential_bloc.dart';
import '../repository/parent_agent_repository/parent_agent_repo.dart';
import '../storage/shared_pref_helper.dart';
import '../vendor_bloc/vendor_bloc.dart';
part 'parent_agent_event.dart';
part 'parent_agent_state.dart';

class ParentAgentBloc extends Bloc<ParentAgentEvent, ParentAgentState>{
  final ParentAgentRepo parentAgentRepo;
  final VendorBloc vendorBloc;
  final ParentCredentialBloc parentCredentialBloc;
  final CustRegBloc custRegBloc;
  ParentAgentBloc(this.parentAgentRepo, this.vendorBloc, this.parentCredentialBloc, this.custRegBloc):super(ParentAgentInitialState()){
    on<FetchParentAgentEvent>((event , emit) async {
      emit(ParentAgentLoaderState());
      final data  = await parentAgentRepo.getParentAgentDetails(event.mobNum);
      if (data is ParentAgentSuccessModel){
        emit(ParentAgentSuccessState(data));
        var datas =  data.parentAgentSuccessResponse.data;

        await SharedPref.shared.setAgentId(
          datas.parentAgentId.toString(),
        );
        await SharedPref.shared.setParentAgentMobNum(
          datas.parentAgentMobNo.toString(),
        );
        await SharedPref.shared.setSubAgentName(
          datas.subAgentName.toString(),
        );
        await SharedPref.shared.setSubAgentMobNum(
          datas.mobileNumber.toString(),
        );
        await SharedPref.shared.setAgentOriginId(datas.subAgentOriginId
            .toString());
        await SharedPref.shared.setSubAgentCode(
          datas.subAgentOriginId.toString(),
        );
        await SharedPref.shared.setSubAgentCodeNew(
          datas.subAgentCode.toString(),
        );
        await SharedPref.shared.setSubAgentId(
          datas.subAgentId.toString(),
        );
        vendorBloc.add(VendorEventUrl(datas.mobileNumber));
        parentCredentialBloc.add(ParentCredentialEventGet(datas.parentAgentMobNo));
        custRegBloc.add(GetCustRegEvent(datas.parentAgentMobNo..replaceAll("+91", "")));


      }else if (data is ParentAgentFailModel){
        emit(ParentAgentFailState(data));
      }

    });
  }
}