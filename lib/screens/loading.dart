import 'package:flutter/material.dart';
import 'package:shoe/custom_widgets.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 1.6,
                backgroundColor: btnColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Loading'),
            ],
          ),
        ),
      ),
    );
  }
}
