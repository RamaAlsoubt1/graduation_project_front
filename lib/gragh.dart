/*import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class RelationshipGraph extends StatefulWidget {
  @override
  State<RelationshipGraph> createState() => _RelationshipGraphState();
}

class _RelationshipGraphState extends State<RelationshipGraph> {
  final Graph graph = Graph();
  final Map<String, Node> nodes = {};
  int dummyCounter = 0;

  final List<Map<String, String>> relations = [
    {'from': 'الرجل', 'to': 'نبوية', 'type': 'خيانة'},
    {'from': 'الرجل', 'to': 'عليش', 'type': 'صداقة سابقة'},
    {'from': 'الرجل', 'to': 'رءوف علوان', 'type': 'صداقة وأستاذية'},
    {'from': 'الرجل', 'to': 'سناء', 'type': 'أبوة'},
    {'from': 'الرجل', 'to': 'المرأة (حاملة سناء)', 'type': 'زوجة سابقة؟'},
    {'from': 'الرجل', 'to': 'الشيخ علي', 'type': 'مريد وشيخ'},

    {'from': 'نبوية', 'to': 'عليش', 'type': 'اسمان أصبحا واحداً'},
    {'from': 'نبوية', 'to': 'سناء', 'type': 'أمومة'},
    {'from': 'نبوية', 'to': 'سعيد مهران', 'type': 'خيانة'},
    {'from': 'نبوية', 'to': 'سعيد مهران', 'type': 'حب وخطوبة'},

    {'from': 'عليش', 'to': 'الرجل', 'type': 'خيانة وصداقة سابقة'},
    {'from': 'عليش', 'to': 'سناء', 'type': 'أبوة بالتبني'},
    {'from': 'عليش سدرة', 'to': 'سعيد مهران', 'type': 'عداوة'},
    {'from': 'عليش سدرة', 'to': 'نبوية', 'type': 'اسمان أصبحا واحداً'},

    {'from': 'سناء', 'to': 'الرجل/اللص', 'type': 'أبوة'},
    {'from': 'سناء', 'to': 'عليش', 'type': 'أبوة بالتبني'},

    {'from': 'سعيد مهران', 'to': 'نبوية', 'type': 'حب وخطوبة'},
    {'from': 'سعيد مهران', 'to': 'رءوف علوان', 'type': 'صداقة قديمة'},
    {'from': 'سعيد مهران', 'to': 'رءوف علوان', 'type': 'عداء'},
    {'from': 'سعيد مهران', 'to': 'معلم القهوة طرزان', 'type': 'صداقة'},
    {'from': 'سعيد مهران', 'to': 'زبائن المقهى', 'type': 'صداقة'},
    {'from': 'سعيد مهران', 'to': 'نور', 'type': 'حب واستغلال ثم سرقة'},
    {'from': 'سعيد مهران', 'to': 'الشيخ علي الجنيدي', 'type': 'مرشد وتلميذ'},
    {'from': 'سعيد مهران', 'to': 'المعلم بياظة', 'type': 'معرفة'},
    {'from': 'سعيد مهران', 'to': 'الوايلي', 'type': 'لا علاقة واضحة'},
    {'from': 'سعيد مهران', 'to': 'عابد', 'type': 'منفعة وتبعية'},
    {'from': 'سعيد مهران', 'to': 'عم مهران', 'type': 'زمالة وصداقة'},
    {'from': 'أم سعيد مهران', 'to': 'سعيد مهران', 'type': 'أمومة'},

    {'from': 'نور', 'to': 'صاحبها', 'type': 'غير متكافئة'},

    {'from': 'الشيخ علي', 'to': 'سعيد مهران', 'type': 'مريد وشيخ'},
    {'from': 'الشيخ علي', 'to': 'عم مهران', 'type': 'مودة'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'سعيد مهران', 'type': 'مرشد قديم'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'عم مهران', 'type': 'مودة'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'أهل الذكر', 'type': 'شيخ بمريديه'},

    {'from': 'عم مهران', 'to': 'الشيخ علي الجنيدي', 'type': 'مودة'},
  ];

  final SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..nodeSeparation = 70
    ..levelSeparation = 150;

  @override
  void initState() {
    super.initState();

    for (var rel in relations) {
      final from = rel['from']!;
      final to = rel['to']!;
      final type = rel['type']!;

      nodes.putIfAbsent(from, () => Node.Id(from));
      nodes.putIfAbsent(to, () => Node.Id(to));

      // عقدة العلاقة كنص في المنتصف
      final dummyId = '__label_${dummyCounter++}';
      final dummyNode = Node(getEdgeLabel(type));
      nodes[dummyId] = dummyNode;

      graph.addNode(dummyNode);
      graph.addEdge(nodes[from]!, dummyNode);
      graph.addEdge(dummyNode, nodes[to]!);
    }
  }

  Widget getNodeWidget(String label) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 36, color: Colors.blueGrey),
          SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget getEdgeLabel(String text) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("شبكة علاقات الشخصيات")),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: EdgeInsets.all(200),
        minScale: 0.1,
        maxScale: 5,
        child: GraphView(
          graph: graph,
          algorithm: SugiyamaAlgorithm(builder),
          builder: (Node node) {
            final key = node.key?.value;
            if (key != null && key.toString().startsWith('__label_')) {
              return node.key!.value;
            }
            return getNodeWidget(key.toString());
          },
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class RelationsGraphScreen extends StatefulWidget {
  @override
  _RelationsGraphScreenState createState() => _RelationsGraphScreenState();
}

class _RelationsGraphScreenState extends State<RelationsGraphScreen> {
  final Graph graph = Graph();
  late final BuchheimWalkerConfiguration builder;

  // بيانات العلاقات كمثال (from, to, type)
  final List<Map<String, String>> relations = [
    {'from': 'الرجل', 'to': 'نبوية', 'type': 'خيانة'},
    {'from': 'الرجل', 'to': 'عليش', 'type': 'صداقة سابقة'},
    {'from': 'الرجل', 'to': 'رءوف علوان', 'type': 'صداقة وأستاذية'},
    {'from': 'الرجل', 'to': 'سناء', 'type': 'أبوة'},
    {'from': 'الرجل', 'to': 'المرأة (حاملة سناء)', 'type': 'زوجة سابقة؟'},
    {'from': 'الرجل', 'to': 'الشيخ علي', 'type': 'مريد وشيخ'},

    {'from': 'نبوية', 'to': 'عليش', 'type': 'اسمان أصبحا واحداً'},
    {'from': 'نبوية', 'to': 'سناء', 'type': 'أمومة'},
    {'from': 'نبوية', 'to': 'سعيد مهران', 'type': 'خيانة'},
    {'from': 'نبوية', 'to': 'سعيد مهران', 'type': 'حب وخطوبة'},
  ];

  // خريطة للاحتفاظ بالعقد حسب الاسم لتجنب التكرار
  final Map<String, Node> nodesMap = {};

  @override
  void initState() {
    super.initState();

    // بناء العقد (nodes) لكل شخصية
    for (var rel in relations) {
      if (!nodesMap.containsKey(rel['from'])) {
        nodesMap[rel['from']!] = Node.Id(rel['from']!);
      }
      if (!nodesMap.containsKey(rel['to'])) {
        nodesMap[rel['to']!] = Node.Id(rel['to']!);
      }
    }

    // إضافة العقد للـ graph
    nodesMap.values.forEach(graph.addNode);

    // إضافة الحواف (edges) مع العلم أن المكتبة لا تعرض النص على الحواف بشكل مباشر
    // لكن هذا ينشئ العلاقات بين العقد
    for (var rel in relations) {
      var fromNode = nodesMap[rel['from']]!;
      var toNode = nodesMap[rel['to']]!;
      graph.addEdge(fromNode, toNode);
    }

    // إعدادات الرسم (layout)
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (20)
      ..levelSeparation = (30)
      ..subtreeSeparation = (30)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Graph Relations')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            constrained: false,  // أو جرب true
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.01,
            maxScale: 5.6,
            child: SizedBox(
              width: constraints.maxWidth > 1000 ? constraints.maxWidth : 1000,
              height: constraints.maxHeight > 800 ? constraints.maxHeight : 800,
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                builder: (Node node) {
                  String id = node.key!.value as String;
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      id,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(child: GraphSceneWidget()),
    ),
  ));
}

class GraphSceneWidget extends StatelessWidget {
  const GraphSceneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.5,
      maxScale: 3.0,
      child: SceneBuilderWidget(
        builder: () => SceneController(front: GraphScene()),
      ),
    );
  }
}

class GraphScene extends GSprite {
  final relationships = [
    {'from': 'الشيخ علي', 'to': 'سعيد مهران', 'type': 'مريد وشيخ'},
    {'from': 'الشيخ علي', 'to': 'عم مهران', 'type': 'مودة'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'سعيد مهران', 'type': 'مرشد قديم'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'عم مهران', 'type': 'مودة'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'أهل الذكر', 'type': 'شيخ بمريديه'},
    {'from': 'عم مهران', 'to': 'الشيخ علي الجنيدي', 'type': 'مودة'},
    {'from': 'سعيد مهران', 'to': 'نبوية', 'type': 'حب وخطوبة'},
    {'from': 'سعيد مهران', 'to': 'رءوف علوان', 'type': 'صداقة قديمة'},
    {'from': 'سعيد مهران', 'to': 'رءوف علوان', 'type': 'عداء'},
    {'from': 'سعيد مهران', 'to': 'معلم القهوة طرزان', 'type': 'صداقة'},
    {'from': 'سعيد مهران', 'to': 'زبائن المقهى', 'type': 'صداقة'},
    {'from': 'سعيد مهران', 'to': 'نور', 'type': 'حب واستغلال ثم سرقة'},
    {'from': 'سعيد مهران', 'to': 'الشيخ علي الجنيدي', 'type': 'مرشد وتلميذ'},
    {'from': 'سعيد مهران', 'to': 'المعلم بياظة', 'type': 'معرفة'},
    {'from': 'سعيد مهران', 'to': 'الوايلي', 'type': 'لا علاقة واضحة'},
    {'from': 'سعيد مهران', 'to': 'عابد', 'type': 'منفعة وتبعية'},
    {'from': 'سعيد مهران', 'to': 'عم مهران', 'type': 'زمالة وصداقة'},
    {'from': 'أم سعيد مهران', 'to': 'سعيد مهران', 'type': 'أمومة'},
  ];

  final nodes = <String, GraphNode>{};

  @override
  void addedToStage() {
    _drawGraph();
  }

  void _drawGraph() {
    stage!.color = Colors.white;

    final centerX = stage!.stageWidth / 2;
    final centerY = stage!.stageHeight / 2;
    final radius = 200.0;
    double angle = 0;

    final uniqueNames = relationships
        .expand((e) => [e['from'], e['to']])
        .toSet()
        .toList();

    for (var i = 0; i < uniqueNames.length; i++) {
      final name = uniqueNames[i]!;
      final node = GraphNode(name);
      nodes[name] = node;

      final rad = angle * pi / 180;
      node.x = centerX + radius * cos(rad);
      node.y = centerY + radius * sin(rad);

      addChild(node);

      angle += 360 / uniqueNames.length;
    }

    for (final rel in relationships) {
      final from = nodes[rel['from']]!;
      final to = nodes[rel['to']]!;
      final label = rel['type']!;
      final edge = GraphEdge(from, to, label: label);
      addChild(edge);
    }
  }
}

class GraphNode extends GSprite {
  final String name;

  GraphNode(this.name) {
    final shape = GShape();
    shape.graphics
      ..beginFill(Colors.orange.shade100)
      ..lineStyle(2, Colors.deepOrange)
      ..drawRoundRect(0, 0, 100, 40, 12)
      ..endFill();
    addChild(shape);

    final label = GText(
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    label.text = name;
    label.x = 10;
    label.y = 12;
    addChild(label);

    pivotX = 50;
    pivotY = 20;

    mouseChildren = false;
  }
}

class GraphEdge extends GSprite {
  GraphEdge(GraphNode from, GraphNode to, {required String label}) {
    final line = GShape();

    final p1 = Offset(from.x, from.y);
    final p2 = Offset(to.x, to.y);

    final fromRect = Rect.fromLTWH(
      from.x - from.pivotX,
      from.y - from.pivotY,
      100,
      40,
    );

    final toRect = Rect.fromLTWH(
      to.x - to.pivotX,
      to.y - to.pivotY,
      100,
      40,
    );

    final startPoint = lineRectIntersection(p2: p1, p1: p2, rect: fromRect);
    final endPoint = lineRectIntersection(p1: p1, p2: p2, rect: toRect);

    line.graphics
      ..lineStyle(1, Colors.black)
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy);
    addChild(line);

    final dx = endPoint.dx - startPoint.dx;
    final dy = endPoint.dy - startPoint.dy;
    final angle = atan2(dy, dx);

    final arrow = GShape();
    arrow.graphics
      ..beginFill(Colors.black)
      ..moveTo(0, 0)
      ..lineTo(-8, 4)
      ..lineTo(-8, -4)
      ..lineTo(0, 0)
      ..endFill();
    arrow.rotation = angle * 180 / pi;
    arrow.x = endPoint.dx + cos(angle) * 4;
    arrow.y = endPoint.dy + sin(angle) * 4;
    addChild(arrow);

    final labelText = GText(
      textStyle: TextStyle(
        fontSize: 10,
        color: Colors.blueGrey,
      ),
    );
    labelText.text = label;
    labelText.x = (startPoint.dx + endPoint.dx) / 2;
    labelText.y = (startPoint.dy + endPoint.dy) / 2 - 10;
    addChild(labelText);
  }
}

Offset lineRectIntersection({required Offset p1, required Offset p2, required Rect rect}) {
  final lines = [
    [rect.topLeft, rect.topRight],
    [rect.topRight, rect.bottomRight],
    [rect.bottomRight, rect.bottomLeft],
    [rect.bottomLeft, rect.topLeft],
  ];

  for (final edge in lines) {
    final intersect = lineIntersection(p1, p2, edge[0], edge[1]);
    if (intersect != null) {
      if (_pointOnSegment(intersect, edge[0], edge[1]) && _pointOnSegment(intersect, p1, p2)) {
        return intersect;
      }
    }
  }

  return p2;
}

Offset? lineIntersection(Offset p1, Offset p2, Offset p3, Offset p4) {
  final denom = (p4.dy - p3.dy) * (p2.dx - p1.dx) - (p4.dx - p3.dx) * (p2.dy - p1.dy);
  if (denom == 0) return null;

  final ua = ((p4.dx - p3.dx) * (p1.dy - p3.dy) - (p4.dy - p3.dy) * (p1.dx - p3.dx)) / denom;
  return Offset(p1.dx + ua * (p2.dx - p1.dx), p1.dy + ua * (p2.dy - p1.dy));
}

bool _pointOnSegment(Offset p, Offset a, Offset b) {
  final crossproduct = (p.dy - a.dy) * (b.dx - a.dx) - (p.dx - a.dx) * (b.dy - a.dy);
  if (crossproduct.abs() > 0.01) return false;

  final dotproduct = (p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy);
  if (dotproduct < 0) return false;

  final squaredlengthba = (b.dx - a.dx) * (b.dx - a.dx) + (b.dy - a.dy) * (b.dy - a.dy);
  if (dotproduct > squaredlengthba) return false;

  return true;
}
*/

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'dart:math';

