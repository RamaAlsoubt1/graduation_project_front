import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:newno/login.dart';
import 'package:newno/profile.dart';
import 'package:path/path.dart' as path;
import 'package:epubx/epubx.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'bookscreen.dart';
import 'library.dart';
import 'package:flutter/material.dart' as flutter;

import 'mybooks.dart';

class BooksHomeScreen extends StatefulWidget {
  @override
  _BooksHomeScreenState createState() => _BooksHomeScreenState();
}

class _BooksHomeScreenState extends State<BooksHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDrawerOpen = false;
  final GlobalKey<MyBooksTabState> myBooksTabKey = GlobalKey<MyBooksTabState>();
  final GlobalKey<LibraryScreenState> libraryTabKey = GlobalKey<LibraryScreenState>();
  final uploadbookurl = Uri.parse("http://10.161.240.99:80/api/v1/customer/books/upload/");
  final refreshtokenurl=Uri.parse("http://10.161.240.99:80/api/v1/refresh/");
  static const String baseRequestUrl = "http://10.161.240.99:80/api/v1/customer/store/request/";
  Uri getRequestUrl(int bookId) {
    return Uri.parse('$baseRequestUrl$bookId/');
  }
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

  Future<File> pickAndSaveBookToAppFolder(XFile pickedFile) async {
    final downloadDir = Directory('/storage/emulated/0/Download/MyAppBooks');

    // إنشاء المجلد إذا غير موجود
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final fileName = path.basename(pickedFile.path);
    final newFile = File(path.join(downloadDir.path, fileName));

    // نسخ الملف
    final copied = await File(pickedFile.path).copy(newFile.path);
    return copied;
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
  /*Future<void> _pickAndOpenBook() async {
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
  }*/

  Future<void> showUploadDialog({
    required BuildContext context,
    required XFile bookFile,
    required String suggestedTitle,
    required VoidCallback onSuccess,
  }) async
  {
    final titleController = TextEditingController(text: suggestedTitle);
    bool allowReview = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // لازم يختار OK أو Cancel
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Book Upload'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Respecting your privacy, do you allow review of your book for public library addition if appropriate?'),
              SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Book Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: allowReview,
                    onChanged: (val) {
                      setState(() {
                        allowReview = val ?? false;
                      });
                    },
                  ),
                  Flexible(child: Text('I allow my book to be reviewed and added publicly'))
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                String? accessToken = prefs.getString('access_token');
                final refreshToken = prefs.getString('refresh_token');

                if (accessToken == null || refreshToken == null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                  );
                  return;
                }

                Future<http.Response> uploadBook(String token) async {
                  final request = http.MultipartRequest('POST', uploadbookurl);
                  request.headers['Authorization'] = 'Bearer $token';
                  request.fields['title'] = titleController.text;
                  request.fields['allowReview'] = allowReview ? 'true' : 'false';
                  request.files.add(await http.MultipartFile.fromPath('file', bookFile.path));

                  final streamedResponse = await request.send();
                  return await http.Response.fromStream(streamedResponse);
                }

                Future<http.Response> sendBookRequest(String token, int bookId) async {
                  final requestUrl = getRequestUrl(bookId);

                  // دالة داخلية لإرسال الطلب
                  Future<http.Response> makeRequest(String token) {
                    return http.post(
                      requestUrl,
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Accept': 'application/json',
                      },
                    );
                  }

                  http.Response response = await makeRequest(token);

                  if (response.statusCode == 401) {
                    // التوكن انتهت صلاحيته → نحتاج نستخدم refresh token
                    final prefs = await SharedPreferences.getInstance();
                    final refreshToken = prefs.getString('refresh_token');

                    if (refreshToken == null) {
                      throw Exception('No refresh token found.');
                    }

                    // أرسل طلب تجديد التوكن
                    final refreshResponse = await http.post(
                      refreshtokenurl,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'refresh': refreshToken}),
                    );

                    if (refreshResponse.statusCode == 200) {
                      final newAccessToken = jsonDecode(refreshResponse.body)['access'];
                      print("newAccessToken $newAccessToken");
                      await prefs.setString('access_token', newAccessToken);

                      // أعد المحاولة بالتوكن الجديد
                      response = await makeRequest(newAccessToken);
                    }
                    else {
                      throw Exception('Failed to refresh token');
                    }
                  }

                  return response;
                }


                http.Response response = await uploadBook(accessToken);

                if (response.statusCode == 401) {
                  final refreshResponse = await http.post(
                    refreshtokenurl,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'refresh': refreshToken}),
                  );

                  if (refreshResponse.statusCode == 200) {
                    final refreshData = jsonDecode(refreshResponse.body);
                    final newAccessToken = refreshData['access'];
                    await prefs.setString('access_token', newAccessToken);
                    accessToken = newAccessToken;

                    response = await uploadBook(accessToken!);
                  } else {
                    await prefs.remove('access_token');
                    await prefs.remove('refresh_token');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Session expired. Please log in again.')),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                    );
                    return;
                  }
                }

                if (response.statusCode == 200 || response.statusCode == 201) {
                  final responseData = json.decode(response.body);
                  print("Upload success response: $responseData");

                  final bookId = responseData['data']['book']['id'] as int;

                  // استدعاء طلب الموافقة على الكتاب
                  final requestResponse = await sendBookRequest(accessToken!, bookId);
                  print("Book request response: ${requestResponse.statusCode} - ${requestResponse.body}");

                  if (requestResponse.statusCode == 200 || requestResponse.statusCode == 201) {
                    final requestData = json.decode(requestResponse.body);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(requestData['en'] ?? 'Book request submitted successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to submit book request')),
                    );
                  }

                  onSuccess(); // نعلم الشاشة تعيد تحميل الكتب
                  Navigator.of(context).pop();
                } else {
                  print('Upload failed: ${response.body}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload the book')),
                  );
                }
              },
              child: Text('OK'),
            ),

          ],
        ),
      ),
    );
    }

  Future<void> _pickAndUploadBook() async {
    const typeGroup = XTypeGroup(
      label: 'books',
      extensions: ['epub', 'txt'],
    );

    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    // نستخدم basename بدون امتداد كعنوان مقترح
    final suggestedTitle = path.basenameWithoutExtension(file.path);

    // نعرض dialog لإدخال العنوان والسماح بالمراجعة
    await showUploadDialog(
      context: context,
      bookFile: file,
      suggestedTitle: suggestedTitle,
      onSuccess: () {
        myBooksTabKey.currentState?.fetchMyBooks(); // بعد نجاح الرفع
      },
    );

    final savedFile = await pickAndSaveBookToAppFolder(file);
    // هنا تقدر تأخذ القيم من showUploadDialog لو عدلتها لإرجاع القيم

    final ext = path.extension(savedFile.path).toLowerCase();

    String content = '';

    if (ext == '.txt') {
      content = await File(file.path).readAsString();
    }
    else if (ext == '.epub') {
      final epubBytes = await File(file.path).readAsBytes();
      final book = await EpubReader.readBook(epubBytes);

      final chapters = book.Chapters;

      if (chapters != null && chapters.isNotEmpty) {
        content = gatherChapterText(chapters);
      }
    }
    else {
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

    /*Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookScreen(
          content: content,
          fileName: path.basename(file.path),
        ),
      ),
    );*/

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:Drawer(
        child: Container(
         // color: Color(0xFF0D99C9).withOpacity(0.2),
          color: Colors.white,
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
          Center(child: LibraryScreen(
              key: libraryTabKey,
          )),
          Center(
            child: MyBooksTab(key: myBooksTabKey),
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
          onPressed: _pickAndUploadBook,
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
          onTap: () async {
            Navigator.of(context).pop();
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');
            await prefs.remove('refresh_token');
            await prefs.remove('rememberMe');
            await prefs.remove('user_email');
            await prefs.remove('user_uuid');
            await prefs.remove('user_role');
            await prefs.remove('remembered_email');

            print('--- SharedPreferences after logout ---');
            prefs.getKeys().forEach((key) {
              print('$key: ${prefs.get(key)}');
            });
            print('-----------------------------------------');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logged out successfully'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black,
              ),
            );

            await Future.delayed(Duration(milliseconds: 1300));

            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
                  (Route<dynamic> route) => false,
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



