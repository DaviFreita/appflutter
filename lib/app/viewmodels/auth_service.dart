import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  //Função Assícrona
  //Vai retornar no futuro uma String
  Future<void> register({
    required String name,
    required String cpf,
    required String password,
    required DateTime date,
    required String email,
  }) async {
    //criar user no Auth
    //ESTA ERRADO MUDARRRR
    final response, user;
    try {
      response = await supabase.auth.signUp(password: password, email: email);

      user = response.user;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    }

    if (user == null) {
      throw Exception('Erro ao criar usuário.');
    }
    //verifica se ja esta cadastrado
    try {
      //criar user no profile
      await supabase.from('users').insert({
        'id': user.id,
        'name': name,
        'cpf': cpf,
        'date': date.toIso8601String(),
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('CPF já cadastrado');
      }
      rethrow;
    }
  }

  Future<void> login({required String email, required String password})
  //usar async(assicrona) para usar o await(espere) porque vai demorar a requisição http
  async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Erro ao Logar usuário!');
    }
  }
}
