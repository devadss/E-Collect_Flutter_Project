
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/rdcl_duelist_model/rdcl_due_list_model.dart';
import '../repository/e_collect_repository/rdcl_due_list_repo/rdcl_due_list_repo.dart';


part 'rdcl_duelist_event.dart';
part 'rdcl_duelist_state.dart';


class RdclDuelistBloc extends Bloc<RdclDuelistEvent , RdclDuelistState>{
  final RdclDueListRepo rdclDueListRepo;
  RdclDuelistBloc(this.rdclDueListRepo):super(const RdclDueListInitialState()){
    on<RdclDueListFetchEvent>((event ,emit) async {
      emit(const RdclDueListLoaderState());
      final data = await rdclDueListRepo.fetchRdclDueList(event.baseUrl,event.agentId, event.branchCode, event.accNo, event.custName, event.pageNo, event.itemsPerPage);
      if(data is RdclDulistSuccess){
        emit(RdclDueListSuccessState(data));
      }else if (data is RdclDueListFail){
        emit(RdclDueListFailState(data));
      }
    });
  }
}