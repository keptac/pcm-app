import 'package:zeucpcm/screens/login_screen.dart';
import 'package:zeucpcm/screens/meal_screen.dart';
import 'package:zeucpcm/utils/size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zeucpcm/utils/constants.dart';

import '../widgets/customDialogs/meal_verification_dialog.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List options = [
    [
      {
        "name": "CHECK IN",
        "icon": "assets/images/checkin.png",
        "key": "checkin",
        "page": "checkin"
      },
      {
        "name": "MEALS",
        "icon": "assets/images/dining.png",
        "key": "meals",
        "page": "meals"
      },
    ],
    [
      {
        "name": "CHECK IN",
        "icon": "assets/images/checkin.png",
        "key": "checkin",
        "page": "checkin"
      },
      {
        "name": "MEALS",
        "icon": "assets/images/dining.png",
        "key": "meals",
        "page": "meals"
      },
    ],
  ];

  String active = "";

  void setActiveFunc(String key) {
    setState(() {
      active = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 2,
        backgroundColor: const Color.fromARGB(255, 121, 10, 10),
        elevation: 5.0,
        titleSpacing: 00.0,
        centerTitle: true,
        title: const Text(
          "ZEUC PCM",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Image.asset(
            "assets/images/white-logo.png",
            height: size.height * 0.05,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: const Text("Logout"),
                    value: "Logout",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()));
                    }),
              ];
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 86, 4, 127),
                      Color.fromARGB(255, 2, 25, 68),
                      Color.fromARGB(255, 63, 6, 2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        "assets/images/background.jpg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'MisCon24',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Present-day Waldenses',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            '28 March - 01 April 2024',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 160,
              ),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      1,
                      (index) => Expanded(
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: index == 2 ? 0 : 10.0),
                          child: Row(
                            children: [
                              serviceCard(context, options[index][0], active,
                                  setActiveFunc),
                              const SizedBox(
                                width: 10.0,
                              ),
                              serviceCard(context, options[index][1], active,
                                  setActiveFunc),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget serviceCard(
    BuildContext context, Map item, String active, Function setActive) {
  bool isActive = active == item["key"];
  return Expanded(
    child: GestureDetector(
      onTap: () {
        setActive(item["page"]);
        Future.delayed(const Duration(milliseconds: 100), () {
          switch (item["page"]) {
            case "checkin":
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case "meals":

              //Popup with information to select day and meal then pass to next scanning page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MealScreen()),
              );
              break;
          }

          // nextPage();
        });
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isActive ? Constants.lightGreenColor : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    item["icon"],
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Text(
                item["name"],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: isActive
                        ? Colors.black
                        : const Color.fromRGBO(20, 20, 20, 0.96)),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
