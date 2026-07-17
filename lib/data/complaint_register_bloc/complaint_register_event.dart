part of 'complaint_register_bloc.dart';
abstract class ComplaintRegisterEvent {}

class EventComplaintRegister extends ComplaintRegisterEvent{
  final ComplaintRequest complaintRequest;
  EventComplaintRegister(this.complaintRequest);
}