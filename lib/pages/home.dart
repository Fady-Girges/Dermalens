import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermalens/PDF/pdf_view_screen.dart';
import 'package:dermalens/pages/profile.dart';
import 'package:dermalens/pages/results.dart';
import 'package:dermalens/pages/settings.dart' as FirestoreSettings;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  final String firstName;

  const Home({super.key, required this.firstName});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _imageFile;
  String result = '';
  String? pdfUrl;

  @override
  void initState() {
    super.initState();
    _fetchPdfUrl(); // استدعاء دالة لجلب رابط الملف PDF عند تهيئة الصفحة
  }

 Future<void> _fetchPdfUrl() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

        // جلب الوثيقة الأخيرة للمستخدم من Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('uploads')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            pdfUrl = querySnapshot.docs.first['pdfUrl'];
          });
        } else {
          print('No previous downloads');
        }
      }
    } catch (e) {
      print('Failed to fetch PDF link from Firestore: $e');
    }
  }

  void _openPdf() async {
    if (pdfUrl != null && pdfUrl!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(pdfUrl: pdfUrl!),
        ),
      );
    } else {
      print('No link to PDF file');
    }
  }


  Future<void> getImage(bool isCamera) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _uploadImageToServer(_imageFile!);
    }
  }

  Future<void> _uploadImageToServer(File image) async {
    try {
      String base64Image = base64Encode(image.readAsBytesSync());

      // إرسال الصورة إلى الخادم وتحليل النتيجة
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      var response = await http.put(
        Uri.parse("http://10.0.2.2:5000/api"),
        headers: headers,
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String imageUrl = responseData['imageUrl'];
        String pdfUrl = responseData['pdfUrl'];
        setState(() {
          result = responseData['result'];
        });

        // تحميل البيانات إلى Firestore
        await _uploadDataToFirestore(base64Image, result, imageUrl, pdfUrl);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Results(
              imageUrl: imageUrl,
              result: responseData['result'],
            ),
          ),
        );
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadDataToFirestore(String base64Image, String result, String imageUrl, String pdfUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

       // إنشاء مستند جديد تحت مجموعة 'uploads' داخل مستند المستخدم
        await FirebaseFirestore.instance.collection('users').doc(uid).collection('uploads').add({
          'image': base64Image,
          'result': result,
          'imageUrl': imageUrl,
          'pdfUrl': pdfUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Failed to upload data to Firestore: $e');
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
        // homescreen 
        width: double.infinity,
        decoration: const BoxDecoration (
          color: Color.fromARGB(255, 21, 21, 21),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 100*fem),
                    width: 16*fem,
                    height: 16*fem,
                  ),
                  Container(
                    // welcome 
                    margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 0*fem, 68*fem),
                    child: RichText(
                      text: TextSpan(
                        style: SafeGoogleFont (
                          'Poppins',
                          fontSize: 24*ffem,
                          height: 1.5*ffem/fem,
                          color: const Color(0xffffffff),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Welcome, ',
                          ),
                          TextSpan(
                             text: widget.firstName,
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 24*ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.5*ffem/fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openPdf,
                  
                 child: Container(
                    margin: EdgeInsets.fromLTRB(22*fem, 0*fem, 26*fem, 32*fem),
                    padding: EdgeInsets.fromLTRB(26*fem, 19*fem, 29*fem, 25*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      color: const Color(0xff1d1d1d),
                      borderRadius: BorderRadius.circular(24*fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // pastresult
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 21*fem),
                          child: Text(
                            'Result:',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 16*ffem,
                              height: 1.5*ffem/fem,
                              color: const Color(0xffeeeeee),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16*fem, 11*fem, 154*fem, 12*fem),
                          width: double.infinity,
                          decoration: BoxDecoration (
                            color: const Color(0xff2b2b2b),
                            borderRadius: BorderRadius.circular(10*fem),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 7*fem, 0*fem),
                                width: 20*fem,
                                height: 20*fem,
                                child: Image.asset(
                                  'assets/page-1/images/auto-group-k4ge.png',
                                  width: 20*fem,
                                  height: 20*fem,
                                ),
                              ),
                              Text(
                                'result.pdf',
                                style: SafeGoogleFont (
                                  'Poppins',
                                  fontSize: 16*ffem,
                                  height: 1.5*ffem/fem,
                                  color: const Color(0xffeeeeee),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  Container(
                    // new analysis 
                    margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 0*fem, 18*fem),
                    child: Text(
                      'New analysis',
                      style: SafeGoogleFont (
                        'Poppins',
                        fontSize: 24*ffem,
                        height: 1.5*ffem/fem,
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                  Container(
                    // box 
                    margin: EdgeInsets.fromLTRB(24*fem, 0*fem, 24*fem, 32*fem),
                    padding: EdgeInsets.fromLTRB(24*fem, 20*fem, 36*fem, 23*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      color: const Color(0xff1d1d1d),
                      borderRadius: BorderRadius.circular(24*fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // photo for the analysis
                          margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 1*fem, 44*fem),
                          constraints: BoxConstraints (
                            maxWidth: 284*fem,
                          ),
                          child: Text(
                            'Please provide a photo of your skin condition',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 16*ffem,
                              height: 1.5*ffem/fem,
                              color: const Color(0xffeeeeee),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5*fem, 0*fem, 0*fem, 0*fem),
                          width: double.infinity,
                          height: 44*fem,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // take photo
                                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                child: TextButton(
                                  onPressed: () => getImage(true),
                                  style: TextButton.styleFrom (
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: 132*fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration (
                                      borderRadius: BorderRadius.circular(49.8873214722*fem),
                                      gradient: const LinearGradient (
                                        begin: Alignment(2.543, -1.776),
                                        end: Alignment(-1.097, 1),
                                        colors: <Color>[Color(0xff023994), Color(0xff12aaff)],
                                        stops: <double>[0, 1],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Take photo',
                                        style: SafeGoogleFont (
                                          'Poppins',
                                          fontSize: 16*ffem,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5*ffem/fem,
                                          color: const Color(0xffeeeeee),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => getImage(false),
                                style: TextButton.styleFrom (
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(25*fem, 10*fem, 28*fem, 10*fem),
                                  height: double.infinity,
                                  decoration: BoxDecoration (
                                    borderRadius: BorderRadius.circular(49.8873214722*fem),
                                    border: const Border (
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0.75*fem, 7*fem, 0*fem),
                                        width: 14*fem,
                                        height: 12.75*fem,
                                        child: Image.asset(
                                          'assets/page-1/images/auto-group-bsgw.png',
                                          width: 14*fem,
                                          height: 12.75*fem,
                                        ),
                                      ),
                                      Text(
                                        // upload
                                        'Upload',
                                        style: SafeGoogleFont (
                                          'Poppins',
                                          fontSize: 16*ffem,
                                          height: 1.5*ffem/fem,
                                          color: const Color(0xff12aaff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0*fem,5*fem, 0*fem,  0*fem),

              width: double.infinity,
              height: 150*fem,
              child: Stack(
                children: [
                  Positioned(
                    left: 24*fem,
                    top: 52*fem,
                    child: Align(
                      child: SizedBox(
                        width: 345*fem,
                        height: 76*fem,
                        child: Container(
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(24*fem),
                            color: const Color(0xff1d1d1d),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // home button
                    left: 139*fem,
                    top: 67*fem,
                    child: Align(
                      child: SizedBox(
                        width: 28*fem,
                        height: 28*fem,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Image.asset(
                            'assets/page-1/images/vector-WSA.png',
                            width: 28*fem,
                            height: 28*fem,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // results button 
                    left: 48*fem,
                    top: 68*fem,
                    child: Align(
                      child: SizedBox(
                        width: 35*fem,
                        height: 25*fem,
                        child: TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Results(imageUrl: '', result: '',))
                      );},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Image.asset(
                            'assets/page-1/images/vector-PbC.png',
                            width: 35*fem,
                            height: 25*fem,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // Profile button 
                    left: 223*fem,
                    top: 67*fem,
                    child: Align(
                      child: SizedBox(
                        width: 27*fem,
                        height: 27*fem,
                        child: TextButton(
                          onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())
                      );},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Image.asset(
                            'assets/page-1/images/group-3-pwG.png',
                            width: 27*fem,
                            height: 27*fem,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // settings button 
                    left: 306*fem,
                    top: 68*fem,
                    child: Align(
                      child: SizedBox(
                        width: 25*fem,
                        height: 26*fem,
                        child: TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const FirestoreSettings.Settings())
                      );},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Image.asset(
                            'assets/page-1/images/vector-Hjk.png',
                            width: 25*fem,
                            height: 26*fem,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // home text
                    left: 139*fem,
                    top: 99*fem,
                    child: Align(
                      child: SizedBox(
                        width: 30*fem,
                        height: 15*fem,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'home',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 10*ffem,
                              height: 1.5*ffem/fem,
                              color: const Color(0xff12aaff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // results text
                    left: 49*fem,
                    top: 99*fem,
                    child: Align(
                      child: SizedBox(
                        width: 36*fem,
                        height: 15*fem,
                        child: TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Results(imageUrl: '', result: '',))
                      );},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Results',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 10*ffem,
                              height: 1.5*ffem/fem,
                              color: const Color(0xff898989),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // profile text
                    left: 222*fem,
                    top: 99*fem,
                    child: Align(
                      child: SizedBox(
                        width: 31*fem,
                        height: 15*fem,
                        child: TextButton(
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())
                      );
                          },
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Profile',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 10*ffem,
                              height: 1.5*ffem/fem,
                              color: const Color(0xff898989),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // settings text
                    left: 299*fem,
                    top: 99*fem,
                    child: Align(
                      child: SizedBox(
                        width: 41*fem,
                        height: 15*fem,
                        child: TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const FirestoreSettings.Settings())
                      );},
                          style: TextButton.styleFrom (
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Settings',
                            style: SafeGoogleFont (
                              'Poppins',
                              fontSize: 10*ffem,
                              height: 1.5*ffem/fem,
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
      )
          );
  }
}