import 'package:zeucpcm/screens/login_screen.dart';
import 'package:zeucpcm/utils/size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zeucpcm/utils/constants.dart';

import 'home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List options = [
    [
      {
        "name": "Checkin",
        "icon": "assets/svg/billpayments.svg",
        "key": "checkin",
        "page": "checkin"
      },
      {
        "name": "Meals",
        "icon": "assets/svg/billstatement.svg",
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2,
        backgroundColor: Constants.greenColor,
        elevation: 0.0,
        titleSpacing: 00.0,
        centerTitle: true,
        leading: Container(),
      ),
      body: Center(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: size.height * 0.05,
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        print(value);
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                              child: const Text("Logout"),
                              value: "Logout",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LogInScreen()));
                              }),
                        ];
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                thickness: 1,
                color: Constants.greyColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(61, 100, 13, 1)
                    // color: Colors.red
                    ),

                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        "assets/images/person.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Z bills and enquire balance at the comfort of your home',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      2,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
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
        elevation: 8.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            // color: isActive ? Constants.goldColor : Constants.greyColor,
            // color: isActive ? Constants.goldColor: Colors.white,
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
                child: SvgPicture.asset(
                  item["icon"],
                  height: SizeUtil.height(context, 0.04),
                  width: SizeUtil.width(context, 0.03),
                  // color: isActive ? Colors.white : Constants.greenColor,
                  color: isActive ? Constants.greenColor : Constants.greenColor,
                ),
              ),
              Text(
                item["name"],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
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
