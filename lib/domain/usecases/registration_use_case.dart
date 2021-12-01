import 'package:Hercules/domain/repositories/auth_repository.dart';

class RegistrationUseCase {
  final AuthRepository _authRepository;

  RegistrationUseCase(AuthRepository authRepository) : _authRepository = authRepository;

  Future<bool> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }
}