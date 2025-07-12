
/*
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String email;

  const ProfileScreen({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الخلفية لون Gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7BD5F5), // أزرق فاتح
              Color(0xFF1F2F98), // أزرق غامق
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            padding: EdgeInsets.all(20),
            //margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85), // شفاف قليلاً
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1F2F98),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    username,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1F2F98),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      // TODO: أضف هنا منطق إعادة تعيين كلمة المرور
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reset Password tapped')),
                      );
                    },
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Color(0xFF1F2F98),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
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
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gragh.dart';

class ProfileScreen extends StatelessWidget {
  //final String bookContent;

  const ProfileScreen({Key? key,
    // required this.bookContent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For now, just simulate with placeholder text
    final hasAnalysis = false; // or true if you have analysis
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body:  Container(
        color: Color(0xFF0D99C9).withOpacity(0.2),
        child: Column(
            children: [
              Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7BD5F5), // light blue
                      Color(0xFF1F2F98),
                    ],),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(200),

                  ),
                ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              //  bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(200),
            ),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        Text(
                            'My Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:30,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                          ]  ),
                )
          ),
          ),


              ),
              SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(20),
                  ),

                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff787FF6),
                          Color(0xFF7BD5F5),
                        ],),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(100),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 10),
                            const Text(
                              'User Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                             // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 3,),
                        const Text(
                          'Rama Alsoubt',
                          style: TextStyle(
                            fontSize: 18,
                           // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          //textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    topLeft: Radius.circular(10),
                  ),
                  onTap: () {
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff787FF6),
                          Color(0xFF7BD5F5),
                        ],),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:  MainAxisAlignment.end,
                          children: [
                            Icon(Icons.email, color:  Colors.white),
                            SizedBox(width: 10),
                            const Text(
                              'Email Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:  Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 3,),
                        const Text(
                          'Ramabook2025@gmail.com',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password logic
                  },
                  child: Text(
                    'Reset Password !',
                    style: TextStyle(
                      color:Color(0xFF1F2F98), // Medium blue for links
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

            ]
        ),
      )
    );
  }
}