import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mail_app2/userAccount/GoogleAccount.dart';

class Welcome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
              child:
              SizedBox(
                width: 300,
                child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Welcome to Mail", style: TextStyle(fontSize: 32)),
                            Text("Stay organized with fast and secure email, all in one place.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                          ]
                      ),
                      Positioned(
                        bottom: 200,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            GoogleAccount().signIn(context);
                          },
                          child: Container(
                              width: 334,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Color(0xFF484848),
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/GoogleLogo.png',
                                      height: 32,
                                    ),
                                    Text("Login with Google Account", style: (TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),)
                                  ]
                              )
                          ),
                        ),
                      )
                    ]
                ),
              )
          ),
        ],
      ),
    );

    return Scaffold(
      body: Center(
          child:
          SizedBox(
            width: 300,
            child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Welcome to Mail", style: TextStyle(fontSize: 32)),
                        Text("Stay organized with fast and secure email, all in one place.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                      ]
                  ),
                  Positioned(
                    bottom: 200,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        GoogleAccount().signIn(context);
                      },
                      child: Container(
                          width: 334,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Color(0xFF484848),
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/GoogleLogo.png',
                                  height: 32,
                                ),
                                Text("Login with Google Account", style: (TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),)
                              ]
                          )
                      ),
                    ),
                  )
                ]
            ),
          )
      ),
    );
  }

}