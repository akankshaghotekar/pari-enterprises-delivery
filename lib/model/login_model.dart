class LoginModel {
  final String userSrNo;
  final String name;

  LoginModel({required this.userSrNo, required this.name});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'][0];

    return LoginModel(userSrNo: data['usersrno'], name: data['name']);
  }
}
