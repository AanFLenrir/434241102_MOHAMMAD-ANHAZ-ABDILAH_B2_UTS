import '../models/ticket_model.dart';

class TicketService {
  static List<TicketModel> _mockTickets = [
    TicketModel(
      id: 1,
      title: 'Koneksi WiFi lambat',
      description: 'WiFi di lantai 3 sering putus-putus dan kecepatan sangat lambat sejak 2 hari lalu.',
      status: 'open',
      priority: 'high',
      category: 'Jaringan',
      attachmentUrl: null,
      createdBy: 3,
      createdByName: 'Budi Santoso',
      assignedTo: null,
      assignedToName: null,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
      comments: [
        CommentModel(
          id: 1,
          ticketId: 1,
          userId: 3,
          userName: 'Budi Santoso',
          userRole: 'user',
          message: 'Tolong segera diperbaiki, sangat mengganggu pekerjaan.',
          attachmentUrl: null,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
      ],
    ),
    TicketModel(
      id: 2,
      title: 'Printer tidak terdeteksi',
      description: 'Printer di ruang meeting tidak bisa digunakan, driver sudah diinstall ulang tetap tidak terdeteksi.',
      status: 'in_progress',
      priority: 'medium',
      category: 'Hardware',
      attachmentUrl: null,
      createdBy: 4,
      createdByName: 'Siti Aminah',
      assignedTo: 2,
      assignedToName: 'Helpdesk Agent',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      updatedAt: DateTime.now(),
      comments: [
        CommentModel(
          id: 2,
          ticketId: 2,
          userId: 2,
          userName: 'Helpdesk Agent',
          userRole: 'helpdesk',
          message: 'Sedang kami cek, mohon tunggu.',
          attachmentUrl: null,
          createdAt: DateTime.now(),
        ),
      ],
    ),
    TicketModel(
      id: 3,
      title: 'Aplikasi ERP error saat login',
      description: 'Setelah update terbaru, aplikasi ERP selalu crash saat login dengan error "NullReferenceException".',
      status: 'resolved',
      priority: 'critical',
      category: 'Software',
      attachmentUrl: null,
      createdBy: 3,
      createdByName: 'Budi Santoso',
      assignedTo: 1,
      assignedToName: 'Admin User',
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
      comments: [
        CommentModel(
          id: 3,
          ticketId: 3,
          userId: 1,
          userName: 'Admin User',
          userRole: 'admin',
          message: 'Masalah sudah diperbaiki pada patch terbaru. Silakan update aplikasi.',
          attachmentUrl: null,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
      ],
    ),
  ];

  Future<List<TicketModel>> getTickets({String? status, String? role, int? userId}) async {
    await Future.delayed(Duration(milliseconds: 800));
    List<TicketModel> filtered = List.from(_mockTickets);
    if (status != null && status != 'all') {
      filtered = filtered.where((t) => t.status == status).toList();
    }
    if (role == 'user' && userId != null) {
      filtered = filtered.where((t) => t.createdBy == userId).toList();
    }
    return filtered;
  }

  Future<TicketModel> getTicketById(int id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _mockTickets.firstWhere((t) => t.id == id);
  }

  Future<TicketModel> createTicket({
    required String title,
    required String description,
    required String category,
    required String priority,
    required int createdBy,
    required String createdByName,
    String? attachmentUrl,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    final newId = _mockTickets.length + 1;
    final newTicket = TicketModel(
      id: newId,
      title: title,
      description: description,
      status: 'open',
      priority: priority,
      category: category,
      attachmentUrl: attachmentUrl,
      createdBy: createdBy,
      createdByName: createdByName,
      assignedTo: null,
      assignedToName: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      comments: [],
    );
    _mockTickets.insert(0, newTicket);
    return newTicket;
  }

  Future<TicketModel> updateTicketStatus(int ticketId, String newStatus) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final old = _mockTickets[index];
      final updated = TicketModel(
        id: old.id,
        title: old.title,
        description: old.description,
        status: newStatus,
        priority: old.priority,
        category: old.category,
        attachmentUrl: old.attachmentUrl,
        createdBy: old.createdBy,
        createdByName: old.createdByName,
        assignedTo: old.assignedTo,
        assignedToName: old.assignedToName,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
        comments: old.comments,
      );
      _mockTickets[index] = updated;
      return updated;
    }
    throw Exception('Ticket not found');
  }

  Future<TicketModel> assignTicket(int ticketId, int assignedToId, String assignedToName) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final old = _mockTickets[index];
      final updated = TicketModel(
        id: old.id,
        title: old.title,
        description: old.description,
        status: old.status == 'open' ? 'in_progress' : old.status,
        priority: old.priority,
        category: old.category,
        attachmentUrl: old.attachmentUrl,
        createdBy: old.createdBy,
        createdByName: old.createdByName,
        assignedTo: assignedToId,
        assignedToName: assignedToName,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
        comments: old.comments,
      );
      _mockTickets[index] = updated;
      return updated;
    }
    throw Exception('Ticket not found');
  }

  Future<CommentModel> addComment(int ticketId, int userId, String userName, String userRole, String message, {String? attachmentUrl}) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _mockTickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      final newComment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        ticketId: ticketId,
        userId: userId,
        userName: userName,
        userRole: userRole,
        message: message,
        attachmentUrl: attachmentUrl,
        createdAt: DateTime.now(),
      );
      final old = _mockTickets[index];
      final updatedComments = [...old.comments, newComment];
      final updatedTicket = TicketModel(
        id: old.id,
        title: old.title,
        description: old.description,
        status: old.status,
        priority: old.priority,
        category: old.category,
        attachmentUrl: old.attachmentUrl,
        createdBy: old.createdBy,
        createdByName: old.createdByName,
        assignedTo: old.assignedTo,
        assignedToName: old.assignedToName,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
        comments: updatedComments,
      );
      _mockTickets[index] = updatedTicket;
      return newComment;
    }
    throw Exception('Ticket not found');
  }

  Future<Map<String, int>> getTicketStats(String role, int? userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    List<TicketModel> tickets;
    if (role == 'user' && userId != null) {
      tickets = _mockTickets.where((t) => t.createdBy == userId).toList();
    } else {
      tickets = _mockTickets;
    }
    return {
      'total': tickets.length,
      'open': tickets.where((t) => t.status == 'open').length,
      'in_progress': tickets.where((t) => t.status == 'in_progress').length,
      'resolved': tickets.where((t) => t.status == 'resolved').length,
      'closed': tickets.where((t) => t.status == 'closed').length,
    };
  }
}