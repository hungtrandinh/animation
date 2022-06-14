import 'dart:math';

import 'package:animation/provider/card_provider.dart';
import 'package:animation/widgets/tinder_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Scaffold(
            body: MyHomePage(),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: buildCard()),
    );
  }

  Widget buildCard() {
    final provider = context.watch<CardProvider>();
    final images = provider.urlImages;
    return images.isEmpty
        ? Center(
            child: TextButton(
              onPressed: () {
                provider.resetUsers();
              },
              child: const Text("reset"),
            ),
          )
        : Stack(
            children: images
                .map((urlImages) => TinderCard(
                    urlImages: urlImages, isFont: images.last == urlImages))
                .toList(),
          );
  }
}
