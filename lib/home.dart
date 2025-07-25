import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:newno/login.dart';
import 'package:newno/profile.dart';
import 'package:path/path.dart' as path;
import 'package:epubx/epubx.dart';
import 'package:image/image.dart' as img;
import 'bookscreen.dart';
import 'library.dart';
import 'package:flutter/material.dart' as flutter;
class BooksHomeScreen extends StatefulWidget {
  @override
  _BooksHomeScreenState createState() => _BooksHomeScreenState();
}

class _BooksHomeScreenState extends State<BooksHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String stripHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '');
  }

  String gatherChapterText(List<EpubChapter>? chapters) {
    if (chapters == null || chapters.isEmpty) return '';

    final buffer = StringBuffer();

    for (final chapter in chapters) {
      if (chapter.HtmlContent != null && chapter.HtmlContent!.isNotEmpty) {
        buffer.writeln(stripHtmlTags(chapter.HtmlContent!));
        buffer.writeln('\n');
      }
      if (chapter.SubChapters != null && chapter.SubChapters!.isNotEmpty) {
        buffer.writeln(gatherChapterText(chapter.SubChapters));
      }
    }

    return buffer.toString();
  }
  Future<void> _pickAndOpenBook() async {
    const typeGroup = XTypeGroup(
      label: 'books',
      extensions: [ 'epub', 'txt'],
    );

    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null) {
      final ext = path.extension(file.path).toLowerCase();

      String content = '';

      if (ext == '.txt') {
        content = await File(file.path).readAsString();
      } else if (ext == '.epub') {
        final epubBytes = await File(file.path).readAsBytes();
        final book = await EpubReader.readBook(epubBytes);

        final chapters = book.Chapters;

        if (chapters != null && chapters.isNotEmpty) {
          content = gatherChapterText(chapters);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This file type is not supported')),
        );
        return;
      }

      if (content.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The file is empty and contains no content')),
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookScreen(
            content: content,
            fileName: path.basename(file.path),
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:Drawer(
        child: Container(
          color: Color(0xFF0D99C9).withOpacity(0.2),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              buildCustomDrawerHeader(context),

            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
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
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(child: Text("Library", style: TextStyle(color: Colors.white))),
            Tab(child: Text("My Book", style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: LibraryScreen()),
          Center(
            child: Text('Tap the + button to upload and read a book'),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
            colors: [
             Color(0xff787FF6),
             Color(0xFF7BD5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: _pickAndOpenBook,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add,color: Colors.white,),
        ),
      )
          : null,
    );
  }
}

Widget buildCustomDrawerHeader(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Column(
    children: [
      Container(
        height: screenHeight * 0.35,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(200),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(200),
          ),
          child: flutter.Image.asset(
            'assets/images/OIP.webp',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
      SizedBox(height: 50,),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: InkWell(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(100),
            topRight: Radius.circular(20),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ProfileScreen(),
            ),);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 10),
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),

      SizedBox(height: 20,),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: InkWell(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(100),
            topRight: Radius.circular(10),
          ),
          onTap: () {

            Navigator.pushReplacement(
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
            );

          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
            child: Row(
              children: [
                Icon(Icons.exit_to_app, color:  Colors.white),
                SizedBox(width: 10),
                const Text(
                  'Sign out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:  Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      )

    ]
  );
}


