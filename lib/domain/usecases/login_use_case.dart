import 'package:Hercules/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(AuthRepository authRepository) : _authRepository = authRepository;

  Future<bool> signIn(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }

  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }
}