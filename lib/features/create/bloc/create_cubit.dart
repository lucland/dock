import 'package:dockcheck_web/models/user.dart';
import 'package:dockcheck_web/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
part 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  final UserRepository userRepository;

  CreateCubit(this.userRepository) : super(CreateState());

  void validateForm({
    required String name,
    required String email,
    required String cpf,
    required String empresa,
    required String username,
    required String password,
    required String role,
  }) {
    final isFormValid = name.isNotEmpty &&
        email.isNotEmpty &&
        cpf.isNotEmpty &&
        empresa.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        role.isNotEmpty;

    emit(state.copyWith(isFormValid: isFormValid));
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String cpf,
    required String empresa,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));
      final User user = User(
        id: const Uuid().v4(),
        name: name,
        email: email,
        cpf: cpf,
        companyId: empresa,
        role: role,
        number: 0,
        bloodType: "O+",
        isBlocked: false,
        blockReason: "-",
        canCreate: true,
        username: username,
        salt: password,
        hash: "-",
        status: "active",
      );
      await userRepository.createUser(user);
      emit(CreateState(
          isFormValid: true,
          isLoading: false,
          canLogin:
              true)); // Reinicia o estado ao estado inicial, mas mantém isFormValid
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create user: $e',
      ));
    }
  }
}
