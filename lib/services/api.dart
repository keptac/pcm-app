import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeucpcm/controllers/home_controller.dart';
import 'package:zeucpcm/model/delegate_info.dart';
import 'package:zeucpcm/model/user.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Api {
  final homeController = Get.put(HomeController());
  final httpClient = http.Client();

  Future<List<User>> login() async {
    final String response = await rootBundle.loadString('assets/user.json');
    final data = await json.decode(response);
    return data['users'].map<User>((user) => User.fromJson(user)).toList();
  }

  Future<List<DelegateInfo>> getAllCheckinDelegates() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );

    final db = await database;

    final List<Map<String, dynamic>> delegates =
        await db.query('delegates', where: 'checkinStatus = ?', whereArgs: [1]);

    List<DelegateInfo> delegatesList = delegates.isNotEmpty
        ? List.generate(
            delegates.length,
            (i) {
              return DelegateInfo(
                  id: delegates[i]['id'],
                  fname: delegates[i]['fname'],
                  lname: delegates[i]['lname'],
                  username: delegates[i]['username'],
                  email: delegates[i]['email'],
                  image: delegates[i]['image'],
                  checkinStatus: delegates[i]['checkinStatus']);
            },
          )
        : <DelegateInfo>[];

    return delegatesList;
  }

  Future<List<DelegateInfo>> getAllSubscribers() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );

    final db = await database;

    final List<Map<String, dynamic>> delegates = await db.query('subscribers');

    List<DelegateInfo> delegatesList = delegates.isNotEmpty
        ? List.generate(
            delegates.length,
            (i) {
              return DelegateInfo(
                  id: delegates[i]['id'],
                  fname: delegates[i]['fname'],
                  lname: delegates[i]['lname'],
                  username: delegates[i]['username'],
                  email: delegates[i]['email'],
                  image: delegates[i]['image'],
                  checkinStatus: delegates[i]['checkinStatus']);
            },
          )
        : <DelegateInfo>[];

    return delegatesList;
  }

//Add subscriber
  Future<void> subscribeUser(
    DelegateInfo delegate,
  ) async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );
    final db = await database;

    await db.insert(
      'subscribers',
      delegate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//Add delegate
  Future<void> insertDelegate(DelegateInfo delegate) async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );
    final db = await database;

    await db.insert(
      'delegates',
      delegate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//Update Delegate Attendance status
  Future<void> updateDelegateAttendance(DelegateInfo delegate) async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );

    final db = await database;

    var resp = await db.update(
      'delegates',
      delegate.toMap(),
      where: 'id = ?',
      whereArgs: [delegate.id],
    );

    print(resp.toString());
  }

// Get Delegate by ID
  Future<List<DelegateInfo>> getDelegateById(int id) async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );

    final db = await database;

    final List<Map<String, dynamic>> delegates =
        await db.query('delegates', where: 'id = ?', whereArgs: [id]);

    List<DelegateInfo> delegatesList = delegates.isNotEmpty
        ? List.generate(
            delegates.length,
            (i) {
              return DelegateInfo(
                  id: delegates[i]['id'],
                  fname: delegates[i]['fname'],
                  lname: delegates[i]['lname'],
                  username: delegates[i]['username'],
                  email: delegates[i]['email'],
                  image: delegates[i]['image'],
                  checkinStatus: delegates[i]['checkinStatus']);
            },
          )
        : <DelegateInfo>[];

    return delegatesList;
  }
}
