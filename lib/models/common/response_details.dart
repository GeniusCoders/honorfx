class ResponseDetails {
  int? status;
  String? msg;

  ResponseDetails({
    this.status,
    this.msg,
  });

  ResponseDetails.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["msg"] = msg;
    return _data;
  }
}
