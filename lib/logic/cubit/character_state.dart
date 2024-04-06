abstract class CharacterState {}

final class CharacterInitial extends CharacterState {}

class CharacterLoadingDataState extends CharacterState {}

class CharacterLoadedSuccessfullyState extends CharacterState {}

class CharacterLoadedFailureState extends CharacterState {
  final String error;

  CharacterLoadedFailureState({required this.error});
}

class CharacterSearchedLoadedState extends CharacterState {}

class CharacterListStoreState extends CharacterState {}

class CharacterFamilyListLoadedState extends CharacterState {}

class ChangePasswordConditionColorsState extends CharacterState {}

class ClearDataInputState extends CharacterState {}

class RegisterUserAuthenticationLoadingState extends CharacterState {}

class RegisterUserAuthenticationSuceedState extends CharacterState {}

class RegisterUserAuthenticationFaliureState extends CharacterState {
  final String error;

  RegisterUserAuthenticationFaliureState({required this.error});
}

class LoginUserAuthenticationLoadingState extends CharacterState {}

class LoginUserAuthenticationSuceedState extends CharacterState {}

class LoginUserAuthenticationFaliureState extends CharacterState {
  final String error;

  LoginUserAuthenticationFaliureState({required this.error});
}
