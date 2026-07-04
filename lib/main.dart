import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:i_bazaar/app_scroll_behavior.dart';
import 'package:i_bazaar/routers/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // can be decompiled anyway, cuz on assets, so uh...
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    publishableKey: dotenv.env["SUPABASE_PUBLISHABLE_KEY"],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      scrollBehavior: AppScrollBehavior(), // so that we can mouse-drag on linux/web

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF9E4EDD)),
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),

      routerConfig: router,
    );
  }
}
