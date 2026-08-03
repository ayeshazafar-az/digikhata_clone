import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/theme.dart';

final staffProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final profileRes =
      await supabase.from('profiles').select('active_business_id').single();
  final activeBusinessId = profileRes['active_business_id'];

  if (activeBusinessId == null) return [];

  final res = await supabase
      .from('staff')
      .select()
      .eq('business_id', activeBusinessId)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(res);
});

class StaffBookScreen extends ConsumerWidget {
  const StaffBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Dark Theme
      appBar: AppBar(
        title: const Text('Staff Book',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: AppTheme.primaryBlue,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Attendance'),
                Tab(text: 'Payroll'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAttendanceTab(context, ref),
                  _buildPayrollTab(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTab(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffProvider);
    return Stack(
      children: [
        Column(
          children: [
            // Date Scroller
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.chevron_left, color: Colors.black87),
                  Text('Sat, 01 Aug 26',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Icon(Icons.chevron_right, color: Colors.black87),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Present/Absent Metrics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                shape: BoxShape.circle),
                            child: const Text(' P ',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          const Text('Rs 0',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const Text('0 Present',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                shape: BoxShape.circle),
                            child: const Text(' A ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          const Text('Rs 0',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const Text('0 Absent',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: staffAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: Colors.black87))),
                data: (staffList) {
                  if (staffList.isEmpty) return _buildAttendanceEmptyState();
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 16, bottom: 80),
                    itemCount: staffList.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade800),
                    itemBuilder: (context, index) {
                      final staff = staffList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withValues(alpha: 0.2),
                          child: Text(
                              (staff['name'] ?? '?')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ),
                        title: Text(staff['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        subtitle: Text(
                            'Monthly: Rs. ${staff['monthly_salary']}',
                            style: const TextStyle(color: Colors.grey)),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text('Mark Present',
                              style: TextStyle(color: Colors.black87)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: ElevatedButton.icon(
            onPressed: () => _showAddStaffModal(context, ref),
            icon: const Icon(Icons.person_add, color: Colors.black87),
            label: const Text('ADD STAFF',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF05A28),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: const Icon(Icons.groups,
                    size: 100, color: Color(0xFFE8C17F)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("1- Add staff",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
                Text("2- Mark attendance daily",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
                Text("3- Automatically manages salary",
                    style:
                        TextStyle(color: Colors.grey, fontSize: 16, height: 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollTab(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffProvider);

    return Stack(
      children: [
        Column(
          children: [
            // Month Scroller
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.chevron_left, color: Colors.black87),
                  Text('August 2026',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Icon(Icons.chevron_right, color: Colors.black87),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Total Salary Metric
            Expanded(
              child: staffAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                    child: Text('Error: $err',
                        style: const TextStyle(color: Colors.black87))),
                data: (staffList) {
                  if (staffList.isEmpty) return _buildPayrollEmptyState();

                  double totalSalary = 0;
                  for (var s in staffList) {
                    totalSalary +=
                        double.tryParse(s['monthly_salary'].toString()) ?? 0;
                  }

                  return Column(children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Salary Generated',
                              style:
                                  TextStyle(color: Colors.black87, fontSize: 16)),
                          Text('Rs $totalSalary',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                        child: ListView.separated(
                            padding: const EdgeInsets.only(top: 8, bottom: 80),
                            itemCount: staffList.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: Colors.grey.shade800),
                            itemBuilder: (context, index) {
                              final staff = staffList[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.amber.withValues(alpha: 0.2),
                                  child: const Icon(Icons.assignment_ind,
                                      color: Colors.amber),
                                ),
                                title: Text(staff['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87)),
                                subtitle: const Text('Present: 28 Days',
                                    style: TextStyle(color: Colors.grey)),
                                trailing: Text('Rs. ${staff['monthly_salary']}',
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              );
                            }))
                  ]);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayrollEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: const Icon(Icons.assignment,
                    size: 100, color: Color(0xFFE8C17F)),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
                child: const Icon(Icons.lock, color: Colors.black87, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('No records for this month',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Add staff properly first to trigger generation.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showAddStaffModal(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final salaryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF252525),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Staff',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 20),
              decoration: const InputDecoration(
                labelText: 'Staff Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black87, fontSize: 18),
              decoration: const InputDecoration(
                prefixText: 'Rs. ',
                prefixStyle: TextStyle(color: Colors.grey),
                labelText: 'Monthly Salary',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                try {
                  final supabase = Supabase.instance.client;
                  final pRes = await supabase
                      .from('profiles')
                      .select('active_business_id')
                      .single();
                  final bId = pRes['active_business_id'];
                  if (bId != null) {
                    await supabase.from('staff').insert({
                      'business_id': bId,
                      'name': nameController.text,
                      'monthly_salary':
                          double.tryParse(salaryController.text) ?? 0,
                    });
                    ref.invalidate(staffProvider);
                    if (context.mounted) Navigator.pop(ctx);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error adding staff')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: const Color(0xFFF05A28),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('SAVE STAFF',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
