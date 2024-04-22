import 'package:bills_collector_mobile/model/payment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bill.g.dart';

@JsonSerializable(explicitToJson: true)
class Bill {
  Bill(this.id, this.type, this.comment, this.payments);

  int id;
  String type;
  String comment;
  List<Payment> payments;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);


  Map<String, dynamic> toJson() => _$BillToJson(this);
}