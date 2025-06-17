class CreateTicketRequest {
  final String title;
  final String category;
  final String priority;
  final String message;

  CreateTicketRequest({
    required this.title,
    required this.category,
    required this.priority,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'priority': priority,
      'message': message,
    };
  }
}

class CreateTicketResponse {
  int? status;
  String? msg;
  CreateTicketData? data;

  CreateTicketResponse({this.status, this.msg, this.data});

  CreateTicketResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data =
        json["data"] != null ? CreateTicketData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["msg"] = msg;
    if (data != null) {
      _data["data"] = data!.toJson();
    }
    return _data;
  }
}

class CreateTicketData {
  String? ticketId;
  String? message;

  CreateTicketData({this.ticketId, this.message});

  CreateTicketData.fromJson(Map<String, dynamic> json) {
    ticketId = json["ticket_id"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["ticket_id"] = ticketId;
    _data["message"] = message;
    return _data;
  }
}

class MyTicketsResponse {
  int? status;
  String? msg;
  List<TicketData>? data;

  MyTicketsResponse({this.status, this.msg, this.data});

  MyTicketsResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data =
        json["data"] != null && json["data"] is List
            ? (json["data"] as List).map((e) => TicketData.fromJson(e)).toList()
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["msg"] = msg;
    if (data != null) {
      _data["data"] = data!.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class TicketData {
  int? userid;
  String? title;
  String? ticketId;
  String? category;
  String? priority;
  String? message;
  String? status;
  String? name;
  String? createdAt;
  String? updatedAt;

  TicketData({
    this.userid,
    this.title,
    this.ticketId,
    this.category,
    this.priority,
    this.message,
    this.status,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  TicketData.fromJson(Map<String, dynamic> json) {
    userid = json["userid"];
    title = json["title"];
    ticketId = json["ticket_id"];
    category = json["category"];
    priority = json["priority"];
    message = json["message"];
    status = json["status"];
    name = json["name"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userid"] = userid;
    _data["title"] = title;
    _data["ticket_id"] = ticketId;
    _data["category"] = category;
    _data["priority"] = priority;
    _data["message"] = message;
    _data["status"] = status;
    _data["name"] = name;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

class AddCommentRequest {
  final String ticketId;
  final String comment;

  AddCommentRequest({required this.ticketId, required this.comment});

  Map<String, dynamic> toJson() {
    return {'ticket_id': ticketId, 'comment': comment};
  }
}

class AddCommentResponse {
  int? status;
  String? msg;
  CommentData? data;

  AddCommentResponse({this.status, this.msg, this.data});

  AddCommentResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
    data = json["data"] != null ? CommentData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["msg"] = msg;
    if (data != null) {
      _data["data"] = data!.toJson();
    }
    return _data;
  }
}

class CommentData {
  String? commentId;
  String? ticketId;
  String? comment;
  String? createdAt;

  CommentData({this.commentId, this.ticketId, this.comment, this.createdAt});

  CommentData.fromJson(Map<String, dynamic> json) {
    commentId = json["comment_id"];
    ticketId = json["ticket_id"];
    comment = json["comment"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["comment_id"] = commentId;
    _data["ticket_id"] = ticketId;
    _data["comment"] = comment;
    _data["created_at"] = createdAt;
    return _data;
  }
}
