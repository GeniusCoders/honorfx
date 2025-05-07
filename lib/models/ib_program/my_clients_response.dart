class MyClientsResponse {
  final int status;
  final String? msg;
  final List<ClientData>? data;

  MyClientsResponse({required this.status, this.msg, this.data});

  factory MyClientsResponse.fromJson(Map<String, dynamic> json) {
    return MyClientsResponse(
      status: json['status'] ?? 0,
      msg: json['msg'],
      data:
          json['data'] != null && json['data'] is List
              ? List<ClientData>.from(
                json['data'].map((x) => ClientData.fromJson(x)),
              )
              : null,
    );
  }
}

class ClientData {
  final String name;
  final String email;
  final String phone;
  final String mt5id;
  final String totalLots;
  final String totalComm;
  final String ibName;
  final String date;

  ClientData({
    required this.name,
    required this.email,
    required this.phone,
    required this.mt5id,
    required this.totalLots,
    required this.totalComm,
    required this.ibName,
    required this.date,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      mt5id: json['mt5id'] ?? '',
      totalLots: json['totallots'] ?? '0.00',
      totalComm: json['totalcomm'] ?? '0.00',
      ibName: json['ibname'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
