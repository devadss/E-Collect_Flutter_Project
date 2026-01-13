
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/rdcl_duelist_model/rdcl_due_list_model.dart';
import '../repository/rdcl_due_list_repo/rdcl_due_list_repo.dart';


part 'rdcl_duelist_event.dart';
part 'rdcl_duelist_state.dart';


class RdclDuelistBloc extends Bloc<RdclDuelistEvent , RdclDuelistState>{
  final RdclDueListRepo rdclDueListRepo;
  RdclDuelistBloc(this.rdclDueListRepo):super(RdclDueListInitialState()){
    on<RdclDueListFetchEvent>((event ,emit) async {
      final data = await rdclDueListRepo.fetchRdclDueList(event.agentId, event.branchCode, event.accNo, event.custName);
      if(data is RdclDulistSuccess){
        emit(RdclDueListSuccessState(data));
      }else if (data is RdclDueListFail){
        emit(RdclDueListFailState(data));
      }
    });
  }
}