class GraphSceneWidget extends StatelessWidget {
  const GraphSceneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(1000), // هامش كبير للتمرير
      minScale: 0.3,
      maxScale: 4.0,
      child: SizedBox(
        width: 5000,
        height: 5000,
        child: SceneBuilderWidget(
          builder: () => SceneController(front: GraphScene()),
        ),
      ),
    );
  }}

class GraphScene extends GSprite {
  final relationships = [
    {'from': 'الشيخ علي', 'to': 'سعيد مهران', 'type': 'مريد وشيخ'},
    {'from': 'الشيخ علي', 'to': 'عم مهران', 'type': 'مودة'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'سعيد مهران', 'type': 'مرشد قديم'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'عم مهران', 'type': 'مودة'},
    {'from': 'الشيخ علي الجنيدي', 'to': 'أهل الذكر', 'type': 'شيخ بمريديه'},
    {'from': 'عم مهران', 'to': 'الشيخ علي الجنيدي', 'type': 'مودة'},
    {'from': 'سعيد مهران', 'to': 'نبوية', 'type': 'حب وخطوبة'},
    //{'from': 'سعيد مهران', 'to': 'رءوف علوان', 'type': 'صداقة قديمة'},
    {'from': 'سعيد مهران', 'to': 'رءوف علوان', 'type': 'عداء'},
    {'from': 'سعيد مهران', 'to': 'معلم القهوة طرزان', 'type': 'صداقة'},
    {'from': 'سعيد مهران', 'to': 'زبائن المقهى', 'type': 'صداقة'},
    {'from': 'سعيد مهران', 'to': 'نور', 'type': 'حب واستغلال ثم سرقة'},
    {'from': 'سعيد مهران', 'to': 'الشيخ علي الجنيدي', 'type': 'مرشد وتلميذ'},
    {'from': 'سعيد مهران', 'to': 'المعلم بياظة', 'type': 'معرفة'},
    {'from': 'سعيد مهران', 'to': 'الوايلي', 'type': 'لا علاقة واضحة'},
    {'from': 'سعيد مهران', 'to': 'عابد', 'type': 'منفعة وتبعية'},
    {'from': 'سعيد مهران', 'to': 'عم مهران', 'type': 'زمالة وصداقة'},
    {'from': 'أم سعيد مهران', 'to': 'سعيد مهران', 'type': 'أمومة'},
    {'from': 'الرجل', 'to': 'نبوية', 'type': 'خيانة'},
    {'from': 'الرجل', 'to': 'عليش', 'type': 'صداقة سابقة'},
    {'from': 'الرجل', 'to': 'رءوف علوان', 'type': 'صداقة وأستاذية'},
    {'from': 'الرجل', 'to': 'سناء', 'type': 'أبوة'},
    {'from': 'الرجل', 'to': 'المرأة (حاملة سناء)', 'type': 'زوجة سابقة؟'},
    {'from': 'الرجل', 'to': 'الشيخ علي', 'type': 'مريد وشيخ'},

    {'from': 'نبوية', 'to': 'عليش', 'type': 'اسمان أصبحا واحداً'},
    {'from': 'نبوية', 'to': 'سناء', 'type': 'أمومة'},
    //{'from': 'نبوية', 'to': 'سعيد مهران', 'type': 'خيانة'},
    {'from': 'نبوية', 'to': 'سعيد مهران', 'type': 'حب وخطوبة'},

    {'from': 'عليش', 'to': 'الرجل', 'type': 'خيانة وصداقة سابقة'},
    {'from': 'عليش', 'to': 'سناء', 'type': 'أبوة بالتبني'},
    {'from': 'عليش سدرة', 'to': 'سعيد مهران', 'type': 'عداوة'},
    {'from': 'عليش سدرة', 'to': 'نبوية', 'type': 'اسمان أصبحا واحداً'},
  ];

