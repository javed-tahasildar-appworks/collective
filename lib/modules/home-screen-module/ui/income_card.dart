// income_dashboard_card.dart
import 'package:flutter/material.dart';

class IncomeDashboardCard extends StatefulWidget {
  final String title;
  final String amount;
  final bool showChart;
  final Color primaryColor;
  final Color secondaryColor;

  const IncomeDashboardCard({
    super.key,
    required this.title,
    required this.amount,
    this.showChart = true,
    this.primaryColor = const Color(0xFF667EEA),
    this.secondaryColor = const Color(0xFFF59E0B),
  });

  @override
  State<IncomeDashboardCard> createState() => _IncomeDashboardCardState();
}

class _IncomeDashboardCardState extends State<IncomeDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardPadding = isTablet ? 32.0 : 20.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: isTablet ? 16.0 : 8.0,
                vertical: 8.0,
              ),
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: isTablet ? 24 : 20),
                  _buildAmountSection(isTablet),
                  if (widget.showChart) ...[
                    SizedBox(height: isTablet ? 24 : 20),
                    _buildChartSection(isTablet),
                  ],
                  SizedBox(height: isTablet ? 24 : 20),
                  _buildPerformanceIndicator(isTablet),
                  SizedBox(height: isTablet ? 24 : 20),
                  _buildActionButtons(isTablet),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'TODAY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection(bool isTablet) {
    return Center(
      child: Column(
        children: [
          Text(
            widget.amount,
            style: TextStyle(
              fontSize: isTablet ? 40 : 36,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title.toLowerCase().contains('collection')
                ? 'Total collected today'
                : 'Total earned today',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(bool isTablet) {
    return Row(
      children: [
        _buildPieChart(isTablet ? 140 : 120),
        SizedBox(width: isTablet ? 32 : 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChartLegendItem('Loan', '60.9%', widget.primaryColor),
              const SizedBox(height: 12),
              _buildChartLegendItem('Pigmy', '39.1%', widget.secondaryColor),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collection Rate',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: const Color(0xFF0284C7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '87.5%',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 0.609,
              strokeWidth: 12,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '60.9%',
                    style: TextStyle(
                      fontSize: size * 0.12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Loans',
                    style: TextStyle(
                      fontSize: size * 0.08,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegendItem(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceIndicator(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            widget.title.toLowerCase().contains('collection')
                ? '+15.2% from yesterday'
                : '+12.8% from yesterday',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Loan',
            '\$390',
            widget.primaryColor,
            isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildActionButton(
            'Pigmy',
            '\$608',
            widget.secondaryColor,
            isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, String amount, Color color, bool isTablet) {
    return GestureDetector(
      onTap: () => _showDetailBottomSheet(label),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 16,
          horizontal: isTablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 6),
            Text(
              amount,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailBottomSheet(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      '$type Details',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailCard(
                        'Total Amount', type == 'Loan' ? '\$390' : '\$608'),
                    _buildDetailCard(
                        'Active Clients', type == 'Loan' ? '24' : '31'),
                    _buildDetailCard(
                        'Collection Rate', type == 'Loan' ? '89%' : '85%'),
                    _buildDetailCard(
                        'Pending Amount', type == 'Loan' ? '\$45' : '\$62'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class IncomeDashboardCard extends StatelessWidget {
//   final String title;

//   const IncomeDashboardCard({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: trendDark),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
//                   child: Text(
//                     "Wed 26 Mar",
//                     style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: kWhite),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: 100,
//                 width: 100,
//                 child: PieChart(
//                   PieChartData(
//                     sectionsSpace: 4,
//                     centerSpaceRadius: 30,
//                     sections: [
//                       PieChartSectionData(
//                         value: 60.93,
//                         color: budgetLight,
//                         radius: 20,
//                       ).copyWith(
//                         title: '60.9%',
//                         titleStyle: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       PieChartSectionData(
//                         value: 39.07,
//                         color: cc,
//                         radius: 20,
//                       ).copyWith(
//                         title: '39.0%',
//                         titleStyle: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Total Collection : \$998.8',
//                     style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                         color: trendDark),
//                   ),
//                   SizedBox(height: getProportionateHeight(16.0)),
//                   Text(
//                     'Day to Day',
//                     style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                         color: neutralDark),
//                   ),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.arrow_drop_up_rounded,
//                         color: wealthyGreen,
//                       ),
//                       Text(
//                         '\$456.8 (55%)',
//                         style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w500,
//                             color: wealthyGreen),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: getProportionateHeight(16.0)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildButton('Loan', "\$390", cc),
//               _buildButton('Pigmy', "\$608", budgetLight),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildButton(String text, String value, Color color) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: () {},
//           child: Column(
//             children: [
//               Text(
//                 text,
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
