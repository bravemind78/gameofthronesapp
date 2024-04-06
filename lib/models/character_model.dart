// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CharacterModel {
  int id;
  String firstName;
  String lastName;
  String fullName;
  String title;
  String family;
  String imageUrl;
  CharacterModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.title,
    required this.family,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'title': title,
      'family': family,
      'imageUrl': imageUrl,
    };
  }

  factory CharacterModel.fromMap(map) {
    return CharacterModel(
      id: map['id'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      fullName: map['fullName'] as String,
      title: map['title'] as String,
      family: map['family'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharacterModel.fromJson(String source) =>
      CharacterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
