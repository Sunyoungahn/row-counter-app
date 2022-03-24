import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:row_counter_app/screens/project_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row Counter',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.yellow[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow[50],
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ProjectListPage(),
      //const CounterPage(),
    );
  }
}
