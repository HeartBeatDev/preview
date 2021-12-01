import 'package:Hercules/domain/repositories/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource _source;

  AuthRepositoryImpl(AuthRemoteDataSource source) : _source = source;

  @override
  Future<bool> signIn(String email, String password) async {
    final user = await _source.signIn(email, password);
    return user != null;
  }

  @override
  Future<bool> signUp(String email, String password) async {
    final user = await _source.signUp(email, password);
    return user != null;
  }

  @override
  Future<bool> signInWithGoogle() async {
    final user = await _source.signInWithGoogle();
    return user != null;
  }

  @override
  Future<bool> signInWithFacebook() async {
    final user = await _source.signInWithFacebook();
    return user != null;
  }

  @override
  Future<bool> signInWithApple() async {
    final user = await _source.signInWithApple();
    return user != null;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _source.resetPassword(email);
  }
}