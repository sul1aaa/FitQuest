import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String uid;
  final double radius;

  const UserAvatar({super.key, required this.uid, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircleAvatar(radius: radius);
        }

        final data = snapshot.data!.data()!;
        final url = data['photoUrl'];

        return CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(url),
        );
      },
    );
  }
}
