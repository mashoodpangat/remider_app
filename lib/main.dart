import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:remider_app/homesamples.dart';
import 'package:remider_app/providerPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderPage(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CalendarScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
