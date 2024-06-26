import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bills_collector_mobile/screens/add_payment.dart';
import 'package:bills_collector_mobile/screens/edit_bill.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../model/bill.dart';
import '../model/bills.dart';
import '../model/usages.dart';
import '../services/auth_service.dart';
import '../services/bills_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.bill, required this.bills});

  final Bills bills;
  final Bill bill;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        scrolledUnderElevation: 4.0,
        title: Text(widget.bill.name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditBill(bill: widget.bill)));
              },
              icon: Icon(Icons.edit)),
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Удаление услуги'),
                content: const Text('Вы уверены, что хотите удалить услугу?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отменить'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        AuthService authService = AuthService();
                        String? token = await authService.getToken();

                        if (token != null) {
                          BillsService billsService = BillsService();
                          await billsService.deleteBill(widget.bill.id, token);

                          setState(() {
                            widget.bills.remove(widget.bill);
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
                          SnackBar(content: Text('Ошибка при удалении счета: $e')),
                        );
                      }
                    },
                    child: const Text('Да'),
                  ),
                ],
              ),
            ),
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Использование коммунальной услуги',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            widget.bill.usages.length < 3
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Слишком мало данных для графика',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : PaymentsChart(payments: widget.bill.usages),
            GestureDetector(
              onTap: () async {
                try {
                  AuthService authService = AuthService();
                  String? token = await authService.getToken();

                  if (token != null) {
                    BillsService billsService = BillsService();
                    String advice = await billsService.fetchAdvise(widget.bill.id, token);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Советы по потреблению'),
                        content: Text(advice),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              AppMetrica.reportEvent('Получена аналитика');
                              Navigator.pop(context);
                            },
                            child: const Text('Ок'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Handle the case where token is not available
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Не удалось получить токен')),
                    );
                  }
                } catch (e) {
                  // Handle any errors that occur during the request
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка при получении рекомендации: $e')),
                  );
                }
              },
              child: Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: const ListTile(
                  title: Text('Рекомендации по потреблению'),
                  subtitle: Text('(Нажми на меня)'),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('История платежей',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.bill.usages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(('Расход: ${widget.bill.usages[index].usage}')),
                    subtitle: Text(
                        'Дата учета: ${DateFormat.yMd().format(widget.bill.usages[index].countDate)}'),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPayment(bill: widget.bill)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PaymentsChart extends StatefulWidget {
  const PaymentsChart({super.key, required this.payments});

  final List<Usages> payments;

  @override
  State<PaymentsChart> createState() => _PaymentsChartState();
}

class _PaymentsChartState extends State<PaymentsChart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 8,
              left: 20,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
          DateFormat.MMM().format(widget.payments[value.toInt()].countDate)),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: ([
                  ...widget.payments.map((Usages payment) {
                    return payment.usage;
                  })
                ].average /
                3)
            .round()
            .toDouble(),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: ([
                      ...widget.payments.map((Usages payment) {
                        return payment.usage;
                      })
                    ].average /
                    3)
                .round()
                .toDouble(),
            reservedSize: 42,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            top: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      // minX: 0,
      // maxX: 11,
      minY: [
            ...widget.payments.map((Usages payment) {
              return payment.usage;
            })
          ].min *
          0.9,
      maxY: [
            ...widget.payments.map((Usages payment) {
              return payment.usage;
            })
          ].max *
          1.1,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < widget.payments.length; i++)
              FlSpot(i.toDouble(), widget.payments[i].usage)
          ],
          isCurved: true,
          barWidth: 0,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            color: Theme.of(context).colorScheme.primary,
            show: true,
          ),
        ),
      ],
    );
  }
}
