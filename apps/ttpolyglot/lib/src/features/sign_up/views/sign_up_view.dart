import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_up/sign_up.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(
        child: Center(
          child: Text('Sign Up'),
        ),
      ),
    );
  }
}
