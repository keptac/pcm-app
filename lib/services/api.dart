import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeucpcm/controllers/home_controller.dart';
import 'package:zeucpcm/model/delegate_info.dart';
import 'package:zeucpcm/model/meal_info.dart';
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

    final List<Map<String, dynamic>> delegates = await db.query('delegates',
        where: 'checkinStatus = ?', whereArgs: ["CHECKED IN"]);

    List<DelegateInfo> delegatesList = delegates.isNotEmpty
        ? List.generate(
            delegates.length,
            (i) {
              return DelegateInfo(
                  id: delegates[i]['id'],
                  title: delegates[i]['title'],
                  institute: delegates[i]['institute'],
                  username: delegates[i]['username'],
                  selectedRoom: delegates[i]['selectedRoom'],
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
                  title: delegates[i]['title'],
                  institute: delegates[i]['institute'],
                  username: delegates[i]['username'],
                  selectedRoom: delegates[i]['selectedRoom'],
                  checkinStatus: delegates[i]['checkinStatus']);
            },
          )
        : <DelegateInfo>[];

    return delegatesList;
  }

  Future<List<MealInfo>> getMealsSubscribers() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );

    final db = await database;

    final List<Map<String, dynamic>> meals = await db.query('canteen');

    List<MealInfo> delegatesList = meals.isNotEmpty
        ? List.generate(
            meals.length,
            (i) {
              return MealInfo(
                  id: meals[i]['id'],
                  mealName: meals[i]['mealName'],
                  username: meals[i]['username'],
                  checkinStatus: meals[i]['checkinStatus']);
            },
          )
        : <MealInfo>[];

    return delegatesList;
  }

  Future<void> insertMeal(MealInfo meal) async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), 'miscon_delegates.db'),
    );
    final db = await database;

    await db.insert(
      'canteen',
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
  Future<List<DelegateInfo>> getDelegateById(String id) async {
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
                  title: delegates[i]['title'],
                  institute: delegates[i]['institute'],
                  username: delegates[i]['username'],
                  selectedRoom: delegates[i]['selectedRoom'],
                  checkinStatus: delegates[i]['checkinStatus']);
            },
          )
        : <DelegateInfo>[];

    return delegatesList;
  }
}
