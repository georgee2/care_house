import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationSystem {

  Future<List<int>> appointments (String clinicName) async{
    List<int> result = List<int>.empty(growable: true);
    var bookingRef = FirebaseFirestore.instance.collection('clinics').doc(clinicName).collection('reservation');
    QuerySnapshot snapshot = await bookingRef.get();
    for (var element in snapshot.docs) {
      result.add(int.parse(element.id));
    }
    return result;
  }

}