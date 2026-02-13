class DropRequestModel {
  final String billSrNo;
  final String billDate;
  final String billNo;
  final String? clientName;
  final String? mobile;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? area;
  final String? pincode;
  final String amount;
  final String deliveryDate;

  DropRequestModel({
    required this.billSrNo,
    required this.billDate,
    required this.billNo,
    this.clientName,
    this.mobile,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.area,
    this.pincode,
    required this.amount,
    required this.deliveryDate,
  });

  factory DropRequestModel.fromJson(Map<String, dynamic> json) {
    return DropRequestModel(
      billSrNo: json['bill_srno'].toString(),
      billDate: json['bill_date'].toString(),
      billNo: json['bill_no'].toString(),
      clientName: json['client_name'],
      mobile: json['mobile'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      state: json['state'],
      area: json['area'],
      pincode: json['pincode'],
      amount: json['amount'].toString(),
      deliveryDate: json['delivery_date'].toString(),
    );
  }
}
