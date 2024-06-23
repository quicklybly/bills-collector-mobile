import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bills_collector_mobile/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bill.dart';
import '../model/bills.dart';
import '../model/usages.dart';
import '../utils/MySharedPreferences.dart';
import 'home_page.dart';
import 'login_screen.dart';

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
                  Navigator.pushReplacement(
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



