import 'dart:convert';
import 'package:collection_qr_flutter/core/constants.dart';
import 'package:collection_qr_flutter/data/service/error_handler.dart';
import 'package:collection_qr_flutter/domain/interface/group/update_account_interface.dart';
import 'package:collection_qr_flutter/domain/model/group/default_model/default_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UpdateBankAccountDetailsRepository implements IUpdateBankAccountDetailsRepository{
  @override
  Future<Either<ErrorHandler, DefaultModel>> updateBankAccountDetails(String? accountId,String? userId, String? accountHolderName, String? accountNumber, String? ifsc, String? corpCode, String? branchCode, String? entityId) async{
    final url =Uri.parse("${baseUrl}api/UpdateAccount/$accountId");
    final body ={
      "userId": userId,
      "accountHolderName": accountHolderName,
      "accountNumber": accountNumber,
      "ifsc": ifsc,
      "CorpCode": corpCode,
      "BranchCode": branchCode,
      "EntityId": entityId
    };
    bool checkConnection = await InternetConnectionChecker().hasConnection;
    if(checkConnection){
      final response = await http.put(
        url,
        body: json.encode(body),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        try{
          return Right(DefaultModel.fromJson(jsonDecode(response.body)));
        }catch(e){
          return Left(DataParsingException(e));
        }
      }else{
        return Left(FetchDataError("Failed To Fetch Data"));
      }
    }else{
      return Left(FetchDataError("No Internet Connection"));
    }
  }
}