  final nodes = <String, GraphNode>{};

  @override
  void addedToStage() {
    _drawGraph();
  }

  void _drawGraph() {
    stage!.color = Colors.white;

    final uniqueNames = relationships
        .expand((e) => [e['from'], e['to']])
        .toSet()
        .toList();

    for (var name in uniqueNames) {
      final node = GraphNode(name!);
      nodes[name] = node;
      addChild(node);
    }

    _applyForceDirectedLayout();

    for (final rel in relationships) {
      final from = nodes[rel['from']]!;
      final to = nodes[rel['to']]!;
      final label = rel['type']!;
      final edge = GraphEdge(from, to, label: label);
      addChild(edge);
    }
  }

  void _applyForceDirectedLayout() {
    final width = stage!.stageWidth * 3.5;
    final height = stage!.stageHeight * 2.2;
    final area = width * height;
    final k = sqrt(area / nodes.length);

    final rand = Random();
    for (final node in nodes.values) {
      node.x = rand.nextDouble() * width;
      node.y = rand.nextDouble() * height;
    }

    const iterations = 100;
    for (int i = 0; i < iterations; i++) {
      final displacements = <String, Offset>{};
      for (final v in nodes.entries) {
        Offset disp = Offset.zero;
        for (final u in nodes.entries) {
          if (v.key != u.key) {
            final dx = v.value.x - u.value.x;
            final dy = v.value.y - u.value.y;
            final dist = sqrt(dx * dx + dy * dy) + 0.01;
            final force = k * k / dist;
            disp += Offset(dx / dist * force, dy / dist * force);
          }
        }
        displacements[v.key] = disp;
      }

      for (final rel in relationships) {
        final from = nodes[rel['from']]!;
        final to = nodes[rel['to']]!;
        final dx = from.x - to.x;
        final dy = from.y - to.y;
        final dist = sqrt(dx * dx + dy * dy) + 0.01;
        final force = dist * dist / k;
        final disp = Offset(dx / dist * force, dy / dist * force);

        displacements[rel['from']!] = displacements[rel['from']!]! - disp;
        displacements[rel['to']!] = displacements[rel['to']!]! + disp;
      }

      for (final entry in nodes.entries) {
        final disp = displacements[entry.key]!;
        const maxDisp = 30.0;
        final dx = disp.dx.clamp(-maxDisp, maxDisp);
        final dy = disp.dy.clamp(-maxDisp, maxDisp);
        entry.value.x = (entry.value.x + dx).clamp(0, width);
        entry.value.y = (entry.value.y + dy).clamp(0, height);
      }
    }
  }
}

