

import 'complaint_success_resposne.dart';

abstract class CompliantResponse {}

class ComplaintResponseSuccess extends CompliantResponse{
  final ComplaintResponse complaintResponse;
  ComplaintResponseSuccess(this.complaintResponse);
}

class ComplaintResponseFail extends CompliantResponse{
  final String complaintResponseFail;
  ComplaintResponseFail(this.complaintResponseFail);
}