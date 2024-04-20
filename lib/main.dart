import 'package:bills_collector_mobile/model/Bills.dart';
import 'package:bills_collector_mobile/screens/Onboarding.dart';
import 'package:bills_collector_mobile/utils/MySharedPreferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLaunch = false;

  _MyAppState() {
    MySharedPreferences.instance
        .getBooleanValue("notFirstRun")
        .then((value) => setState(() {
              isFirstLaunch = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return ChangeNotifierProvider(
        create: (context) => Bills(),
        child: MaterialApp(
          title: 'Bills Collector',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: isFirstLaunch ? MyHomePage() : Onboarding(),
        ),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Test")),
                Text("iosdjdajksskjldakjsldjklasljkdakljsdjkl")
              ],
            ),
          ),
        );
      }
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
