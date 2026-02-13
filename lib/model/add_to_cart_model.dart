class AddToCartModel {
  final int status;
  final String message;

  AddToCartModel({required this.status, required this.message});

  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return AddToCartModel(status: json['status'], message: json['message']);
  }
}
