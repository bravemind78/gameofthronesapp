// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, must_be_immutable, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gameofthronesapp/layout/home_page.dart';
import 'package:gameofthronesapp/layout/register_page.dart';
import 'package:gameofthronesapp/logic/cubit/character_cubit.dart';
import 'package:gameofthronesapp/logic/cubit/character_state.dart';
import 'package:gameofthronesapp/widgets/default_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    CharacterCubit cubit = CharacterCubit.get(context);
    return BlocConsumer<CharacterCubit, CharacterState>(
      listener: (context, state) {
        if (state is LoginUserAuthenticationLoadingState) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is LoginUserAuthenticationSuceedState) {
          EasyLoading.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else if (state is LoginUserAuthenticationFaliureState) {
          EasyLoading.dismiss();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('problem in login'),
              content:
                  Text('The login process failed. ${cubit.loginErrorFairbase}'),
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
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.4,
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/register.jpg",
                    ))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "Login",
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
                                  "Email should not be empty",
                                  cubit.emailLoginController);
                            },
                            controller: cubit.emailLoginController,
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
                                  cubit.passwordLoginController);
                            },
                            isPassword: true,
                            controller: cubit.passwordLoginController,
                            type: TextInputType.visiblePassword,
                            prefix: Icons.lock,
                            label: 'Password',
                            hintText: "Password"),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await cubit.loginUserAuthentication();
                                cubit.clearLoginFields();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(24, 25, 27, 1)),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(12)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                            ),
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "do not have an account?",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 5, 35, 60),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
