import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').limit(100).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document['userName']),
              subtitle: new Text(document['userRole']),
            );
          }).toList(),
        );
      },
    );
  }
}