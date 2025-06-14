import '../../data/service/error_handler.dart';
import '../../domain/model/due_list_model.dart';
import 'package:dartz/dartz.dart';

abstract class IDueListRepository{
  Future<Either<ErrorHandler,DueListModel>>getDueList(String accountNumber,String onDate);
}