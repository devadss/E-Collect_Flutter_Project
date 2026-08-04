import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../../domain/model/e_collect/payment/response/payment_qr_response.dart';
import '../../repository/e_collect_repository/payment_repository/payment_repository.dart';
part 'payment_event.dart';
part 'payment_state.dart';


class PaymentBloc extends Bloc<PaymentEvent, PaymentState>{
  PaymentRepository paymentRepository;
  PaymentBloc(this.paymentRepository):super(QrPaymentInitialState()){
    on<QrPaymentEvent>((event, emit) async {
      emit(QrPaymentLoaderState());
      var data = await paymentRepository.qrPaymentApiIntentCall(event.qrPaymentRequestModel);
      if(data is QrPaymentSuccess){
        emit(QrPaymentSuccessState(data));
      }else if(data is QrPaymentFail){
        emit(QrPaymentFailState(data));
      }
    });
  }
}