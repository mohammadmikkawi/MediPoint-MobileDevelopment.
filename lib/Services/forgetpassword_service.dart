import 'package:training_1/db/auth_forgetpassword_service.dart';

class ForgetPasswordService {
  String emailFP;
  ForgetPasswordService(this.emailFP);

  void Cheked() {
    print(emailFP);
  }

  bool notNull() {
    if (emailFP.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool checkEmail() {
    if (emailFP.contains('@') && emailFP.contains('.')) {
      return true;
    } else {
      throw Exception("Email not correct");
    }
  }

  Future<bool> sendDt() async {
    AuthServiceForgetPassword authServiceForgetPassword =
        AuthServiceForgetPassword(emailFP);
    authServiceForgetPassword.emailAuth; //check

    return authServiceForgetPassword.sendRestData(); //send
  }
}
