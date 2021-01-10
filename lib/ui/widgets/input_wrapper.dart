import 'package:flutter/material.dart';

class InputContainerWrapper extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final int maxLines;
  final int type;

  final Function onTab;
  const InputContainerWrapper(
      {Key key,
      @required this.controller,
      @required this.title,
      this.maxLines = 1,
      this.type = 1,
      this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextField(
        onTap: onTab,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          // isDense: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
          ),
          labelText: title,
          labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
          // enabled: false
        ),
        style: TextStyle(fontSize: 14, color: Colors.black87),
        maxLines: maxLines,
        readOnly: type == 2 ? true : false,
      ),
    );
  }
}
