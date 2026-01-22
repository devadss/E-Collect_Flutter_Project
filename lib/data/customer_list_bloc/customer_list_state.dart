part of 'customer_list_bloc.dart';
abstract class CustomerListState {
  const CustomerListState();
}

class CustomerListInitialState extends CustomerListState{
  const CustomerListInitialState();
}

class CustomerListLoaderState extends CustomerListState{
  const CustomerListLoaderState();
}

class CustomerListSuccessState extends CustomerListState{
  final CustomerListSuccessModel customerListSuccessModel;
  const CustomerListSuccessState(this.customerListSuccessModel);
}

class CustomerListFailState extends CustomerListState{
  final CustomerListFailModel customerListFailModel;
  const CustomerListFailState(this.customerListFailModel);
}