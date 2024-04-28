import 'package:bills_collector_mobile/model/bill.dart';
import 'package:bills_collector_mobile/model/bills.dart';
import 'package:bills_collector_mobile/model/payment.dart';
import 'package:bills_collector_mobile/screens/About.dart';
import 'package:bills_collector_mobile/screens/AddNewBill.dart';
import 'package:bills_collector_mobile/screens/DetailPage.dart';
import 'package:bills_collector_mobile/screens/Onboarding.dart';
import 'package:bills_collector_mobile/screens/final_page_with_login.dart';
import 'package:bills_collector_mobile/screens/registration_screen.dart';
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

class DrawerPoints {
  const DrawerPoints(this.label, this.icon, this.selectedIcon, this.screen);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget screen;
}

const List<DrawerPoints> destinations = <DrawerPoints>[
  DrawerPoints('Регистрация', Icon(Icons.account_circle_outlined),
      Icon(Icons.account_circle), RegistrationScreen()),
  DrawerPoints(
      'Логин', Icon(Icons.manage_accounts_outlined), Icon(Icons.manage_accounts), FinalPage()),
];

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double scrolledUnderElevation = 4.0;
    int screenIndex = -1;
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: theme.textTheme.bodyMedium,
                text: "Благодарим вас за выбор BillsCollector! Наше мобильное приложение поможет вам следить за своими счетами. На информационной странице представлен краткий обзор функций, включая отслеживание счетов, напоминания и аналитику. Контролируйте свои финансы с помощью Bill-Collector.\nGitHub: "),
            TextSpan(
                style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
                text: 'https://flutter.dev'),
            TextSpan(style: theme.textTheme.bodyMedium, text: '.'),
          ],
        ),
      ),
    ];

    void handleScreenChanged(int selectedScreen) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => destinations[selectedScreen].screen));
    }

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
              icon: const Icon(Icons.adb))
        ],
        title: Text(
          "Bills Collector",
          style: theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.onSurface),
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
      // todo вынести в отдельный файл
      drawer: NavigationDrawer(
        selectedIndex: screenIndex,
        onDestinationSelected: handleScreenChanged,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Bills Collector',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: theme.colorScheme.onSurface),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
          ...destinations.map(
            (DrawerPoints destination) {
              return NavigationDrawerDestination(
                label: Text(destination.label),
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationName: 'Bills Collector',
            applicationVersion: '0.1',
            applicationLegalese: '\u{a9} Bills Collector Team',
            applicationIcon: Image.asset('assets/icon_64.png'),
            aboutBoxChildren: aboutBoxChildren,
          )
        ],
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
}
