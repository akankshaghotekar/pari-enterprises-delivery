class LaundryCategoryModel {
  final String laundrySrNo;
  final String laundry;

  LaundryCategoryModel({required this.laundrySrNo, required this.laundry});

  factory LaundryCategoryModel.fromJson(Map<String, dynamic> json) {
    return LaundryCategoryModel(
      laundrySrNo: json['laundry_srno'],
      laundry: json['laundry'],
    );
  }
}
