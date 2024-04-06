// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gameofthronesapp/models/character_model.dart';

import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit() : super(CharacterInitial());
  static CharacterCubit get(context) => BlocProvider.of(context);
  List<CharacterModel> characterList = [];
  List<CharacterModel> searchCharacterList = [];
  List<CharacterModel> familyCharacterList = [];
  bool onSearch = false;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  TextEditingController nameRegisterController = TextEditingController();
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  TextEditingController retypepasswordRegisterController =
      TextEditingController();
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  Color passwordNumberLengthConditionColor =
      const Color.fromARGB(255, 50, 17, 15);
  Color passwordCapitalConditionColor = const Color.fromARGB(255, 50, 17, 15);
  Color passwordNumberConditionColor = const Color.fromARGB(255, 50, 17, 15);
  Color passwordSymbolConditionColor = const Color.fromARGB(255, 50, 17, 15);
  UserCredential? user;
  User? currentUser;
  bool loginSucceed = false;
  String? loginErrorFairbase;
  /* -------------------------------------------------------------------------- */
  /*                            FUNCTION DEFINITIONS                            */
  /* -------------------------------------------------------------------------- */
  /* ------------------------- GET CHARACTER FUNCTION ------------------------- */
  Future getCharacter() async {
    try {
      var response =
          await Dio().get("https://thronesapi.com/api/v2/Characters");
      List jsonList = response.data;
      for (var element in jsonList) {
        characterList.add(CharacterModel.fromMap(element));
      }
      emit(CharacterLoadedSuccessfullyState());
      return characterList;
    } catch (error) {
      emit(CharacterLoadedFailureState(error: error.toString()));
    }
  }

/* -------------------- GET SEARCHED CHARACTERS FUNCTION -------------------- */
  List<CharacterModel> searchCharacter(String searchText) {
    searchCharacterList.clear();
    if (searchText.isNotEmpty) {
      onSearch = true;
      for (var element in characterList) {
        if (element.fullName
            .toLowerCase()
            .startsWith(searchText.toLowerCase())) {
          searchCharacterList.add(element);
        }
      }
      emit(CharacterSearchedLoadedState());
      return searchCharacterList;
    } else {
      onSearch = false;
      emit(CharacterListStoreState());
      return characterList;
    }
  }

  /* --------------------- GET FAMILY CHARACTERS FUNCTION --------------------- */
  List<CharacterModel> getFamilyCharacter(String family) {
    familyCharacterList.clear();
    for (var element in characterList) {
      if (element.family == family) {
        familyCharacterList.add(element);
      }
    }
    emit(CharacterFamilyListLoadedState());
    return familyCharacterList;
  }

