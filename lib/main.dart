import 'dart:io';

import 'package:flutter/material.dart';
import 'screens/home.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
       MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'home/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              default:
                return MaterialPageRoute(
                  builder: (context) {
                    switch (settings.name) {
                      case 'home/':
                        return const Home();
                      default:
                        return const Home();
                    }
                  },
                );
            }
          }
      ),
  );
}


