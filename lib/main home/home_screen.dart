import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'flows/home_screen2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _stepController;
  late AnimationController _mainController;
  late Animation<double> _moonAnimation;
  late Animation<double> _rogoAnimation;
  late Animation<double> _buttonAnimation;

  bool showCloud = false;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(milliseconds: 500));
      showCloud = true;
      setState(() {});
    });
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    _moonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _rogoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 1, curve: Curves.easeOutCubic),
      ),
    );
    _mainController.forward();
  }

  @override
  void dispose() {
    _stepController.dispose();
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
                    child: Opacity(opacity: _moonAnimation.value, child: child),
                  ),
                );
              },
              child: SizedBox(child: Image.asset("assets/moon.png")),
            ),
            clouds(),
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
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/Daily Tarot.png", width: 200),
                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: Image.asset("assets/graphic.png", width: 60),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Text(
                      "운명을 엿볼 시간이에요.",
                      style: TextStyle(
                        fontFamily: 'CustomFont',
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
            pages(),
          ],
        ),
      ),
    );
  }

  Widget pages() {
    final widget = [button(), const HomeScreen2()];

    return widget[pageIndex];
  }

  Widget button() => AnimatedBuilder(
    animation: _buttonAnimation,
    builder: (context, child) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 470),
          child: Transform.translate(
            offset: Offset(0, 200 * (1 - _buttonAnimation.value)),
            child: Opacity(opacity: _buttonAnimation.value, child: child),
          ),
        ),
      );
    },
    child: Container(
      width: 180,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF85677B), Color(0xff3C1464)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.2 , 0.5],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffffe57f).withAlpha(40),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (pageIndex == 0) {
            setState(() {
              pageIndex = 1;
            });
          }
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
            Text(
              "시작하기",
              style: TextStyle(
                fontFamily: 'CustomFont',
                fontSize: 18,
                color: Colors.white,
                fontWeight: .bold,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -2),
              child: Transform.flip(
                flipX: true,
                child: SvgPicture.asset(
                  "assets/arrow_back.svg",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget clouds() => AnimatedOpacity(
    opacity: showCloud ? 1 : 0,
    duration: Duration(milliseconds: 500),
    child: Stack(
      children: [
        clloudItem(170, 85, false),
        clloudItem(-50, 70, true),
        clloudItem(230, 50, false),
        clloudItem(-25, 5, true),
        clloudItem(145, -20, false),
      ],
    ),
  );

  Widget clloudItem(double left, double bottom, flipx) => Positioned(
    bottom: bottom,
    left: left,
    child: Transform.flip(
      flipX: flipx,
      child: Image.asset('assets/cloud.png', width: 240),
    ),
  );
}
