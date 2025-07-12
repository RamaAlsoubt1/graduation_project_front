import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';  // your plugin
import 'package:epubx/epubx.dart';

class BooksHomeScreen extends StatefulWidget {
  const BooksHomeScreen({super.key});

  @override
  State<BooksHomeScreen> createState() => _BooksHomeScreenState();
}

class _BooksHomeScreenState extends State<BooksHomeScreen> {
  String? _epubTitle;
  int? _chapterCount;
  String? _error;

  Future<void> pickAndReadEpub() async {
    setState(() {
      _epubTitle = null;
      _chapterCount = null;
      _error = null;
    });

    // Pick an epub file using file_selector
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'EPUB',
      extensions: ['epub'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) {
      setState(() {
        _error = 'No file selected';
      });
      print('No file selected');
      return;
    }

    print('Picked file path: ${file.path}');

    try {
      final fileBytes = await file.readAsBytes();
      print('File size in bytes: ${fileBytes.length}');

      final book = await EpubReader.readBook(fileBytes);
      print('EPUB metadata title: ${book.Title}');
      print('Number of chapters: ${book.Chapters?.length ?? 0}');

      setState(() {
        _epubTitle = book.Title ?? 'No title found';
        _chapterCount = book.Chapters?.length ?? 0;
      });

      if (_chapterCount == 0) {
        print('No chapters found in EPUB.');
      }
    } catch (e) {
      setState(() {
        _error = 'Error reading EPUB: $e';
      });
      print('Error reading EPUB: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EPUB Reader Debug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickAndReadEpub,
              child: const Text('Pick EPUB File'),
            ),
            const SizedBox(height: 20),
            if (_error != null) Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (_epubTitle != null) Text('Title: $_epubTitle'),
            if (_chapterCount != null) Text('Chapters: $_chapterCount'),
          ],
        ),
      ),
    );
  }
}
