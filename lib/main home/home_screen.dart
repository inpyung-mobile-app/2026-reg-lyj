import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _cloudAnimation;
  late Animation<double> _moonAnimation;
  late Animation<double> _rogoAnimation;
  late Animation<double> _buttonAnimation;
  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000)
    );
    _moonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOutCubic)
      ),
    );
    _cloudAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.1, 0.3, curve: Curves.easeInOutCubic)
      ),
    );
    _rogoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.5, 0.7, curve: Curves.easeOutCubic)
      ),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.7, 1, curve: Curves.easeOutCubic)
      ),
    );
    _mainController.forward();
  }
  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }
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
            AnimatedBuilder(
              animation: _moonAnimation,
              builder: (context, child) {
                return Positioned(
                  left: -2.5,
                  top: -2.5,
                  width: 145,
                  child: Transform.translate(
                    offset: Offset(0, 200 * (1 - _moonAnimation.value)),
                    child: Opacity(
                      opacity: _moonAnimation.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: SizedBox(
                child: Image.asset("assets/moon.png"),
              ),
            ),
            ...[
              Alignment(1.1, 0.65),
              Alignment(-1.5, 0.7),
              Alignment(2.1, 0.8),
              Alignment(-1.2, 0.95),
              Alignment(1, 1),
            ].map((cloud) {
              return AnimatedBuilder(
                animation: _cloudAnimation,
                builder: (context, child) {
                  return Align(
                    alignment: cloud,
                    child: Transform.translate(
                      offset: Offset(0, 200 * (1 - _cloudAnimation.value)),
                      child: Opacity(
                        opacity: _cloudAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  alignment: cloud,
                  child: Image.asset("assets/cloud.png",width: 240,),
                ),
              );
            }),
            AnimatedBuilder(
              animation: _rogoAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 240),
                    child: Transform.translate(
                      offset: Offset(0, 200 * (1 - _rogoAnimation.value)),
                      child: Opacity(
                        opacity: _rogoAnimation.value,
                        child: child,
                      ),
                    ),
                  )
                );
              },
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
                      child: Text("운명을 엿볼 시간이에요.",style: TextStyle(fontFamily: 'CustomFont',color: Colors.white,fontWeight: .bold,fontSize: 15),)
                    ),
                  ]
                ),
            ),
            SizedBox(height: 80,),
            AnimatedBuilder(
              animation: _buttonAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 470),
                    child: Transform.translate(
                      offset: Offset(0, 200 * (1 - _buttonAnimation.value)),
                      child: Opacity(
                        opacity: _buttonAnimation.value,
                        child: child,
                      ),
                    ),
                  )
                );
              },
              child: Container(
                width: 180,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF85677B),
                      Color(0xff3C1464),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0,0.5]
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffffe57f).withAlpha(40),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10)
                    )
                  ]
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen2(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("시작하기",style: TextStyle(fontFamily: 'CustomFont',fontSize: 18,color: Colors.white, fontWeight: .bold),),
                      Transform.translate(
                        offset: const Offset(0, -2),
                        child: Transform.flip(
                          flipX: true,
                          child: SvgPicture.asset(
                            "assets/arrow_back.svg",
                            width: 24,
                            height: 24,
                          )
                        )
                      )
                    ],
                  ),
                ),
              )
            ),
          ],
        )
      ),
    );
  }
}
