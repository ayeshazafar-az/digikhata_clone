import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF05A28), Color(0xFFE65100)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Dashboard',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Stack(
        children: [
          // Orange Header Background Extension
          Container(
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF05A28), Color(0xFFE65100)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildMainCard(),
                const SizedBox(height: 16),
                _buildReceiveablesCard(),
                const SizedBox(height: 16),
                _buildCashFlowCard(),
                const SizedBox(height: 16),
                _buildAvailableStockCard(),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('👋', style: TextStyle(fontSize: 28)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi Ayesha\'s Ledger!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Let\'s see all the statistics of your business',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text('Income & Expense',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                SizedBox(height: 4),
                Text('Profit = Income - Expense',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          // Chart Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              const Text('Income',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 16),
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              const Text('Expense',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LineChart(LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                      dashArray: [5, 5]),
                  getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.orange.withOpacity(0.2), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return const Text('0',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10));
                            })),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10);
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('Mar', style: style);
                                  break;
                                case 1:
                                  text = const Text('Apr', style: style);
                                  break;
                                case 2:
                                  text = const Text('May', style: style);
                                  break;
                                case 3:
                                  text = const Text('Jun', style: style);
                                  break;
                                case 4:
                                  text = const Text('Jul', style: style);
                                  break;
                                case 5:
                                  text = const Text('Aug', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(meta: meta, child: text);
                            }))),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: -2,
                maxY: 2,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 0),
                      const FlSpot(1, 0),
                      const FlSpot(2, 0),
                      const FlSpot(3, 0),
                      const FlSpot(4, 0),
                      const FlSpot(5, 0),
                    ],
                    isCurved: false,
                    color: Colors.red,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                              radius: 3,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: Colors.red),
                    ),
                  ),
                ])),
          ),
          const SizedBox(height: 16),
          // Actions
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Select month',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(children: [
                        Text('Lifetime', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey, size: 16)
                      ]),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.trending_up, color: Colors.green),
                        Icon(Icons.monetization_on, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('Profit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))
                      ]),
                      Text('Rs 0',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ]),
                const SizedBox(height: 16),
                _buildActionRow('Income', 'Rs 0', isGreen: true),
                _buildActionRow('Stock Sale', 'Add >', isBtn: true),
                _buildActionRow('Bill Sale', 'Add >', isBtn: true),
                const SizedBox(height: 8),
                _buildActionRow('Expense', 'Rs 0', isGreen: false),
                _buildActionRow('Purchases', 'Add >', isBtn: true),
                _buildActionRow('Expenses', 'Add >', isBtn: true),
                _buildActionRow('Salaries', 'Add >', isBtn: true),
              ]))
        ],
      ),
    );
  }

  Widget _buildActionRow(String label, String trailing,
      {bool isGreen = false, bool isBtn = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isBtn
            ? (label.contains('Sale')
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.05))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 15,
                  color: isBtn
                      ? Colors.black87
                      : (isGreen ? Colors.green : Colors.red),
                  fontWeight: isBtn ? FontWeight.normal : FontWeight.bold)),
          if (isBtn)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFF05A28),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(trailing,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            )
          else
            Text(trailing,
                style: TextStyle(
                    color: isGreen ? Colors.green : Colors.red, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildReceiveablesCard() {
    return _buildBaseCard(
        icon: Icons.receipt_long,
        title: 'Receiveables & Payables',
        subtitle: 'Top payable & Receiveable amounts',
        child: Row(children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: const Color(0xFFF05A28),
                borderRadius: BorderRadius.circular(8)),
            child: const Column(children: [
              Text('Rs 0',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text('Receiveables',
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ]),
          )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8)),
            child: const Column(children: [
              Text('Rs 0',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text('Payables',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ]),
          )),
        ]));
  }

  Widget _buildCashFlowCard() {
    return _buildBaseCard(
        icon: Icons.money,
        title: 'Cash Flow Summery',
        subtitle: 'Track your daily cash activity',
        child: Row(children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cash in Hand',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Rs 0',
                      style: TextStyle(color: Colors.black87, fontSize: 13)),
                ]),
          )),
          const SizedBox(width: 12),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bank Balance',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('0',
                      style: TextStyle(color: Colors.black87, fontSize: 13)),
                ]),
          )),
        ]));
  }

  Widget _buildAvailableStockCard() {
    return _buildBaseCard(
        icon: Icons.inventory_2,
        title: 'Available Stock Items',
        subtitle: 'Stock overview & ledgers',
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8)),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Stock',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('0',
                        style: TextStyle(color: Colors.black87, fontSize: 13)),
                  ]),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8)),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock Value',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Rs 0',
                        style: TextStyle(color: Colors.black87, fontSize: 13)),
                  ]),
            )),
          ]),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Best Seller',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const Text('No Stock Found Please Add Stock!',
              style: TextStyle(color: Colors.grey, fontSize: 13)),
        ]));
  }

  Widget _buildBaseCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ])),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFF05A28).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.arrow_outward,
                    color: Color(0xFFF05A28), size: 16),
              )
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
