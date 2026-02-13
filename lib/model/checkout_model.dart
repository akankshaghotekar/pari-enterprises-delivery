class CheckoutModel {
  final int status;
  final String message;

  CheckoutModel({required this.status, required this.message});

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(status: json['status'], message: json['message']);
  }
}
