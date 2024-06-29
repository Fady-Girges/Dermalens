import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermalens/PDF/pdf_view_screen.dart';
import 'package:dermalens/pages/home.dart';
import 'package:dermalens/pages/results.dart';
import 'package:dermalens/pages/settings.dart' as FirestoreSettings;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  List<Map<String, dynamic>> pdfList = [];

  int age = 20;
  int height = 170;
  String gender = 'Male';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchPdfUrls();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          age = userDoc.get('age') ?? age;
          height = userDoc.get('height') ?? height;
          gender = userDoc.get('gender') ?? gender;
        });
      }
    }
  }

  Future<void> saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentReference userDocRef =
            firestore.collection('users').doc(user.uid);

        // Update the document with the new data
        await userDocRef.update({
          'age': age,
          'height': height,
          'gender': gender,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User data updated successfully!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user is signed in.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchPdfUrls() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

        // جلب الوثائق من مجموعة uploads للمستخدم
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('uploads')
            .orderBy('timestamp', descending: true)
            .get();

        List<Map<String, dynamic>> tempList = [];
        for (var doc in querySnapshot.docs) {
          tempList.add(doc.data() as Map<String, dynamic>);
        }

        setState(() {
          pdfList = tempList;
        });
      }
    } catch (e) {
      print('Failed to fetch PDF links from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          // profileULv (67:2)
          padding: EdgeInsets.fromLTRB(0 * fem, 20 * fem, 0 * fem, 15 * fem),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 21, 21, 21),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // octiconupload16CgE (67:19)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 30 * fem),
                width: 16 * fem,
                height: 16 * fem,
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(24 * fem, 0 * fem, 24 * fem, 11 * fem),
                padding: EdgeInsets.fromLTRB(
                    20 * fem, 15 * fem, 20 * fem, 20 * fem), // تعديل padding
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff1d1d1d),
                  borderRadius: BorderRadius.circular(24 * fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // userinfoXkS (67:54)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 18 * fem),
                      child: Text(
                        'User info:',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16 * ffem,
                          height: 1.5 * ffem / fem,
                          color: const Color(0xffeeeeee),
                        ),
                      ),
                    ),
                    // قسم الطول
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 51 * fem, 3 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_up,
                                color: Color(0xffeeeeee)),
                            onPressed: () {
                              setState(() {
                                height++;
                              });
                            },
                          ),
                          RichText(
                            text: TextSpan(
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16 * ffem,
                                height: 1.5 * ffem / fem,
                                color: const Color(0xffeeeeee),
                              ),
                              children: [
                                TextSpan(
                                  text: '$height',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xffeeeeee),
                                  ),
                                ),
                                TextSpan(
                                  text: ' cm',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xff12aaff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xffeeeeee)),
                            onPressed: () {
                              setState(() {
                                height--;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // قسم العمر
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 10 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_up,
                                color: Color(0xffeeeeee)),
                            onPressed: () {
                              setState(() {
                                age++;
                              });
                            },
                          ),
                          RichText(
                            text: TextSpan(
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 16 * ffem,
                                height: 1.5 * ffem / fem,
                                color: const Color(0xffeeeeee),
                              ),
                              children: [
                                TextSpan(
                                  text: '$age',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xffeeeeee),
                                  ),
                                ),
                                TextSpan(
                                  text: ' Years old',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xff12aaff),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Color(0xffeeeeee)),
                            onPressed: () {
                              setState(() {
                                age--;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // قسم الجنس
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Male',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 16 * ffem,
                                  height: 1.5 * ffem / fem,
                                  color: const Color(0xffeeeeee),
                                ),
                              ),
                              value: 'Male',
                              groupValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              activeColor: const Color(0xff12aaff),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Female',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 16 * ffem,
                                  height: 1.5 * ffem / fem,
                                  color: const Color(0xffeeeeee),
                                ),
                              ),
                              value: 'Female',
                              groupValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              activeColor: const Color(0xff12aaff),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity, // يستخدم لتعيين العرض بالكامل
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: saveUserData,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff12aaff),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25 * ffem,
                                vertical: 12 * ffem), 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  66 * ffem), 
                            ), 
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
  // frame1jvN (67:77)
  margin: EdgeInsets.fromLTRB(24 * fem, 0 * fem, 24 * fem, 0 * fem),
  padding: EdgeInsets.fromLTRB(26 * fem, 19 * fem, 29 * fem, 64 * fem),
  width: double.infinity,
  decoration: BoxDecoration(
    color: const Color(0xff1d1d1d),
    borderRadius: BorderRadius.circular(24 * fem),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        // pastresultsCJA (67:37)
        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 193 * fem, 21 * fem),
        child: Text(
          'past results:',
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 16 * ffem,
            height: 1.5 * ffem / fem,
            color: const Color(0xffeeeeee),
          ),
        ),
      ),
      SizedBox(
        height: 170,
        child: ListView.builder(
          itemCount: pdfList.length,
          itemBuilder: (context, index) {
            var pdfData = pdfList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerPage(pdfUrl: pdfData['pdfUrl']),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff2b2b2b),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        width: 32.0,
                        height: 32.0,
                        child: Image.asset(
                                  'assets/page-1/images/auto-group-k4ge.png',
                                  width: 20*fem,
                                  height: 20*fem,
                                ),
                      ),
                      Expanded(
                        child: Text(
                          'result${index + 1}.pdf',
                          style: SafeGoogleFont(
                          'Poppins',
                            fontSize: 16.0,
                            color: const Color(0xffeeeeee),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
),
              SizedBox(
                // autogroupfemuhYS (D9veuooGzqTp4i2cfdFEMU)
                width: double.infinity,
                height: 150 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      // navi
                      left: 24 * fem,
                      top: 52 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 345 * fem,
                          height: 76 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24 * fem),
                              color: const Color(0xff1d1d1d),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // home icon
                      left: 139 * fem,
                      top: 67 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 28 * fem,
                          height: 28 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home(
                                            firstName: '',
                                          )));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/vector-7wt.png',
                              width: 28 * fem,
                              height: 28 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // results icon
                      left: 48 * fem,
                      top: 68 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 35 * fem,
                          height: 25 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Results(
                                            imageUrl: '',
                                            result: '',
                                          )));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/vector-PbC.png',
                              width: 35 * fem,
                              height: 25 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // profile icon
                      left: 223 * fem,
                      top: 67 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 27 * fem,
                          height: 27 * fem,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/group-3-hBk.png',
                              width: 27 * fem,
                              height: 27 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // settings icon
                      left: 306 * fem,
                      top: 68 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 25 * fem,
                          height: 26 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FirestoreSettings.Settings()));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/vector-Hjk.png',
                              width: 25 * fem,
                              height: 26 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // home text
                      left: 139 * fem,
                      top: 99 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 30 * fem,
                          height: 15 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home(
                                            firstName: '',
                                          )));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'home',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 10 * ffem,
                                height: 1.5 * ffem / fem,
                                color: const Color(0xff898989),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // results text
                      left: 49 * fem,
                      top: 99 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 36 * fem,
                          height: 15 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Results(
                                            imageUrl: '',
                                            result: '',
                                          )));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Results',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 10 * ffem,
                                height: 1.5 * ffem / fem,
                                color: const Color(0xff898989),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // profile text
                      left: 222 * fem,
                      top: 99 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 31 * fem,
                          height: 15 * fem,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Profile',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 10 * ffem,
                                height: 1.5 * ffem / fem,
                                color: const Color(0xff12aaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // settings text
                      left: 299 * fem,
                      top: 99 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 41 * fem,
                          height: 15 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FirestoreSettings.Settings()));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Settings',
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 10 * ffem,
                                height: 1.5 * ffem / fem,
                                color: const Color(0xff898989),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
