// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gameofthronesapp/logic/cubit/character_cubit.dart';
import 'package:gameofthronesapp/widgets/character_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CharacterCubit cubit = CharacterCubit.get(context);
    return CharacterListView(cubit: cubit);
  }
}
