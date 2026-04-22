import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_controller.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/ticket_model.dart';

class DashboardScreen extends StatelessWidget {
  final TicketController ticketController = Get.put(TicketController());
  final AuthService _authService = AuthService();

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                middleText: 'Apakah Anda yakin ingin logout?',
                onConfirm: () {
                  logout();
                  Get.back();
                },
                textConfirm: 'Ya',
                textCancel: 'Batal',
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ticketController.fetchStats();
          await ticketController.fetchTickets();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _authService.getCurrentUser(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selamat Datang,', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          Text(user?.name ?? 'User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Chip(
                            label: Text(user?.role ?? 'user', style: TextStyle(color: Colors.white)),
                            backgroundColor: user?.role == 'admin' ? Colors.red : (user?.role == 'helpdesk' ? Colors.orange : Colors.blue),
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text('Statistik Tiket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Obx(() {
                final stats = ticketController.stats;
                if (stats.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildStatCard('Total Tiket', stats['total'] ?? 0, Icons.confirmation_number, Colors.blue),
                    _buildStatCard('Open', stats['open'] ?? 0, Icons.warning_amber, Colors.orange),
                    _buildStatCard('In Progress', stats['in_progress'] ?? 0, Icons.sync, Colors.purple),
                    _buildStatCard('Resolved', stats['resolved'] ?? 0, Icons.check_circle, Colors.green),
                  ],
                );
              }),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/create-ticket'),
                      icon: Icon(Icons.add),
                      label: Text('Buat Tiket Baru'),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed('/tickets'),
                      icon: Icon(Icons.list),
                      label: Text('Lihat Semua Tiket'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Tiket Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Obx(() {
                if (ticketController.isLoading.value && ticketController.tickets.isEmpty) {
                  return Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()));
                }
                if (ticketController.tickets.isEmpty) {
                  return Card(
                    child: Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Belum ada tiket'))),
                  );
                }
                final recentTickets = ticketController.tickets.take(3).toList();
                return Column(
                  children: recentTickets.map((ticket) => _buildRecentTicketTile(ticket)).toList(),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed('/tickets');
          } else if (index == 2) {
            Get.toNamed('/profile');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tiket'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTicketTile(TicketModel ticket) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(ticket.status),
          child: Icon(Icons.confirmation_number, size: 18, color: Colors.white),
        ),
        title: Text(ticket.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${ticket.category} • ${ticket.status}'),
        trailing: Text(_formatDate(ticket.createdAt), style: TextStyle(fontSize: 12)),
        onTap: () => Get.toNamed('/ticket-detail/${ticket.id}'),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open': return Colors.orange;
      case 'in_progress': return Colors.purple;
      case 'resolved': return Colors.green;
      case 'closed': return Colors.grey;
      default: return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (now.difference(date).inDays == 0) return 'Hari ini';
    if (now.difference(date).inDays == 1) return 'Kemarin';
    return '${now.difference(date).inDays} hari lalu';
  }
}