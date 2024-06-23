import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bill.dart';
import '../model/bills.dart';
import '../model/usages.dart';
import '../services/auth_service.dart';
import '../utils/MySharedPreferences.dart';
import 'home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      final response = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (response != null && response.containsKey('access_token')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Вход успешен')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => Bills([
                Bill(1, "Электричество", "comment", [
                  Usages(1, 100, DateTime(2024, 1, 1)),
                  Usages(2, 150, DateTime(2024, 2, 1)),
                  Usages(5, 125, DateTime(2024, 3, 1)),
                ]),
                Bill(2, "Газ", "comment2", [
                  Usages(3, 50, DateTime(2024, 3, 1)),
                  Usages(4, 25, DateTime(2024, 4, 5))
                ])
              ]),
              child: MyHomePage(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Вход не удался')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Логин',
                hintText: 'Введите логин',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Введите что-нибудь';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Пароль',
                hintText: 'Введите пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Введите что-нибудь';
                }
                return null;
              },
            ),
            const SizedBox(height: 12,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  AppMetrica.reportEvent('Вход в приложение'); // todo поменять
                  if (_loginFormKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: const Text('Войти',),
              ),
            ),
          ],
        ),
      ),
    );
  }
}