import 'package:bills_collector_mobile/model/bills.dart';
import 'package:bills_collector_mobile/screens/home_page.dart';
import 'package:bills_collector_mobile/screens/onboarding.dart';
import 'package:bills_collector_mobile/utils/MySharedPreferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/bill.dart';
import 'model/payment.dart';

bool _isDemoUsingDynamicColors = false;

const _brandBlue = Color(0xFF1E88E5);

CustomColors lightCustomColors = const CustomColors(danger: Color(0xFFE53935));
CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notFirstRun =
      await MySharedPreferences.instance.getBooleanValue("notFirstRun");
  runApp(MyApp(notFirstRun: notFirstRun));
}

class MyApp extends StatefulWidget {
  final bool notFirstRun;

  const MyApp({super.key, required this.notFirstRun});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
          lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          darkColorScheme = darkDynamic.harmonized();
          darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
          darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

          _isDemoUsingDynamicColors = true;
        } else {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: 'Bills Collector',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            extensions: [lightCustomColors],
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            extensions: [darkCustomColors],
          ),
          themeMode: ThemeMode.system,
          home: ChangeNotifierProvider(
                  create: (context) => Bills([
                        Bill(1, "Электричество", "comment", [
                          Payment(1, 100, DateTime(2024, 1, 1)),
                          Payment(2, 150, DateTime(2024, 2, 1)),
                          Payment(5, 125, DateTime(2024, 3, 1)),
                        ]),
                        Bill(2, "Газ", "comment2", [
                          Payment(3, 50, DateTime(2024, 3, 1)),
                          Payment(4, 25, DateTime(2024, 4, 5))
                        ])
                      ]),
                  child: widget.notFirstRun ? MyHomePage() : Onboarding()),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}
