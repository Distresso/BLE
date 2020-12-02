import 'package:distressoble/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String text;

  const CustomButton({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '$text',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              color: secondaryButtonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            ),
          ),
        ],
      ),
    );
  }
}
