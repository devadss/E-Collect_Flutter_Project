import 'package:e_Collect/data/non_integrated_bloc/non_integrated_bloc.dart';
import 'package:e_Collect/domain/model/non_integrated/loan_all_data/complete_loanlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils.dart';
import '../../../../domain/model/non_integarted_loan_list_due.dart';
import 'non_integrated_loan_due_detail.dart';

class NonIntegratedLoanDuePaymentsScreen extends StatefulWidget {
  final String baseUrl;
  final String agentCode;
  final String branchCode;
  final String productType;
  final String agentRouteCode;
  final int pageNo;
  final int pageSize;
  final String eCollectMerchantName;
  final String eCollectAgentMerchantID;
  final String eCollectToken;
  final String eCollectAgentID;
  final String eCollectAgentOriginID;
  final String eCollectAgentMobNum;
  final String eCollectAgentEmail;
  final String eCollectAgentBranchCode;
  const NonIntegratedLoanDuePaymentsScreen(
      {super.key,
      required this.baseUrl,
      required this.agentCode,
      required this.branchCode,
      required this.productType,
      required this.pageNo,
      required this.pageSize,
      required this.agentRouteCode, required this.eCollectMerchantName, required this.eCollectAgentMerchantID, required this.eCollectToken, required this.eCollectAgentID, required this.eCollectAgentOriginID, required this.eCollectAgentMobNum, required this.eCollectAgentEmail, required this.eCollectAgentBranchCode});

  @override
  State<NonIntegratedLoanDuePaymentsScreen> createState() =>
      _NonIntegratedLoanDuePaymentsScreenState();
}

class _NonIntegratedLoanDuePaymentsScreenState
    extends State<NonIntegratedLoanDuePaymentsScreen> {
  bool showProgress = false;
  @override
  void initState() {
    super.initState();

    context.read<NonIntegratedBloc>().add(FetchNonIntegratedLoanDues(
        widget.baseUrl,
        widget.agentCode,
        widget.branchCode,
        widget.productType,
        widget.pageNo,
        widget.pageSize,
        widget.agentRouteCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'Due Payments',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          _HeaderIconButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 4),
          _HeaderIconButton(
            icon: Icons.tune_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocConsumer<NonIntegratedBloc, NonIntegratedState>(
        builder: (BuildContext context, NonIntegratedState state) {

          if (state is NonIntegratedLoanDueSuccessState) {

            var items = <Map<String, dynamic>>[];
            var totalOne = 0;
            var totalOneCount = 0;
            var totalTwo = 0;
            var totalTwoCount = 0;
            var totalThree = 0;
            var totalThreeCount = 0;
            var totalFour = 0;
            var totalFourCount = 0;
            var totalFive = 0;
            var totalFiveCount = 0;
            List<String> riskType = [];
            for (var daysPastDue in state
                .dueLoanListNonIntegratedSuccess
                .nonIntegratedLoanDueList
                .data) {
              if (daysPastDue.daysPastDue == 0) {
                totalOne += daysPastDue.outstandingAmount;
                totalOneCount++;
                riskType.add(daysPastDue.riskCategory);
              } else if (daysPastDue.daysPastDue > 0 &&
                  daysPastDue.daysPastDue < 31) {
                totalTwo += daysPastDue.outstandingAmount;
                totalTwoCount++;
                riskType.add(daysPastDue.riskCategory);
              } else if (daysPastDue.daysPastDue > 30 &&
                  daysPastDue.daysPastDue < 61) {
                totalThree += daysPastDue.outstandingAmount;
                totalThreeCount++;
                riskType.add(daysPastDue.riskCategory);
              } else if (daysPastDue.daysPastDue > 60 &&
                  daysPastDue.daysPastDue < 91) {
                totalFour += daysPastDue.outstandingAmount;
                totalFourCount++;
                riskType.add(daysPastDue.riskCategory);
              } else if (daysPastDue.daysPastDue > 90) {
                totalFive += daysPastDue.outstandingAmount;
                totalFiveCount++;
                riskType.add(daysPastDue.riskCategory);
              }
            }

            if (totalOneCount > 0) {
              items.add({
                "bucket_name": "current",
                "total_overdue": totalOne,
                "total_count": totalOneCount,
                "risk": riskType[0],
                "color": Colors.green,
              });
            }

            if (totalTwoCount > 0) {
              items.add({
                "bucket_name": "1-30",
                "total_overdue": totalTwo,
                "total_count": totalTwoCount,
                "risk": riskType[1],
                "color": Colors.yellow,
              });
            }

            if (totalThreeCount > 0) {
              items.add({
                "bucket_name": "31-60",
                "total_overdue": totalThree,
                "total_count": totalThreeCount,
                "risk": riskType[2],
                "color": Colors.orange,
              });
            }

            if (totalFourCount > 0) {
              items.add({
                "bucket_name": "61-90",
                "total_overdue": totalFour,
                "total_count": totalFourCount,
                "risk": riskType[3],
                "color": Colors.purple,
              });
            }

            if (totalFiveCount > 0) {
              items.add({
                "bucket_name": "90+",
                "total_overdue": totalFive,
                "total_count": totalFiveCount,
                "risk": riskType[4],
                "color": Colors.red,
              });
            }
            var total = 0;
            var emi = 0;
            NonIntegratedLoanDueList data = state.dueLoanListNonIntegratedSuccess.nonIntegratedLoanDueList;
            for (var x in data.data) {
              total += x.outstandingAmount.toInt();
              emi += x.emiAmount.toInt();
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                // ============================================================
                // SUMMARY CARD
                // ============================================================

                _CollectionSummaryCard(emi: emi, data: data, total: total),

                const SizedBox(height: 24),

                // ============================================================
                // BUCKET HEADER
                // ============================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Due Analysis',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ============================================================
                // BUCKETS
                // ============================================================

                SizedBox(
                  height: 160,
                  child:
                  ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return DpdBucketCard(
                        bucket: items[index],
                      );
                    },
                  )
                ),

                const SizedBox(height: 28),

                // ============================================================
                // CUSTOMER HEADER
                // ============================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Customers',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ============================================================
                // CUSTOMER CARDS
                // ============================================================

                ...state.dueLoanListNonIntegratedSuccess
                    .nonIntegratedLoanDueList.data
                    .map(
                      (customer) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DueCustomerCard(
                      customer: customer,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)
                        => CustomerDetailPage(
                     customer: customer, ecollectMerchantModelData:
                        EcollectMerchantModelData(
                            eCollectMerchantName: widget.eCollectMerchantName,
                            eCollectAgentId: widget.eCollectAgentID,
                            eCollectAgentOriginId: widget.eCollectAgentOriginID,
                            eCollectAgentNumber:widget. eCollectAgentMobNum,
                            eCollectAgentEmail: widget.eCollectAgentEmail,
                            eCollectAgentBranchCode:widget.eCollectAgentBranchCode,
                            eCollectAgentMerchantID: widget.eCollectAgentMerchantID,
                            eCollectCollectionType: "LOAN", eCollectToken: widget.eCollectToken),

                        )));
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
        listener: (BuildContext context, NonIntegratedState state) {
          if(state is NonIntegratedLoanDueLoaderState){
            if (showProgress == false) {
              showProgressDialog(context);
              showProgress = true;
            }
          }
          if(state is NonIntegratedLoanDueSuccessState){
            if(showProgress == true){
              Navigator.pop(context);
              showProgress = false;
            }
          }
          else if(state is NonIntegratedLoanDueFailureState){
            if(showProgress == true){
              Navigator.pop(context);
              showProgress = false;
            }
          }
        },

      ),
    );
  }
}

// ======================================================================
// HEADER BUTTON
// ======================================================================

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 22,
      icon: Icon(
        icon,
        size: 22,
        color: const Color(0xFF374151),
      ),
    );
  }
}

