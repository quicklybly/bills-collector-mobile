import 'package:bills_collector_mobile/model/bill.dart';
import 'package:bills_collector_mobile/model/bills.dart';
import 'package:bills_collector_mobile/model/payment.dart';
import 'package:bills_collector_mobile/screens/AddNewBill.dart';
import 'package:bills_collector_mobile/screens/DetailPage.dart';
import 'package:bills_collector_mobile/screens/Onboarding.dart';
import 'package:bills_collector_mobile/utils/IconPicker.dart';
import 'package:flutter/material.dart';

final _test_data = Bills([
  Bill(1, "Электричество", "comment", [
    Payment(1, 100, DateTime(2024, 1, 1)),
    Payment(2, 150, DateTime(2024, 2, 1))
  ]),
  Bill(2, "Газ", "comment2", [
    Payment(3, 50, DateTime(2024, 3, 1)),
    Payment(4, 25, DateTime(2024, 4, 5))
  ])
]);

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double scrolledUnderElevation = 4.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surfaceContainer,
        scrolledUnderElevation: scrolledUnderElevation,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Onboarding()));
              },
              icon: Icon(Icons.adb))
        ],
        title: const Text(
          "Bills Collector",
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: theme.colorScheme.onSurface,
                ));
          },
        ),
      ),
      body: Container(
        color: theme.colorScheme.surface,
        child: GridView.builder(
          itemCount: _test_data.bills.length,
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final item = _test_data.bills[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(bill: item)));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            IconPicker().pick(item.type),
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.type,
                          style: theme.textTheme.titleSmall!.copyWith(
                              color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewBill(bills: _test_data)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

// var selectedIndex = 0;
//
// @override
// Widget build(BuildContext context) {
//
//   Widget page;
//   switch (selectedIndex) {
//     case 0:
//       page = GeneratorPage();
//       break;
//     case 1:
//       page = FavoritesPage();
//       break;
//     default:
//       throw UnimplementedError('no widget for $selectedIndex');
//   }
//
//   return LayoutBuilder(
//       builder: (context, constraints) {
//         return Scaffold(
//           body: Row(
//             children: [
//               SafeArea(
//                 child: NavigationRail(
//                   extended: constraints.maxWidth >= 600,
//                   destinations: [
//                     NavigationRailDestination(
//                       icon: Icon(Icons.home),
//                       label: Text('Home'),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.favorite),
//                       label: Text('Favorites'),
//                     ),
//                   ],
//                   selectedIndex: selectedIndex,
//                   onDestinationSelected: (value) {
//                     setState(() {
//                       selectedIndex = value;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   child: page,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//   );
// }
}
