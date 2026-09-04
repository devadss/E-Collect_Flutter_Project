import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/agent_customer_details_model.dart';
import '../../domain/model/customer_list_model/customer_list_model.dart';
import '../repository/e_collect_repository/customer_list_repo/customer_list_repo.dart';
part 'customer_list_state.dart';
part 'customer_list_event.dart';

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  final CustomerListRepo customerListRepo;

  RdCustomerListSuccessModel? _originalRdCustomerList;
  CustomerListBloc(this.customerListRepo)
      : super(const CustomerListInitialState()) {
    on<CustomerListFetchEvent>((event, emit) async {
      emit(CustomerListLoaderState());
      final data = await customerListRepo.fetchCustList(
          event.baseUrl,
          event.agentId,
          event.branchId,
          event.pageNo,
          event.pageSize,
          event.customerName);
      if (data is CustomerListSuccessModel) {
        emit(CustomerListSuccessState(data));
      } else if (data is CustomerListFailModel) {
        emit(CustomerListFailState(data));
      }
    });

    on<RdCustomerListFetchEvent>((event, emit) async {
      emit(RdCustomerListLoaderState());

      final data = await customerListRepo.fetchRdCustList(
        event.requestUrl,
        event.agentId,
        event.branchId,
      );

      if (data is RdCustomerListSuccessModel) {
        // Keep the original API response
        _originalRdCustomerList = data;

        emit(RdCustomerListSuccessState(data));
      } else if (data is RdCustomerListFailModel) {
        emit(RdCustomerListFailState(data));
      }
    });

    on<RdCustomerListFilterEvent>((event, emit) {
      if (_originalRdCustomerList == null) return;

      final originalData = _originalRdCustomerList!;

      final filteredCustomers = originalData.rdCustomerListModel.data
          .where((customer) {
        final name = (customer.custName ?? '').toLowerCase();
        final accNo =
            customer.depGlobalAccNo?.toString().toLowerCase() ?? '';

        final query = event.filterName.toLowerCase().trim();

        return name.contains(query) || accNo.contains(query);
      }).toList();

      // If search is empty, return original list
      if (event.filterName.trim().isEmpty) {
        emit(RdCustomerListSuccessState(originalData));
        return;
      }

      // Create filtered model
      final filteredCustomerModel = AgentCustomerDetailsModel(
        // your other required fields here
        data: filteredCustomers, totalCount:filteredCustomers.length ,
      );

      final filteredResult =
      RdCustomerListSuccessModel(filteredCustomerModel);

      emit(RdCustomerListFilteredState(filteredResult));
    });
  }


}
