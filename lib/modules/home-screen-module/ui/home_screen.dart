// Updated home_screen.dart with proper responsive layout
// class HomeScreen extends StatefulWidget {
//   static String routeName = "/home";
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             _buildSliverAppBar(isTablet),
//             SliverPadding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: isTablet ? 24.0 : 16.0,
//                 vertical: 16.0,
//               ),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   _buildGreetingSection(isTablet),
//                   const SizedBox(height: 24),
//                   if (isTablet)
//                     _buildTabletLayout()
//                   else
//                     _buildMobileLayout(),
//                   const SizedBox(height: 24),
//                   const WeeklyPerformanceScreen(),
//                   const SizedBox(height: 100),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSliverAppBar(bool isTablet) {
//     return SliverAppBar(
//       backgroundColor: const Color(0xFFF8FAFC),
//       elevation: 0,
//       floating: true,
//       snap: true,
//       title: Text(
//         'Dashboard',
//         style: TextStyle(
//           color: const Color(0xFF1E293B),
//           fontSize: isTablet ? 24 : 20,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.notifications_outlined,
//               color: Color(0xFF64748B),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGreetingSection(bool isTablet) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(isTablet ? 32 : 24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF667EEA).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Good morning,',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: isTablet ? 18 : 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Sarah Johnson',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: isTablet ? 28 : 24,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               'Wednesday, March 26',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: isTablet ? 14 : 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabletLayout() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: IncomeDashboardCard(
//             title: "Total Collection",
//             amount: "\$998.8",
//             primaryColor: const Color(0xFF667EEA),
//             secondaryColor: const Color(0xFFF59E0B),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: IncomeDashboardCard(
//             title: "Total Earning",
//             amount: "\$698.2",
//             showChart: false,
//             primaryColor: const Color(0xFF10B981),
//             secondaryColor: const Color(0xFFEF4444),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileLayout() {
//     return Column(
//       children: [
//         IncomeDashboardCard(
//           title: "Total Collection",
//           amount: "\$998.8",
//           primaryColor: const Color(0xFF667EEA),
//           secondaryColor: const Color(0xFFF59E0B),
//         ),
//         const SizedBox(height: 16),
//         IncomeDashboardCard(
//           title: "Total Earning",
//           amount: "\$698.2",
//           showChart: false,
//           primaryColor: const Color(0xFF10B981),
//           secondaryColor: const Color(0xFFEF4444),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/modules/home-screen-module/ui/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32.0 : 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreetingSection(),
                const SizedBox(height: 24),
                _buildCollectionCards(isTablet),
                const SizedBox(height: 24),
                _buildWeeklyPerformance(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good morning,',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sarah Johnson',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Wednesday, March 26',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCards(bool isTablet) {
    if (isTablet) {
      return Row(
        children: [
          Expanded(
              child: _buildCollectionCard("Total Collection", "\$998.8", true)),
          const SizedBox(width: 16),
          Expanded(
              child: _buildCollectionCard("Total Earning", "\$698.2", false)),
        ],
      );
    }

    return Column(
      children: [
        _buildCollectionCard("Total Collection", "\$998.8", true),
        const SizedBox(height: 16),
        _buildCollectionCard("Total Earning", "\$698.2", false),
      ],
    );
  }

  Widget _buildCollectionCard(String title, String amount, bool isCollection) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'TODAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Amount Display
          Center(
            child: Column(
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isCollection ? 'Total collected today' : 'Total earned today',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Performance Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isCollection
                      ? '+15.2% from yesterday'
                      : '+12.8% from yesterday',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Loan',
                  '\$390',
                  const Color(0xFF667EEA),
                  () => _showDetailModal('Loan Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Pigmy',
                  '\$608',
                  const Color(0xFFF59E0B),
                  () => _showDetailModal('Pigmy Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, String amount, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyPerformance() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),

          // Chart Area
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildChartBars(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .map((day) => Text(
                            day,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(const Color(0xFF8B5CF6), 'Earning'),
              const SizedBox(width: 24),
              _buildLegendItem(const Color(0xFF3B82F6), 'Collection'),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChartBars() {
    final data = [30, 45, 25, 60, 40, 75, 50];
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final collectionValue = entry.value.toDouble();
      final earningValue = collectionValue * 0.7;

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: (earningValue / 75 * 140).clamp(20, 140),
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 8,
                height: (collectionValue / 75 * 140).clamp(20, 140),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showDetailModal(String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Detailed information will be displayed here...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:collectiv/modules/home-screen-module/ui/income_card.dart';
// import 'package:collectiv/modules/home-screen-module/ui/weekly_performance.dart';
// import 'package:collectiv/utils/size_config.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   static String routeName = "/modules/home-screen-module/ui/home_screen";

//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(
//             getProportionateWidth(16),
//             getProportionateHeight(16),
//             getProportionateWidth(16),
//             getProportionateHeight(16)),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const IncomeDashboardCard(
//                 title: "Total Collection",
//               ),
//               SizedBox(
//                 height: getProportionateHeight(16.0),
//               ),
//               const IncomeDashboardCard(
//                 title: "Total Earning",
//               ),
//               SizedBox(
//                 height: getProportionateHeight(16.0),
//               ),
//               const WeeklyPerformanceScreen(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
