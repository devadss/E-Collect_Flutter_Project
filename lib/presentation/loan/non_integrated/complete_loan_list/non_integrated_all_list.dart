import 'package:e_Collect/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/non_integrated_bloc/non_integrated_bloc.dart';
import '../../../../domain/model/non_integrated/loan_all_data/complete_loanlist.dart';
import 'non_integrated_detail/non_integrated_loan_detail_page.dart';

class NonIntegratedAllLoansScreen extends StatefulWidget {
  final String endPoint;
  final String branchCode;
  final String agentID;
  final String eCollectMerchantName;
  final String eCollectAgentMerchantID;
  final String eCollectToken;
  final String eCollectAgentID;
  final String eCollectAgentOriginID;
  final String eCollectAgentMobNum;
  final String eCollectAgentEmail;
  final String eCollectAgentBranchCode;
  const NonIntegratedAllLoansScreen(
      {super.key,
      required this.endPoint,
      required this.branchCode,
      required this.agentID, required this.eCollectMerchantName, required this.eCollectAgentMerchantID, required this.eCollectToken, required this.eCollectAgentID, required this.eCollectAgentOriginID, required this.eCollectAgentMobNum, required this.eCollectAgentEmail, required this.eCollectAgentBranchCode

      });

  @override
  State<NonIntegratedAllLoansScreen> createState() =>
      _NonIntegratedAllLoansScreenState();
}

