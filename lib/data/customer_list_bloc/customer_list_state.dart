part of 'customer_list_bloc.dart';
abstract class CustomerListState {}

class CustomerListInitialState extends CustomerListState{}

class CustomerListLoaderState extends CustomerListState{}

class CustomerListSuccessState extends CustomerListState{
  final CustomerListSuccessModel customerListSuccessModel;
  CustomerListSuccessState(this.customerListSuccessModel);
}

class CustomerListFailState extends CustomerListState{
  final CustomerListFailModel customerListFailModel;
  CustomerListFailState(this.customerListFailModel);
}