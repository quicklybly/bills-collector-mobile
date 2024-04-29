import 'package:bills_collector_mobile/model/payment.dart';
import 'package:flutter/material.dart';

import '../model/bill.dart';

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
        onPressed: () {
          widget.bill.payments.add(Payment(
              101,
              double.parse(consumptionController.text.replaceAll(",", "")),
              DateTime.parse(dateController.text)));
          // Navigator.pop(context);
          Navigator.of(context).popUntil(
              (route) => route.isFirst); // todo баг при isFirstRun == true
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
