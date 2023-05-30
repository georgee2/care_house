import 'package:flutter/material.dart';

class UserReservContainer extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String date;
  final String placeName;

  const UserReservContainer({Key? key, required this.firstName, required this.lastName, required this.phone, required this.date, required this.placeName,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$firstName $lastName', style: const TextStyle(fontSize: 20, color: Colors.white),),
          Text(placeName, style: const TextStyle(fontSize: 20, color: Colors.white),),
          Text(phone, style: const TextStyle(fontSize: 20, color: Colors.white),),
          Text(date, style: const TextStyle(fontSize: 20, color: Colors.white),),
        ],
      ),
    );
  }
}
