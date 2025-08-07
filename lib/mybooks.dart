import 'dart:convert';
import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bookscreen.dart';
import 'login.dart';

class MyBooksTab extends StatefulWidget {
  @override
  State<MyBooksTab> createState() => MyBooksTabState();
  MyBooksTab({Key? key}) : super(key: key);
}

class MyBooksTabState extends State<MyBooksTab>  {
  List<dynamic> myBooks = [];
  bool isLoading = true;
  final fetchuserbookurl = Uri.parse("http://10.161.240.99:80/api/v1/customer/books/");
  final refreshtokenurl=Uri.parse("http://10.161.240.99:80/api/v1/refresh/");
  Uri getDeleteUrl(String id) {
    return Uri.parse("http://10.161.240.99:80/api/v1/customer/books/$id/delete/");
  }

  @override
  void initState() {
    super.initState();
    fetchMyBooks();
  }

  Future<void> fetchMyBooks() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final String? refreshToken = prefs.getString('refresh_token');

    http.Response response = await http.get(
      fetchuserbookurl,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print("data_response: $data");
      print("without_refresh");
      setState(() {
        myBooks = data['data']['books'];
        isLoading = false;
      });
    }
    else if (response.statusCode == 401 && refreshToken != null) {
      final refreshResponse = await http.post(
        refreshtokenurl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (refreshResponse.statusCode == 200) {
        final refreshData = jsonDecode(refreshResponse.body);
        print("responce data $refreshData");
        print("access token after refresh");
        final newAccessToken = refreshData['access'];
        await prefs.setString('access_token', newAccessToken);
        accessToken = newAccessToken;

        response = await http.get(
          fetchuserbookurl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          print("data_response_after_refresh: $data");
          setState(() {
            myBooks = data['data']['books'];
            isLoading = false;
          });
        }
        else {
          print('Failed even after token refresh: ${response.body}');
          setState(() => isLoading = false);
        }
      }
      else {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session expired. Please log in again.')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
          );
        }
      }
    }
    else {
      print('Error fetching books: ${response.body}');
      setState(() => isLoading = false);
    }
  }


  Future<Directory> getAppBooksDirectory() async {
    if (Platform.isAndroid) {
      final downloadsDir = Directory('/storage/emulated/0/Download/MyAppBooks');
      if (await downloadsDir.exists()) {
        return downloadsDir;
      }
      else {
        await downloadsDir.create(recursive: true);
        return downloadsDir;
      }
    }
    return await getApplicationDocumentsDirectory();
  }


  String stripHtmlTags(String htmlText) {
    final exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '');
  }

  String gatherChapterText(List<EpubChapter>? chapters) {
    if (chapters == null) return '';
    final buffer = StringBuffer();
    for (var chapter in chapters) {
      if (chapter.HtmlContent != null) {
        buffer.writeln(stripHtmlTags(chapter.HtmlContent!));
        buffer.writeln('\n');
      }
      buffer.writeln(gatherChapterText(chapter.SubChapters));
    }
    return buffer.toString();
  }


  Future<void> deleteBook(String id, String title, String extension, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in again')),
      );
      return;
    }

    final response = await http.delete(
      getDeleteUrl(id),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print("response data : $data");
      print("access without refresh");

      // حذف الملف من مجلد التطبيق
      final dir = await getAppBooksDirectory();
      print('App books directory: ${dir.path}');
      final filePath = p.join(dir.path, '$title$extension');
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      setState(() {
        myBooks.removeWhere((book) => book['id'].toString() == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['en'] ?? 'The book has been deleted.')),
      );
    }

    else if (response.statusCode == 401 && refreshToken != null) {
      final refreshResponse = await http.post(
        refreshtokenurl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (refreshResponse.statusCode == 200) {
        final newTokens = json.decode(refreshResponse.body);
        final newAccessToken = newTokens['access'];
        await prefs.setString('access_token', newAccessToken);

        final del_response = await http.get(
          fetchuserbookurl,
          headers: {
            'Authorization': 'Bearer $newAccessToken',
            'Accept': 'application/json',
          },
        );

        if (del_response.statusCode == 200) {
          final data = json.decode(utf8.decode(del_response.bodyBytes));
          setState(() {
            myBooks = data['data']['books'];
            isLoading = false;
          });
        }
        else {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch data after token refresh')),
          );
        }
      }
      else {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session expired. Please login again.')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
          );
        }
      }
    }

    else {
      print('Delete error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete the book')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    if (myBooks.isEmpty) {
      return Center(child: Text("Tap the + button to upload and read a book"));
    }
    print('myBooks: $myBooks');
    return ListView.builder(
      itemCount: myBooks.length,
      itemBuilder: (context, index) {
        final book = myBooks[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(book['title'] ?? 'Untitled'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Color(0xFF1F2F98),),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Delete Book"),
                    content: Text("Are you sure you want to delete this book?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await deleteBook(
                    book['id'].toString(),
                    book['title'] ?? '',
                    book['file_extension'] ?? '',
                    context,
                  );
                }
              },
            ),
            onTap: () async {
              final dir = await getAppBooksDirectory();
              if (dir == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot access download directory')),
                );
                return;
              }

              final fileName = book['title'];
              if (fileName == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File name is missing')),
                );
                return;
              }

              final completefileName = book['title']! + book['file_extension']!;
              final filePath = p.join(dir.path, completefileName);
              final ext = book['file_extension'];
              String content = '';
              final file = File(filePath);

              if (!await file.exists()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('The file does not exist. Please re-upload it.'),
                  ),
                );
                return;
              }

              if (ext == '.txt') {
                content = await File(filePath).readAsString();
              }
              else if (ext == '.epub') {
                final epubBytes = await File(filePath).readAsBytes();
                final epubBook = await EpubReader.readBook(epubBytes);
                content = gatherChapterText(epubBook.Chapters ?? []);
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unsupported file type')),
                );
                return;
              }

              if (content.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This file is empty')),
                );
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BookScreen(
                    content: content,
                    fileName: book['title']!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );

  }

/*@override
  bool get wantKeepAlive => true;*/

}

