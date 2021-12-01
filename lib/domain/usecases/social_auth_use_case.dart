import 'package:Hercules/domain/repositories/auth_repository.dart';

class SocialAuthUseCase {
  final AuthRepository _authRepository;

  SocialAuthUseCase(AuthRepository authRepository) : _authRepository = authRepository;

  Future<bool> signInWithGoogle() async {
    return await _authRepository.signInWithGoogle();
  }

  Future<bool> signInWithFacebook() async {
    return await _authRepository.signInWithFacebook();
  }

  Future<bool> signInWithApple() async {
    return await _authRepository.signInWithApple();
  }
}