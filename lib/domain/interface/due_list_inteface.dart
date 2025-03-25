
import 'package:dartz/dartz.dart';

import '../../data/service/error_handler.dart';
import '../model/due_list_model.dart';

abstract class IDueListRepository{
  Future<Either<ErrorHandler,DueListModel>>getDueList(String accountNumber,String onDate);
}