/* ------------- TIMER FUNCTION FOR GETTING SEARCHED CHARACTERS ------------- */
  void onSearchChanged(String searchText) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(microseconds: 700), () {
      searchCharacter(searchText);
    });
  }

  /* ----------------------------- VALIDATION REGISTER FORM ---------------------------- */
  String? validateRegisterFields(value, String message, controller) {
    if (value.isEmpty) {
      return message;
    } else if (controller == retypepasswordRegisterController &&
        passwordRegisterController.text !=
            retypepasswordRegisterController.text) {
      return "password did not match";
    } else if (controller == passwordRegisterController &&
        passwordRegisterController.text !=
            retypepasswordRegisterController.text) {
      return "password did not match";
    } else if (controller == passwordRegisterController &&
        passwordRegisterController.text.length < 8) {
      return "password should be at least 8 characters";
    } else if (controller == passwordRegisterController) {
      bool symbolChecker =
          validateSymbolAndCapitalAndNumberPassword(controller.text);
      if (symbolChecker == false) {
        print("the symbol checker=$symbolChecker");
        return "password should be at least one capital letter,number,special symbol";
      }
    }
    return null;
  }

  /* --------------------------- CLEAR REGISTER FORM -------------------------- */
  void clearRegisterFields() {
    nameRegisterController.clear();
    emailRegisterController.clear();
    passwordRegisterController.clear();
    retypepasswordRegisterController.clear();
    passwordNumberLengthConditionColor = const Color.fromARGB(255, 50, 17, 15);
    passwordCapitalConditionColor = const Color.fromARGB(255, 50, 17, 15);
    passwordNumberConditionColor = const Color.fromARGB(255, 50, 17, 15);
    passwordSymbolConditionColor = const Color.fromARGB(255, 50, 17, 15);
    emit(ClearDataInputState());
  }

  /* ---------------------------- CLEAR LOGIN FORM ---------------------------- */
  void clearLoginFields() {
    emailLoginController.clear();
    passwordLoginController.clear();
  }

  /* -------------------- CHANGE PASSWORD CONDITIONS COLORS ------------------- */
  void changePasswordConditionColors(String value) {
    Color newNumberLengthColor = passwordNumberLengthConditionColor;
    Color neCapitalColor = passwordCapitalConditionColor;
    Color newNumberColor = passwordNumberConditionColor;
    Color newSymbolColor = passwordSymbolConditionColor;
    bool capitalPassword = validateCapitalPassword(value);
    bool numberPassword = validateNumberPassword(value);
    bool symbolPassword = validateSymbolPassword(value);
    if (value.length > 7) {
      newNumberLengthColor = const Color.fromARGB(255, 19, 84, 21);
    } else {
      newNumberLengthColor = const Color.fromARGB(255, 50, 17, 15);
    }
    if (capitalPassword == true) {
      neCapitalColor = const Color.fromARGB(255, 19, 84, 21);
    } else {
      neCapitalColor = const Color.fromARGB(255, 50, 17, 15);
    }
    if (numberPassword == true) {
      newNumberColor = const Color.fromARGB(255, 19, 84, 21);
    } else {
      newNumberColor = const Color.fromARGB(255, 50, 17, 15);
    }
    if (symbolPassword == true) {
      newSymbolColor = const Color.fromARGB(255, 19, 84, 21);
    } else {
      newSymbolColor = const Color.fromARGB(255, 50, 17, 15);
    }
    /////////////////////////////////////////////////////////////////
    if (newNumberLengthColor != passwordNumberLengthConditionColor) {
      passwordNumberLengthConditionColor = newNumberLengthColor;
      Timer(Duration(milliseconds: 10000), () {
        emit(ChangePasswordConditionColorsState());
      });
    }

    if (neCapitalColor != passwordCapitalConditionColor) {
      passwordCapitalConditionColor = neCapitalColor;
      Timer(Duration(milliseconds: 10000), () {
        emit(ChangePasswordConditionColorsState());
      });
    }

    if (newNumberColor != passwordNumberConditionColor) {
      passwordNumberConditionColor = newNumberColor;
      Timer(Duration(milliseconds: 10000), () {
        emit(ChangePasswordConditionColorsState());
      });
    }

    if (newSymbolColor != passwordSymbolConditionColor) {
      passwordSymbolConditionColor = newSymbolColor;
      Timer(Duration(milliseconds: 10000), () {
        emit(ChangePasswordConditionColorsState());
      });
    }
  }