// ======================================================================
// COLLECTION SUMMARY
// ======================================================================

class _CollectionSummaryCard extends StatefulWidget {
  final int emi;
  final int total;
  final NonIntegratedLoanDueList data;

  const _CollectionSummaryCard({required this.emi, required this.data, required this.total});

  @override
  State<_CollectionSummaryCard> createState() => _CollectionSummaryCardState();
}

class _CollectionSummaryCardState extends State<_CollectionSummaryCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Outstanding collections',
                style: TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '₹ ${NumberFormat('#,##,##0', 'en_IN').format(widget.emi)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Total amount to collect',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  value: "${widget.data.data.length.toString()} Nos",
                  label: 'Customers count',
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              Expanded(
                child: _SummaryMetric(
                  value:
                  '₹${NumberFormat('#,##,##0', 'en_IN').format(widget.total)}',
                  label: 'Overdue',
                ),
              ),
            ],
          ),
        ],
      )

    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryMetric({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// DPD BUCKET CARD
// ======================================================================

class DpdBucketCard extends StatelessWidget {
  final Map<String, dynamic> bucket;

  const DpdBucketCard({
    super.key,
    required this.bucket,
  });

  @override
  Widget build(BuildContext context) {
    final Color bucketColor = bucket["color"] as Color;

    final String count = NumberFormat(
      '#,##,##0',
      'en_IN',
    ).format(bucket["total_count"]);

    final String overdue = NumberFormat(
      '#,##,##0',
      'en_IN',
    ).format(bucket["total_overdue"]);

    return Container(
      width: 165,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE9ECF1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: bucketColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  bucket['bucket_name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF18202F),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Risk description
          Text(
            bucket["risk"] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              height: 1.35,
              color: Color(0xFF8A93A3),
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          // Count
          Text(
            count,
            style: const TextStyle(
              fontSize: 23,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'ACCOUNTS',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9CA3AF),
            ),
          ),

          const SizedBox(height: 12),

          // Overdue section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 14,
                  color: Colors.red.shade500,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '₹ $overdue',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// CUSTOMER CARD
// ======================================================================

class DueCustomerCard extends StatelessWidget {
  final CustomerDue customer;
  final VoidCallback? onTap;

  const DueCustomerCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final risk = _getRiskStyle(customer.riskCategory);

    final dueAmount = NumberFormat(
      '#,##,##0',
      'en_IN',
    ).format(customer.dueAmount);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE8EBF0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // CUSTOMER HEADER
              // ============================================================

              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: risk.background,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      customer.customerName.isNotEmpty
                          ? customer.customerName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: risk.foreground,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Loan • ${customer.accountNumber}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8A93A3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Risk badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: risk.background,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: risk.foreground,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          customer.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: risk.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ============================================================
              // AMOUNT SECTION
              // ============================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL DUE',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹ $dueAmount',
                          style: const TextStyle(
                            fontSize: 23,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'NEXT DUE',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 0.7,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer.nextDueDate,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: risk.foreground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ============================================================
              // LAST PAYMENT
              // ============================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 15,
                      color: Color(0xFF8A93A3),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'Last paid',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8A93A3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        customer.lastPaidDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: Color(0xFFB0B7C3),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ============================================================
              // ACTIONS
              // ============================================================

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.phone_outlined,
                          size: 15,
                        ),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 15,
                        ),
                        label: const Text('WhatsApp'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: onTap,
                      tooltip: 'View customer',
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF111827),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
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
  }

  _RiskStyle _getRiskStyle(String riskCategory) {
    if (riskCategory.contains('Regular (0 DPD)')) {
      return const _RiskStyle(
        foreground: Color(0xFF15803D),
        background: Color(0xFFF0FDF4),
      );
    }

    if (riskCategory.contains('SMA-0 (2 DPD)')) {
      return const _RiskStyle(
        foreground: Color(0xFFB45309),
        background: Color(0xFFFFFBEB),
      );
    }

    if (riskCategory.contains('SMA-2 (61-90 DPD)')) {
      return const _RiskStyle(
        foreground: Color(0xFFEA580C),
        background: Color(0xFFFFF7ED),
      );
    }

    return const _RiskStyle(
      foreground: Color(0xFFDC2626),
      background: Color(0xFFFEF2F2),
    );
  }
}

class _RiskStyle {
  final Color foreground;
  final Color background;

  const _RiskStyle({
    required this.foreground,
    required this.background,
  });
}


/*class DueCustomerCard extends StatelessWidget {
  final CustomerDue customer;
  final VoidCallback? onTap;

  const DueCustomerCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.orange;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: customer.riskCategory.contains("Regular (0 DPD)")
                  ? Colors.green
                  : customer.riskCategory.contains("SMA-0 (2 DPD)")
                  ? Colors.yellow
                  : customer.riskCategory
                  .contains("SMA-2 (61-90 DPD)")
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// ========================================================
// CUSTOMER HEADER
// ========================================================
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: customer.riskCategory.contains("Regular (0 DPD)")
                          ? Colors.green.shade50
                          : customer.riskCategory.contains("SMA-0 (2 DPD)")
                          ? Colors.yellow.shade50
                          : customer.riskCategory
                          .contains("SMA-2 (61-90 DPD)")
                          ? Colors.orange.shade50
                          : Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      customer.customerName[0].toUpperCase(),
                      style: TextStyle(
                        color: customer.riskCategory.contains("Regular (0 DPD)")
                            ? Colors.green
                            : customer.riskCategory.contains("SMA-0 (2 DPD)")
                            ? Colors.yellow
                            : customer.riskCategory
                            .contains("SMA-2 (61-90 DPD)")
                            ? Colors.orange
                            : Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.customerName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Loan • ${customer.accountNumber}',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: customer.riskCategory.contains("Regular (0 DPD)")
                          ? Colors.green.shade50
                          : customer.riskCategory.contains("SMA-0 (2 DPD)")
                              ? Colors.yellow.shade50
                              : customer.riskCategory
                                      .contains("SMA-2 (61-90 DPD)")
                                  ? Colors.orange.shade50
                                  : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      customer.status,
                      style: TextStyle(
                        color: customer.riskCategory.contains("Regular (0 DPD)")
                            ? Colors.green
                            : customer.riskCategory.contains("SMA-0 (2 DPD)")
                            ? Colors.black
                            : customer.riskCategory
                            .contains("SMA-2 (61-90 DPD)")
                            ? Colors.orange
                            : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

             // const SizedBox(height: 18),

// ========================================================
// AMOUNT
// ========================================================
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AMOUNT DUE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹ ${NumberFormat('#,##,##0', 'en_IN').format(customer.dueAmount)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    customer.nextDueDate,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

// ========================================================
// STATUS
// ========================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: color,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      customer.lastPaidDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

// ========================================================
// ACTIONS
// ========================================================

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.phone_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'Call',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                        ),
                        label: const Text(
                          'WhatsApp',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: onTap,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF111827),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
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
  }
}*/
