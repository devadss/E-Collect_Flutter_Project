part of 'complaint_register_bloc.dart';
abstract class ComplaintRegisterState {}

class ComplaintRegisterInitialState extends ComplaintRegisterState {}

class ComplaintRegisterLoaderState extends ComplaintRegisterState {}

class ComplaintRegisterSuccessState extends ComplaintRegisterState {
  final ComplaintResponseSuccess complaintResponseSuccess;
  ComplaintRegisterSuccessState(this.complaintResponseSuccess);
}

class ComplaintRegisterFailState extends ComplaintRegisterState {
  final ComplaintResponseFail complaintResponseFail;
  ComplaintRegisterFailState(this.complaintResponseFail);
}
