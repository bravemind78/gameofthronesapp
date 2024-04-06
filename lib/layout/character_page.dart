// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gameofthronesapp/logic/cubit/character_cubit.dart';
import 'package:gameofthronesapp/logic/cubit/character_state.dart';
import 'package:gameofthronesapp/models/character_model.dart';
import 'package:gameofthronesapp/widgets/character_info_card.dart';
import 'package:gameofthronesapp/widgets/family_circle_avatar.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key, required this.characterModel});
  final CharacterModel characterModel;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharacterCubit, CharacterState>(
      listener: (context, state) {},
      builder: (context, state) {
        CharacterCubit cubit = CharacterCubit.get(context);
        cubit.getFamilyCharacter(characterModel.family);
        return Scaffold(
            appBar: AppBar(),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: CharacterInfoCard(
                  characterModel: characterModel,
                )),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return FamilyCircleAvatar(
                          characterModel: cubit.familyCharacterList[index],
                        );
                      },
                      itemCount: cubit.familyCharacterList.length,
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
