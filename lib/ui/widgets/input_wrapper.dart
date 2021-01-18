import 'package:flutter/material.dart';

class InputContainerWrapper extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final int maxLines;
  final Function onTab;
  final Widget prefix;
  final bool isReadOnly;

  final TextInputType keyboardType;
  const InputContainerWrapper(
      {Key key,
      @required this.controller,
      @required this.title,
      this.maxLines = 1,
      this.onTab,
      this.prefix,
      this.isReadOnly = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: TextField(
        keyboardType: keyboardType,
        onTap: onTab,
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
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
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
          prefix: prefix ?? null,
          // enabled: false
        ),
        style: TextStyle(fontSize: 14, color: Colors.black87),
        maxLines: maxLines,
        readOnly: isReadOnly,
      ),
    );
  }
}
