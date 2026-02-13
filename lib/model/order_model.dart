class OrderModel {
  final String orderSrNo;
  final String orderDate;
  final String orderNo;
  final String amount;
  final String status;
  final String clientName;
  final String mobile;

  OrderModel({
    required this.orderSrNo,
    required this.orderDate,
    required this.orderNo,
    required this.amount,
    required this.status,
    required this.clientName,
    required this.mobile,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderSrNo: json['ordersrno'],
      orderDate: json['order_date'],
      orderNo: json['order_no'],
      amount: json['amount'],
      status: json['status'],
      clientName: json['client_name'],
      mobile: json['mobile'],
    );
  }
}
