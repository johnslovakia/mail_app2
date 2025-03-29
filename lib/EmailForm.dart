import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mail_app2/main.dart';
import 'package:mail_app2/userAccount/GoogleAccount.dart';

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  Future<void> sendEmail() async {
    final authClient = await GoogleAccount().getAuthClient();

    if (authClient == null) {
      return;
    }

    final gmailApi = gmail.GmailApi(authClient);
    final messageText = 'From: me\n'
        'To: ${_recipientController.text}\n'
        'Subject: ${_subjectController.text}\n'
        '\n'
        '${_bodyController.text}';

    final message = gmail.Message()
      ..raw = base64Url.encode(utf8.encode(messageText));

    try {
      await gmailApi.users.messages.send(message, 'me');
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) => CupertinoAlertDialog(
          title: Text('Success'),
          content: Text('Email sent successfully!'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error sending email: $e');
      showCupertinoDialog(
        context: context,
        builder: (BuildContext dialogContext) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(() {
            if (_recipientController.text == "" || _recipientController.text.contains('@') == false) {
              return 'The email address is invalid.';
            } else if (_subjectController.text == "") {
              return 'Subject cannot be empty."';
            } else {
              return 'There was an error sending the email.';
            }
          }()),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("New Message", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Spacer(),
                GestureDetector (
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      sendEmail();
                    }
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
                          //color: Color(0xFFECECEC).withOpacity(0.45),
                          color: _recipientController.text == "" || _recipientController.text.contains('@') == false || _subjectController.text == "" ? Color(0xFFECECEC).withOpacity(0.45) : Colors.white.withOpacity(0.45),
                          child: Icon(Icons.send_rounded, size: 22, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CupertinoTextField(
                      controller: _recipientController,
                      prefix: Text(
                        'Recipient:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFF4A4A4A),width: 1)),
                      ),
                      style: TextStyle(color: CupertinoColors.white)
                  ),
                  SizedBox(height: 25),
                  CupertinoTextField(
                      controller: _subjectController,
                      prefix: Text(
                        'Subject:',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFF4A4A4A),width: 1)),
                      ),
                      style: TextStyle(color: CupertinoColors.white)
                  ),
                  SizedBox(height: 25),
                  CupertinoTextField(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      controller: _bodyController,
                      prefix: Text(
                        'Message:',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                      ),
                      decoration: BoxDecoration(),
                      maxLines: 8,
                      style: TextStyle(color: CupertinoColors.white)
                  ),
                  /*SizedBox(height: 30),
                  Center(
                    child: CupertinoButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          sendEmail();
                        }
                      },
                      color: CupertinoColors.activeBlue,
                      child: Text('Send Email', style: TextStyle(color: CupertinoColors.white),),
                    ),
                  ),*/
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
