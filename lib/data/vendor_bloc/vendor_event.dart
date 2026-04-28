
part of 'vendor_bloc.dart';
abstract class VendorEvent {}

class VendorEventUrl extends VendorEvent{
  final String mobNUmber;
  VendorEventUrl(this.mobNUmber);
}