import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/complaint/complaint_track/complaint_track_resposne.dart';
import '../repository/complaint_track/complaint_track_repository.dart';

part 'complaint_track_event.dart';
part 'complaint_track_state.dart';


class ComplaintTrackBloc extends Bloc<ComplaintTrackEvent, ComplaintTrackState>{
  final ComplaintTrackRepository complaintTrackRepository;
  ComplaintTrackBloc(this.complaintTrackRepository):super(ComplaintTrackInitialState()){
    on<EventComplaintTrack>((event, emit) async {
      var data = await complaintTrackRepository.trackComplaint(event.compliantID);
      if(data is ComplaintTrackSuccess){
        emit(ComplaintTrackSuccessState(data));
      }else if(data is CompliantTrackFail){
        emit(ComplaintTrackFailState(data));
      }
    });
  }
}