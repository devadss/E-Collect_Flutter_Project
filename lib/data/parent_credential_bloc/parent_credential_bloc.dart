
import 'package:collection_qr_flutter/data/cust_register_bloc/cust_reg_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/parent_credential_model/parent_credential_model.dart';
import '../repository/parent_credentail_repo/parent_credentail_repo.dart' show ParentCredentialRepo;
import '../storage/shared_pref_helper.dart';

part 'parent_credential_event.dart';
part 'parent_credential_state.dart';


class ParentCredentialBloc extends Bloc<ParentCredentialEvent, ParentCredentialState>{
  final ParentCredentialRepo parentCredentialRepo;

  ParentCredentialBloc(this.parentCredentialRepo):super(ParentCredentialInitialState()){
    on<ParentCredentialEventGet>((event , emit) async {
      emit(ParentCredentialLoaderState());

      final data =  await parentCredentialRepo.fetchCredentials(event.mobNum);
      if(data is ParentCredentialSuccess){
        emit(ParentCredentialSuccessState(data));

        SharedPref.shared.setParentAgentName(data.parentAgentCredentialModel.b.userName);
        SharedPref.shared.setParentAgentPassword(data.parentAgentCredentialModel.b.mobPassword);
        SharedPref.shared.setAgentName(data.parentAgentCredentialModel.b.userName);


      }else if(data is ParentCredentialFail){
        emit(ParentCredentialFailState(data));
      }
    });
  }

}