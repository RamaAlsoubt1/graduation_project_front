/*
import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';


class RelationshipExample extends StatelessWidget {
  const RelationshipExample({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Graph Example')),
        body: const GraphExample(),
      ),
    );
  }
}

class GraphExample extends StatefulWidget {
  const GraphExample({super.key});
  @override
  State<GraphExample> createState() => _GraphExampleState();
}

class _GraphExampleState extends State<GraphExample> {
  final GraphData data = GraphData(
    [
      {'id': '1', 'label': 'عليش'},
      {'id': '2', 'label': 'رءوف علوان'},
      {'id': '3', 'label': 'الرجل'},
    ],
    [
      {'srcId': '1', 'dstId': '2', 'edgeName': 'صداقة'},
      {'srcId': '3', 'dstId': '1', 'edgeName': 'أستاذية'},
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GraphView(
      graphData: data,
      algorithm: SugiyamaAlgorithm(),
      builder: (context, node) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(node.data['label'] ?? '',
                style: const TextStyle(fontSize: 16)),
          ),
        );
      },
      edgeLabelBuilder: (context, edge) {
        return Text(edge.data['edgeName'] ?? '',
            style: const TextStyle(color: Colors.red));
      },
    );
  }
}
*/