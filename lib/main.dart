import 'package:bills_collector_mobile/model/bills.dart';
import 'package:bills_collector_mobile/screens/final_page_with_login.dart';
import 'package:bills_collector_mobile/screens/home_page.dart';
import 'package:bills_collector_mobile/screens/onboarding.dart';
import 'package:bills_collector_mobile/services/auth_service.dart';
import 'package:bills_collector_mobile/services/bills_service.dart';
import 'package:bills_collector_mobile/utils/MySharedPreferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import 'model/bill.dart';
import 'model/usages.dart';

const _brandBlue = Color(0xFF1E88E5);

CustomColors lightCustomColors = const CustomColors(danger: Color(0xFFE53935));
CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String appmetrikaApiKey = dotenv.get('APPMETRIKA_API_KEY', fallback: '');
  AppMetrica.activate(AppMetricaConfig(appmetrikaApiKey));
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
        } else {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
            brightness: Brightness.dark,
          );
        }

        Future<List<Bill>> fetchInitialBills() async {
          AuthService authService = AuthService();
          String? token = await authService.getToken();
          if (token != null) {
            BillsService billsService = BillsService();
            return await billsService.fetchBills();
          } else {
            return [];
          }
        }

        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'),
          ],
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
          home: FutureBuilder<List<Bill>>(
            future: fetchInitialBills(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return ChangeNotifierProvider(
                  create: (context) => Bills(snapshot.data!),
                  child: Onboarding(),
                );
              } else if (snapshot.hasData) {
                return ChangeNotifierProvider(
                  create: (context) => Bills(snapshot.data!),
                  child: widget.notFirstRun ? MyHomePage() : Onboarding(),
                );
              } else {
                return Center(child: Text('No data available'));
              }
            }
          ),
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
