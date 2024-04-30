import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bill.dart';
import '../model/bills.dart';
import '../model/payment.dart';
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
                  AppMetrica.reportEvent('To homepage without login');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => Bills([
                            Bill(1, "Электричество", "comment", [
                              Payment(1, 100, DateTime(2024, 1, 1)),
                              Payment(2, 150, DateTime(2024, 2, 1)),
                              Payment(5, 125, DateTime(2024, 3, 1)),
                            ]),
                            Bill(2, "Газ", "comment2", [
                              Payment(3, 50, DateTime(2024, 3, 1)),
                              Payment(4, 25, DateTime(2024, 4, 5))
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
            const SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_registrationFormKey.currentState!.validate()) {
                    // Process data.
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

