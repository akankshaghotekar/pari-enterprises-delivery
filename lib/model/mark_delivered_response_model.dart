class MarkDeliveredResponse {
  final String billNo;
  final String deliveryDate;
  final String message;

  MarkDeliveredResponse({
    required this.billNo,
    required this.deliveryDate,
    required this.message,
  });

  factory MarkDeliveredResponse.fromJson(Map<String, dynamic> json) {
    return MarkDeliveredResponse(
      billNo: json['billno']?.toString() ?? "",
      deliveryDate: json['delivery_date']?.toString() ?? "",
      message: json['message']?.toString() ?? "",
    );
  }
}
