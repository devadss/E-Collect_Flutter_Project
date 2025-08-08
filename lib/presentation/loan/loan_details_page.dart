import 'package:collection_qr_flutter/core/colors.dart';
import 'package:flutter/material.dart';

class LoanDetailsPage extends StatefulWidget {
  final String customerName;
  final String loanNumber;
  final String loanStatus;
  final num emiAmount;
  final num loanTerm;
  final num loanAmount;
  const LoanDetailsPage(
      {super.key,
        required this.customerName,
        required this.loanNumber,
        required this.emiAmount,
        required this.loanTerm,
        required this.loanStatus,
        required this.loanAmount});

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideUpAnimation;
  late Animation<Color?> _colorAnimation;

  // Sample loan data
  final Map<String, dynamic> loanDetails = {
    'loanNumber': 'LN-2023-45678',
    'borrowerName': 'John Doe',
    'loanAmount': 25000.00,
    'interestRate': 7.5,
    'term': 36, // months
    'startDate': '2023-06-15',
    'endDate': '2026-06-15',
    'monthlyPayment': 777.53,
    'remainingBalance': 18500.00,
    'status': 'Active',
    'lastPaymentDate': '2023-10-01',
    'nextPaymentDue': '2023-11-01',
  };

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _slideUpAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: home1.withOpacity(0),
      end: home1.withOpacity(0.1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Loan Details'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: home2),
        titleTextStyle: const TextStyle(
          color: home2,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with profile and status
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: home1.withOpacity(0.2),
                              child:const Icon(
                                Icons.person,
                                size: 30,
                                color: home1,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.customerName,
                                    style:const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: home2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Loan #${widget.loanNumber.replaceAll("LOAN-", "")}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.loanStatus == 'Active'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.loanStatus == 'Active'
                                      ? Colors.green
                                      : Colors.orange,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.loanStatus,
                                style: TextStyle(
                                  color: widget.loanStatus == 'Active'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // FadeTransition(
                //   opacity: _fadeAnimation,
                //   child: SlideTransition(
                //     position: Tween<Offset>(
                //       begin: const Offset(0, 0.2),
                //       end: Offset.zero,
                //     ).animate(_animationController),
                //     child: Container(
                //       padding: const EdgeInsets.all(16),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(16),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.05),
                //             blurRadius: 10,
                //             offset: const Offset(0, 5),
                //           ),
                //         ],
                //       ),
                //       child: Row(
                //         children: [
                //           CircleAvatar(
                //             radius: 30,
                //             backgroundColor: home1.withOpacity(0.2),
                //             child: Icon(
                //               Icons.person,
                //               size: 30,
                //               color: home1,
                //             ),
                //           ),
                //           const SizedBox(width: 16),
                //           Expanded(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   widget.customerName,
                //                   style: TextStyle(
                //                     fontSize: 18,
                //                     fontWeight: FontWeight.bold,
                //                     color: home2,
                //                   ),
                //                 ),
                //                 const SizedBox(height: 4),
                //                 Text(
                //                   'Loan #${widget.loanNumber.replaceAll("LOAN-", "")}',
                //                   style: const TextStyle(
                //                     color: Colors.grey,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Container(
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 12, vertical: 6),
                //             decoration: BoxDecoration(
                //               color: widget.loanStatus == 'Active'
                //                   ? Colors.green.withOpacity(0.1)
                //                   : Colors.orange.withOpacity(0.1),
                //               borderRadius: BorderRadius.circular(20),
                //               border: Border.all(
                //                 color: widget.loanStatus == 'Active'
                //                     ? Colors.green
                //                     : Colors.orange,
                //                 width: 1,
                //               ),
                //             ),
                //             child: Text(
                //               widget.loanStatus,
                //               style: TextStyle(
                //                 color: widget.loanStatus == 'Active'
                //                     ? Colors.green
                //                     : Colors.orange,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 20),

                // Loan summary cards in a row
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Loan Amount',
                            '${widget.loanAmount}',
                            Icons.attach_money,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            'Balance',
                            '\$${loanDetails['remainingBalance'].toStringAsFixed(2)}',
                            Icons.account_balance_wallet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Loan details
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.4),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.zero, // To match previous container width behavior
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const  Text(
                              'Loan Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: home2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailItem(
                              Icons.percent,
                              'Interest Rate',
                              '${loanDetails['interestRate']}%',
                            ),
                            _buildDetailItem(
                              Icons.calendar_today,
                              'Loan Term',
                              '${widget.loanTerm} days',
                            ),
                            _buildDetailItem(
                              Icons.payment,
                              'Monthly Payment',
                              '₹${widget.emiAmount}',
                            ),
                            _buildDetailItem(
                              Icons.date_range,
                              'Start Date',
                              loanDetails['startDate'],
                            ),
                            _buildDetailItem(
                              Icons.event_available,
                              'End Date',
                              loanDetails['endDate'],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // FadeTransition(
                //   opacity: _fadeAnimation,
                //   child: SlideTransition(
                //     position: Tween<Offset>(
                //       begin: const Offset(0, 0.4),
                //       end: Offset.zero,
                //     ).animate(_animationController),
                //     child: Container(
                //       width: double.infinity,
                //       padding: const EdgeInsets.all(16),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(16),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.05),
                //             blurRadius: 10,
                //             offset: const Offset(0, 5),
                //           ),
                //         ],
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Loan Details',
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: home2,
                //             ),
                //           ),
                //           const SizedBox(height: 12),
                //           _buildDetailItem(
                //             Icons.percent,
                //             'Interest Rate',
                //             '${loanDetails['interestRate']}%',
                //           ),
                //           _buildDetailItem(
                //             Icons.calendar_today,
                //             'Loan Term',
                //             '${widget.loanTerm} days',
                //           ),
                //           _buildDetailItem(
                //             Icons.payment,
                //             'Monthly Payment',
                //             '₹${widget.emiAmount}',
                //           ),
                //           _buildDetailItem(
                //             Icons.date_range,
                //             'Start Date',
                //             loanDetails['startDate'],
                //           ),
                //           _buildDetailItem(
                //             Icons.event_available,
                //             'End Date',
                //             loanDetails['endDate'],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 20),

                // Payment information section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.zero, // Ensures full width
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const  Text(
                              'Payment Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: home2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailItem(
                              Icons.history,
                              'Last Payment',
                              loanDetails['lastPaymentDate'],
                            ),
                            _buildDetailItem(
                              Icons.next_plan,
                              'Next Payment Due',
                              loanDetails['nextPaymentDue'],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // FadeTransition(
                //   opacity: _fadeAnimation,
                //   child: SlideTransition(
                //     position: Tween<Offset>(
                //       begin: const Offset(0, 0.5),
                //       end: Offset.zero,
                //     ).animate(_animationController),
                //     child: Container(
                //       width: double.infinity,
                //       padding: const EdgeInsets.all(16),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(16),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.05),
                //             blurRadius: 10,
                //             offset: const Offset(0, 5),
                //           ),
                //         ],
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Payment Information',
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               color: home2,
                //             ),
                //           ),
                //           const SizedBox(height: 12),
                //           _buildDetailItem(
                //             Icons.history,
                //             'Last Payment',
                //             loanDetails['lastPaymentDate'],
                //           ),
                //           _buildDetailItem(
                //             Icons.next_plan,
                //             'Next Payment Due',
                //             loanDetails['nextPaymentDue'],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 24),

                // Action buttons
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.6),
                      end: Offset.zero,
                    ).animate(_animationController),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: home1,
                              elevation: 0,
                            ),
                            onPressed: () {
                              // Handle make payment action
                            },
                            child: const Text(
                              'Make Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side:const BorderSide(color: home1),
                            ),
                            onPressed: () {
                              // Handle view schedule action
                            },
                            child:const Text(
                              'View Payment Schedule',
                              style: TextStyle(
                                color: home1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: home1.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: home1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: home2,
              ),
            ),
          ],
        ),
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(16),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.05),
    //         blurRadius: 10,
    //         offset: const Offset(0, 5),
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             decoration: BoxDecoration(
    //               color: home1.withOpacity(0.1),
    //               shape: BoxShape.circle,
    //             ),
    //             child: Icon(
    //               icon,
    //               size: 20,
    //               color: home1,
    //             ),
    //           ),
    //           const SizedBox(width: 8),
    //           Text(
    //             title,
    //             style: const TextStyle(
    //               color: Colors.grey,
    //               fontSize: 14,
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 8),
    //       Text(
    //         value,
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //           color: home2,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: home1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style:const TextStyle(
              fontWeight: FontWeight.w500,
              color: home2,
            ),
          ),
        ],
      ),
    );
  }
}
