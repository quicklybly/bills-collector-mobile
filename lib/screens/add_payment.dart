import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bills_collector_mobile/model/usages.dart';
import 'package:flutter/material.dart';

import '../model/bill.dart';
import '../services/auth_service.dart';
import '../services/bills_service.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key, required this.bill});

  final Bill bill;

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final consumptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    consumptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 4.0,
        title: Text(
          'Добавление платежа',
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
                labelText: 'Расход',
              ),
              // initialValue: widget.bill.type,
              controller: consumptionController,
            ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Дата',
              ),
              readOnly: true,
              controller: dateController,
              onTap: () {
                _selectDate();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AppMetrica.reportEvent('Добавлен платеж');

          try {
            AuthService authService = AuthService();
            String? token = await authService.getToken();

            if (token != null) {
              BillsService billsService = BillsService();
              Usages newUsage = Usages(
                0,
                double.parse(consumptionController.text.replaceAll(",", "")),
                DateTime.parse(dateController.text),
                widget.bill.id,
              );

              Usages createdUsage = await billsService.createUsage(
                widget.bill.id,
                newUsage,
                token,
              );

              setState(() {
                widget.bill.usages.add(createdUsage);
              });

              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              // Handle the case where token is not available
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Не удалось получить токен')),
              );
            }
          } catch (e) {
            // Handle any errors that occur during the request
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка при создании расхода: $e')),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
