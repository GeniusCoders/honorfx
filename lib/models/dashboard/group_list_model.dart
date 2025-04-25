class GroupListResponse {
  final int status;
  final String? msg;
  final List<GroupData>? data;

  GroupListResponse({required this.status, this.msg, this.data});

  factory GroupListResponse.fromJson(Map<String, dynamic> json) {
    return GroupListResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null
              ? List<GroupData>.from(
                json['data'].map((x) => GroupData.fromJson(x)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class GroupData {
  final String name;
  final String value;

  GroupData({required this.name, required this.value});

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(name: json['name'] ?? '', value: json['value'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
