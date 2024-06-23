import 'package:bills_collector_mobile/model/bill.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bills.g.dart';

@JsonSerializable(explicitToJson: true)
class Bills extends ChangeNotifier {
  Bills(this.bills);

  List<Bill> bills;

  factory Bills.fromJson(List<dynamic> parsedJson) {
    return Bills(
      parsedJson.map((i) => Bill.fromJson(i)).toList(),
    );
  }
  Map<String, dynamic> toJson() => _$BillsToJson(this);

  void add(Bill bill) {
    bills.add(bill);
    notifyListeners();
  }

  void editBill(Bill bill, String type, String comment) {
    int index = bills.indexOf(bill);
    bills[index].edit(type, comment);
    bills.replaceRange(index, index + 1, [bill]);
    notifyListeners();
  }


  void remove(Bill bill) {
    bills.remove(bill);
    notifyListeners();
  }
}