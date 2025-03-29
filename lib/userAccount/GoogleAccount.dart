import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:mail_app2/Mail.dart';

import '../main.dart';

class GoogleAccount {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://mail.google.com/',
      'https://www.googleapis.com/auth/gmail.readonly',
      'https://www.googleapis.com/auth/gmail.modify',
    ],
  );

  Future<User?> signIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'https://mail.google.com/',
          'https://www.googleapis.com/auth/gmail.readonly',
          'https://www.googleapis.com/auth/gmail.modify',
        ],
      ).signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<auth.AuthClient?> getAuthClient() async {
    final GoogleSignInAccount? googleUser = _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();

    if (googleUser == null) {
      print("User not signed in");
      return null;
    }

    final googleAuth = await googleUser.authentication;
    return auth.authenticatedClient(
      http.Client(),
      auth.AccessCredentials(
        auth.AccessToken('Bearer', googleAuth.accessToken!, DateTime.now().toUtc()),
        null,
        _googleSignIn.scopes.toList(),
      ),
    );
  }

  Future<List<Mail>> fetchEmails() async {
    final authClient = await getAuthClient();
    if (authClient == null) {
      print("Failed to get authenticated client.");
      return [];
    }

    final gmailApi = gmail.GmailApi(authClient);

    try {
      final messages = await gmailApi.users.messages.list('me', maxResults: 15);

      if (messages.messages == null || messages.messages!.isEmpty) {
        print("No emails found.");
        return [];
      }

      List<Mail> mails = [];

      for (var message in messages.messages!.take(15)) {
        final msg = await gmailApi.users.messages.get('me', message.id!);

        final headers = msg.payload?.headers;
        String sender = headers?.firstWhere((h) => h.name == 'From', orElse: () => gmail.MessagePartHeader(name: '', value: 'Unknown')).value ?? "Unknown";
        String subject = headers?.firstWhere((h) => h.name == 'Subject', orElse: () => gmail.MessagePartHeader(name: '', value: 'No Subject')).value ?? "No Subject";

        DateTime date = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(msg.internalDate ?? '0') ?? 0,
        ).toLocal();

        String text = getMessageBody(msg.payload);


        mails.add(Mail(
          extractEmail(sender),
          extractName(sender),
          subject,
          text,
          date,
          msg.labelIds?.contains('UNREAD') == false,
        ));
      }

      return mails;
    } catch (e) {
      print("Error fetching emails: $e");
      return [];
    }
  }

  String getMessageBody(gmail.MessagePart? payload) {
    if (payload == null) return "No message body.";

    String? bestText;
    int bestScore = 0;

    String? decodePart(gmail.MessagePartBody? body) {
      if (body?.data == null) return null;
      try {
        final decoded = base64.decode(body!.data!).cast<int>();
        return utf8.decode(decoded);
      } catch (e) {
        try{
          return utf8.decode(base64.decode(body!.data!.replaceAll('-', '+').replaceAll('_', '/')).cast<int>());
        }catch(e){
          try{
            return utf8.decode(body?.data?.codeUnits ?? []);
          }catch(e){
            print('Error decoding: $e');
            return null;
          }
        }
      }
    }

    void processPart(gmail.MessagePart part, int depth) {
      final contentType = part.mimeType?.toLowerCase();
      final content = decodePart(part.body);

      if (content != null) {
        int score = 0;
        if (contentType == 'text/html') {
          score += 2;
        } else if (contentType == 'text/plain') {
          score += 1;
        }
        score += depth;

        if (bestText == null || score > bestScore) {
          bestText = content;
          bestScore = score;
        }
      }

      if (part.parts != null) {
        for (var subPart in part.parts!) {
          processPart(subPart, depth + 1);
        }
      }
    }

    processPart(payload, 0);

    return bestText ?? "No text message body found.";
  }


  String extractEmail(String sender) {
    final emailRegExp = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final match = emailRegExp.firstMatch(sender);
    return match?.group(0) ?? '';
  }

  String _decodeBase64(String data) {
    return String.fromCharCodes(base64.decode(data.replaceAll('-', '+').replaceAll('_', '/')));
  }

  String extractName(String sender) {
    final regex = RegExp(r'^([^<]+)\s*<.*>$');
    final match = regex.firstMatch(sender);
    if (match != null) {
      return match.group(1)!.trim();
    }
    return sender;
  }
}