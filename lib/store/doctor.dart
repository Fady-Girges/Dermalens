import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: PreferredSize(
  preferredSize: const Size.fromHeight(kToolbarHeight),
  child: Container(
    color: Colors.black, 
    alignment: Alignment.center,
    child: const Text(
      'Dermatologist List',
      style: TextStyle(
        color: Colors.white, 
        fontSize: 20, 
      ),
    ),
  ),
),



      backgroundColor:
          const Color.fromARGB(255, 21, 21, 21), // Set background color to black
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Doctors').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final doctors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (BuildContext context, int index) {
              final doctor = doctors[index];
              final data = doctor.data() as Map<String, dynamic>;
              final name = data['name'].toString(); // Convert to string
              final address =
                  data['address'].toString(); // Convert to string
              final mobile =
                  data['mobile'].toString(); // Convert to string

              return DoctorCard(
                name: name,
                address: address,
                mobile: mobile,
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String address;
  final String mobile;

  const DoctorCard({
    required this.name,
    required this.address,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      color: const Color(0xff12aaff), // Set card color to blue
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color:
                    Color.fromARGB(255, 21, 21, 21), // Set text color to white
              ),
            ),
            const SizedBox(height: 16), // Increase space between lines
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Address:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 21, 21, 21),
                  ),
                ),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xffeeeeee),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Increase space between boxes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mobile:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 21, 21, 21),
                  ),
                ),
                Text(
                  mobile,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xffeeeeee),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