class GraphNode extends GSprite {
  final String name;

  GraphNode(this.name) {
    final shape = GShape();
    shape.graphics
      ..beginFill(Color(0xFF7BD5F5))
      ..lineStyle(2, Color(0xFF1F2F98),)
      ..drawRoundRect(0, 0, 100, 40, 12)
      ..endFill();
    addChild(shape);

    final label = GText(
      textStyle: TextStyle(
        color: Color(0xFF1F2F98),
        fontSize: 12,
        fontWeight: FontWeight.w900,
      ),
    );
    label.text = name;
    label.x = 10;
    label.y = 12;
    addChild(label);

    pivotX = 50;
    pivotY = 20;
    mouseChildren = false;
  }
}

Offset getIntersectionWithRect(
    Offset p1,
    Offset p2,
    Offset rectCenter,
    double width,
    double height,
    ) {
  final left = rectCenter.dx - width / 2;
  final right = rectCenter.dx + width / 2;
  final top = rectCenter.dy - height / 2;
  final bottom = rectCenter.dy + height / 2;

  final dx = p2.dx - p1.dx;
  final dy = p2.dy - p1.dy;

  final points = <Offset>[];

  if (dx != 0) {
    final t1 = (left - p1.dx) / dx;
    if (t1 >= 0 && t1 <= 1) {
      final y = p1.dy + t1 * dy;
      if (y >= top && y <= bottom) points.add(Offset(left, y));
    }
    final t2 = (right - p1.dx) / dx;
    if (t2 >= 0 && t2 <= 1) {
      final y = p1.dy + t2 * dy;
      if (y >= top && y <= bottom) points.add(Offset(right, y));
    }
  }

  if (dy != 0) {
    final t3 = (top - p1.dy) / dy;
    if (t3 >= 0 && t3 <= 1) {
      final x = p1.dx + t3 * dx;
      if (x >= left && x <= right) points.add(Offset(x, top));
    }
    final t4 = (bottom - p1.dy) / dy;
    if (t4 >= 0 && t4 <= 1) {
      final x = p1.dx + t4 * dx;
      if (x >= left && x <= right) points.add(Offset(x, bottom));
    }
  }

  if (points.isEmpty) return rectCenter;

  points.sort((a, b) =>
      (a - p1).distanceSquared.compareTo((b - p1).distanceSquared));
  return points.first;
}

