import 'package:distressoble/constants/colors.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback _onPressed;

  RegisterButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RaisedButton(
        color: secondaryButtonColor,
        splashColor: secondaryButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: _onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Next', style: TextStyle(color: Colors.white),),
        ),
      ),
    );

  }
}
