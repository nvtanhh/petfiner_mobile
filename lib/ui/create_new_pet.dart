import 'package:flutter/material.dart';

class CreateNewPet extends StatelessWidget {
  const CreateNewPet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Add new pet'),
      ),
    );
  }
}
