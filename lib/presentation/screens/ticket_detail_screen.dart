import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_controller.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/ticket_model.dart';

class TicketDetailScreen extends StatefulWidget {
  final int ticketId;
  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TicketController controller = Get.find<TicketController>();
  final AuthService _authService = AuthService();
  final commentController = TextEditingController();
  var isUpdating = false.obs;
  
  @override
  void initState() {
    super.initState();
    controller.loadTicketDetail(widget.ticketId);
  }
  
  Future<void> _updateStatus(String newStatus) async {
    isUpdating.value = true;
    await controller.updateStatus(widget.ticketId, newStatus);
    isUpdating.value = false;
  }
  
  Future<void> _addComment() async {
    if (commentController.text.trim().isEmpty) return;
    await controller.addComment(widget.ticketId, commentController.text);
    commentController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tiket'),
        actions: [
          Obx(() {
            if (isUpdating.value) return Padding(padding: EdgeInsets.all(16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
            return Container();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.selectedTicket.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        final ticket = controller.selectedTicket.value;
        if (ticket == null) return Center(child: Text('Tiket tidak ditemukan'));
        return RefreshIndicator(
          onRefresh: () => controller.loadTicketDetail(widget.ticketId),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildInfoCard(ticket),
              SizedBox(height: 16),
              _buildStatusActions(ticket),
              SizedBox(height: 16),
              _buildComments(ticket),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildInfoCard(TicketModel ticket) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(ticket.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(ticket.priority),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ticket.priority.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow('Status', ticket.status, _getStatusColor(ticket.status)),
            _buildInfoRow('Kategori', ticket.category, null),
            _buildInfoRow('Dibuat oleh', ticket.createdByName, null),
            _buildInfoRow('Assign ke', ticket.assignedToName ?? 'Belum assign', null),
            _buildInfoRow('Dibuat', _formatDateTime(ticket.createdAt), null),
            _buildInfoRow('Terakhir update', _formatDateTime(ticket.updatedAt), null),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),
            Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(ticket.description),
            if (ticket.attachmentUrl != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_file, size: 16),
                  SizedBox(width: 4),
                  Text('Lampiran: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(ticket.attachmentUrl!.split('/').last),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: valueColor != null ? TextStyle(color: valueColor, fontWeight: FontWeight.w500) : null)),
        ],
      ),
    );
  }
  
  Widget _buildStatusActions(TicketModel ticket) {
    return FutureBuilder(
      future: _authService.getCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final isAdminOrHelpdesk = user?.role == 'admin' || user?.role == 'helpdesk';
        if (!isAdminOrHelpdesk) return SizedBox.shrink();
        
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aksi Admin/Helpdesk', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    if (ticket.status == 'open')
                      ElevatedButton(
                        onPressed: () => _updateStatus('in_progress'),
                        child: Text('Ambil Tiket'),
                      ),
                    if (ticket.status == 'in_progress')
                      ElevatedButton(
                        onPressed: () => _updateStatus('resolved'),
                        child: Text('Tandai Selesai'),
                      ),
                    if (ticket.status == 'resolved')
                      OutlinedButton(
                        onPressed: () => _updateStatus('closed'),
                        child: Text('Tutup Tiket'),
                      ),
                    OutlinedButton(
                      onPressed: () => _showAssignDialog(),
                      child: Text('Assign ke Helpdesk'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildComments(TicketModel ticket) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Komentar (${ticket.comments.length})', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ticket.comments.length,
              itemBuilder: (context, index) {
                final comment = ticket.comments[index];
                return _buildCommentTile(comment);
              },
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCommentTile(CommentModel comment) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: comment.userRole == 'admin' ? Colors.red : (comment.userRole == 'helpdesk' ? Colors.orange : Colors.blue),
            child: Text(comment.userName[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text(comment.userRole, style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Spacer(),
                    Text(_formatTime(comment.createdAt), style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 4),
                Text(comment.message),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAssignDialog() {
    final assignController = TextEditingController();
    Get.defaultDialog(
      title: 'Assign Tiket',
      content: Column(
        children: [
          TextField(
            controller: assignController,
            decoration: InputDecoration(labelText: 'ID Helpdesk (contoh: 2)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      onConfirm: () {
        final id = int.tryParse(assignController.text);
        if (id != null) {
          controller.assignTicket(widget.ticketId, id, 'Helpdesk $id');
        } else {
          Get.snackbar('Error', 'ID tidak valid');
        }
        Get.back();
      },
      textConfirm: 'Assign',
      textCancel: 'Batal',
    );
  }
  
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'critical': return Colors.red;
      case 'high': return Colors.orange;
      case 'medium': return Colors.blue;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
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
  
  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}