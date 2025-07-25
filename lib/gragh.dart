import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'dart:math';

class GraphSceneWidget extends StatelessWidget {
  const GraphSceneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(1000),
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

    final isReverse = from.name.compareTo(to.name) > 0;

    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final length = sqrt(dx * dx + dy * dy);
    final nx = -dy / length;
    final ny = dx / length;

    final offsetAmount = isReverse ? 8.0 : 0.0;

    final offsetP1 = Offset(p1.dx + nx * offsetAmount, p1.dy + ny * offsetAmount);
    final offsetP2 = Offset(p2.dx + nx * offsetAmount, p2.dy + ny * offsetAmount);

    final fromPoint = getIntersectionWithRect(offsetP2, offsetP1, offsetP1, 100, 40);
    final toPoint = getIntersectionWithRect(offsetP1, offsetP2, offsetP2, 100, 40);

    line.graphics
      ..lineStyle(1, Color(0xff787FF6))
      ..moveTo(fromPoint.dx, fromPoint.dy)
      ..lineTo(toPoint.dx, toPoint.dy);
    addChild(line);

    final angle = atan2(toPoint.dy - fromPoint.dy, toPoint.dx - fromPoint.dx);

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