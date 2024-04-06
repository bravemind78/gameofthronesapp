// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gameofthronesapp/models/character_model.dart';

class CharacterInfoCard extends StatelessWidget {
  const CharacterInfoCard({super.key, required this.characterModel});
  final CharacterModel characterModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          color: Colors.black,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                characterModel.fullName,
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Satisfy",
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Image.network(characterModel.imageUrl),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                Text(
                  "First Name :",
                  style: TextStyle(
                      fontFamily: "Satisfy",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  characterModel.firstName,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Text(
                  "Second Name :",
                  style: TextStyle(
                      fontFamily: "Satisfy",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  characterModel.lastName,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Text(
                  "Full Name :",
                  style: TextStyle(
                      fontFamily: "Satisfy",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  characterModel.fullName,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Text(
                  "Title :",
                  style: TextStyle(
                      fontFamily: "Satisfy",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    characterModel.title,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Text(
                  "Family :",
                  style: TextStyle(
                      fontFamily: "Satisfy",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  characterModel.family,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ]),
            ],
          )),
    );
  }
}
