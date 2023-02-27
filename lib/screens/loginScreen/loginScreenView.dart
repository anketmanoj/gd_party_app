import 'package:flutter/material.dart';
import 'package:gd_party_app/services/Users/userController.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login-screen';
  final UserController userController = Get.put(UserController());

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 32.0),
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onChanged: (value) => userController.username.value = value,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  // Make the ui fancy
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) => userController.password.value = value,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    Get.snackbar(
                      'Error',
                      'Please enter your email and password',
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  userController.loginUser(
                    userController.username.value,
                    userController.password.value,
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