class _NonIntegratedAllLoansScreenState
    extends State<NonIntegratedAllLoansScreen> {
  bool showProgress = false;
  @override
  void initState() {
    super.initState();
    context.read<NonIntegratedBloc>().add(FetchAllNonIntegratedLoans(
        widget.endPoint, widget.branchCode, "ALL", widget.agentID, ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
// ============================================================
// APP BAR
// ============================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 20,
        centerTitle: false,
        title: const Text(
          'Loans',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          _HeaderButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
          _HeaderButton(
            icon: Icons.tune_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),

// ============================================================
// BODY
// ============================================================
      body: BlocConsumer<NonIntegratedBloc, NonIntegratedState>(
        builder: (BuildContext context, NonIntegratedState state) {
          if (state is AllNonIntegratedLoanSuccessState) {
            var data = state.completeLoanListNonIntegratedSuccess
                .completeLoanLisResponse.data;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                // ==========================================================
                // PORTFOLIO SUMMARY
                // ==========================================================
                _PortfolioSummary(
                  loanCount: data.length,
                ),
                const SizedBox(height: 26),
                // ==========================================================
                // SECTION HEADER
                // ==========================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All loans',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      '${data.length} active',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 11),

                // ==========================================================
                // LOANS
                // ==========================================================

                ...data.map(
                  (loan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: LoanCard(
                      loan: loan,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NonIntegratedLoanDetailsScreen(
                              loanData: loan, ecollectMerchantModelData:
                            EcollectMerchantModelData(
                                eCollectMerchantName: widget.eCollectMerchantName,
                                eCollectAgentId: widget.eCollectAgentID,
                                eCollectAgentOriginId: widget.eCollectAgentOriginID,
                                eCollectAgentNumber:widget. eCollectAgentMobNum,
                                eCollectAgentEmail: widget.eCollectAgentEmail,
                                eCollectAgentBranchCode:widget.eCollectAgentBranchCode,
                                eCollectAgentMerchantID: widget.eCollectAgentMerchantID,
                                eCollectCollectionType: "LOAN", eCollectToken: widget.eCollectToken),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AllNonIntegratedLoanFailureState) {
            return Text("");
          }
          return Text("");
        },
        listener: (BuildContext context, NonIntegratedState state) {
          if (state is AllNonIntegratedLoanLoaderState) {
            if (showProgress == false) {
              showProgressDialog(context);
              showProgress = true;
            }
          }
          if (state is AllNonIntegratedLoanSuccessState) {
            if (showProgress == true) {
              Navigator.pop(context);
              showProgress = false;
            }
          } else if (state is AllNonIntegratedLoanFailureState) {
            if (showProgress == true) {
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

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({
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
        size: 21,
        color: const Color(0xFF374151),
      ),
    );
  }
}

// ======================================================================
// PORTFOLIO SUMMARY
// ======================================================================

class _PortfolioSummary extends StatelessWidget {
  final int loanCount;

  const _PortfolioSummary({
    required this.loanCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: BlocBuilder<NonIntegratedBloc, NonIntegratedState>(
        builder: (BuildContext context, NonIntegratedState state) {
          double total = 0;
          double emiTotal = 0;

          if (state is AllNonIntegratedLoanSuccessState) {
            final data = state
                .completeLoanListNonIntegratedSuccess
                .completeLoanLisResponse
                .data;

            for (var t in data) {
              total += t.outstandingAmount;
              emiTotal += t.emiAmount;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.account_balance_outlined,
                        color: Color(0xFFE2E8F0),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Loan portfolio',
                      style: TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  '₹${NumberFormat('#,##,##0', 'en_IN').format(total)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Total outstanding',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PortfolioMetric(
                          value: '$loanCount',
                          label: 'Active loans',
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 32,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      Expanded(
                        child: _PortfolioMetric(
                          value:
                          '₹${NumberFormat('#,##,##0', 'en_IN').format(emiTotal)}',
                          label: 'Total EMI',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PortfolioMetric extends StatelessWidget {
  final String value;
  final String label;

  const _PortfolioMetric({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}



class LoanCard extends StatelessWidget {
  final LoanData loan;
  final VoidCallback? onTap;

  const LoanCard({
    super.key,
    required this.loan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const statusColor = Color(0xFF16A34A);
    const statusBackground = Color(0xFFF0FDF4);

    final outstanding = NumberFormat(
      '#,##,##0',
      'en_IN',
    ).format(loan.outstandingAmount);

    final emi = NumberFormat(
      '#,##,##0',
      'en_IN',
    ).format(loan.emiAmount);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                  _CustomerAvatar(
                    name: loan.customerName.isNotEmpty
                        ? loan.customerName[0]
                        : '?',
                    color: statusColor,
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Loan • ${loan.accountNumber}',
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

                  _StatusChip(
                    label: loan.status,
                    color: statusColor,
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 19,
                    color: Color(0xFFB0B7C3),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ============================================================
              // OUTSTANDING BALANCE
              // ============================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUTSTANDING BALANCE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9CA3AF),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹ $outstanding',
                          style: const TextStyle(
                            fontSize: 25,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          loan.status,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ============================================================
              // LOAN METRICS
              // ============================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _LoanMetric(
                        label: 'EMI',
                        value: '₹ $emi',
                      ),
                    ),

                    _MetricDivider(),

                    Expanded(
                      child: _LoanMetric(
                        label: 'Frequency',
                        value: loan.emiFrequency,
                      ),
                    ),

                    _MetricDivider(),

                    Expanded(
                      child: _LoanMetric(
                        label: 'Next due',
                        value: loan.nextDueDate.toString(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 13),

              // ============================================================
              // REMINDER STATUS
              // ============================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: loan.reminderEnabled
                      ? const Color(0xFFFFFBEB)
                      : const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: loan.reminderEnabled
                            ? const Color(0xFFFFF3D6)
                            : const Color(0xFFEEF0F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        loan.reminderEnabled
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_none_rounded,
                        size: 15,
                        color: loan.reminderEnabled
                            ? const Color(0xFFD97706)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loan.reminderEnabled
                                ? 'Payment reminder active'
                                : 'Payment reminder inactive',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: loan.reminderEnabled
                                  ? const Color(0xFF92400E)
                                  : const Color(0xFF6B7280),
                            ),
                          ),

                          if (loan.reminderEnabled) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${loan.reminderDaysBeforeDue} • '
                                  '${loan.reminderChannels}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: Color(0xFFB8BEC8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================================
// SMALL COMPONENTS
// ============================================================================

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFE5E7EB),
    );
  }
}

// class _PortfolioSummary extends StatelessWidget {
//   final int loanCount;
//
//   const _PortfolioSummary({
//     required this.loanCount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           // color: const Color(0xFF111827),
//           color: const Color(0xFF111827),
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: BlocBuilder<NonIntegratedBloc, NonIntegratedState>(
//           builder: (BuildContext context, NonIntegratedState state) {
//             double? total = 0;
//             double? emiTotal = 0;
//             if (state is AllNonIntegratedLoanSuccessState) {
//               var data = state.completeLoanListNonIntegratedSuccess
//                   .completeLoanLisResponse.data;
//               for (var t in data) {
//                 total = (total! + t.outstandingAmount) as double?;
//                 emiTotal = (emiTotal! + t.emiAmount) as double?;
//               }
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 32,
//                         height: 32,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.10),
//                           borderRadius: BorderRadius.circular(9),
//                         ),
//                         child: const Icon(
//                           Icons.account_balance_outlined,
//                           color: Colors.white,
//                           size: 17,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Text(
//                         'Loan portfolio',
//                         style: TextStyle(
//                           color: Color(0xFFD1D5DB),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 18),
//                   Text(
//                     '₹${NumberFormat('#,##,##0', 'en_IN').format(total)}',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: -1,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Total outstanding',
//                     style: TextStyle(
//                       color: Color(0xFF9CA3AF),
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     height: 1,
//                     color: Colors.white.withValues(alpha: 0.08),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _PortfolioMetric(
//                           value: '$loanCount',
//                           label: 'Active loans',
//                         ),
//                       ),
//                       Container(
//                         width: 1,
//                         height: 30,
//                         color: Colors.white.withValues(alpha: 0.08),
//                       ),
//                       Expanded(
//                         child: _PortfolioMetric(
//                           value:
//                               '₹${NumberFormat('#,##,##0', 'en_IN').format(emiTotal)}',
//                           label: 'Total EMI',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             }
//             return SizedBox.shrink();
//           },
//         ));
//   }
// }
//
// class _PortfolioMetric extends StatelessWidget {
//   final String value;
//   final String label;
//
//   const _PortfolioMetric({
//     required this.value,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Color(0xFF9CA3AF),
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ======================================================================
// LOAN CARD
// ======================================================================
/*class LoanCard extends StatelessWidget {
  final LoanData loan;
  final VoidCallback? onTap;

  const LoanCard({
    super.key,
    required this.loan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = Colors.green;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
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
                  _CustomerAvatar(
                    name: loan.customerName[0],
                    color: statusColor,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.customerName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Loan • ${loan.accountNumber}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(
                    label: loan.status,
                    color: statusColor,
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),

             // const SizedBox(height: 18),

// ========================================================
// OUTSTANDING
// ========================================================
Divider(),
              const Text(
                'OUTSTANDING',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.7,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "₹ ${NumberFormat('#,##,##0', 'en_IN').format(loan.outstandingAmount)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 17),

// ========================================================
// EMI INFORMATION
// ========================================================

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _LoanMetric(
                          label: 'EMI',
                          value: NumberFormat('#,##,##0', 'en_IN')
                              .format(loan.emiAmount)),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: const Color(0xFFE5E7EB),
                    ),
                    Expanded(
                      child: _LoanMetric(
                        label: 'Frequency',
                        value: loan.emiFrequency,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: const Color(0xFFE5E7EB),
                    ),
                    Expanded(
                      child: _LoanMetric(
                        label: 'Due date',
                        value: loan.nextDueDate.toString(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

// ========================================================
// REMINDER
// ========================================================

              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: loan.reminderEnabled
                          ? const Color(0xFFFFF7ED)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      loan.reminderEnabled
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined,
                      size: 16,
                      color: loan.reminderEnabled
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.reminderEnabled
                              ? 'Payment reminder enabled'
                              : 'Payment reminder disabled',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: loan.reminderEnabled
                                ? const Color(0xFF374151)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        if (loan.reminderEnabled) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${loan.reminderDaysBeforeDue} • ${loan.reminderChannels}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFFD1D5DB),
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

// ======================================================================
// CUSTOMER AVATAR
// ======================================================================

class _CustomerAvatar extends StatelessWidget {
  final String name;
  final Color color;

  const _CustomerAvatar({
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ======================================================================
// STATUS CHIP
// ======================================================================

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// LOAN METRIC
// ======================================================================

class _LoanMetric extends StatelessWidget {
  final String label;
  final String value;

  const _LoanMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
