import 'package:bills_collector_mobile/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../utils/MySharedPreferences.dart';
import 'MyHomePage.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  _FinalPageState() {
    MySharedPreferences.instance.setBooleanValue("notFirstRun", true);
  }

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
                "Авторизация",
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const LoginForm(),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()));
                },
                child: const Text(
                  "Зарегистрироваться",
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
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

// todo вынести в отдельный класс все же

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

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
                  if (_loginFormKey.currentState!.validate()) {
                    // Process data.
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
