import 'package:dermalens/utils.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/pages/home.dart';
import 'package:dermalens/pages/profile.dart';
import 'package:dermalens/pages/settings.dart' as FirestoreSettings;
import 'package:dermalens/store/doctor.dart';

class Results extends StatefulWidget {
  final String imageUrl;
  final String result;

  const Results({Key? key, required this.imageUrl, required this.result}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0 * fem),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 21, 21, 21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                width: 16 * fem,
                height: 45 * fem,
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(24 * fem, 0 * fem, 24 * fem, 11 * fem),
                width: double.infinity,
                height: 196 * fem,
                decoration: BoxDecoration(
                  color: const Color(0xff1d1d1d),
                  borderRadius: BorderRadius.circular(24 * fem),
                ),
            child: Column(
                  children: [
                    Text(
                      'Your analyzed photo',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16 * ffem,
                        height: 2 * ffem / fem,
                        color: const Color(0xffeeeeee),
                      ),
                    ),
                    Image.network(
                       widget.imageUrl,
                      height: 150 * fem,
                      width: 280 * fem,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(24 * fem, 6 * fem, 24 * fem, 16 * fem),
                padding:
                    EdgeInsets.fromLTRB(22 * fem, 19 * fem, 22 * fem, 70 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff1d1d1d),
                  borderRadius: BorderRadius.circular(24 * fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk assessment',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 16 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.5 * ffem / fem,
                        color: const Color(0xff12aaff),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 6 * fem),
                      constraints: BoxConstraints(
                        maxWidth: 257 * fem,
                      ),
                      child: Text(
                        widget.result,
                        style: SafeGoogleFont(
                         'Poppins',
                          fontSize: 14 * ffem,
                          height: 1.5 * ffem / fem,
                          color: const Color(0xff8e8e8e),
                        ),
                      ),
                    ),
                    
                    
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(24 * fem, 0 * fem, 24 * fem, 0 * fem),
                padding:
                    EdgeInsets.fromLTRB(19 * fem, 23 * fem, 19 * fem, 28 * fem),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff1d1d1d),
                  borderRadius: BorderRadius.circular(24 * fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          3 * fem, 0 * fem, 0 * fem, 2 * fem),
                      child: Text(
                        'Warning',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 16 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.5 * ffem / fem,
                          color: const Color(0xff8e8e8e),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          3 * fem, 0 * fem, 0 * fem, 27 * fem),
                      child: Text(
                        'If you are concerned please seek a dermatologist help',
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 14 * ffem,
                          height: 1.5 * ffem / fem,
                          color: const Color(0xff8e8e8e),
                        ),
                      ),
                    ),
                    Container(
                      width: 196 * fem,
                      height: 44 * fem,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(49.8873214722 * fem),
                        gradient: const LinearGradient(
                          begin: Alignment(2.543, -1.776),
                          end: Alignment(-1.097, 1),
                          colors: <Color>[Color(0xff023994), Color(0xff12aaff)],
                          stops: <double>[0, 1],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            'Find nearest doctor',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: const Color(0xffeeeeee),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 30 * fem, 0 * fem, 0 * fem),
                width: double.infinity,
                height: 145 * fem,
                child: Stack(
                  children: [
                    Positioned(
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
                      left: 48 * fem,
                      top: 68 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 35 * fem,
                          height: 25 * fem,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/vector-LhU.png',
                              width: 35 * fem,
                              height: 25 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 223 * fem,
                      top: 67 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 27 * fem,
                          height: 27 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Profile(
                                        
                                          )));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/group-3-pwG.png',
                              width: 27 * fem,
                              height: 27 * fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
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
                                      builder: (context) => const FirestoreSettings.Settings()));
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
                      left: 49 * fem,
                      top: 99 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 36 * fem,
                          height: 15 * fem,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Results',
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
                      left: 222 * fem,
                      top: 99 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 31 * fem,
                          height: 15 * fem,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Profile(
                                  
                                          )));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Profile',
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
                                      builder: (context) => const FirestoreSettings.Settings()));
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
