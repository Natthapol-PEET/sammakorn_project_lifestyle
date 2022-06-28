class AccountModel {
  final int? id;
  final String? username;
  final String? password;
  final int? isLogin;
  final int? isRemember;

  const AccountModel({
    this.id,
    this.username,
    this.password,
    this.isLogin,
    this.isRemember,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'isLogin': isLogin,
      'isRemember': isRemember,
    };
  }

  @override
  String toString() {
    return 'Account{id: $id, username: $username, password: $password, isLogin: $isLogin, isRemember: $isRemember}';
  }
}
