import 'package:flutter/material.dart';
//import 'signup.dart';

import 'login.dart';
// Helper function to convert hex string to Color object
Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

// Define the colors from the palette for easy use
final Color primaryBlueLight = hexToColor('#7BD5F5'); // Light blue
final Color primaryPurpleBlue = hexToColor('#787FF6'); // Purple-blue (for gradient)
final Color primaryTeal = hexToColor('#4ADEDE');     // Teal
final Color primaryBlue = hexToColor('#1CA7CE');    // Medium blue
final Color primaryDarkBlue = hexToColor('#1F2F98');  // Dark blue



class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  //bool _rememberMe = false; // State for the "Remember Me" checkbox
  bool _obscurePassword = true; // <-- Add this in your State class
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
                      Color(0xFF7BD5F5), // light blue
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
                            color: Colors.white, // White text on the dark gradient
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
                        color: Colors.white.withOpacity(0.3), // White background for the card
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),// Rounded corners for the card
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // Subtle shadow for depth
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
                        //padding: const EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for the card
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                          ),// Rounded corners for the card
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), // Subtle shadow for depth
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
                                //mainAxisSize: MainAxisSize.min, // Column takes minimum required space
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
                                 Row(
                                   children: [
                                     Expanded(
                                       child: TextField(
                                         decoration: InputDecoration(
                                           filled: true,
                                           fillColor: Colors.white, // Changed to pure white as per image 2
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(15), // Rounded corners for input
                                             borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Adding a very thin light grey border
                                           ),
                                           enabledBorder: OutlineInputBorder( // Add an enabled border for a slight outline
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5), // Very light grey border
                                           ),
                                           focusedBorder: OutlineInputBorder( // Focus border to match the theme
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: BorderSide(color: primaryBlue, width: 1),
                                           ),
                                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 5,),
                                     Expanded(
                                       child: TextField(
                                         decoration: InputDecoration(
                                           filled: true,
                                           fillColor: Colors.white, // Changed to pure white as per image 2
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(15), // Rounded corners for input
                                             borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Adding a very thin light grey border
                                           ),
                                           enabledBorder: OutlineInputBorder( // Add an enabled border for a slight outline
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5), // Very light grey border
                                           ),
                                           focusedBorder: OutlineInputBorder( // Focus border to match the theme
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: BorderSide(color: primaryBlue, width: 1),
                                           ),
                                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 5,),
                                     Expanded(
                                       child: TextField(
                                         decoration: InputDecoration(
                                           filled: true,
                                           fillColor: Colors.white, // Changed to pure white as per image 2
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(15), // Rounded corners for input
                                             borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Adding a very thin light grey border
                                           ),
                                           enabledBorder: OutlineInputBorder( // Add an enabled border for a slight outline
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5), // Very light grey border
                                           ),
                                           focusedBorder: OutlineInputBorder( // Focus border to match the theme
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: BorderSide(color: primaryBlue, width: 1),
                                           ),
                                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 5,),
                                     Expanded(
                                       child: TextField(
                                         decoration: InputDecoration(
                                           filled: true,
                                           fillColor: Colors.white, // Changed to pure white as per image 2
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(15), // Rounded corners for input
                                             borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Adding a very thin light grey border
                                           ),
                                           enabledBorder: OutlineInputBorder( // Add an enabled border for a slight outline
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5), // Very light grey border
                                           ),
                                           focusedBorder: OutlineInputBorder( // Focus border to match the theme
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: BorderSide(color: primaryBlue, width: 1),
                                           ),
                                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 5,),
                                     Expanded(
                                       child: TextField(
                                         decoration: InputDecoration(
                                           filled: true,
                                           fillColor: Colors.white, // Changed to pure white as per image 2
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(15), // Rounded corners for input
                                             borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Adding a very thin light grey border
                                           ),
                                           enabledBorder: OutlineInputBorder( // Add an enabled border for a slight outline
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5), // Very light grey border
                                           ),
                                           focusedBorder: OutlineInputBorder( // Focus border to match the theme
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: BorderSide(color: primaryBlue, width: 1),
                                           ),
                                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 5,),
                                     Expanded(
                                       child: TextField(
                                         decoration: InputDecoration(
                                           filled: true,
                                           fillColor: Colors.white, // Changed to pure white as per image 2
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(15), // Rounded corners for input
                                             borderSide: const BorderSide(color: Colors.grey, width: 0.5), // Adding a very thin light grey border
                                           ),
                                           enabledBorder: OutlineInputBorder( // Add an enabled border for a slight outline
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 0.5), // Very light grey border
                                           ),
                                           focusedBorder: OutlineInputBorder( // Focus border to match the theme
                                             borderRadius: BorderRadius.circular(15),
                                             borderSide: BorderSide(color: primaryBlue, width: 1),
                                           ),
                                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),


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
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                  const begin = Offset(1.0, 0.0); // Slide from right
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
                                            );
                                          },

                                          child: Text(
                                            'Log In',
                                            style: TextStyle(
                                              color: primaryBlue, // Medium blue for links
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],),

                                  SizedBox(height: 40,),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      const Spacer(),
                                      // Sign In Button with Gradient
                                      Expanded(
                                        // Takes available space next to the checkbox
                                        child: Container(
                                          height: 50, // Fixed height for the button
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [primaryPurpleBlue, primaryTeal], // Gradient as requested
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(15), // Rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryPurpleBlue.withOpacity(0.3), // Subtle shadow for button
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: MaterialButton(
                                            onPressed: () {
                                              // TODO: Implement sign in logic
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            padding: EdgeInsets.zero, // Remove default MaterialButton padding
                                            child: Ink(
                                              // Ink widget for a consistent gradient background for the touch ripple
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
                                                    color: Colors.white, // White text for button
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


