import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/screens/home_screen.dart';
import 'package:qrcode/screens/initialization_screen.dart';
import 'package:qrcode/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:qrcode/model/delegate_info.dart';
import 'package:qrcode/screens/subscribe_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'miscon_delegates.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE IF NOT EXISTS subscribers(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, username TEXT, email TEXT, image TEXT, checkinStatus INTEGER)',
      );
      return db.execute(
        'CREATE TABLE IF NOT EXISTS delegates(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, username TEXT, email TEXT, image TEXT, checkinStatus INTEGER)',
      );
    },
    version: 1,
  );

  Future<void> insertDelegate(DelegateInfo delegate) async {
    final db = await database;

    await db.insert(
      'delegates',
      delegate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> readCSVAndInsertToSQLite(List<List<dynamic>> csvData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasRunBefore = prefs.getBool('hasRunBefore') ?? false;

    if (!hasRunBefore) {
      List<List<dynamic>> csvTable = csvData;

      List<DelegateInfo> dataToInsert = [];
      for (var row in csvTable) {
        dataToInsert.add(DelegateInfo(
          id: row[0],
          fname: row[1],
          lname: row[2],
          username: row[3],
          email: row[4],
          image: row[5],
          checkinStatus: row[6],
        ));
      }
      for (var data in dataToInsert) {
        insertDelegate(data);
      }

      print('This code runs only once on application installation.');

      await prefs.setBool('hasRunBefore', true);
    }
  }

  String csvString = await rootBundle.loadString('assets/delegates.csv');
  List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

  await readCSVAndInsertToSQLite(csvTable);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VExpo QR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/init', page: () => InitializationScreen()),
        GetPage(name: '/login', page: () => const LogInScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/subscribe', page: () => const SubscribeScreen()),
      ],
      initialRoute: '/home',
    );
  }
}
