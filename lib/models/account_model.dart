class AccountModel {
  final int id;
  final String username;
  final String password;
  final int isLogin;

  const AccountModel({
    this.id,
    this.username,
    this.password,
    this.isLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'isLogin': isLogin,
    };
  }

  @override
  String toString() {
    return 'Account{id: $id, username: $username, password: $password, isLogin: $isLogin}';
  }
}
