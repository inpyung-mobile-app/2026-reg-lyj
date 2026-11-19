import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'flows/info_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCloud = false;
  bool showmoon = false;
  bool showLogo = false;
  bool showButton = false;
  int pageIndex = 0;
  bool editing = false;

  void nextTo(int i) => setState(() {
    pageIndex = editing ? 6 : i;
    editing = false;
  });

  final texts = [
    '운명을 엿볼 시간이에요.',
    '이름을 입력해주세요.',
    '나이를 입력해주세요.',
    '성별을 선택해주세요.',
    '태어난 날짜를 입력해주세요.',
    '태어난 시간을 입력해주세요',
    '입력한 정보가 맞는지 확인해주세요.',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() => showCloud = true);

      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() => showmoon = true);

      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() => showLogo = true);

      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() => showButton = true);
    });
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
            Positioned(
              left: -3,
              top: -8,
              width: 146,
              child: appear(showmoon, Image.asset('assets/moon.png')),
            ),

            clouds(),
            bottombar(),
            logo(),
            backbutton(),
            pages(),
          ],
        ),
      ),
    );
  }

  Widget logo() => AnimatedPositioned(
    left: 0,
    right: 5,
    top: pageIndex == 0 ? 0 : -95,
    duration: Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
    child: Padding(
      padding: const EdgeInsets.only(top: 245),
      child: appear(
        showLogo,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/Daily Tarot.png', width: 210),
            Transform.translate(
              offset: const Offset(0, -12),
              child: Image.asset('assets/graphic.png', width: 62),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  texts[pageIndex],
                  key: ValueKey(pageIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget appear(bool show, Widget child) => AnimatedSlide(
    offset: show ? Offset.zero : const Offset(0, 0.5),
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeOutCubic,
    child: AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: const Duration(milliseconds: 1000),
      child: child,
    ),
  );

  Widget buttonPage() =>
      IgnorePointer(ignoring: !showButton, child: appear(showButton, button()));

  Widget pages() => Positioned.fill(
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) {
        final isNew = child.key == ValueKey(pageIndex);
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: Offset(isNew ? 0.1 : -0.1, 0), end: Offset.zero).animate(anim),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(pageIndex),
        child: switch (pageIndex) {
          0 => buttonPage(),
          1 => NameField(next: () => setState(() => pageIndex = 2)),
          2 => AgeField(next: () => setState(() => pageIndex = 3)),
          3 => GenderField(next: () => setState(() => pageIndex = 4)),
          4 => BirthField(next: () => setState(() => pageIndex = 5)),
          5 => TimeField(next: () => setState(() => pageIndex = 6)),
          6 => ConfirmField(go: (i) => setState(() { editing = i != 7; pageIndex = i; })),
          _ => const SizedBox(),
        },
      ),
    ),
  );

  Widget bottombar() => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: pageIndex >= 1 && pageIndex <= 5 ? 1 : 0,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          borderRadius: .circular(10),
          color: Colors.white.withAlpha(100),
        ),
        child: Row(
          children: .generate(5,
            (i) => Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 10,
                margin: .symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: (i + 1) <= pageIndex && pageIndex <= 5 ? Colors.white : Colors.white.withAlpha(0),
                  borderRadius: .circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget button() => Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 512),
      child: Container(
        width: 190,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF85677B), Color(0xff3C1464)],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.8],
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
            setState(() {
              pageIndex = 1;
            });
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '시작하기',
                style: TextStyle(
                  fontFamily: 'CustomFont',
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -2),
                child: Transform.flip(
                  flipX: true,
                  child: SvgPicture.asset(
                    'assets/arrow_back.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget backbutton() => Positioned(
    left: 0, right: 0, bottom: 64,
    child: Center(
      child: AnimatedSlide(
        offset: Offset(pageIndex == 5 ? -0.94 : 0, 0),
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: pageIndex < 1 || pageIndex > 5,
          child: AnimatedOpacity(
            opacity: pageIndex >= 1 && pageIndex <= 5 ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => setState(() => pageIndex--),
              child: Container(
                width: 100, height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(offset: const Offset(-10, 0),child: SvgPicture.asset('assets/arrow_back.svg',width: 24, height: 24,),),
                    Transform.translate(offset: const Offset(-5, 0),child: Text('이전', style: TextStyle(fontFamily: 'CustomFont2', color: Colors.white, fontWeight: .w600, fontSize: 17),),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget clouds() => AnimatedOpacity(
    opacity: showCloud ? 1 : 0,
    duration: const Duration(milliseconds: 500),
    child: Stack(
      children: [
        cloudItem(170, 85, false),
        cloudItem(-50, 70, true),
        cloudItem(230, 50, false),
        cloudItem(-25, 0, true),
        cloudItem(145, -20, false),
      ],
    ),
  );

  Widget cloudItem(double left, double bottom, bool flipX) => Positioned(
    left: left,
    bottom: bottom,
    child: Transform.flip(
      flipX: flipX,
      child: Image.asset('assets/cloud.png', width: 240),
    ),
  );
}
