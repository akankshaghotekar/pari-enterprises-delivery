class RemoveCartModel {
  final int status;
  final String message;

  RemoveCartModel({required this.status, required this.message});

  factory RemoveCartModel.fromJson(Map<String, dynamic> json) {
    return RemoveCartModel(status: json['status'], message: json['message']);
  }
}
