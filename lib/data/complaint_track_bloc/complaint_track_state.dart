
part of 'complaint_track_bloc.dart';

abstract class ComplaintTrackState {}

class ComplaintTrackInitialState extends ComplaintTrackState{}
class ComplaintTrackLoaderState extends ComplaintTrackState{}
class ComplaintTrackSuccessState extends ComplaintTrackState{
final ComplaintTrackSuccess complaintTrackSuccess;
ComplaintTrackSuccessState(this.complaintTrackSuccess);
}
class ComplaintTrackFailState extends ComplaintTrackState{
  final CompliantTrackFail compliantTrackFail;
  ComplaintTrackFailState(this.compliantTrackFail);
}