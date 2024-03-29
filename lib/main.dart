import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeucpcm/screens/dashboard.dart';
import 'package:zeucpcm/screens/home_screen.dart';
import 'package:zeucpcm/screens/initialization_screen.dart';
import 'package:zeucpcm/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:zeucpcm/model/delegate_info.dart';
import 'package:zeucpcm/screens/subscribe_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'miscon_delegates.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE IF NOT EXISTS subscribers(id TEXT PRIMARY KEY, title TEXT, institute TEXT, username TEXT, selectedRoom TEXT, image TEXT, checkinStatus TEXT)',
      );

      db.execute(
        'CREATE TABLE IF NOT EXISTS canteen(id TEXT PRIMARY KEY, username TEXT, mealName TEXT, checkinStatus TEXT)',
      );

      return db.execute(
        'CREATE TABLE IF NOT EXISTS delegates(id TEXT PRIMARY KEY, title TEXT, institute TEXT, username TEXT, selectedRoom TEXT, image TEXT, checkinStatus TEXT)',
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

  // Future<void> readCSVAndInsertToSQLite(List<List<dynamic>> csvData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool hasRunBefore = prefs.getBool('hasRunBefore') ?? false;

  //   if (!hasRunBefore) {
  //     List<List<dynamic>> csvTable = csvData;

  //     List<DelegateInfo> dataToInsert = [];
  //     for (var row in csvTable) {
  //       dataToInsert.add(DelegateInfo(
  //         id: row[0],
  //         title: row[1],
  //         institute: row[2],
  //         username: row[3],
  //         selectedRoom: row[4],
  //         checkinStatus: row[5],
  //       ));
  //     }
  //     for (var data in dataToInsert) {
  //       insertDelegate(data);
  //     }

  //     print('This code runs only once on application installation.');

  //     await prefs.setBool('hasRunBefore', true);
  //   }
  // }

  // String csvString = await rootBundle.loadString('assets/delegates.csv');
  // List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

  // await readCSVAndInsertToSQLite(csvTable);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ZEUC PCM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/init', page: () => const InitializationScreen()),
        GetPage(name: '/login', page: () => const LogInScreen()),
        GetPage(name: '/home', page: () => const Dashboard()),
        GetPage(name: '/checkin', page: () => const HomeScreen()),
        GetPage(name: '/subscribe', page: () => const SubscribeScreen()),
      ],
      initialRoute: '/init',
    );
  }
}
