import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/card_provider.dart';

class TinderCard extends StatefulWidget {
  final String urlImages;
  final bool isFont;

  const TinderCard({Key? key, required this.urlImages, required this.isFont})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TinderCardState();
  }
}

class TinderCardState extends State<TinderCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child:widget.isFont ? buildFrontCard() :buildCard()
    );
  }

  Widget buildFrontCard() => GestureDetector(
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          if (kDebugMode) {
            print("x,${context.read<CardProvider>().count}");
          }
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
          provider.increment();
        },
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = context.watch<CardProvider>();
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;
          final angle = provider.angle * pi / 180;
          final center = constraints.smallest.center(Offset.zero);
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);
          return AnimatedContainer(
              curve: Curves.easeInOut,
              transform: rotatedMatrix..translate(position.dx, position.dy),
              duration: Duration(milliseconds: milliseconds),
              child: buildCard());
        }),
      );

  Widget buildCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.urlImages),
                fit: BoxFit.cover,
                alignment: const Alignment(-0.3, 0)),
          ),
        ),
      ),
    );
  }
}
