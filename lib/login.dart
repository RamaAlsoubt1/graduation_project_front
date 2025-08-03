import 'package:flutter/material.dart';
import 'package:newno/library.dart';
import 'home.dart';
import 'otp.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

final Color primaryBlueLight = hexToColor('#7BD5F5'); // Light blue
final Color primaryPurpleBlue = hexToColor('#787FF6'); // Purple-blue (for gradient)
final Color primaryTeal = hexToColor('#4ADEDE');     // Teal
final Color primaryBlue = hexToColor('#1CA7CE');    // Medium blue
final Color primaryDarkBlue = hexToColor('#1F2F98');  // Dark blue


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final url = Uri.parse("http://10.161.240.99:80/api/v1/login/");
  final reqpassurl = Uri.parse("http://10.161.240.99:80/api/v1/password-reset-request/");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7BD5F5),
                      Color(0xFF1F2F98),
                    ]
                )
            ),
          ),
          Flex(
            direction: Axis.vertical,
            children:[
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Flexible(
                      flex: 5,
                      child: Stack(
                        children:[
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30,top: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            width: double.infinity,
                            height: double.infinity,
                            child:  SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all( 25.0),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        hintText: 'Enter your email',
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(color: primaryBlue, width: 1),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    TextField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(color: primaryBlue, width: 1),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () async {
                                          final email = _emailController.text.trim();
                                          if (email.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Please enter your email')),
                                            );
                                            return;
                                          }

                                          try {
                                            final response = await http.post(
                                              reqpassurl,
                                              headers: {'Content-Type': 'application/json'},
                                              body: jsonEncode({'email': email}),
                                            );

                                            final data = jsonDecode(response.body);
                                            print(data);
                                            if (response.statusCode == 200 && data['status'] == 'success') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => OtpScreen(email: email, isFromForgotPassword: true),
                                                ),
                                              );
                                            } else if (response.statusCode == 400) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(data['en'] ?? 'Invalid email')),
                                              );
                                            } else if (response.statusCode >= 500) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Server error, please try again later')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Unexpected error, please try again')),
                                              );
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Network error, please try again')),
                                            );
                                          }
                                        },
                                        child: Text(
                                          'Forgot Password ?',
                                          style: TextStyle(
                                            color: primaryBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                            activeColor: primaryBlue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Remember Me',
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),

                                        const Spacer(),

                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [primaryPurpleBlue, primaryTeal],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: primaryPurpleBlue.withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: MaterialButton(
                                                onPressed: () async {
                                                  final email = _emailController.text.trim();
                                                  final password = _passwordController.text;

                                                  if (email.isEmpty || password.isEmpty) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Please enter both email and password')),
                                                    );
                                                    return;
                                                  }

                                                  try {
                                                    final response = await http.post(
                                                      url,
                                                      headers: {'Content-Type': 'application/json'},
                                                      body: jsonEncode({'email': email, 'password': password}),
                                                    );

                                                    if (response.statusCode == 200) {
                                                      final data = jsonDecode(response.body);
                                                      print('response data: $data');
                                                      final access = data['access'];
                                                      final refresh = data['refresh'];
                                                      final user = data['user'];

                                                      final prefs = await SharedPreferences.getInstance();
                                                      await prefs.setString('access_token', access);
                                                      await prefs.setString('refresh_token', refresh);
                                                      await prefs.setString('user_email', user['email']);
                                                      await prefs.setString('user_role', user['role']);
                                                      await prefs.setString('user_uuid', user['uuid']);

                                                      if (_rememberMe) {
                                                        await prefs.setString('remembered_email', email);
                                                      }
                                                      else {
                                                        await prefs.remove('remembered_email');
                                                      }
                                                      await prefs.setBool('rememberMe', _rememberMe);

                                                      print('*********shared prefrence **************\n');
                                                      print('Access Token: ${prefs.getString('access_token')}');
                                                      print('Refresh Token: ${prefs.getString('refresh_token')}');
                                                      print('User Email: ${prefs.getString('user_email')}');
                                                      print('User Role: ${prefs.getString('user_role')}');
                                                      print('User UUID: ${prefs.getString('user_uuid')}');
                                                      print('Remembered Email: ${prefs.getString('remembered_email')}');
                                                      print('Remember Me: ${prefs.getBool('rememberMe')}');
                                                      print('***********************\n');

                                                      Navigator.pushAndRemoveUntil(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context, animation, secondaryAnimation) => BooksHomeScreen(),
                                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                            final tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                                                                .chain(CurveTween(curve: Curves.ease));
                                                            final offsetAnimation = animation.drive(tween);
                                                            return SlideTransition(position: offsetAnimation, child: child);
                                                          },
                                                        ),
                                                            (Route<dynamic> route) => false,
                                                      );
                                                    }
                                                    else if (response.statusCode == 400) {
                                                      final data = jsonDecode(response.body);
                                                      print(data);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text(data['en'] ?? 'Invalid credentials')),
                                                      );
                                                    }
                                                    else if (response.statusCode == 500) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Server error, please try again later')),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Unexpected error')),
                                                      );
                                                    }
                                                  }
                                                  catch (e, stackTrace) {
                                                    print('Error caught: $e');
                                                    print('Stack trace: $stackTrace');
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Network error')),
                                                    );
                                                  }
                                                },
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              padding: EdgeInsets.zero,
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [primaryPurpleBlue, primaryTeal],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'Sign In',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 30),

                                    // "Or" Divider
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        children: [
                                          Expanded(child: Divider(color: Colors.grey[300])),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(
                                              'Or',
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                          ),
                                          Expanded(child: Divider(color: Colors.grey[300])),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                               /*     Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.phone_android,
                                              size: 35,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {

                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 30),

                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.apple,
                                              size: 35,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {

                                            },
                                          ),
                                        ),
                                      ],
                                    ),*/

                                    const SizedBox(height: 20),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:[
                                        Text(
                                          'Don\'t have aacout?',
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => SignupScreen(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                  const begin = Offset(1.0, 0.0);
                                                  const end = Offset.zero;
                                                  const curve = Curves.ease;

                                                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                  final offsetAnimation = animation.drive(tween);

                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                                  //(Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: primaryBlue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],),
                                  ],
                                ),
                              ),
                            ),
                        ),
                            ),),

                        ], ),
                    ),
          ],),
        ],
      ),
    );
  }
}




