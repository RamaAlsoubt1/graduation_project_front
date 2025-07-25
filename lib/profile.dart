import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gragh.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAnalysis = false;
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
                      Color(0xFF7BD5F5),
                      Color(0xFF1F2F98),
                    ],),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(200),

                  ),
                ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
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

                            ),
                          ],
                        ),
                        SizedBox(height: 3,),
                        const Text(
                          'Rama Alsoubt',
                          style: TextStyle(
                            fontSize: 18,

                            color: Colors.white,
                          ),

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

                            color: Colors.white,
                          ),

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

                  },
                  child: Text(
                    'Reset Password !',
                    style: TextStyle(
                      color:Color(0xFF1F2F98),
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