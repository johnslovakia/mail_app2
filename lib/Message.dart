import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mail_app2/Inbox_mail.dart';

import 'Mail.dart';
import 'Utils.dart';

class Message extends StatelessWidget{

  final Mail mail;

  Message({required this.mail});

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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: CupertinoColors.systemBlue),
                            SizedBox(width: 5),
                            Text("Back", style: TextStyle(fontSize: 18, color: CupertinoColors.systemBlue))
                          ],
                        ),
                      ),
                      Spacer(),
                      CupertinoContextMenu(
                        actions: <CupertinoContextMenuAction>[
                          CupertinoContextMenuAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Move to Junk'),
                          ),
                          CupertinoContextMenuAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Reply'),
                          ),
                          CupertinoContextMenuAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Flag'),
                          ),
                        ],
                        child: Icon(
                          Icons.more_vert, // Ikona tří teček
                          size: 22,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      /*GestureDetector (
                        onTap: () {
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: Color(0xFFECECEC).withOpacity(0.45),
                                child: Icon(Icons.more_vert, size: 22, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )*/
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: Text(
                          mail.senderName[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mail.senderName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(mail.senderAddress, style: TextStyle(fontSize: 16, color: Color(0xFFC6C6C6))),
                        ],
                      ),
                      Spacer(),
                      Text(Utils().formatDateTime(mail.date), style: TextStyle(fontSize: 16, color: Color(0xFFC6C6C6)))
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(mail.subject, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(mail.text, style: TextStyle(fontSize: 16))
                      //Html(data: mail.text),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );

    return CupertinoPageScaffold(
        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFECECEC).withOpacity(0.45),
                        ),
                        child: Icon(Icons.arrow_back_ios, size: 28, color: Colors.white),
                      ),
                      Text("Back", style: TextStyle(fontSize: 16))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: Text(
                          mail.senderName[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text(mail.senderName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Address: ${mail.senderAddress}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
        )
    );
  }

  String extractBody(String html) {
    final bodyRegex = RegExp(r'<body[^>]*>([\s\S]*)<\/body>');
    final match = bodyRegex.firstMatch(html);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return html;
  }
}