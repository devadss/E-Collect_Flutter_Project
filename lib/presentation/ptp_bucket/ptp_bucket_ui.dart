import 'package:e_Collect/presentation/ptp_bucket/ptp_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils.dart';

class PtpBucketUi extends StatefulWidget {
  const PtpBucketUi({super.key});

  @override
  State<PtpBucketUi> createState() => _PtpBucketUiState();
}

class _PtpBucketUiState extends State<PtpBucketUi> {
  final TextEditingController amountController =
  TextEditingController();

  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  static const Color primary = Color(0xFFEA307B);
  static const Color primaryDark = Color(0xFF0F3FA8);

  static const Color background = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF667085);
  static const Color border = Color(0xFFE4E7EC);

  static const Color success = Color(0xFF039855);
  static const Color warning = Color(0xFFF79009);
  static const Color danger = Color(0xFFD92D20);

  // ------------------------------------------------------------
  // HEADER DATA
  // ------------------------------------------------------------

  final List<Map<String, dynamic>> headerContent = [
    {
      "title": "Due Customers",
      "value": "5",
      "icon": Icons.people_alt_outlined,
    },
    {
      "title": "Total PTP",
      "value": "315",
      "icon": Icons.event_available_outlined,
    },
    {
      "title": "Broken PTP",
      "value": "102",
      "icon": Icons.event_busy_outlined,
    },
    {
      "title": "Kept PTP",
      "value": "2",
      "icon": Icons.verified_outlined,
    },
  ];

  // ------------------------------------------------------------
  // BUCKET DATA
  // ------------------------------------------------------------

  final List<Map<String, dynamic>> buckets = [
    {
      "name": "All",
      "count": "5",
      "color": primary,
    },
    {
      "name": "B1",
      "range": "1-30 DPD",
      "count": "1",
      "color": Color(0xFFF79009),
    },
    {
      "name": "B2",
      "range": "31-60 DPD",
      "count": "1",
      "color": Color(0xFFEAAA08),
    },
    {
      "name": "B3",
      "range": "61-90 DPD",
      "count": "1",
      "color": Color(0xFFF04438),
    },
    {
      "name": "B4",
      "range": "91+ DPD",
      "count": "2",
      "color": Color(0xFFD92D20),
    },
  ];

  // ------------------------------------------------------------
  // CUSTOMER DATA
  // ------------------------------------------------------------

  final List<Map<String, dynamic>> customers = [
    {
      "name": "Ravi Kumar",
      "loanNo": "LN092020",
      "phone": "9090998987",
      "ptpDate": "19 Jan 2026",
      "due": "₹2,450",
      "bucket": "B1",
      "dpd": "18 DPD",
      "status": "PTP Due",
    },
    {
      "name": "Arun Kumar",
      "loanNo": "LN092021",
      "phone": "9090998988",
      "ptpDate": "21 Jan 2026",
      "due": "₹4,800",
      "bucket": "B2",
      "dpd": "42 DPD",
      "status": "PTP Due",
    },
    {
      "name": "Priya Sharma",
      "loanNo": "LN092022",
      "phone": "9090998989",
      "ptpDate": "23 Jan 2026",
      "due": "₹7,250",
      "bucket": "B3",
      "dpd": "76 DPD",
      "status": "Broken",
    },
    {
      "name": "Suresh Babu",
      "loanNo": "LN092023",
      "phone": "9090998990",
      "ptpDate": "25 Jan 2026",
      "due": "₹9,500",
      "bucket": "B4",
      "dpd": "104 DPD",
      "status": "PTP Due",
    },
    {
      "name": "Meena Devi",
      "loanNo": "LN092024",
      "phone": "9090998991",
      "ptpDate": "28 Jan 2026",
      "due": "₹12,200",
      "bucket": "B4",
      "dpd": "118 DPD",
      "status": "Broken",
    },
  ];

  int selectedCodeIndex = 0;

  // ------------------------------------------------------------
  // INIT
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: ptpBucketAppbar("LOAN COLLECTION"),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildDashboardHeader(),

                    const SizedBox(height: 24),

                    _buildSectionHeader(),

                    const SizedBox(height: 12),

                    _buildBucketFilters(),

                    const SizedBox(height: 20),

                    _buildCustomerList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // DASHBOARD HEADER
  // ------------------------------------------------------------

  Widget _buildDashboardHeader() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: headerContent.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 10),
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          final item = headerContent[index];

          return _buildMetricCard(
            title: item["title"],
            value: item["value"],
            icon: item["icon"],
            index: index,
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // METRIC CARD
  // ------------------------------------------------------------

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 19,
              color: primary,
            ),
          ),

          const SizedBox(width: 10),

          // CONTENT
          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 19,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMetricsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: headerContent.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.9,
      ),
      itemBuilder: (
          BuildContext context,
          int index,
          ) {
        final item = headerContent[index];

        return _buildMetricCard(
          title: item["title"],
          value: item["value"],
          icon: item["icon"],
          index: index,
        );
      },
    );
  }

  // ------------------------------------------------------------
  // SECTION HEADER
  // ------------------------------------------------------------

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              "Collection Queue",
              style: TextStyle(
                color: textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Customers requiring follow-up",
              style: TextStyle(
                color: textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            "${_filteredCustomers().length} Accounts",
            style: const TextStyle(
              color: primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // BUCKET FILTERS
  // ------------------------------------------------------------

  Widget _buildBucketFilters() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: buckets.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          return _buildBucketItem(
            index,
            buckets[index],
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // BUCKET ITEM
  // ------------------------------------------------------------

  Widget _buildBucketItem(
      int index,
      Map<String, dynamic> bucket,
      ) {
    final bool selected =
        selectedCodeIndex == index;

    final String name = bucket["name"];

    final String? range =
    bucket["range"];

    final Color bucketColor =
    bucket["color"];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCodeIndex = index;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primary
              : Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? primary
                : border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white
                    : bucketColor,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 8),

            Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (range != null)
                  Text(
                    range,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          .withValues(
                        alpha: 0.75,
                      )
                          : textSecondary,
                      fontSize: 9,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 8),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white
                    .withValues(alpha: 0.15)
                    : const Color(0xFFF2F4F7),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Text(
                bucket["count"],
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CUSTOMER LIST
  // ------------------------------------------------------------

  Widget _buildCustomerList() {
    final List<Map<String, dynamic>>
    filteredCustomers =
    _filteredCustomers();

    if (filteredCustomers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: filteredCustomers.length,
      separatorBuilder: (_, __) =>
      const SizedBox(height: 12),
      itemBuilder: (
          BuildContext context,
          int index,
          ) {
        return _buildCustomerCard(
          filteredCustomers[index],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // FILTER LOGIC
  // ------------------------------------------------------------

  List<Map<String, dynamic>>
  _filteredCustomers() {
    if (selectedCodeIndex == 0) {
      return customers;
    }

    final String selectedBucket =
    buckets[selectedCodeIndex]["name"];

    return customers.where((customer) {
      return customer["bucket"] ==
          selectedBucket;
    }).toList();
  }

  // ------------------------------------------------------------
  // CUSTOMER CARD
  // ------------------------------------------------------------

  Widget _buildCustomerCard(
      Map<String, dynamic> customer,
      ) {
    final String status =
    customer["status"];

    final bool isBroken =
        status == "Broken";

    final Color statusColor =
    isBroken ? danger : warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        children: [
          // --------------------------------------------------
          // CUSTOMER HEADER
          // --------------------------------------------------

          Row(
            children: [
              _buildAvatar(
                customer["name"],
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer["name"],
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Loan ID  •  ${customer["loanNo"]}",
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // STATUS
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.09,
                  ),
                  borderRadius:
                  BorderRadius.circular(6),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            color: border,
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------
          // LOAN INFO
          // --------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _infoItem(
                  "DPD",
                  customer["dpd"],
                ),
              ),

              Expanded(
                child: _infoItem(
                  "PTP DATE",
                  customer["ptpDate"],
                ),
              ),

              Expanded(
                child: _infoItem(
                  "DUE AMOUNT",
                  customer["due"],
                  valueColor: danger,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------
          // DUE AMOUNT
          // --------------------------------------------------

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius:
              BorderRadius.circular(9),
              border: Border.all(
                color: const Color(0xFFFDE7D0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFFFE8D6,
                    ),
                    borderRadius:
                    BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.currency_rupee,
                    size: 16,
                    color: danger,
                  ),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Outstanding Due",
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Text(
                  customer["due"],
                  style: const TextStyle(
                    color: danger,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------
          // ACTION BUTTONS
          // --------------------------------------------------

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _makePhoneCall(
                        customer["phone"],
                      );
                    },
                    icon: const Icon(
                      Icons.call_outlined,
                      size: 17,
                    ),
                    label: const Text(
                      "Call Customer",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: const BorderSide(
                        color: primary,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _openPtpPage(customer);
                    },
                    icon: const Icon(
                      Icons.event_available_outlined,
                      size: 17,
                    ),
                    label: const Text(
                      "Create PTP",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: primary,
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // AVATAR
  // ------------------------------------------------------------

  Widget _buildAvatar(String name) {
    final List<String> parts =
    name.trim().split(" ");

    String initials = "";

    if (parts.isNotEmpty) {
      initials += parts[0][0];

      if (parts.length > 1) {
        initials += parts[1][0];
      }
    }

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          color: primary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // INFO ITEM
  // ------------------------------------------------------------

  Widget _infoItem(
      String label,
      String value, {
        Color valueColor = textPrimary,
      }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textSecondary,
            fontSize: 9,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 42,
            color: Color(0xFF98A2B3),
          ),

          SizedBox(height: 12),

          Text(
            "No customers found",
            style: TextStyle(
              color: textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "There are no accounts in this bucket.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PHONE CALL
  // ------------------------------------------------------------

  Future<void> _makePhoneCall(
      String phone,
      ) async {
    final Uri uri =
    Uri.parse("tel:$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;

      showNotification(
        context,
        "Unable to open phone dialer",
        warning,
        Colors.white,
      );
    }
  }

  // ------------------------------------------------------------
  // OPEN PTP
  // ------------------------------------------------------------

  void _openPtpPage(
      Map<String, dynamic> customer,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PtpPage();
        },
      ),
    );
  }
}
/*class PtpBucketUi extends StatefulWidget {
  const PtpBucketUi({super.key});
  @override
  State<PtpBucketUi> createState() => _PtpBucketUiState();
}

class _PtpBucketUiState extends State<PtpBucketUi> {
  TextEditingController amountController = TextEditingController();

  final Map<String, List<dynamic>> headerContent = {
    "Due Customers": ["5", Colors.deepOrange],
    "Total PTP": ["315", Colors.amber],
    "Broken PTP": ["102", Colors.cyan],
    "Kept PTP": ["2", Colors.green],
  };
  final Map<String, dynamic> bfc = {
    "All": Colors.white,
    "B1(1-30 DPD)": Colors.orange,
    "B2(31-60 DPD)": Colors.amber,
    "B3(61-90 DPD)": Colors.red.shade300,
    "B4(91+ DPD)": Colors.red,
  };

  int? selectedIndex;
  int? selectedCodeIndex;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCodeIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),
      appBar: ptp_bucket_appbar("LOAN-BUCKET"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER CARDS
              SizedBox(
                width: double.infinity,
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: headerContent.length,
                  itemBuilder: (BuildContext context, int index) {
                    return headerWidget(
                      headerContent.keys.elementAt(index),
                      headerContent.values.elementAt(index).first,
                      headerContent.values.elementAt(index).last,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
              const Divider(),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  "Bucket Filters",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// FILTER CHIPS
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bfc.length,
                  itemBuilder: (BuildContext context, int index) {
                    return bucketWidgetCodes(index, bfc);
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// LIST
              Expanded(
                child: contentListWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView contentListWidget() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                border: Border.all(
                  color: selectedIndex == index
                      ? home1.withAlpha(70)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  /// TOP SECTION
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo.shade50,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.indigo,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Ravi Kumar",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "PTP : 19-01-2026",
                              style: TextStyle(
                                color: home1,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.orange.shade100,
                        ),
                        child: Text(
                          bfc.keys.elementAt(index),
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DUE AMOUNT BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.orange.shade50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.currency_rupee,
                                color: Colors.red.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Due Amount",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "₹ 2,450",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: home1,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            _makePhoneCall('tel:9090998987');
                          },
                          icon: const Icon(Icons.call),
                          label: const Text(
                            "Call",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: home1,
                            side: BorderSide(
                              color: home1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => PtpPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                          label: const Text(
                            "PTP",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  GestureDetector bucketWidgetCodes(int indexes, Map<String, dynamic> bfc) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCodeIndex = indexes;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 10,
        ),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selectedCodeIndex == indexes
              ? home2
              : bfc.values.elementAt(indexes),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: Text(
            bfc.keys.elementAt(indexes),
            style: TextStyle(
              color: selectedCodeIndex == indexes
                  ? Colors.white
                  : bfc.keys.elementAt(indexes) == "All"
                      ? Colors.black
                      : Colors.white,
              fontWeight: selectedCodeIndex == indexes
                  ? FontWeight.w800
                  : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Padding headerWidget(
    String headOne,
    String headTwo,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: .75),
              color,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              headOne,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              headTwo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
