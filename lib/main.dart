// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gameofthronesapp/firebase_options.dart';

import 'package:gameofthronesapp/layout/login_page.dart';

import 'package:gameofthronesapp/logic/cubit/character_cubit.dart';
import 'package:gameofthronesapp/logic/cubit/character_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
  // تهيئة EasyLoading
  EasyLoading.init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterCubit()..getCharacter(),
      child: BlocConsumer<CharacterCubit, CharacterState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
            builder: EasyLoading.init(),
          );
        },
      ),
    );
  }
}
