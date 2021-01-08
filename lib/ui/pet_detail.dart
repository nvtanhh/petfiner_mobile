import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';

class PetDetail extends StatelessWidget {
  final Pet pet;

  const PetDetail(this.pet, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Pet detail'),
    );
  }
}
