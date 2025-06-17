class DocumentUploadResponse {
  final int status;
  final String? msg;
  final List<DocumentUpload>? data;

  DocumentUploadResponse({required this.status, this.msg, this.data});

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null && json['data'] is List
              ? (json['data'] as List)
                  .map((item) => DocumentUpload.fromJson(item))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class DocumentUpload {
  final int? id;
  final int? userid;
  final String? filename;
  final String documentType;
  final String status;
  final String? comment;
  final String? extension;
  final int? adminid;
  final String? createdAt;
  final String? updatedAt;

  DocumentUpload({
    this.id,
    this.userid,
    this.filename,
    required this.documentType,
    required this.status,
    this.comment,
    this.extension,
    this.adminid,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentUpload.fromJson(Map<String, dynamic> json) {
    return DocumentUpload(
      id: json['id'],
      userid: json['userid'],
      filename: json['filename'],
      documentType: json['document_type'] ?? '',
      status: json['status'] ?? '0',
      comment: json['comment'],
      extension: json['extension'],
      adminid: json['adminid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userid': userid,
      'filename': filename,
      'document_type': documentType,
      'status': status,
      'comment': comment,
      'extension': extension,
      'adminid': adminid,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper method to get the file path for image display
  String? get filePath {
    if (filename != null && userid != null) {
      return '/images/$documentType/$userid/$filename';
    }
    return null;
  }

  // Helper method to check if document is approved
  bool get isApproved => status == '1';
}

class DocumentUploadModel {
  final int? id;
  final String? userid;
  final String? filename;
  final String? documentType;
  final String? status;
  final String? comment;
  final String? extension;
  final String? adminid;
  final String? createdAt;
  final String? updatedAt;

  DocumentUploadModel({
    this.id,
    this.userid,
    this.filename,
    this.documentType,
    this.status,
    this.comment,
    this.extension,
    this.adminid,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentUploadModel.fromJson(Map<String, dynamic> json) {
    return DocumentUploadModel(
      id: json['id'],
      userid: json['userid'],
      filename: json['filename'],
      documentType: json['document_type'],
      status: json['status'],
      comment: json['comment'],
      extension: json['extension'],
      adminid: json['adminid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userid': userid,
      'filename': filename,
      'document_type': documentType,
      'status': status,
      'comment': comment,
      'extension': extension,
      'adminid': adminid,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper method to get the file path for image display
  String? get filePath {
    if (filename != null && userid != null) {
      return '/images/$documentType/$userid/$filename';
    }
    return null;
  }

  // Helper method to check if document is approved
  bool get isApproved => status == '1';
}

class UploadDocumentModel {
  final String? poi;
  final String? poiBack;
  final String? poa;
  final String? poaBack;

  UploadDocumentModel({this.poi, this.poiBack, this.poa, this.poaBack});

  Map<String, dynamic> toJson() {
    return {'poi': poi, 'poiback': poiBack, 'poa': poa, 'poaback': poaBack};
  }
}
