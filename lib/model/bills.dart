import 'package:bills_collector_mobile/model/bill.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bills.g.dart';

@JsonSerializable(explicitToJson: true)
class Bills {
  Bills(this.bills);

  List<Bill> bills;

  factory Bills.fromJson(Map<String, dynamic> json) => _$BillsFromJson(json);

  Map<String, dynamic> toJson() => _$BillsToJson(this);
}