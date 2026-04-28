part of 'parent_credential_bloc.dart';

abstract class ParentCredentialEvent {}

class ParentCredentialEventGet extends ParentCredentialEvent{
  final String mobNum;
  ParentCredentialEventGet(this.mobNum);
}