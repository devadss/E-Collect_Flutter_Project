
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/complaint/complaint_request_model/complaint_request_model.dart';
import '../../domain/model/complaint/complaint_resposne/compliant_response.dart';
import '../repository/complaint_register/complaint_register_repository.dart';
part 'complaint_register_event.dart';
part 'complaint_register_state.dart';


class ComplaintRegisterBloc extends Bloc<ComplaintRegisterEvent, ComplaintRegisterState>{
  ComplaintRegisterRepository complaintRegisterRepository;
  ComplaintRegisterBloc(this.complaintRegisterRepository):super(ComplaintRegisterInitialState()){
    on<EventComplaintRegister>((event , emit) async {
      var data = await complaintRegisterRepository.registerComplaint(event.complaintRequest);
      if(data is ComplaintResponseSuccess){
        emit(ComplaintRegisterSuccessState(data));
      }else if(data is ComplaintResponseFail){
        emit(ComplaintRegisterFailState(data));
      }
    });
  }
}