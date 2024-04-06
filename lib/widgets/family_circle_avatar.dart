// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:gameofthronesapp/layout/character_page.dart';
import 'package:gameofthronesapp/models/character_model.dart';

class FamilyCircleAvatar extends StatelessWidget {
  const FamilyCircleAvatar({super.key, required this.characterModel});
  final CharacterModel characterModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 110,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CharacterPage(characterModel: characterModel)));
          },
          child: CircleAvatar(
            radius: 65,
            backgroundImage: NetworkImage(
              characterModel.imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
