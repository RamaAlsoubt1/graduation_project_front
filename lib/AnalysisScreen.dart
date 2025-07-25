import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'gragh.dart';

class AnalysisScreen extends StatelessWidget {

  const AnalysisScreen({Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAnalysis = false;

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
                Color(0xFF7BD5F5),
                Color(0xFF1F2F98),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: hasAnalysis
            ? Text("Here is your analysis ...")
            : Text("No analyses available."),
      ),
    );
  }
}