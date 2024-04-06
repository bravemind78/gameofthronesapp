// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gameofthronesapp/logic/cubit/character_cubit.dart';
import 'package:gameofthronesapp/widgets/character_card.dart';

class CharacterListView extends StatelessWidget {
  const CharacterListView({
    super.key,
    required this.cubit,
  });

  final CharacterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: cubit.searchController,
            onChanged: (value) {
              cubit.onSearchChanged(value);
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                hintText: "Search",
                constraints: BoxConstraints(maxHeight: 33),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(35.5)),
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => cubit.onSearch
                  ? CharacterCard(
                      characterModel: cubit.searchCharacterList[index],
                    )
                  : CharacterCard(
                      characterModel: cubit.characterList[index],
                    ),
              itemCount: cubit.onSearch
                  ? cubit.searchCharacterList.length
                  : cubit.characterList.length,
            ),
          ),
        ],
      ),
    );
  }
}
