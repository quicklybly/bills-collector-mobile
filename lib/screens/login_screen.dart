import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bills_collector_mobile/services/bills_service.dart';
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

        BillsService billsService = BillsService();
        List<Bill> bills = await billsService.fetchBills();

        if (bills != null) {
          // Navigate to the home page with fetched bills
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => Bills(bills),
                child: MyHomePage(),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не удалось загрузить данные')),
          );
        }
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