import 'package:bills_collector_mobile/model/usages.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

@JsonSerializable(explicitToJson: true)
class Bill extends ChangeNotifier {
  Bill(this.id, this.name, this.description, this.usages);

  int id;
  String name;
  String description;
  List<Usages> usages;

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      json['id'],
      json['name'],
      json['description'],
      [], // Usages should be fetched later
    );
  }
  Map<String, dynamic> toJson() => _$BillToJson(this);

  Bill edit(String type, String comment) {
    this.name = type;
    this.description = comment;
    return this;
  }

  void addPayment(Usages payment) {
    usages.add(payment);
    notifyListeners();
  }
}