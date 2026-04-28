
part of 'cust_reg_bloc.dart';
abstract class CustRegEvent {}

class GetCustRegEvent extends CustRegEvent{
  final String mobNum;
  GetCustRegEvent(this.mobNum);
}