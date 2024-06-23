import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bills_collector_mobile/model/bill.dart';
import 'package:flutter/material.dart';

import '../model/bills.dart';
import '../services/auth_service.dart';
import '../services/bills_service.dart';

class AddNewBill extends StatefulWidget {
  const AddNewBill({super.key, required this.bills});

  final Bills bills;

  @override
  State<AddNewBill> createState() => _AddNewBillState();
}

class _AddNewBillState extends State<AddNewBill> {
  final typeController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void dispose() {
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 4.0,
        title: Text('Добавление услуги'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Название услуги',
              ),
              controller: typeController,
            ),
            SizedBox(height: 12,),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Комментарий',
              ),
              controller: commentController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AppMetrica.reportEvent('Создана услуга');

          try {
            AuthService authService = AuthService();
            String? token = await authService.getToken();

            if (token != null) {
              BillsService billsService = BillsService();
              Bill newBill = await billsService.createBill(
                typeController.text,
                commentController.text,
                token,
              );

              setState(() {
                widget.bills.add(newBill);
              });

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Не удалось получить токен')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка при создании счета: $e')),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
