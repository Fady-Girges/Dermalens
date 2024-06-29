import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dermalens/pages/home.dart';
import 'package:dermalens/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dermalens/utils.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  String _mobilePhone = '';
  String? _selectedCountryCode;
  bool _isLoading = false;

  Future<void> _signUpWithUsernameAndEmailAndPassword(
      BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        // Check if the phone number already exists
        final QuerySnapshot result = await _firestore
            .collection('users')
            .where('phone', isEqualTo: _mobilePhone)
            .get();

        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isNotEmpty) {
          _showErrorSnackbar(context, 'The phone number is already in use.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // If the phone number is not in use, create a new user
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Save additional user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'phone': _mobilePhone,
        });

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Home(
                    firstName: _firstName,
                  )),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (e.code == 'weak-password') {
          _showErrorSnackbar(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showErrorSnackbar(
              context, 'The account already exists for that email.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar(context, 'An error occurred. Please try again.');
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
    return SafeArea(
      child: Scaffold(
          body: _isLoading
              ? Scaffold(
                  backgroundColor: Colors.grey[900], // رمادي غامق
                  body: Center(
                    child: TweenAnimationBuilder(
                      duration: const Duration(seconds: 1), // مدة الدوران
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double turns, child) {
                        return RotationTransition(
                          turns: AlwaysStoppedAnimation(
                              turns), // تغيير الزاوية التي يتم تدويرها هنا
                          child: Image.asset(
                            'assets/page-1/images/ellipse-2-EMc.png',
                            // اضبط العرض والارتفاع وفقًا لحجم صورتك
                            width: 150,
                            height: 150,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Stack(children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            26 * fem, 112 * fem, 22 * fem, 76 * fem),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 21, 21, 21),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // signup banner
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 198 * fem, 0 * fem),
                                child: Text(
                                  'Signup',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 40 * ffem,
                                    fontWeight: FontWeight.w800,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              ),
                              Container(
                                // please signup to continue
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 139 * fem, 41 * fem),
                                child: Text(
                                  'Please Signup to continue',
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color(0xffaeaeae),
                                  ),
                                ),
                              ),
                              Container(
                                // Email box
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 16 * fem),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff262626),
                                  borderRadius:
                                      BorderRadius.circular(9.1428565979 * fem),
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        18 * fem,
                                        19 * fem,
                                        120 * fem,
                                        22 * fem),
                                    hintText: 'Email',
                                    hintStyle: const TextStyle(
                                        color: Color(0xffaeaeae)),
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
                                    color: const Color.fromARGB(
                                        250, 255, 247, 247),
                                  ),
                                ),
                              ),
                              Container(
                                // name
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 16 * fem),
                                width: double.infinity,
                                height: 67 * fem,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // first name box
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 15 * fem, 0 * fem),
                                      width: 165 * fem,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1d1d1d),
                                        borderRadius: BorderRadius.circular(
                                            9.1428565979 * fem),
                                      ),
                                      child: TextFormField(
                                        controller: firstNameController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: 'First name',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20 * fem,
                                              horizontal: 15 * fem),
                                          hintStyle: const TextStyle(
                                              color: Color(0xffaeaeae)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your first name';
                                          }
                                          
                                          if (value.length < 3) {
                                            return 'At least three letters';
                                          }

                                          return null;
                                        },
                                        onSaved: (value) => _firstName = value!,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 2 * ffem / fem,
                                          color: const Color.fromARGB(
                                              250, 255, 247, 247),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // last name box
                                      width: 165 * fem,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1d1d1d),
                                        borderRadius: BorderRadius.circular(
                                            9.1428565979 * fem),
                                      ),
                                      child: TextFormField(
                                        controller: lastNameController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: 'Last name',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20 * fem,
                                              horizontal: 15 * fem),
                                          hintStyle: const TextStyle(
                                              color: Color(0xffaeaeae)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your last name';
                                          }

                                           if (value.length < 3) {
                                            return 'At least three letters';
                                          }

                                          return null;
                                        },
                                        onSaved: (value) => _lastName = value!,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 2 * ffem / fem,
                                          color: const Color.fromARGB(
                                              250, 255, 247, 247),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // password box
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 16 * fem),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1d),
                                  borderRadius:
                                      BorderRadius.circular(9.1428565979 * fem),
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        18 * fem, 23 * fem, 27 * fem, 20 * fem),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        color: Color(0xffaeaeae)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }

                                    if (value.length < 8) {
                                      return 'The weak password must be at least 8 words or numbers';
                                    }

                                    return null;
                                  },
                                  onSaved: (value) => _password = value!,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color.fromARGB(
                                        250, 255, 247, 247),
                                  ),
                                ),
                              ),
                              Container(
                                // confirm password box
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 16 * fem),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1d),
                                  borderRadius:
                                      BorderRadius.circular(9.1428565979 * fem),
                                ),
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        18 * fem, 21 * fem, 27 * fem, 22 * fem),
                                    hintText: 'Confirm Password',
                                    hintStyle: const TextStyle(
                                        color: Color(0xffaeaeae)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      return "Password does not match";
                                    }

                                    return null;
                                  },
                                  onSaved: (value) => _confirmPassword = value!,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.5 * ffem / fem,
                                    color: const Color.fromARGB(
                                        250, 255, 247, 247),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 16 * fem),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1d),
                                  borderRadius:
                                      BorderRadius.circular(9.1428565979 * fem),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80 * fem,
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedCountryCode,
                                        hint: const Text(
                                          '+20',
                                          style: TextStyle(
                                              color: Color(0xffaeaeae)),
                                        ),
                                        items: <String>[
                                          '+1',
                                          '+20',
                                          '+44',
                                          '+91'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  color: Color(0xffaeaeae)),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedCountryCode = newValue;
                                          });
                                        },
                                        dropdownColor: const Color(0xff1d1d1d),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15 * fem,
                                              horizontal: 15 * fem),
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 1.5 * ffem / fem,
                                          color: const Color(0xffaeaeae),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15 * fem,
                                              horizontal: 15 * fem),
                                          hintText: 'Phone',
                                          hintStyle: const TextStyle(
                                              color: Color(0xffaeaeae)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your phone number';
                                          }

                                          if (!RegExp(r'^[0-9]{10,15}$')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid phone number';
                                          }

                                          return null;
                                        },
                                        onSaved: (value) =>
                                            _mobilePhone = value!,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 1.5 * ffem / fem,
                                          color: const Color.fromARGB(
                                              250, 255, 247, 247),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // continue button
                                margin: EdgeInsets.fromLTRB(
                                    40 * fem, 0 * fem, 36 * fem, 16 * fem),
                                child: TextButton(
                                  onPressed: () =>
                                      _signUpWithUsernameAndEmailAndPassword(
                                          context),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 59 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(66 * fem),
                                      gradient: const LinearGradient(
                                        begin: Alignment(2.543, -1.776),
                                        end: Alignment(-1.097, 1),
                                        colors: <Color>[
                                          Color(0xff023994),
                                          Color(0xff12aaff)
                                        ],
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
                              Container(
                                // already have account
                                margin: EdgeInsets.fromLTRB(
                                    24 * fem, 0 * fem, 27 * fem, 0 * fem),
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // already have an account
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 6 * fem, 0 * fem),
                                      child: Text(
                                        'already have an account?',
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 1.5 * ffem / fem,
                                          color: const Color(0xffaeaeae),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      // click here
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                )),
    );
  }
}
