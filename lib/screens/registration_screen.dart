import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bill.dart';
import '../model/bills.dart';
import '../model/usages.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: theme.colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Регистрация",
                style: theme.textTheme.displaySmall!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const RegistrationForm(),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  AppMetrica.reportEvent('Продолжение без авторизации');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
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
                          child: MyHomePage())));
                },
                child: const Text(
                  "Продолжить без авторизации",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<StatefulWidget> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_registrationFormKey.currentState!.validate()) {
      final success = await _authService.register(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Регистрация успешна')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Регистрация не удалась')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _registrationFormKey,
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
            const SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  AppMetrica.reportEvent('Регистрация в приложении'); // todo
                  if (_registrationFormKey.currentState!.validate()) {
                    _register();
                  }
                },
                child: const Text('Зарегистрироваться',),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

