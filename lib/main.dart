import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mail_app2/EmailForm.dart';
import 'package:mail_app2/Welcome.dart';
import 'package:mail_app2/userAccount/GoogleAccount.dart';
import 'Inbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final googleSignIn = GoogleSignIn();
  final isSignedIn = await googleSignIn.isSignedIn();

  runApp(MyApp(isSignedIn: isSignedIn));
}

class MyApp extends StatelessWidget {
  final bool isSignedIn;

  MyApp({required this.isSignedIn});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CupertinoApp(
        home: isSignedIn ? MainScreen() : Welcome(),
        theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(color: CupertinoColors.white),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CupertinoTabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController();
  }

  final List<Widget> _tabs = [
    Inbox(),
    EmailForm(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        border: Border(top: BorderSide(color: Color(0xFF4A4A4A), width: 1)),
        backgroundColor: Color(0xFF202020).withOpacity(0.45),
        activeColor: Color(0xFF4FABFF),
        iconSize: 26,
        height: 50,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _tabs[index],
              ],
            );
          },
        );
      },
    );
  }

  // Method to switch tabs
  void switchTab(int index) {
    _tabController.index = index;
  }
}