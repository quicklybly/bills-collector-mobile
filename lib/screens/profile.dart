import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final loginController = TextEditingController();
  final passwordOldController = TextEditingController();
  final passwordNewController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordNewController.dispose();
    passwordNewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginController.text = "john_doe";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 4.0,
        title: Text(
          'Профиль и редактирование',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Логин',
              ),
              // initialValue: widget.bill.type,
              controller: loginController,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Старый пароль',
              ),
              // initialValue: widget.bill.comment,
              controller: passwordOldController,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Новый пароль',
              ),
              // initialValue: widget.bill.comment,
              controller: passwordNewController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Допустим, изменения сохранены')));
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
