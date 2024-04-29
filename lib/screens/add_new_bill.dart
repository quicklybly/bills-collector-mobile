import 'package:bills_collector_mobile/model/bill.dart';
import 'package:flutter/material.dart';

import '../model/bills.dart';

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
        onPressed: () {
          widget.bills.add(Bill(99, typeController.text,
              '${commentController.text}', []));
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