/* ------------------ VALIDATE SYMBOL,CAPITAL AND NUMBER PASSWORD CONDITIONS ------------------ */

  bool validateSymbolAndCapitalAndNumberPassword(String password) {
    // التحقق من وجود حرف كبير
    Pattern patternUpperCase = r'[A-Z]';
    RegExp regexUpperCase = RegExp(patternUpperCase.toString());

    // التحقق من وجود رمز خاص
    Pattern patternSpecialCharacter = r'[!@#$%^&*(),.?":{}|<>]';
    RegExp regexSpecialCharacter = RegExp(patternSpecialCharacter.toString());

    // التحقق من وجود رقم
    Pattern patternDigit = r'\d';
    RegExp regexDigit = RegExp(patternDigit.toString());

    // تحقق إذا كانت كلمة المرور تلبي جميع الشروط
    if (regexUpperCase.hasMatch(password) &&
        regexSpecialCharacter.hasMatch(password) &&
        regexDigit.hasMatch(password)) {
      // صحيح إذا تم تلبية جميع الشروط
      return true;
    } else {
      // خطأ إذا لم يتم تلبية واحدة أو أكثر من الشروط
      return false;
    }
  }

  /* ---------------- VALIDATE JUST PASSWORD CONTAINS ONE CAPITAL LETTER---------------- */
  validateCapitalPassword(String password) {
    // التحقق من وجود حرف كبير
    Pattern patternUpperCase = r'[A-Z]';
    RegExp regexUpperCase = RegExp(patternUpperCase.toString());
    if (regexUpperCase.hasMatch(password)) {
      // صحيح إذا تم تلبية جميع الشروط
      return true;
    } else {
      // خطأ إذا لم يتم تلبية واحدة أو أكثر من الشروط
      return false;
    }
  }

  /* --------------- VALIDATE JUST PASSWORD CONTAINS ONE NUMBER --------------- */
  validateNumberPassword(String password) {
    // التحقق من وجود رقم
    Pattern patternDigit = r'\d';
    RegExp regexDigit = RegExp(patternDigit.toString());

    // تحقق إذا كانت كلمة المرور تلبي جميع الشروط
    if (regexDigit.hasMatch(password)) {
      // صحيح إذا تم تلبية جميع الشروط
      return true;
    } else {
      // خطأ إذا لم يتم تلبية واحدة أو أكثر من الشروط
      return false;
    }
  }

  /* --------------- VALIDATE JUST PASSWORD CONTAINS ONE SYMBOL --------------- */
  validateSymbolPassword(String password) {
    // التحقق من وجود رمز خاص
    Pattern patternSpecialCharacter = r'[!@#$%^&*(),.?":{}|<>]';
    RegExp regexSpecialCharacter = RegExp(patternSpecialCharacter.toString());
    // تحقق إذا كانت كلمة المرور تلبي جميع الشروط
    if (regexSpecialCharacter.hasMatch(password)) {
      // صحيح إذا تم تلبية جميع الشروط
      return true;
    } else {
      // خطأ إذا لم يتم تلبية واحدة أو أكثر من الشروط
      return false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                             FIRE BASE FUNCTIONS                            */
  /* -------------------------------------------------------------------------- */
  /* ------------------------- AUTHENTICATION Register FUNCTION ------------------------ */
  Future registerUserAuthentication() async {
    try {
      emit(RegisterUserAuthenticationLoadingState());
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailRegisterController.text,
              password: passwordRegisterController.text)
          .then((value) {
        emit(RegisterUserAuthenticationSuceedState());
        return user;
      });
    } catch (error) {
      emit(RegisterUserAuthenticationFaliureState(error: error.toString()));
    }
  }

  /* ---------------------- LOGIN AUTHENTICATION FUNCTION --------------------- */
  Future loginUserAuthentication() async {
    emit(LoginUserAuthenticationLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailLoginController.text,
            password: passwordLoginController.text)
        .then((value) {
      //currentUser = value.user;
      loginSucceed = true;
      emit(LoginUserAuthenticationSuceedState());
    }).catchError((onError) {
      loginErrorFairbase = handleAuthError(onError);
      emit(LoginUserAuthenticationFaliureState(error: onError.toString()));
    });
  }

  /* ------------- HANDLING ERRORS FROM LOGIN IN FIREBASE DATABASE ------------ */
  String handleAuthError(FirebaseAuthException e) {
    print(e.code); // للتصحيح ومعرفة نوع الخطأ
    switch (e.code) {
      case 'invalid-email':
        return 'Email is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'The user was not found in this email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'email-already-in-use':
        return 'Email is already used by another account.';
      case 'operation-not-allowed':
        return 'The process is not allowed.';
      case 'weak-password':
        return 'The password is very weak.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
