class CartItemModel {
  final String tempSrNo;
  final String subCategory;
  final int qty;
  final double rate;

  CartItemModel({
    required this.tempSrNo,
    required this.subCategory,
    required this.qty,
    required this.rate,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      tempSrNo: json['tempsrno'],
      subCategory: json['subcategory'],
      qty: int.parse(json['qty']),
      rate: double.parse(json['rate']),
    );
  }
}

class ViewCartResponse {
  final List<CartItemModel> items;
  final double total;

  ViewCartResponse({required this.items, required this.total});
}
