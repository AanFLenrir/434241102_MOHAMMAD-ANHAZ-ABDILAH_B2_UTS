class TicketModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String category;
  final String? attachmentUrl;
  final int createdBy;
  final String createdByName;
  final int? assignedTo;
  final String? assignedToName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CommentModel> comments;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    this.attachmentUrl,
    required this.createdBy,
    required this.createdByName,
    this.assignedTo,
    this.assignedToName,
    required this.createdAt,
    required this.updatedAt,
    this.comments = const [],
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      category: json['category'],
      attachmentUrl: json['attachmentUrl'],
      createdBy: json['createdBy'],
      createdByName: json['createdByName'],
      assignedTo: json['assignedTo'],
      assignedToName: json['assignedToName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      comments: (json['comments'] as List?)
              ?.map((c) => CommentModel.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'category': category,
    'attachmentUrl': attachmentUrl,
    'createdBy': createdBy,
    'createdByName': createdByName,
    'assignedTo': assignedTo,
    'assignedToName': assignedToName,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'comments': comments.map((c) => c.toJson()).toList(),
  };
}

class CommentModel {
  final int id;
  final int ticketId;
  final int userId;
  final String userName;
  final String userRole;
  final String message;
  final String? attachmentUrl;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.message,
    this.attachmentUrl,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      ticketId: json['ticketId'],
      userId: json['userId'],
      userName: json['userName'],
      userRole: json['userRole'],
      message: json['message'],
      attachmentUrl: json['attachmentUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ticketId': ticketId,
    'userId': userId,
    'userName': userName,
    'userRole': userRole,
    'message': message,
    'attachmentUrl': attachmentUrl,
    'createdAt': createdAt.toIso8601String(),
  };
}