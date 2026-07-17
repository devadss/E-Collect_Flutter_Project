
import 'complaint_track_success.dart';

abstract class ComplaintTrackResponse {}

class ComplaintTrackSuccess extends ComplaintTrackResponse {
  final ComplaintTrackSuccessResponse complaintTrackSuccessResponse;
  ComplaintTrackSuccess(this.complaintTrackSuccessResponse);
}

class CompliantTrackFail extends ComplaintTrackResponse{
  final String compliantTrackFail;
  CompliantTrackFail(this.compliantTrackFail);
}