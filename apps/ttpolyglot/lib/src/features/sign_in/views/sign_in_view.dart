import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_in/sign_in.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(
        child: Center(
          child: Text('Sign In'),
        ),
      ),
    );
  }
}
