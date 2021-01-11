import 'package:flutter/material.dart';
import 'package:pet_finder/app_them.dart';
import 'package:pet_finder/ui/auth/widgets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final String hintText;

  const RoundedPasswordField(
      {Key key, this.onChanged, this.hintText = 'Password', this.validator})
      : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: widget.validator,
        obscureText: _obscureText,
        enableSuggestions: false,
        autocorrect: false,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onChanged,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          fillColor: AppTheme.fillColor,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: _toggle,
            child: _obscureText
                ? Icon(
                    Icons.visibility,
                    color: Theme.of(context).primaryColor.withOpacity(.7),
                  )
                : Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).primaryColor.withOpacity(.7),
                  ),
          ),
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
}
