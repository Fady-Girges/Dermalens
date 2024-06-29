import 'package:dermalens/pages/home.dart';
import 'package:dermalens/pages/profile.dart';
import 'package:dermalens/pages/results.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/utils.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
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
          // settings4AA (67:144)
          padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
          width: double.infinity,
          decoration: const BoxDecoration (
            color: Color.fromARGB(255, 21, 21, 21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30*fem),
                width: 16*fem,
                height: 16*fem,
              ),
              Container(
                // log out box
                margin: EdgeInsets.fromLTRB(24*fem, 30*fem, 24*fem, 505*fem),
                child: TextButton(
                onPressed: () async {
                    try {
                          _toggleLoading(); // بداية التحميل
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            'login',
                            (route) => false,
                          );
                        } catch (e) {
                          print('Error signing out: $e');
                          // Handle any errors that might occur during the sign-out process
                        } finally {
                          _toggleLoading();
                      // Handle any errors that might occur during the sign-out process
                    }
                  },
                  style: TextButton.styleFrom (
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(27*fem, 23*fem, 27*fem, 20*fem),
                    width: double.infinity,
                    decoration: BoxDecoration (
                      color: const Color(0xff1d1d1d),
                      borderRadius: BorderRadius.circular(9.1428565979*fem),
                    ),
                    child: Text(
                      'Log out',
                      style: SafeGoogleFont (
                        'Poppins',
                        fontSize: 16*ffem,
                        fontWeight: FontWeight.w300,
                        height: 1.5*ffem/fem,
                        color: const Color(0xffaeaeae),
                      ),
                    ),
                  ),
                ),
              ),
                Container(
                margin: EdgeInsets.fromLTRB(0*fem,0*fem, 0*fem,  0*fem),
                width: double.infinity,
                height: 150*fem,
                child: Stack(
                  children: [
                    Positioned(
                      // navi
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
                      // home icon
                      left: 139*fem,
                      top: 67*fem,
                      child: Align(
                        child: SizedBox(
                          width: 28*fem,
                          height: 28*fem,
                          child: TextButton(
                            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(firstName: '',))
                      );},
                            style: TextButton.styleFrom (
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/vector-7wt.png',
                              width: 28*fem,
                              height: 28*fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // results icon 
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
                              'assets/page-1/images/vector-Kmx.png',
                              width: 35*fem,
                              height: 25*fem,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // profile icon
                      left: 223*fem,
                      top: 67*fem,
                      child: Align(
                        child: SizedBox(
                          width: 27*fem,
                          height: 27*fem,
                          child: TextButton(
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())
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
                      // settings icon
                      left: 306*fem,
                      top: 68*fem,
                      child: Align(
                        child: SizedBox(
                          width: 25*fem,
                          height: 26*fem,
                          child: TextButton(
                            onPressed: () {
                      },
                            style: TextButton.styleFrom (
                              padding: EdgeInsets.zero,
                            ),
                            child: Image.asset(
                              'assets/page-1/images/vector-jFU.png',
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
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(firstName: '',))
                      );},
                            style: TextButton.styleFrom (
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'home',
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
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile())
                      );},
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
                      // setting text
                      left: 299*fem,
                      top: 99*fem,
                      child: Align(
                        child: SizedBox(
                          width: 41*fem,
                          height: 15*fem,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom (
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Settings',
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
                    if (_isLoading)
           Center(
  child: TweenAnimationBuilder(
    duration: const Duration(seconds: 1),
    tween: Tween<double>(begin: 0, end: 1),
    builder: (BuildContext context, double value, Widget? child) {
      return Transform.rotate(
        angle: value * 2 * 3.141,
         child: Image.asset('assets/page-1/images/ellipse-2-EMc.png') 
      );
    },
  ),
)
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