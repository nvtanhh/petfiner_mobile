import 'package:flutter/material.dart';
import 'package:pet_finder/app_them.dart';
import 'package:pet_finder/ui/auth/widgets/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  final String initValue;

  final ValueChanged<String> validator;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.mail,
    this.onChanged,
    this.autofocus = false,
    this.initValue = '',
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: validator,
        initialValue: this.initValue,
        autofocus: this.autofocus,
        onChanged: onChanged,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          fillColor: AppTheme.fillColor,
          filled: true,
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }

  bool isEmail(String email) {
    RegExp regExp = new RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regExp.hasMatch(email);
  }
}
