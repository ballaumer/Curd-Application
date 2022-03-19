import 'package:flutter/material.dart';
import 'package:fluttercrud/views/note_list.dart';
import 'package:get_it/get_it.dart';
import 'controller/notice_service.dart';



void setupLocator() {
   GetIt.I.registerLazySingleton(() => NoticeServices());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      home: NoteList(),
    );
  }
}

