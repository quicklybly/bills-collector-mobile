import 'package:bills_collector_mobile/model/bill.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/bills_service.dart';

class EditBill extends StatefulWidget {
  const EditBill({super.key, required this.bill});

  final Bill bill;
  @override
  State<EditBill> createState() => _EditBillState();
}

class _EditBillState extends State<EditBill> {
  final typeController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void dispose() {
    typeController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    typeController.text = widget.bill.name;
    commentController.text = widget.bill.description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 4.0,
        title: Text('Редактирование услуги', style: Theme.of(context).textTheme.titleMedium,),
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
              // initialValue: widget.bill.type,
              controller: typeController,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Комментарий',
              ),
              // initialValue: widget.bill.comment,
              controller: commentController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            AuthService authService = AuthService();
            String? token = await authService.getToken();

            if (token != null) {
              BillsService billsService = BillsService();
              Bill updatedBill = await billsService.editBill(
                widget.bill.id,
                typeController.text,
                commentController.text,
                token,
              );

              setState(() {
                widget.bill.name = updatedBill.name;
                widget.bill.description = updatedBill.description;
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
              SnackBar(content: Text('Ошибка при редактировании счета: $e')),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
