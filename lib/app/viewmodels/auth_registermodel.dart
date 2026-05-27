import 'package:appflutter/app/model/user_model.dart';

class AuthRegistermodel {
  Future<void> register({
    required String name,
    required String cpf,
    required String password,
    required DateTime date,
  }) async {
    UserModel user = UserModel(
      id: DateTime.now().toString(),
      name: name,
      cpf: cpf,
      password: password,
      date: date,
    );

    print(user.toJson());
  }
}
