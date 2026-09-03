import 'package:e_Collect/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_longpress_preview/flutter_longpress_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import '../../core/alerts.dart';
import '../../core/utils.dart' as utl;
import '../../data/e_collect_bloc/payment_bloc/payment_bloc.dart';
import '../../data/e_collect_bloc/transaction_bloc/transaction_bloc.dart';
import '../../domain/model/e_collect/payment/qr_request_model/qr_request_model.dart';
import '../../domain/model/e_collect/transaction_report/transaction_ok_report.dart';
import '../merchant/history/ecollect_transaction_detail.dart';
import '../paymentlink_request_ui.dart';
import '../qr_code/widgets/generate_qr_code_page.dart';
//THE LOAN CUSTOMER DETAILS PAGE 2 OF 2....
class IntegratedLoanDetailModel{
  final String loanDate;
  final String name;
  final String custNo;
  final String loanAmount;
  final String loanNumber;
  final String loanType;
  final String loanPeriod;
  final String loanInterest;
  final double principalAmountReceived;
  final double principalAmountBalance;
  final double principalAmountOverdue;
  final double principalAmountReceipt;
  final double interestAmountReceived;
  final double interestAmountBalance;
  final double interestAmountOverdue;
  final double interestAmountReceipt;
  final double penalInterestAmountReceived;
  final double penalInterestAmountBalance;
  final double penalInterestAmountOverdue;
  final double penalInterestAmountReceipt;
  IntegratedLoanDetailModel({
    required this.loanDate,
    required this.name,
    required this.custNo,
    required this.loanAmount,
    required this.loanNumber,
    required this.loanType,
    required this.loanPeriod,
    required this.loanInterest,
    required this.principalAmountReceived,
    required this.principalAmountBalance,
    required this.principalAmountOverdue,
    required this.principalAmountReceipt,
    required this.interestAmountReceived,
    required this.interestAmountBalance,
    required this.interestAmountOverdue,
    required this.interestAmountReceipt,
    required this.penalInterestAmountReceived,
    required this.penalInterestAmountBalance,
    required this.penalInterestAmountOverdue,
    required this.penalInterestAmountReceipt,
});
}

class EcollectMerchantModelData{
  final String? eCollectMerchantName;
  final String? eCollectAgentId;
  final String? eCollectAgentOriginId;
  final String? eCollectAgentNumber;
  final String? eCollectAgentEmail;
  final String? eCollectAgentBranchCode;
  final String? eCollectAgentMerchantID;
  final String? eCollectCollectionType;
  final String? eCollectToken;

  EcollectMerchantModelData({
    required this.eCollectMerchantName,
    required this.eCollectAgentId,
    required this.eCollectAgentOriginId,
    required this.eCollectAgentNumber,
    required this.eCollectAgentEmail,
    required this.eCollectAgentBranchCode,
    required this.eCollectAgentMerchantID,
    required this.eCollectCollectionType,
    required this.eCollectToken,

});

}

class IntegratedLoanDetail extends StatefulWidget {
  final IntegratedLoanDetailModel integratedLoanDetailModel;
  final EcollectMerchantModelData ecollectMerchantModelData;
  const IntegratedLoanDetail(
      {super.key,
      required this.integratedLoanDetailModel, required this.ecollectMerchantModelData});

  @override
  State<IntegratedLoanDetail> createState() => _IntegratedLoanDetailState();
}

