import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'package:flutter/services.dart';

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

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isFromForgotPassword;

  const OtpScreen({
    Key? key,
    required this.email,
    this.isFromForgotPassword = false,
  }) : super(key: key);


  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final url = Uri.parse("http://10.161.240.99:80/api/v1/verification/");
  final resendurl = Uri.parse("http://10.161.240.99:80/api/v1/resend-otp/");
  final forgotPasswordOtpVerifyUrl=Uri.parse("http://10.161.240.99:80/api/v1/password-reset-verify/");
  final resetPasswordOtpUrl=Uri.parse("http://10.161.240.99:80/api/v1/password-reset/");


  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryBlue, width: 1),
              ),
            ),
          ),
        );
      }),
    );
  }
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
                          'OTP',
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60.0),
                                    child: Text(
                                      'Please enter the 6-digit code sent to your phone/email. ',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  _buildOtpFields(),
                                  SizedBox(height: 20,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Text(
                                        'Already have an account ! ',
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
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
                                                  (Route<dynamic> route) => false,
                                            );
                                          },

                                          child: Text(
                                            'Log In',
                                            style: TextStyle(
                                              color: primaryBlue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],),

                                  SizedBox(height: 40,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed:() async {
                                            try {
                                              final response = await http.post(
                                                resendurl,
                                                headers: {'Content-Type': 'application/json'},
                                                body: jsonEncode({'email': widget.email}),
                                              );
                                              final data = jsonDecode(response.body);
                                              print('Resend status: ${response.statusCode}');
                                              print('Resend body: ${response.body}');

                                              if (response.statusCode == 200 && data['status'] == 'success')  {

                                                if (data['status'] == 'success') {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'تم إرسال رمز التحقق مرة أخرى')),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'فشل إرسال رمز التحقق')),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('خطأ في الاتصال بالخادم')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('خطأ في الاتصال بالخادم')),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Resend OTP !',
                                            style: TextStyle(
                                              color: primaryBlue,
                                              fontWeight: FontWeight.w600,
                                              //fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //const Spacer(),
                                     // const Spacer(),
                                      Expanded(
                                        flex: 1,
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
                                            onPressed: widget.isFromForgotPassword
                                                ?() async {
                                              String otp = _otpControllers.map((e) => e.text.trim()).join();
                                              if (otp.length < 6) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Please enter full 6-digit code')),
                                                );
                                                return;
                                              }

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) => const Center(child: CircularProgressIndicator()),
                                              );

                                              try {
                                                final response = await http.post(
                                                  forgotPasswordOtpVerifyUrl,
                                                  headers: {'Content-Type': 'application/json'},
                                                  body: jsonEncode({'email': widget.email, 'otp': otp}),
                                                );
                                                Navigator.of(context).pop();

                                                final data = jsonDecode(response.body);
                                                print(data);

                                                if (response.statusCode == 200 && data['status'] == 'success') {
                                                  final parentContext = context;

                                                  showDialog(
                                                    context: parentContext,
                                                    barrierDismissible: false,
                                                    builder: (dialogContext) {
                                                      bool _obscureNewPassword = true;
                                                      bool _obscureConfirmPassword = true;
                                                      String errorMessage = '';

                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return AlertDialog(
                                                            title: const Text('Enter New Password'),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                TextField(
                                                                  controller: _newPasswordController,
                                                                  obscureText: _obscureNewPassword,
                                                                  decoration: InputDecoration(
                                                                    labelText: 'New Password',
                                                                    suffixIcon: IconButton(
                                                                      icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          _obscureNewPassword = !_obscureNewPassword;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextField(
                                                                  controller: _confirmPasswordController,
                                                                  obscureText: _obscureConfirmPassword,
                                                                  decoration: InputDecoration(
                                                                    labelText: 'Confirm Password',
                                                                    suffixIcon: IconButton(
                                                                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (errorMessage.isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 10),
                                                                    child: Text(
                                                                      errorMessage,
                                                                      style: const TextStyle(color: Colors.red, fontSize: 13),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.of(dialogContext).pop(),
                                                                child: const Text('Cancel'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  final newPassword = _newPasswordController.text.trim();
                                                                  final confirmPassword = _confirmPasswordController.text.trim();

                                                                  String? validationError;

                                                                  if (newPassword.isEmpty || confirmPassword.isEmpty) {
                                                                    validationError = 'Please fill both password fields';
                                                                  } else if (newPassword.length < 7) {
                                                                    validationError = 'Password must be at least 7 characters long';
                                                                  } else if (newPassword != confirmPassword) {
                                                                    validationError = 'Passwords do not match';
                                                                  }

                                                                  if (validationError != null) {
                                                                    setState(() {
                                                                      errorMessage = validationError!;
                                                                    });
                                                                    return;
                                                                  }

                                                                  setState(() {
                                                                    errorMessage = '';
                                                                  });

                                                                  try {
                                                                    final resetResponse = await http.post(
                                                                      resetPasswordOtpUrl,
                                                                      headers: {'Content-Type': 'application/json'},
                                                                      body: jsonEncode({
                                                                        'email': widget.email,
                                                                        'new_password': newPassword,
                                                                      }),
                                                                    );

                                                                    final resetData = jsonDecode(resetResponse.body);

                                                                    if (resetResponse.statusCode == 200 && resetData['status'] == 'success') {
                                                                      Navigator.of(dialogContext).pop(); // أغلق dialog

                                                                      ScaffoldMessenger.of(parentContext).showSnackBar(
                                                                        SnackBar(
                                                                          content: Text(resetData['en'] ?? 'Password has been reset successfully.'),
                                                                          backgroundColor: Colors.green,
                                                                        ),
                                                                      );

                                                                      await Future.delayed(const Duration(seconds: 2));

                                                                      if (mounted) {
                                                                        Navigator.of(parentContext).pushReplacement(
                                                                          MaterialPageRoute(builder: (_) => LoginScreen()),
                                                                        );
                                                                      }
                                                                    } else if (resetResponse.statusCode == 400) {
                                                                      setState(() {
                                                                        errorMessage = resetData['en'] ?? 'Invalid input';
                                                                      });
                                                                    } else {
                                                                      setState(() {
                                                                        errorMessage = 'Server error. Please try again later.';
                                                                      });
                                                                    }
                                                                  } catch (e) {
                                                                    setState(() {
                                                                      errorMessage = 'Something went wrong. Please check your connection.';
                                                                    });
                                                                  }
                                                                },
                                                                child: const Text('Submit'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                } else if (response.statusCode == 400) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'Invalid OTP')),
                                                  );
                                                } else if (response.statusCode == 500) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'Server error')),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Unexpected error occurred')),
                                                  );
                                                }
                                              } catch (e) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Connection error')),
                                                );
                                              }
                                            }


                                                : () async {
                                              String otp = _otpControllers.map((e) => e.text.trim()).join();
                                              if (otp.length < 6) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Please enter full 6-digit code')),
                                                );
                                                return;
                                              }

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) => const Center(child: CircularProgressIndicator()),
                                              );

                                              try {
                                                final response = await http.post(
                                                  url,
                                                  headers: {'Content-Type': 'application/json'},
                                                  body: jsonEncode({'email': widget.email, 'otp': otp}),
                                                );
                                                Navigator.of(context).pop();

                                                final data = jsonDecode(response.body);
                                                print('Response status: ${response.statusCode}');
                                                print('Response body: ${response.body}');

                                                if (response.statusCode == 200 && data['status'] == 'success') {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'Verification successful')),
                                                  );
                                                  await Future.delayed(const Duration(milliseconds: 500));
                                                  Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                                        (route) => false,
                                                  );
                                                } else if (response.statusCode == 400) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'Invalid OTP')),
                                                  );
                                                } else if (response.statusCode == 500) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(data['en'] ?? 'Server error')),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Unexpected error occurred')),
                                                  );
                                                }
                                              } catch (e) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Connection error')),
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
                                                  'Verify',
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
                                      )

                                    ],
                                  ),
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


