import 'package:animation/provider/card_provider.dart';
import 'package:animation/value/app_text_style.dart';
import 'package:animation/widgets/tinder_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/tinder-icon.svg",semanticsLabel: "logo",height: 40,width: 40,),
                    const SizedBox(width: 20,),
                    const Text("Tinder",style: AppTextStyle.appTitle,),

                  ],
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.orange,
              leading:  Padding(
                padding: const EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.asset("assets/images/avatar.jpg",fit: BoxFit.cover,)
                ),
              ),
            ),
            body: const MyHomePage(),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              stops: [0.7, 1],
              colors: [Colors.orange, Colors.pink],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
            child: buildCard()),
      ),
    );
  }

  Widget buildCard() {
    final provider = context.watch<CardProvider>();
    final images = provider.urlImages;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;
    return images.isEmpty
        ? Center(
            child: TextButton(
              onPressed: () {
                provider.resetUsers();
              },
              child: const Text("reset"),
            ),
          )
        : Column(
            children: [
              Expanded(
                flex: 8,
                child: Stack(
                  children: images
                      .map((urlImages) => TinderCard(
                          urlImages: urlImages,
                          isFont: images.last == urlImages))
                      .toList(),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                getColor(Colors.white, Colors.red, isDislike),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            foregroundColor:
                                getColor(Colors.red, Colors.white, isDislike),
                            side:
                                getBorder(Colors.red, Colors.white, isDislike)),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.clear,
                            size: 40,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: getColor(
                                Colors.white, Colors.blueAccent, isSuperLike),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            foregroundColor: getColor(
                                Colors.blueAccent, Colors.white, isSuperLike),
                            side: getBorder(
                                Colors.blueAccent, Colors.white, isSuperLike)),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.star,
                            size: 30,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: getColor(
                                Colors.white, Colors.tealAccent, isLike),
                            shape:
                                MaterialStateProperty.all(const CircleBorder()),
                            foregroundColor: getColor(
                                Colors.tealAccent, Colors.white, isLike),
                            side: getBorder(
                                Colors.tealAccent, Colors.white, isLike)),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.favorite,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          );
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    getBorder(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    ;
    return MaterialStateProperty.resolveWith(getBorder);
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    getColor(Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    ;
    return MaterialStateProperty.resolveWith(getColor);
  }
}
