import 'package:bills_collector_mobile/model/bill.dart';
import 'package:flutter/material.dart';

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
    typeController.text = widget.bill.type;
    commentController.text = widget.bill.comment;

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
        onPressed: () {
          widget.bill.edit(typeController.text, commentController.text);
          Navigator.of(context).popUntil((route) => route
              .isFirst); // todo баг при isFirstRun == true
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
