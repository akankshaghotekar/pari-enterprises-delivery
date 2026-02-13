class OrderDetailModel {
  final String subCategory;
  final double qty;
  final double originalRate;
  final double amount;

  OrderDetailModel({
    required this.subCategory,
    required this.qty,
    required this.originalRate,
    required this.amount,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      subCategory: json['subcategory'],
      qty: double.tryParse(json['qty'].toString()) ?? 0,
      originalRate: double.tryParse(json['original_rate'].toString()) ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0,
    );
  }
}