class _IntegratedLoanDetailState extends State<IntegratedLoanDetail> {
  String? paymentSessionId;
  String selectedMethod = "";
  TextEditingController editAmountController = TextEditingController();
  Color? dominantColor;
  String? paymentOrderID;
  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
    createColorPallet("assets/images/person.png");
    editAmountController.text = (widget.integratedLoanDetailModel.principalAmountBalance +
            widget.integratedLoanDetailModel.interestAmountBalance +
            widget.integratedLoanDetailModel.penalInterestAmountBalance)
        .toString();
  }

  void validateInput() {
    if (editAmountController.text.isEmpty) return;

    final value = double.parse(editAmountController.text);
    if (value > int.parse(widget.integratedLoanDetailModel.loanAmount)) {
      editAmountController.text = widget.integratedLoanDetailModel.loanAmount.toString();
      editAmountController.selection = TextSelection.fromPosition(
          TextPosition(offset: editAmountController.text.length));
    }
  }

  @override
  void dispose() {
    editAmountController.dispose();
    editAmountController.removeListener(validateInput);
    super.dispose();
  }

   void loadSharedPrefs()  {
    editAmountController.addListener(validateInput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            textAlign: TextAlign.center,
            "LOAN DETAILS",
            style: TextStyle(color: home1, fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildLoanDetailsCard(),
              const SizedBox(height: 24),

              // Modern Card Container for Amount Sections
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildModernAmountSection(
                      title: "Principal Amount",
                      received: widget.integratedLoanDetailModel.principalAmountReceived.toString(),
                      balance: widget.integratedLoanDetailModel.principalAmountBalance.toString(),
                      overdue: widget.integratedLoanDetailModel.principalAmountOverdue.toString(),
                      current: widget.integratedLoanDetailModel.principalAmountReceipt.toString(),
                      icon: Icons.account_balance_wallet_rounded,
                      color: const Color(0xFF4361EE),
                    ),
                    _buildSectionDivider(),
                    _buildModernAmountSection(
                      title: "Interest",
                      received: widget.integratedLoanDetailModel.interestAmountReceived.toString(),
                      balance: widget.integratedLoanDetailModel.interestAmountBalance.toString(),
                      overdue: widget.integratedLoanDetailModel.interestAmountOverdue.toString(),
                      current: widget.integratedLoanDetailModel.interestAmountReceipt.toString(),
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFFE76F51),
                    ),
                    _buildSectionDivider(),
                    _buildModernAmountSection(
                      title: "Penal Interest",
                      received: widget.integratedLoanDetailModel.penalInterestAmountReceived.toString(),
                      balance: widget.integratedLoanDetailModel.penalInterestAmountBalance.toString(),
                      overdue: widget.integratedLoanDetailModel.penalInterestAmountOverdue.toString(),
                      current: widget.integratedLoanDetailModel.penalInterestAmountReceipt.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFE63946),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Modern Button Row
              Row(
                children: [
                  Expanded(
                    child: _buildModernButton(
                      text: "QR",
                      icon: Icons.qr_code,
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "QR Amount",
                                          style: TextStyle(
                                            color: Color(0xFF4361EE),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            editAmountController.text =
                                                widget.integratedLoanDetailModel.loanAmount.toString();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: editAmountController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.currency_rupee,
                                          color: Color(0xFF4361EE),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF4361EE),
                                              width: 2),
                                        ),
                                        labelText: "Enter collection amount",
                                        labelStyle: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedMethod = "QR";
                                          });
                                          context.read<PaymentBloc>().add(QrPaymentEvent(
                                              QrPaymentRequestModel(
                                                  agentDetails: AgentDetails(
                                                      agentName:
                                                          widget.ecollectMerchantModelData.eCollectMerchantName!,
                                                      agentId: widget.ecollectMerchantModelData.eCollectAgentId!,
                                                      agentOrginId:
                                                      widget.ecollectMerchantModelData.eCollectAgentOriginId!,
                                                      agentPhone:
                                                      widget.ecollectMerchantModelData.eCollectAgentNumber!,
                                                      agentEmail:
                                                      widget.ecollectMerchantModelData.eCollectAgentEmail!,
                                                      agentBranch: int.parse(
                                                          widget.ecollectMerchantModelData.eCollectAgentBranchCode!)),
                                                  customerDetails: CustomerDetails(
                                                      customerName: widget.integratedLoanDetailModel.name,
                                                      customerPhone:
                                                      widget.ecollectMerchantModelData.eCollectAgentNumber!,
                                                      customerAccno:
                                                          widget.integratedLoanDetailModel.loanNumber,
                                                      customerId: widget.integratedLoanDetailModel.custNo,
                                                      customerEmail:
                                                      widget.ecollectMerchantModelData. eCollectAgentEmail!),
                                                  collectionType: "LOAN",
                                                  amount: double.parse(
                                                      editAmountController
                                                          .text),
                                                  note: 'Payment for Order',
                                                  qrSource: 'MOB',
                                                  source: 'COLLECTION',
                                                  merchantId: int.parse(
                                                      widget.ecollectMerchantModelData.eCollectAgentMerchantID!)),
                                              widget.ecollectMerchantModelData.eCollectToken!));

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: home1,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: const Text(
                                          "Generate Payment QR",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      isOutlined: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernButton(
                      text: "Link",
                      icon: Icons.link,
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Link Amount",
                                          style: TextStyle(
                                            color: Color(0xFF4361EE),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            editAmountController.text =
                                                widget.integratedLoanDetailModel.loanAmount.toString();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: editAmountController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.currency_rupee,
                                          color: Color(0xFF4361EE),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF4361EE),
                                              width: 2),
                                        ),
                                        labelText: "Enter collection amount",
                                        labelStyle: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedMethod = "Link";
                                          });
                                          context.read<PaymentBloc>().add(LinkPaymentEvent(
                                              QrPaymentRequestModel(
                                                  agentDetails: AgentDetails(
                                                      agentName:
                                                      widget.ecollectMerchantModelData.eCollectMerchantName!,
                                                      agentId:widget.ecollectMerchantModelData. eCollectAgentId!,
                                                      agentOrginId:
                                                      widget.ecollectMerchantModelData.eCollectAgentOriginId!,
                                                      agentPhone:
                                                      widget.ecollectMerchantModelData.eCollectAgentNumber!,
                                                      agentEmail:
                                                      widget.ecollectMerchantModelData.eCollectAgentEmail!,
                                                      agentBranch: int.parse(
                                                          widget.ecollectMerchantModelData.eCollectAgentBranchCode!)),
                                                  customerDetails: CustomerDetails(
                                                      customerName: widget.integratedLoanDetailModel.name,
                                                      customerPhone:
                                                      widget.ecollectMerchantModelData. eCollectAgentNumber!,
                                                      customerAccno:
                                                          widget.integratedLoanDetailModel.loanNumber,
                                                      customerId: widget.integratedLoanDetailModel.custNo,
                                                      customerEmail:
                                                      widget.ecollectMerchantModelData.eCollectAgentEmail!),
                                                  collectionType:
                                                  widget.ecollectMerchantModelData.eCollectCollectionType!,
                                                  amount: double.parse(
                                                      editAmountController
                                                          .text),
                                                  note: 'Payment for Order',
                                                  qrSource: 'MOB',
                                                  source: 'COLLECTION',
                                                  merchantId: int.parse(
                                                      widget.ecollectMerchantModelData. eCollectAgentMerchantID!)),
                                              widget.ecollectMerchantModelData.eCollectToken!));
                                          //merchantId:1)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: home1,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: const Text(
                                          "Send Payment Link",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      isOutlined: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernButton(
                      text: "Cash",
                      icon: Icons.money_rounded,
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Collection Amount",
                                          style: TextStyle(
                                            color: Color(0xFF4361EE),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            editAmountController.text =
                                                widget.integratedLoanDetailModel.loanAmount.toString();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: editAmountController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.currency_rupee,
                                          color: Color(0xFF4361EE),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF4361EE),
                                              width: 2),
                                        ),
                                        labelText: "Enter collection amount",
                                        labelStyle: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          paymentConfirmation(
                                            context,
                                            widget.ecollectMerchantModelData.eCollectMerchantName!,
                                            widget.integratedLoanDetailModel.loanNumber,
                                            widget.integratedLoanDetailModel.custNo,
                                            editAmountController.text,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: home1,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: const Text(
                                          "Confirm Collection",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              MultiBlocListener(
                listeners: [
                  BlocListener<PaymentBloc, PaymentState>(
                    listener: (BuildContext context, PaymentState state) {
                      if (state is QrPaymentLoaderState) {
                        utl.showProgressDialog(context);
                      }
                      if (state is QrPaymentSuccessState) {
                        paymentOrderID = state.qrPaymentSuccess.paymentResponseSuccess.orderId;
                        Navigator.pop(context);

                        selectedMethod == "Link"
                            ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PaymentLinkRequestUi(
                                      customerMobileNumber: "",
                                      paymentLink: state.qrPaymentSuccess
                                          .paymentResponseSuccess.paymentUrl,
                                    )))
                            : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewQrCodePage(
                              paymentSessionId: state.qrPaymentSuccess
                                  .paymentResponseSuccess.paymentUrl,
                              amount: editAmountController.text,
                              custName: "",
                              custPhone: "custNumber",
                              custId: "CustId", orderID: paymentOrderID!, merchantID:
                              widget.ecollectMerchantModelData.eCollectAgentMerchantID!,
                              token: widget.ecollectMerchantModelData.eCollectToken!,
                            ),
                          ),
                        );
                      } else if (state is QrPaymentFailState) {
                        Navigator.pop(context);
                        showAlertDialog(
                            state.qrPaymentFail.paymentFailResponse.message,
                            context);
                        // print(state.qrPaymentFail.paymentFailResponse.message);
                      } else if (state is CashPaymentSuccessState) {
                        paymentOrderID = state.cashPaymentSuccess.cashPaymentSuccessResponse.transactionId;
                        Navigator.pop(context);
                      _showSuccessMessage(state.cashPaymentSuccess.cashPaymentSuccessResponse.message);
                        // print(state.cashPaymentSuccess.cashPaymentSuccessResponse.message);
                      } else if (state is CashPaymentFailState) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        showAlertDialog(state.cashPaymentFail.payemtError, context);
                        // print(state.cashPaymentFail.payemtError);
                      }
                    },
                    child: SizedBox(),
                  ),

                  BlocListener<PaymentTransactionBloc, TransactionState>
                    (listener: (BuildContext context, TransactionState state) {
                    if (state is TransactionReportSuccessState) {
                      final rawData =
                          state.transactionSuccessModel
                              .transactionOkReport.data;

                      for (var orderid in rawData){
                        if(orderid.paymentGatewayTransactionId.contains(paymentOrderID!)){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EcollectTransactionDetail(
                                paymentTransaction: PaymentTransaction(
                                  id: orderid.id,
                                  orderId: orderid.orderId,
                                  transactionId: orderid.transactionId,
                                  paymentGatewayTransactionId:
                                  orderid.paymentGatewayTransactionId,
                                  amount: orderid.amount,
                                  currency: orderid.currency,
                                  description: orderid.description,
                                  customerName: orderid.customerName,
                                  customerEmail: orderid.customerEmail,
                                  customerPhone: orderid.customerPhone,
                                  paymentMode: orderid.paymentMode,
                                  paymentChannel: orderid.paymentChannel,
                                  status: orderid.status,
                                  responseCode: orderid.responseCode,
                                  responseMessage: orderid.responseMessage,
                                  createdAt: orderid.createdAt,
                                  completedAt: orderid.completedAt,
                                  merchantId: orderid.merchantId,
                                  merchantName: orderid.merchantName,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },)
                ],
                child: Text("")
              ),
            ],
          ),
        ));
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade100,
      ),
    );
  }

  Widget _buildModernAmountSection({
    required String title,
    required String received,
    required String balance,
    required String overdue,
    required String current,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2 x 2 Grid
          Row(
            children: [
              Expanded(
                child: _buildAmountItem(
                  label: "Received",
                  value: received,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAmountItem(
                  label: "Balance",
                  value: balance,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildAmountItem(
                  label: "Overdue",
                  value: overdue,
                  isOverdue: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAmountItem(
                  label: "Current Receipt",
                  value: current,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountItem({
    required String label,
    required String value,
    bool isOverdue = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isOverdue
            ? const Color(0xFFE63946).withValues(alpha: 0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue
              ? const Color(0xFFE63946).withValues(alpha: 0.12)
              : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isOverdue ? const Color(0xFFE63946) : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isOverdue ? const Color(0xFFE63946) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _modernCardDecoration() {
    return BoxDecoration(
      // color: dominantColor?.withAlpha(150),
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

/*  Future<void> sendLinkFunction() async {
    final send = await PaymentLinkRepository().getPaymentLink(
        agentName: agentName!,
        agentId: agentId!,
        agentOriginId: agentOriginId!,
        agentPhone: agentMobile!,
        agentEmail: agentEmail!,
        customerName: widget.name,
        customerPhone: widget.custNo,
        customerAccountNumber: widget.loanNumber,
        customerEmail: "",
        customerId: cid!,
        linkAmount: num.parse(editAmountController.text),
        note: "Payment for Order #12345",
        corpCode: corpCode!,
        cardRefNum: "",
        token: token.toString(),
        subAgentId: subagentId!);

    send.fold(
          (error) {

      },
          (sendLink) {
        if (sendLink.linkUrl != null && sendLink.linkUrl!.isNotEmpty) {
          //Share.share("Here is your payment link: ${sendLink.linkUrl}");
          if(utl.printStatementStatus){
            print("3");
          }

          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
              PaymentLinkRequestUi(customerMobileNumber: widget.custNo, paymentLink: sendLink.linkUrl.toString(),)
          ));
        } else {
          // print("Payment link is empty or null");
        }
      },
    );
  }*/
  Future<void> createColorPallet(String imageStr) async {
    final ImageProvider imageProvider = AssetImage(imageStr);
    final PaletteGeneratorMaster paletteGenerator =
        await PaletteGeneratorMaster.fromImageProvider(
      imageProvider,
      maximumColorCount: 16,
      generateHarmony: true, // Generate color harmony
    );
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color;
    });
    if (utl.printStatementStatus) {
      print("dominantColor = $dominantColor");
    }

    //final Color? vibrantColor = paletteGenerator.vibrantColor?.color;
    // final Color? mutedColor = paletteGenerator.mutedColor?.color;
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _modernCardDecoration(),
      child: Row(
        children: [
          // Modern Avatar with gradient background
          LongPressImagePreview(
            imageProvider: AssetImage("assets/images/ecollect_white.png"),
            child: Container(
              decoration: BoxDecoration(
                //  color: dominantColor,
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/ecollect_white.png"),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.integratedLoanDetailModel.name,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    /* Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 12,
                            color: const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Active",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4361EE).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.badge_rounded,
                        size: 14,
                        color: Color(0xFF4361EE),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Customer ID: ${widget.integratedLoanDetailModel.custNo}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade200,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        utl.openGoogleMaps(
                            9.992079734802246, 76.27655792236328);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "View Customer Location",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Loan Details",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: home2,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: [
              _buildDetailItem(
                Icons.date_range,
                "Loan Date",
                widget.integratedLoanDetailModel.loanDate,
              ),
              _buildDetailItem(
                Icons.currency_rupee,
                "Loan Amount",
                widget.integratedLoanDetailModel.loanAmount,
              ),
              _buildDetailItem(
                Icons.numbers,
                "Loan Number",
                widget.integratedLoanDetailModel.loanNumber,
              ),
              _buildDetailItem(
                Icons.account_balance_wallet,
                "Loan Type",
                widget.integratedLoanDetailModel.loanType,
              ),
              _buildDetailItem(
                Icons.schedule,
                "Loan Period",
                widget.integratedLoanDetailModel.loanPeriod,
              ),
              _buildDetailItem(
                Icons.percent,
                "Interest",
                widget.integratedLoanDetailModel.loanInterest,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEA307B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: const Color(0xFFEA307B),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutlined ? Colors.white : home1,
        foregroundColor: isOutlined ? home1 : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isOutlined ? BorderSide(color: home1) : BorderSide.none,
        ),
        elevation: isOutlined ? 0 : 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  Future<bool> paymentConfirmation(
    BuildContext context,
    String name,
    String accNo,
    String custId,
    String amt,
  ) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Payment Confirmation",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Do you wish to proceed with the payment ?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false); // 🚫 User said NO
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: home1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: white,
                        ),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(
                            color: home1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedMethod = "Cash";
                          });
                          Navigator.pop(context);
                          context.read<PaymentBloc>().add(CashPaymentEvent(
                              QrPaymentRequestModel(
                                  agentDetails: AgentDetails(
                                      agentName: widget.ecollectMerchantModelData.eCollectMerchantName!,
                                      agentId: widget.ecollectMerchantModelData.eCollectAgentId!,
                                      agentOrginId: widget.ecollectMerchantModelData.eCollectAgentOriginId!,
                                      agentPhone: widget.ecollectMerchantModelData.eCollectAgentNumber!,
                                      agentEmail: widget.ecollectMerchantModelData.eCollectAgentEmail!,
                                      agentBranch:
                                          int.parse(widget.ecollectMerchantModelData.eCollectAgentBranchCode!)),
                                  customerDetails: CustomerDetails(
                                      customerName: widget.integratedLoanDetailModel.name,
                                      customerPhone: widget.ecollectMerchantModelData.eCollectAgentNumber!,
                                      customerAccno: widget.integratedLoanDetailModel.loanNumber,
                                      customerId: widget.integratedLoanDetailModel.custNo,
                                      customerEmail: widget.ecollectMerchantModelData.eCollectAgentEmail!),
                                  collectionType:widget.ecollectMerchantModelData. eCollectCollectionType!,
                                  amount:
                                      double.parse(editAmountController.text),
                                  note: 'Payment for Order',
                                  qrSource: 'MOB',
                                  source: 'COLLECTION',
                                  merchantId:
                                      int.parse(widget.ecollectMerchantModelData.eCollectAgentMerchantID!)),
                              widget.ecollectMerchantModelData.eCollectToken!));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false); // default to false if dismissed
  }

/*  Future<void> loanCashCollection() async {
    utl.showProgressDialog(context);
    final loanCashProvider =
        Provider.of<LoanCashCollectionProvider>(context, listen: false);
    await loanCashProvider.submitCashCollection(
        agentName.toString(),
        agent_Id.toString(),
        agentOriginId.toString(),
        agentMobile.toString(),
        agentEmail.toString(),
        int.parse(subagentId.toString()),
        "",
        subAgentCodeNew.toString(),
        widget.integratedLoanDetailModel.name,
        "",
        widget.integratedLoanDetailModel.loanNumber,
        widget.integratedLoanDetailModel.custNo,
        "",
        double.parse(editAmountController.text),
        "",
        corpCode.toString(),
        branchCode.toString(),
        "",
        "MOB",
        "CASH",
        "",
        "LOAN");
    if (loanCashProvider.loanCashCollectionResponse != null) {
      if (!mounted) return;
      Navigator.pop(context);
      //print(loanCashProvider.loanCashCollectionResponse?.message.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context,
                loanCashProvider.loanCashCollectionResponse!.status == "Y"
                    ? true
                    : false,
                loanCashProvider.loanCashCollectionResponse!.message
                    .toString());
          });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return linkShareAlert(
                context, false, loanCashProvider.loanCollectionErr.toString());
          });
    }
  }*/

  AlertDialog linkShareAlert(BuildContext context, bool status, String msg) {
    return AlertDialog(
      icon: status == true
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
              size: 30,
            ),
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Center(
          child: status == true ? const Text("Success") : const Text("Error")),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            Text(
              msg,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: home1,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(" OK "))
          ],
        ),
      ),
    );
  }

  //==============================================================================
  void _showSuccessMessage(String? message) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 70,
                        child: Image.asset(
                          'assets/images/ecollect_white.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Transaction Successful',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message ??
                            'Your transaction has been completed successfully.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Transaction Status',
                          'Successful',
                          valueColor: Colors.green,
                        ),
                        const Divider(height: 20),
                        _buildDetailRow(
                          'Transaction Date',
                          _getCurrentDate(),
                        ),
                        const Divider(height: 20),
                        _buildDetailRow(
                          'Order ID',
                          paymentOrderID!,
                        ),
                        const Divider(height: 20),
                        _buildDetailRow(
                          'Transaction Time',
                          _getCurrentTime(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            getHistoryData(message);
                          },
                          icon: const Icon(
                            Icons.print_outlined,
                            size: 20,
                          ),
                          label: const Text(
                            'Print',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {

                            if (!mounted) return;
                            Navigator.of(context).pop();
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildDetailRow(
      String title,
      String value, {
        Color? valueColor,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );}
  String _getCurrentDate() {
    final now = DateTime.now();

    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }
  String _getCurrentTime() {
    final now = DateTime.now();

    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }
  void getHistoryData(String? message) {
    debugPrint('Printing: ${message ?? ''}');
    context.read<PaymentTransactionBloc>().add(GetTransactionByMerchant(widget.ecollectMerchantModelData.eCollectAgentMerchantID!,widget.ecollectMerchantModelData. eCollectToken!));
  }
//===============================================================================


}
