import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Variable Fonts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var weight = 100.0;
  late AnimationController animationController1;
  late Animation animation1;
  late AnimationController animationController2;
  late Animation animation2;
  late AnimationController animationController3a;
  late Animation animation3a;

  late AnimationController animationController3b;
  late Animation animation3b;

  @override
  void initState() {
    super.initState();

    animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    animation1 =
        Tween<double>(begin: 100, end: 900).animate(animationController1);

    animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    animation2 =
        Tween<double>(begin: -200, end: 300).animate(animationController2);

    animationController3a = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    animation3a =
        Tween<double>(begin: 600, end: 800).animate(animationController3a);

    animationController3b = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    animation3b =
        Tween<double>(begin: 10, end: 70).animate(animationController3b);
  }

  @override
  void dispose() {
    animationController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: MaskedImage(
          child: AnimatedBuilder(
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _textFirstWidget('W'),
                  _textSecondWidget('O'),
                  _textThirdWidget('W'),
                ],
              );
            },
            animation: animation1,
          ),
        ),
      ),
    );
  }

  Widget _textFirstWidget(String str) {
    return Text(
      str,
      style: TextStyle(
        fontFamily: "Amstelvar",
        fontSize: 200,
        fontWeight: FontWeight.w100,
        fontVariations: <ui.FontVariation>[
          ui.FontVariation('wght', animation1.value),
          const ui.FontVariation('GRAD', 100),
        ],
      ),
    );
  }

  Widget _textSecondWidget(String str) {
    return Text(
      str,
      style: TextStyle(
        fontFamily: "Amstelvar",
        fontSize: 200,
        fontWeight: FontWeight.w100,
        fontVariations: <ui.FontVariation>[
          ui.FontVariation('GRAD', animation2.value),
          const ui.FontVariation('XOPQ', 10),
        ],
      ),
    );
  }

  Widget _textThirdWidget(String str) {
    return Text(
      str,
      style: TextStyle(
        fontFamily: "Amstelvar",
        fontSize: 200,
        fontWeight: FontWeight.w100,
        fontVariations: <ui.FontVariation>[
          const ui.FontVariation('wght', 200),
          ui.FontVariation('YOPQ', animation3b.value),
          ui.FontVariation('YTUC', animation3a.value),
        ],
      ),
    );
  }
}

class MaskedImage extends StatelessWidget {
  const MaskedImage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
        future: loadUiImage(context),
        builder: (context, img) {
          return img.hasData
              ? ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) => ImageShader(
                    img.data!,
                    TileMode.clamp,
                    TileMode.clamp,
                    Matrix4.identity().storage,
                  ),
                  child: child,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Future<ui.Image> loadUiImage(BuildContext context) async {
    final imageBytes = await rootBundle.load('assets/example4.jpg');

    return decodeImageFromList(
        resizeImage(imageBytes.buffer.asUint8List(), context));
  }

  Uint8List resizeImage(Uint8List data, BuildContext context) {
    Uint8List resizedData = data;
    image.Image? img = image.decodeImage(data);
    image.Image resized = image.copyResize(img!,
        width: MediaQuery.of(context).size.width.toInt(),
        height: MediaQuery.of(context).size.height.toInt());
    resizedData = image.encodeJpg(resized);
    return resizedData;
  }
}
