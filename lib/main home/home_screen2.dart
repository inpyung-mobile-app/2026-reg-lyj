import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});
  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}
class _HomeScreen2State extends State<HomeScreen2> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                left: -2.5,
                top: -2.5,
                width: 145,
                child: Image.asset("assets/moon.png"),
              ),
              ...[
                Alignment(1.1, 0.65),
                Alignment(-1.5, 0.7),
                Alignment(2.1, 0.8),
                Alignment(-1.2, 0.95),
                Alignment(1, 1),
              ].map((cloud) {
                return Align(
                  alignment: cloud,
                  child: Image.asset("assets/cloud.png",
                    width: 240,
                  ),
                );
              }),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 155),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/Daily Tarot.png",width: 200,),
                      Transform.translate(
                        offset: const Offset(0, -15),
                        child: Image.asset("assets/graphic.png",width: 60,),
                      ),
                      Transform.translate(
                          offset: const Offset(0, -20),
                          child: Text("이름을 입력해주세요.",style: TextStyle(fontFamily: 'CustomFont',color: Colors.white,fontWeight: .bold,fontSize: 15),)
                      ),
                    ]
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
