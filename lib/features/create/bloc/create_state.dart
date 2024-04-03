part of 'create_cubit.dart';

class CreateState {
  final bool isLoading;
  final bool isFormValid;
  final bool canLogin;
  final String? errorMessage;

  CreateState({
    this.isLoading = false,
    this.isFormValid = false,
    this.canLogin = false,
    this.errorMessage,
  });

  // Métodos para facilitar a criação de novos estados
  CreateState copyWith({
    bool? isLoading,
    bool? isFormValid,
    String? errorMessage,
  }) {
    return CreateState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
