// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gameofthronesapp/layout/home_page.dart';
import 'package:gameofthronesapp/layout/login_page.dart';
import 'package:gameofthronesapp/logic/cubit/character_cubit.dart';
import 'package:gameofthronesapp/logic/cubit/character_state.dart';
import 'package:gameofthronesapp/widgets/default_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
/* -------------------------------------------------------------------------- */
/*                            VARIABLES DEFINITIONS                           */
/* -------------------------------------------------------------------------- */

  GlobalKey<FormState> formKey = GlobalKey();
/* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    CharacterCubit cubit = CharacterCubit.get(context);
    return BlocConsumer<CharacterCubit, CharacterState>(
      listener: (context, state) {
        if (state is RegisterUserAuthenticationLoadingState) {
          EasyLoading.show(status: "Loading...");
        } else if (state is RegisterUserAuthenticationSuceedState) {
          EasyLoading.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else if (state is RegisterUserAuthenticationFaliureState) {
          EasyLoading.dismiss();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('problem in Register User'),
              content: Text(cubit.loginErrorFairbase.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.of(context).pop(); // إغلاق الحوار
                  },
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  //height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          opacity: 0.4,
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/register.jpg",
                          ))),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Register",
                            style: TextStyle(
                                fontFamily: "Satisfy",
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            "assets/images/gameofthroneslogo.png",
                            width: 400,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          defaultFormField(
                              validate: (value) {
                                return cubit.validateRegisterFields(
                                    value,
                                    "Name should not be empty",
                                    cubit.nameRegisterController);
                              },
                              controller: cubit.nameRegisterController,
                              type: TextInputType.name,
                              prefix: Icons.person,
                              label: 'First Name',
                              hintText: "Full Name"),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                              validate: (value) {
                                return cubit.validateRegisterFields(
                                    value,
                                    "Email should not be empty",
                                    cubit.emailRegisterController);
                              },
                              controller: cubit.emailRegisterController,
                              type: TextInputType.emailAddress,
                              prefix: Icons.email,
                              label: 'Email',
                              hintText: "Email"),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                              validate: (value) {
                                return cubit.validateRegisterFields(
                                    value,
                                    "password should not be empty",
                                    cubit.passwordRegisterController);
                              },
                              onChange: (value) {
                                return cubit
                                    .changePasswordConditionColors(value);
                              },
                              isPassword: true,
                              controller: cubit.passwordRegisterController,
                              type: TextInputType.visiblePassword,
                              prefix: Icons.lock,
                              label: 'Password',
                              hintText: "Password"),
                          Text(
                            "- Passoword should not less than 8 characters",
                            style: TextStyle(
                                fontSize: 14,
                                color: cubit.passwordNumberLengthConditionColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            textAlign: TextAlign.left,
                            "- Passoword should contains one capital letter",
                            style: TextStyle(
                                fontSize: 14,
                                color: cubit.passwordCapitalConditionColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            textAlign: TextAlign.left,
                            "- Passoword should contains one Number        ",
                            style: TextStyle(
                                fontSize: 14,
                                color: cubit.passwordNumberConditionColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            "       - Password should contains one of these symbols(!@#\\\$'%^&*(),.?\":{}|<>)",
                            style: TextStyle(
                                fontSize: 14,
                                color: cubit.passwordSymbolConditionColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                              validate: (value) {
                                return cubit.validateRegisterFields(
                                    value,
                                    "Password should not be empty",
                                    cubit.retypepasswordRegisterController);
                              },
                              isPassword: true,
                              controller:
                                  cubit.retypepasswordRegisterController,
                              type: TextInputType.visiblePassword,
                              prefix: Icons.lock,
                              label: 'Password',
                              hintText: "RetypePassword"),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await cubit.registerUserAuthentication();
                                  cubit.clearRegisterFields();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(24, 25, 27, 1)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(12)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have account?",
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 50, 17, 15),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              MaterialButton(
                                  child: Text("Login",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 18, 55, 107),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  })
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}
