import 'package:training_1/db/auth_login_service.dart';

class LoginService {
  String email;
  String password;
  String code;

  LoginService(this.email, this.password, this.code);

  bool notNull() {
    if (email.isEmpty || password.isEmpty || code.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool checkEmail() {
    if (email.contains('@') && email.contains('.')) {
      return true;
    } else {
      throw Exception("Email not correct");
    }
  }

  void checkPassword2() {
    if (password.length > 9) {
      throw Exception("the password must be 6 letters  or less");
    }
  }

  Future<bool> SendDataToLoginAutherSarver() async {
    AuthServiceLogin authServiceLogin = AuthServiceLogin(email, password, code);
    authServiceLogin.checkDB();

    bool result = await authServiceLogin.login();
    return result;
  }
}
