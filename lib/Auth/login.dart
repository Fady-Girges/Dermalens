import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermalens/pages/home.dart';
import 'package:dermalens/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String firstName = '';
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Fetch additional user data from Firestore
        final DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(userCredential.user!.uid).get();
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final String firstName = userData['firstName'];

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home(firstName: firstName)),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showErrorSnackbar(context, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          _showErrorSnackbar(context, 'Wrong password provided for that user.');
        } else {
          _showErrorSnackbar(context, 'Invalid Email or Password.');
        }
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: _isLoading
          ? Scaffold(
              backgroundColor: Colors.grey[900], // رمادي غامق
              body: Center(
                child: TweenAnimationBuilder(
                  duration: const Duration(seconds: 1), // مدة الدوران
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double turns, child) {
                    return RotationTransition(
                      turns: AlwaysStoppedAnimation(turns),
                      child: Image.asset(
                        'assets/page-1/images/ellipse-2-EMc.png',
                        width: 150,
                        height: 150,
                      ),
                    );
                  },
                  onEnd: () {
                    setState(() {});
                  },
                ),
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  // login page
                  width: double.infinity,
                  height: 852 * fem,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 21, 21, 21),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        Positioned(
                          // login banner
                          left: 26 * fem,
                          top: 146 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 113 * fem,
                              height: 60 * fem,
                              child: Text(
                                'Login',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 40 * ffem,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5 * ffem / fem,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // please login to continue
                          left: 26 * fem,
                          top: 206 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 250 * fem,
                              height: 24 * fem,
                              child: Text(
                                'Please login to continue',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.5 * ffem / fem,
                                  color: const Color(0xffaeaeae),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // forget password
                          left: 126 * fem,
                          top: 560 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 141 * fem,
                              height: 24 * fem,
                              child: TextButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: _email);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Sent via email"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Forget password?',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xff11a3f8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // if you dont have account
                          left: 87 * fem,
                          top: 704 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 223 * fem,
                              height: 24 * fem,
                              child: Text(
                                'You don’t have an account?',
                                style: SafeGoogleFont(
                                  'Poppins',
                                  fontSize: 16 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.5 * ffem / fem,
                                  color: const Color(0xffaeaeae),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // click here
                          left: 160 * fem,
                          top: 728 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 78 * fem,
                              height: 24 * fem,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Signup(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Click here',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xff11a3f8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // email input box
                          left: 26 * fem,
                          top: 269 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 345 * fem,
                              height: 67 * fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff262626),
                                  borderRadius: BorderRadius.circular(9.1428565979 * fem),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Image.asset('lib/icons/Email.png', scale: 2.5),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(18 * fem, 22 * fem, 50 * fem, 23 * fem),
                                    hintText: 'Email',
                                    hintStyle: const TextStyle(color: Color(0xffaeaeae)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _email = value!,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color.fromARGB(250, 255, 247, 247),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // password input box
                          left: 26 * fem,
                          top: 351 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 345 * fem,
                              height: 67 * fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1d),
                                  borderRadius: BorderRadius.circular(9.1428565979 * fem),
                                ),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Image.asset('lib/icons/Password.png', scale: 2.5),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(18 * fem, 22 * fem, 50 * fem, 21 * fem),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(color: Color(0xffaeaeae)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _password = value!,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color.fromARGB(250, 255, 247, 247),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // continue button
                          left: 62 * fem,
                          top: 491 * fem,
                          child: TextButton(
                            onPressed: () => _signInWithEmailAndPassword(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: 269 * fem,
                              height: 59 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(66 * fem),
                                gradient: const LinearGradient(
                                  begin: Alignment(2.543, -1.776),
                                  end: Alignment(-1.097, 1),
                                  colors: <Color>[Color(0xff023994), Color(0xff12aaff)],
                                  stops: <double>[0, 1],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Continue',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
