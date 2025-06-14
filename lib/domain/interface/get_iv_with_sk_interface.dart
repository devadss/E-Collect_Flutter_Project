import '../../data/service/error_handler.dart';
import '../../domain/model/get_iv_with_sk_model.dart';
import 'package:dartz/dartz.dart';

abstract class IGetIvWithSkRepository{
  Future<Either<ErrorHandler,GetIvWithSkModel>>getIvWithSk();
}