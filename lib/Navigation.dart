
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mail_app2/Welcome.dart';

import 'Inbox.dart';
import 'Utils.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final int _currentIndex = 0;

  final List<Widget> _tabs = [
    Welcome(),
    Inbox()
  ];


  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
          border: Border(top: BorderSide(color: Color(0xFF4A4A4A),width: 1)),
          backgroundColor: Color.fromRGBO(32, 32, 32, 0.45),
          activeColor: Color(0xFF4FABFF),
          iconSize: 26,
          height: 50,
          currentIndex: _currentIndex,

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
          ]
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

/*@override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/background.png', // Cesta k obrázku v assets
              fit: BoxFit.cover, // Zajistí, že se obrázek vyplní celou obrazovku
            ),
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), // Rozmazání
              child: CupertinoTabBar(
                border: Border(top: BorderSide(color: Color(0xFF4A4A4A),width: 1)),
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
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
            ),
          ),
        ],
      ),
    );
  }*/
}