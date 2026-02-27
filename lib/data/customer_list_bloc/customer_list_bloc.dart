import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/customer_list_model/customer_list_model.dart';
import '../repository/customer_list_repo/customer_list_repo.dart';
part 'customer_list_state.dart';
part 'customer_list_event.dart';

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState>{
  final CustomerListRepo customerListRepo;
  CustomerListBloc(this.customerListRepo):super(const CustomerListInitialState()){
    on<CustomerListFetchEvent>((event , emit) async {
      final data = await customerListRepo.fetchCustList(event.agentId,
          event.branchId, event.pageNo, event.pageSize, event.customerName);
      if(data is CustomerListSuccessModel){
        emit (CustomerListSuccessState(data));
      }else if(data is CustomerListFailModel){
        emit(CustomerListFailState(data));
      }


    });
  }

}