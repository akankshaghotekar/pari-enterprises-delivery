class PickupRequestModel {
  final String pickupSrNo;
  final String pickupDate;
  final String pickupTime;
  final String services;
  final String userSrNo;
  final String? clientName;
  final String? mobile;
  final int orderGenerated;

  PickupRequestModel({
    required this.pickupSrNo,
    required this.pickupDate,
    required this.pickupTime,
    required this.services,
    required this.userSrNo,
    this.clientName,
    this.mobile,
    required this.orderGenerated,
  });

  factory PickupRequestModel.fromJson(Map<String, dynamic> json) {
    return PickupRequestModel(
      pickupSrNo: json['pickupsrno'],
      pickupDate: json['pickup_date'],
      pickupTime: json['pickup_time'],
      services: json['services'],
      userSrNo: json['usersrno'],
      clientName: json['client_name'],
      mobile: json['mobile'],
      orderGenerated: int.tryParse(json['order_generated'].toString()) ?? 0,
    );
  }
}
