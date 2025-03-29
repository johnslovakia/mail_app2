import 'dart:ui';

import 'package:flutter/material.dart';
import 'Inbox_mail.dart';

import 'Mail.dart';
import 'userAccount/GoogleAccount.dart';

class Inbox extends StatelessWidget {
  const Inbox({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("All Inboxes", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              color: Color(0xFFECECEC).withOpacity(0.45),
                              child: Icon(Icons.keyboard_arrow_down_sharp, size: 28, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("x emails", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 5),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text("x unread", style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Icon(Icons.filter_list, size: 16, color: Color(0xFFC6C6C6)),
                        SizedBox(width: 3),
                        Text("Filter", style: TextStyle(fontSize: 16))
                      ]
                  ),
                ],
              ),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 13, right: 20),
                child: FutureBuilder<List<Mail>>(
                  future: GoogleAccount().fetchEmails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No emails found. (2)"));
                    }

                    final emails = snapshot.data!;

                    return ListView.separated(
                      itemCount: emails.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        final mail = emails[index];
                        return InboxMail(mail);
                      },
                    );
                  },
                ),
              )
          ),
        ],
      )
    );
  }
}