import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gragh.dart';

class AnalysisScreen extends StatelessWidget {
  //final String bookContent;

  const AnalysisScreen({Key? key,
   // required this.bookContent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For now, just simulate with placeholder text
    final hasAnalysis = false; // or true if you have analysis

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        actions: [

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GraphSceneWidget()),
              );
            },
            icon: const Icon(Icons.hub , color: Colors.white, size: 32),
          ),
        ],
        title: Text('Book Analyses',style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7BD5F5), // light blue
                Color(0xFF1F2F98), // deep blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: hasAnalysis
            ? Text("Here is your analysis ...") // Replace with real data later
            : Text("No analyses available."),
      ),
    );
  }
}