import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bookscreen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
  bool get wantKeepAlive => true;
}

class _LibraryScreenState extends State<LibraryScreen> with AutomaticKeepAliveClientMixin {
  final List<Map<String, String>> libraryBooks = [
    {
      'title': 'Pride and Prejudice',
      'url': 'https://www.gutenberg.org/ebooks/1342.epub.noimages',
      'fileName': 'pride_and_prejudice.epub',
    },
    {
      'title': 'Frankenstein',
      'url': 'https://www.gutenberg.org/ebooks/84.epub.noimages',
      'fileName': 'frankenstein.epub',
    },
  ];

  final Map<String, double?> downloadProgress = {}; // fileName => progress (null = indeterminate)

  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) return dir;
    }
    return await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> downloadBook(String url, String fileName) async {
    final dir = await getDownloadDirectory();
    final filePath = p.join(dir.path, fileName);
    final file = File(filePath);

    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send();

    if (response.statusCode != 200) throw Exception('Failed to download file');

    final total = response.contentLength ?? 0;
    List<int> bytes = [];
    int received = 0;

    setState(() {
      downloadProgress[fileName] = null; // start indeterminate
    });

    final stream = response.stream.asBroadcastStream();
    await for (var chunk in stream) {
      bytes.addAll(chunk);
      received += chunk.length;

      final progress = total > 0 ? received / total : null;
      setState(() {
        downloadProgress[fileName] = progress;
      });
    }

    await file.writeAsBytes(bytes);
    setState(() {
      downloadProgress.remove(fileName);
    });



  }

  Future<void> openBook(String filePath) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7BD5F5), Color(0xFF1F2F98)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text("Opening book...", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(Duration(milliseconds: 100));

    try {
      final ext = p.extension(filePath).toLowerCase();
      String content = '';

      if (ext == '.epub') {
        final bytes = await File(filePath).readAsBytes();
        final book = await EpubReader.readBook(bytes);
        content = gatherChapterText(book.Chapters);
        if (content.isEmpty) content = 'No chapters found in EPUB.';
      } else if (ext == '.txt') {
        content = await File(filePath).readAsString();
      } else {
        content = 'Unsupported file type.';
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookScreen(
            content: content,
            fileName: p.basename(filePath),
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open book: $e")),
      );
    }
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

  String stripHtmlTags(String htmlText) {
    final exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '');
  }

  Future<void> handleBookTap(Map<String, String> book) async {
    final fileName = book['fileName']!;
    final url = book['url']!;
    final title = book['title']!;

    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied.')),
      );
      return;
    }

    final dir = await getDownloadDirectory();
    final filePath = p.join(dir.path, fileName);
    final file = File(filePath);

    if (await file.exists()) {
      await openBook(filePath);
    } else {
      final shouldDownload = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('File not found'),
          content: Text('Do you want to download "$title"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Download')),
          ],
        ),
      );

      if (shouldDownload == true) {
        try {
          await downloadBook(url, fileName);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download failed: $e")),
          );
          setState(() {
            downloadProgress.remove(fileName);
          });
          return;
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Downloaded '$fileName'. Open now?"),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => openBook(filePath),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<Directory>(
      future: getDownloadDirectory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final dir = snapshot.data!;

        return ListView.builder(
          itemCount: libraryBooks.length,
          itemBuilder: (context, index) {
            final book = libraryBooks[index];
            final fileName = book['fileName']!;
            final filePath = p.join(dir.path, fileName);
            final file = File(filePath);

            final isDownloading = downloadProgress.containsKey(fileName);
            final progress = downloadProgress[fileName];

            return FutureBuilder<bool>(
              future: file.exists(),
              builder: (context, fileSnapshot) {
                final fileExists = fileSnapshot.data ?? false;

                Widget trailingWidget;

                if (isDownloading) {
                  trailingWidget = SizedBox(
                    width: 24,
                    height: 24,
                    child: (progress == null)
                        ? CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFF1F2F98),
                    )
                        : CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      color: Color(0xFF1F2F98),
                    ),
                  );
                } else if (fileExists) {
                  trailingWidget = Icon(
                    Icons.check_circle,
                    color: Color(0xFF1F2F98),
                  );
                } else {
                  trailingWidget = Icon(
                    Icons.download_rounded,
                    color: Color(0xFF1F2F98),
                  );
                }

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(book['title'] ?? 'Unknown'),
                    trailing: trailingWidget,
                    onTap: () => handleBookTap(book),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

}
