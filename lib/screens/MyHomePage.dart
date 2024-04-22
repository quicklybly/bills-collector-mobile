import 'package:bills_collector_mobile/screens/Onboarding.dart';
import 'package:flutter/material.dart';

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
                  color: theme.colorScheme.onPrimary,
                ));
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Test")),
            Container(
              color: theme.colorScheme.surfaceContainer,
              child: Text("123"),
            ),
            Text("iosdjdajksskjldakjsldjklasljkdakljsdjkl")
          ],
        ),
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
