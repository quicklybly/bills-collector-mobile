import 'package:json_annotation/json_annotation.dart';

part 'usages.g.dart';

@JsonSerializable()
class Usages{
  Usages(this.id, this.usage, this.countDate, this.billId);

  int id;
  double usage;
  DateTime countDate;
  int billId;

  factory Usages.fromJson(Map<String, dynamic> json) {
    return Usages(
      json['id'],
      json['usage'],
      DateTime.parse(json['count_date']),
      json['bill_id'],
    );
  }

  Map<String, dynamic> toJson() => _$UsagesToJson(this);
}