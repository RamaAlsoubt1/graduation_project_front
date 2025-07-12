import 'package:flutter/material.dart';
import 'AnalysisScreen.dart';

class BookScreen extends StatefulWidget {
  final String content;
  final String fileName;

  const BookScreen({
    super.key,
    required this.content,
    required this.fileName,
  });

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late List<String> pages;
  late PageController _pageController;

  double fontSize = 18;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    final cleanedContent = formatParagraphs(cleanText(widget.content));
    pages = paginateText(cleanedContent, 1000);
    _pageController = PageController(initialPage: currentPage);
  }

  String cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\n\s*\n'), '\n') // Remove empty lines
        .replaceAll(RegExp(r'\s+'), ' ')      // Remove extra spaces
        .trim();
  }

  String formatParagraphs(String text) {
    return text.replaceAllMapped(
      RegExp(r'([.!؟])\s+'),
          (match) => '${match.group(1)}\n\n',
    );
  }

  List<String> paginateText(String text, int maxCharsPerPage) {
    List<String> words = text.split(RegExp(r'\s+'));
    List<String> pages = [];
    StringBuffer currentPage = StringBuffer();

    for (var word in words) {
      if ((currentPage.length + word.length + 1) <= maxCharsPerPage) {
        currentPage.write(word + ' ');
      } else {
        pages.add(currentPage.toString().trim());
        currentPage = StringBuffer();
        currentPage.write(word + ' ');
      }
    }

    if (currentPage.isNotEmpty) {
      pages.add(currentPage.toString().trim());
    }

    return pages;
  }

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.fileName)),
        body: const Center(child: Text('No content to display.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Text(widget.fileName, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              setState(() {
                fontSize += 2;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () {
              setState(() {
                fontSize = fontSize > 10 ? fontSize - 2 : fontSize;
              });
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AnalysisScreen()),
              );
            },
            icon: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7BD5F5), Color(0xFF1F2F98)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child:SelectableText(
                      pages[index],
                      style: TextStyle(fontSize: fontSize, height: 1.6),
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },
            ),
          ),
          Slider(
            inactiveColor: const Color(0xff787FF6).withOpacity(0.5),
            activeColor: const Color(0xff787FF6),
            value: currentPage.toDouble(),
            min: 0,
            max: (pages.length - 1).toDouble(),
            divisions: pages.length > 1 ? pages.length - 1 : 1,
            label: 'Page ${currentPage + 1}',
            onChanged: (value) {
              setState(() {
                currentPage = value.toInt();
                _pageController.jumpToPage(currentPage);
              });
            },
          ),
        ],
      ),
    );
  }
}
