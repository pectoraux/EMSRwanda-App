import 'dart:async';

import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String firstName;
  String lastName;
  String location;
  int age;
  double rating;
  int numberProjects;

  String get fullName => "$firstName $lastName";

  String get ageString => _abbreviatedCount(age);

  String get ratingString => rating.toString();

  String get numberProjectsString => _abbreviatedCount(numberProjects);

  String _abbreviatedCount(int num) {
    if (num < 1000) return "$num";
    if (num >= 1000 && num < 1000000) {
      String s = (num / 1000).toStringAsFixed(1);
      if (s.endsWith(".0")) {
        int idx = s.indexOf(".0");
        s = s.substring(0, idx);
      }
      return "${s}K";
    } else if (num >= 1000000 && num < 1000000000) {
      String s = (num / 1000000).toStringAsFixed(1);
      if (s.endsWith(".0")) {
        int idx = s.indexOf(".0");
        s = s.substring(0, idx);
      }
      return "${s}M";
    }
    return "";
  }
}

Profile getProfile(BaseAuth auth)  {
  String firstName, lastName;

  auth.currentUser().then((userId) async {
    firstName = await Firestore.instance.collection('tables/users/$userId')
        .getDocuments()
        .then((doc) {
      return doc.documents[0]['firstName'];
    });
  });

  return new Profile()
    ..firstName = firstName
    ..lastName = "Watson"
    ..location = "Kigali"
    ..age = 35
    ..rating = 4.6
    ..numberProjects = 17;
}