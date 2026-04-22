// lib/presentation/widgets/ticket_card.dart
import 'package:flutter/material.dart';
import '../../data/models/ticket_model.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({required this.ticket, required this.onTap, super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open': return Colors.orange;
      case 'in_progress': return Colors.blue;
      case 'resolved': return Colors.green;
      case 'closed': return Colors.grey;
      default: return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low': return Colors.green;
      case 'medium': return Colors.orange;
      case 'high': return Colors.red;
      case 'critical': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(ticket.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: _getStatusColor(ticket.status).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text(ticket.status.toUpperCase(), style: TextStyle(fontSize: 10, color: _getStatusColor(ticket.status))),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(ticket.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(ticket.category, style: TextStyle(fontSize: 12)),
                  SizedBox(width: 16),
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: _getPriorityColor(ticket.priority), shape: BoxShape.circle)),
                  SizedBox(width: 4),
                  Text(ticket.priority, style: TextStyle(fontSize: 12, color: _getPriorityColor(ticket.priority))),
                  Spacer(),
                  Text(DateFormat('dd/MM/yy').format(ticket.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}