import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'Mail.dart';
import 'Message.dart';
import 'Utils.dart';

class InboxMail extends StatelessWidget{

  final Mail mail;


  const InboxMail(this.mail);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Message(mail: mail),
          ),
        );

        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CupertinoPageScaffold(
                appBar: AppBar(title: Text("Message")),
                body: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Message(mail: mail),
                  ],
                ),
              );
            },
          ),
        );*/
      },
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                if (mail.read) ...[
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ]else ...[
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
                  SizedBox(width: 5),
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
                  )
                ]
            ),
            SizedBox(width: 12),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          Text(mail.senderName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Spacer(),
                          Text(Utils().formatDateTime(mail.date), style: TextStyle(fontSize: 16, color: Color(0xFFC6C6C6)))
                        ]
                    ),
                    Text(mail.subject, style: TextStyle(fontSize: 16, color: Color(0xFFC6C6C6))),
                    //Text(text, style: TextStyle(color: Color(0xFFC6C6C6), fontSize: 14)),
                  ],
                )
            )
          ],
        ),
    );
  }
}