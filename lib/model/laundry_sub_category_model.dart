class LaundrySubCategoryModel {
  final String subCategorySrNo;
  final String subCategory;

  LaundrySubCategoryModel({
    required this.subCategorySrNo,
    required this.subCategory,
  });

  factory LaundrySubCategoryModel.fromJson(Map<String, dynamic> json) {
    return LaundrySubCategoryModel(
      subCategorySrNo: json['laundry_subcategory_srno'],
      subCategory: json['subcategory'],
    );
  }
}
