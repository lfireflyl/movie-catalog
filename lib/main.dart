import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'style/app_style.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
    await dotenv.load(fileName: "../.env");
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Каталог фильмов',
      theme: AppStyle.lightTheme(),
      home: HomePage(),
    );
  }
}
