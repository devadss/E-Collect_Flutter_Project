
part of 'complaint_track_bloc.dart';
abstract class ComplaintTrackEvent {}

class EventComplaintTrack extends ComplaintTrackEvent{
  final String compliantID;
  EventComplaintTrack(this.compliantID);
}