class GraphEdge extends GSprite {
  GraphEdge(GraphNode from, GraphNode to, {required String label}) {
    final line = GShape();

    final p1 = Offset(from.x, from.y);
    final p2 = Offset(to.x, to.y);

    // نحدد هل العلاقة عكسية (مثلاً حسب الترتيب الأبجدي للأسماء)
    final isReverse = from.name.compareTo(to.name) > 0;

    // حساب المتجه والخط عمودي عليه (normal vector)
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final length = sqrt(dx * dx + dy * dy);
    final nx = -dy / length; // متجه عمودي موحد
    final ny = dx / length;

    // مقدار الإزاحة الجانبية للسهم إذا كانت العلاقة عكسية
    final offsetAmount = isReverse ? 8.0 : 0.0;

    // تطبيق الإزاحة على نقطة البداية والنهاية
    final offsetP1 = Offset(p1.dx + nx * offsetAmount, p1.dy + ny * offsetAmount);
    final offsetP2 = Offset(p2.dx + nx * offsetAmount, p2.dy + ny * offsetAmount);

    // حساب نقاط تقاطع السهم مع مستطيلات العقد
    final fromPoint = getIntersectionWithRect(offsetP2, offsetP1, offsetP1, 100, 40);
    final toPoint = getIntersectionWithRect(offsetP1, offsetP2, offsetP2, 100, 40);

    // رسم الخط بإزاحة (في حالة عكسية)
    line.graphics
      ..lineStyle(1, Color(0xff787FF6))
      ..moveTo(fromPoint.dx, fromPoint.dy)
      ..lineTo(toPoint.dx, toPoint.dy);
    addChild(line);

    // حساب زاوية السهم
    final angle = atan2(toPoint.dy - fromPoint.dy, toPoint.dx - fromPoint.dx);

    // رسم السهم (خطين مائلين)
    final arrowLength = 10.0;
    final arrowAngle = pi / 8;
    final end = toPoint;

    final arrowSide1 = Offset(
      end.dx - arrowLength * cos(angle - arrowAngle),
      end.dy - arrowLength * sin(angle - arrowAngle),
    );
    final arrowSide2 = Offset(
      end.dx - arrowLength * cos(angle + arrowAngle),
      end.dy - arrowLength * sin(angle + arrowAngle),
    );

    final arrow = GShape();
    arrow.graphics
      ..lineStyle(1.5,Color(0xff787FF6))
      ..moveTo(arrowSide1.dx, arrowSide1.dy)
      ..lineTo(end.dx, end.dy)
      ..moveTo(arrowSide2.dx, arrowSide2.dy)
      ..lineTo(end.dx, end.dy);
    addChild(arrow);

    // وضع التسمية (label) مع تحريكها عمودياً وبعض الشيء على نفس إزاحة الخط الجانبية
    final labelText = GText(
      textStyle: TextStyle(
        fontSize: 10,
        color: Colors.black,
      ),
    );
    labelText.text = label;
    labelText.x = (fromPoint.dx + toPoint.dx) / 2 + nx * offsetAmount * 1.5;
    labelText.y = (fromPoint.dy + toPoint.dy) / 2 + ny * offsetAmount * 1.5 + (isReverse ? 12 : -12);
    addChild(labelText);
  }
}