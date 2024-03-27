import 'package:flutter/material.dart';
import 'package:zeucpcm/screens/dashboard.dart';
import 'package:zeucpcm/utils/constants.dart';
import 'package:zeucpcm/screens/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  List beneficiaries = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 2,
        backgroundColor: const Color.fromARGB(255, 121, 10, 10),
        elevation: 5.0,
        titleSpacing: 00.0,
        centerTitle: true,
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            )
          },
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    thickness: 1,
                    color: Constants.greyColor,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: beneficiaries.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 15.0,
                            ),
                            Center(
                              child: Card(
                                margin: const EdgeInsets.all(2.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2.0,
                                child: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 1.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white,
                                  ),

                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Constants.greenColor,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            child: Text(
                                              beneficiaries[index]
                                                      ['account_name'] ??
                                                  "",
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 160,
                                            child: Text(
                                              beneficiaries[index]
                                                      ['bill_account'] ??
                                                  "",
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {},
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            PopupMenuItem(
                                                value: "Delete",
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color:
                                                          Constants.goldColor,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Delete")
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Profile()));
                                                }),
                                          ];
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
