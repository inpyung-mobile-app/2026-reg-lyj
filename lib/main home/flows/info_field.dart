import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class UserController {
  static String name = '';
  static String age = '';
  static String gender = '';
  static DateTime? birth;
  static bool isPm = false;
  static int? hour;
  static int? minute;
}

class NameField extends StatefulWidget {
  final VoidCallback next;
  const NameField({super.key, required this.next});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  final c = TextEditingController(text: UserController.name);
  String error = '';

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  void check() {
    final name = c.text.trim();
    final msg = name.isEmpty
        ? '이름을 입력해주세요.'
        : name.length < 2
        ? '이름은 2자 이상 입력해주세요.'
        : name.length > 20
        ? '이름은 20자 이하로 입력해주세요.'
        : '';
    setState(() => error = msg);
    if (msg.isNotEmpty) return;
    UserController.name = name;
    FocusScope.of(context).unfocus();
    widget.next();
  }

  @override
  Widget build(BuildContext context) => atTop(
    325,
      Column(
      children: [
        SizedBox(
          width: 285,
          child: TextField(
            controller: c,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => check(),
            onChanged: (_) {
              if (error.isNotEmpty) setState(() => error = '');
            },
            cursorColor: Colors.white54,
            style: const TextStyle(
              fontFamily: 'CustomFont2',
              color: Colors.white,
              fontSize: 15,
              fontWeight: .w600,
            ),
            decoration: InputDecoration(
              hintText: '이름을 입력해주세요.',
              hintStyle: const TextStyle(
                fontFamily: 'CustomFont2',
                color: Colors.white54,
                fontWeight: .w600,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.white38, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 32,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              error,
              style: const TextStyle(
                fontFamily: 'CustomFont2',
                color: Colors.red,
                fontSize: 14,
                fontWeight: .w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class AgeField extends StatefulWidget {
  final VoidCallback next;
  const AgeField({super.key, required this.next});

  @override
  State<AgeField> createState() => _AgeFieldState();
}

class _AgeFieldState extends State<AgeField> {
  final c = TextEditingController(text: UserController.age);
  String error = '';

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(color: color, width: 2),
  );

  void check() {
    final age = int.tryParse(c.text.trim());
    final msg = age == null
        ? '나이를 입력해주세요.'
        : age < 1 || age > 120
        ? '나이는 1세부터 120세 사이로 입력해주세요.'
        : '';
    setState(() => error = msg);
    if (msg.isNotEmpty) return;
    UserController.age = age.toString();
    FocusScope.of(context).unfocus();
    widget.next();
  }

  @override
  Widget build(BuildContext context) => atTop(
    325,
    Column(
      children: [
        SizedBox(
          width: 285,
          child: TextField(
            controller: c,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => check(),
            onChanged: (_) {
              if (error.isNotEmpty) setState(() => error = '');
            },
            cursorColor: Colors.white,
            style: const TextStyle(
              fontFamily: 'CustomFont2',
              color: Colors.white,
              fontSize: 15,
              fontWeight: .w600,
            ),
            decoration: InputDecoration(
              hintText: '나이를 입력해주세요.',
              hintStyle: const TextStyle(
                fontFamily: 'CustomFont2',
                color: Colors.white54,
                fontWeight: .w600,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              enabledBorder: border(Colors.white38),
              focusedBorder: border(Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 32,
          child: Padding(
            padding: const EdgeInsetsGeometry.only(top: 10),
            child: Text(
              error,
              style: const TextStyle(
                fontFamily: 'CustomFont2',
                color: Colors.red,
                fontSize: 14,
                fontWeight: .w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class GenderField extends StatelessWidget {
  final VoidCallback next;
  const GenderField({super.key, required this.next});

  Widget item(String gender, String icon) => GestureDetector(
    onTap: () {
      UserController.gender = gender;
      next();
    },
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(
          color: UserController.gender == gender
              ? Colors.white
              : Colors.white54,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: SvgPicture.asset('assets/$icon.svg', width: 55, height: 55),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => atTop(
    386,
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item('여성', 'female'),
        const SizedBox(width: 26),
        item('남성', 'male'),
      ],
    ),
  );
}

class BirthField extends StatefulWidget {
  final VoidCallback next;
  const BirthField({super.key, required this.next});

  @override
  State<BirthField> createState() => _BirthFieldState();
}

class _BirthFieldState extends State<BirthField> {
  int year = (UserController.birth ?? DateTime.now()).year;
  int month = (UserController.birth ?? DateTime.now()).month;
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  bool picking = false;
  FixedExtentScrollController yearC = FixedExtentScrollController();
  FixedExtentScrollController monthC = FixedExtentScrollController();

  @override
  void dispose() {
    yearC.dispose();
    monthC.dispose();
    super.dispose();
  }

  void open() {
    yearC.dispose();
    monthC.dispose();
    yearC = FixedExtentScrollController(initialItem: year - 1900);
    monthC = FixedExtentScrollController(initialItem: month - 1);
    setState(() => picking = true);
  }

  Widget cell(DateTime d) {
    final isMonth = d.month == month;
    final ok = d.month == month && d.isBefore(today);
    final sel = isMonth && d == UserController.birth;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ok
          ? () {
              setState(() => UserController.birth = d);
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) widget.next();
              });
            }
          : null,
      child: Center(
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: sel
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                )
              : null,
          child: Text(
            '${d.day}',
            style: TextStyle(
              fontFamily: 'CustomFont',
              fontSize: 16,
              color: ok ? Colors.white : Colors.white24,
              fontWeight: .w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget grid() {
    final offset = DateTime(year, month, 1).weekday % 7;
    final days = DateTime(year, month + 1, 0).day;
    final rows = ((offset + days) / 7).ceil();
    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: 46 / 52,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: List.generate(
        rows * 7,
        (i) => cell(DateTime(year, month, 1 - offset + i)),
      ),
    );
  }

  Widget bar() => Container(
    width: 220,
    height: 44,
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(25),
      border: Border.all(color: Colors.white54, width: 1.5),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            scrollController: yearC,
            itemExtent: 44,
            selectionOverlay: const SizedBox(),
            onSelectedItemChanged: (i) => setState(() => year = 1900 + i),
            children: List.generate(
              today.year - 1900 + 1,
              (i) => item('${1900 + i}'),
            ),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            scrollController: monthC,
            itemExtent: 44,
            selectionOverlay: const SizedBox(),
            onSelectedItemChanged: (i) => setState(() => month = i + 1),
            children: List.generate(12, (i) => item('${i + 1}')),
          ),
        ),
      ],
    ),
  );

  Widget item(String t) => GestureDetector(
    onTap: () => setState(() => picking = false),
    child: Center(
      child: Text(
        t,
        style: const TextStyle(
          fontFamily: 'CustomFont',
          color: Colors.white,
          fontSize: 22,
          fontWeight: .w600,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => atTop(
    310,
    Padding(
      padding: const EdgeInsets.only(
        left: 8,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Center(
              child: picking
                  ? bar()
                  : GestureDetector(
                      onTap: open,
                      child: Text(
                        '$year.$month',
                        style: const TextStyle(
                          fontFamily: 'CustomFont',
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(width: 322, child: grid()),
        ],
      ),
    ),
  );
}

class TimeField extends StatefulWidget {
  final VoidCallback next;
  const TimeField({super.key, required this.next});

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  bool isPm = UserController.isPm;
  int hour = UserController.hour ?? 12;
  int minute = UserController.minute ?? 0;
  bool minuteMode = false;

  String two(int v) => v.toString().padLeft(2, '0');

  void pick(int n) {
    if (!minuteMode) {
      setState(() {
        hour = n;
        minuteMode = true;
      });
      return;
    }
    setState(() => minute = n == 12 ? 0 : n * 5);
    UserController.isPm = isPm;
    UserController.hour = hour;
    UserController.minute = minute;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) widget.next();
    });
  }

  Widget box(String t, bool on, VoidCallback ontap) => GestureDetector(
    onTap: ontap,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: on ? 60 : 34,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: on ? Colors.white38 : Colors.transparent,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        t,
        style: TextStyle(
          fontFamily: 'CustomFont',
          fontSize: 28,
          color: on ? Colors.white : Colors.white38,
          fontWeight: .w600,
        ),
      ),
    ),
  );

  Widget ampmHalf(String t, bool sel, bool top, VoidCallback ontap) => Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: sel ? Colors.white : Colors.white38,
            width: 1,
          ),
          borderRadius: BorderRadius.vertical(
            top: top ? const Radius.circular(12) : Radius.zero,
            bottom: top ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          t,
          style: TextStyle(
            fontFamily: 'CustomFont',
            fontSize: 14,
            color: sel ? Colors.white : Colors.white38,
            fontWeight: .w600,
          ),
        ),
      ),
    ),
  );

  Widget ampm() => SizedBox(
    width: 42,
    height: 56,
    child: Column(
      children: [
        ampmHalf('AM', !isPm, true, () => setState(() => isPm = false)),
        ampmHalf('PM', isPm, false, () => setState(() => isPm = true)),
      ],
    ),
  );

  Widget clock() {
    const c = 91.5;
    const r = 74.0;
    const big = 36.0;
    const len = r - big / 2;
    final sel = minuteMode ? (minute == 0 ? 12 : minute ~/ 5) : hour;
    return SizedBox(
      width: 183,
      height: 183,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),
          Positioned(
            left: c - 0.5,
            top: c - len,
            child: Transform.rotate(
              angle: sel * math.pi / 6,
              origin: const Offset(0, len / 2),
              child: Container(width: 1, height: len, color: Colors.white70),
            ),
          ),
          Positioned(
            left: c - 3,
            top: c - 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          for (var n = 1; n <= 12; n++)
            Positioned(
              left: c + r * math.sin(n * math.pi / 6) - big / 2,
              top: c - r * math.cos(n * math.pi / 6) - big / 2,
              width: big,
              height: big,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => pick(n),
                child: Container(
                  alignment: Alignment.center,
                  decoration: n == sel
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        )
                      : null,
                  child: Text(
                    '$n',
                    style: const TextStyle(
                      fontFamily: 'CustomFont',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget skip() => GestureDetector(
    onTap: () {
      UserController.hour = null;
      UserController.minute = null;
      widget.next();
    },
    child: Container(
      width: 174,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '잘 모르겠어요',
            style: TextStyle(
              fontFamily: 'CustomFont',
              color: Colors.white,
              fontSize: 16,
              fontWeight: .w600,
            ),
          ),
          const SizedBox(width: 8),
          Transform.flip(
            flipX: true,
            child: SvgPicture.asset(
              'assets/arrow_back.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: Stack(
      children: [
        Positioned(
          top: 303,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(
                    two(hour),
                    !minuteMode,
                    () => setState(() => minuteMode = false),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    ':',
                    style: TextStyle(
                      fontFamily: 'CustomFont',
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  box(
                    two(minute),
                    minuteMode,
                    () => setState(() => minuteMode = true),
                  ),
                  const SizedBox(width: 14),
                  ampm(),
                ],
              ),
              const SizedBox(height: 38),
              clock(),
            ],
          ),
        ),
        Positioned(
          bottom: 64,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.translate(
              offset: const Offset(57, 0),
              child: skip(),
            ),
          ),
        ),
      ],
    ),
  );
}

class ConfirmField extends StatelessWidget {
  final void Function(int) go;
  const ConfirmField({super.key, required this.go});

  String two(int v) => v.toString().padLeft(2, '0');

  Widget pill(String t, int to) => GestureDetector(
    onTap: () => go(to),
    child: Container(
      height: 52, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 24),
      decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(26)),
      child: Text(t, style: const TextStyle(fontFamily: 'CustomFont2', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
    ),
  );

  Widget genderIcon() => GestureDetector(
    onTap: () => go(3),
    child: Container(
      width: 52, height: 52,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white54)),
      child: Center(child: SvgPicture.asset('assets/${UserController.gender == '여성' ? 'female' : 'male'}.svg', width: 32, height: 32)),
    ),
  );

  String time() {
    final h = UserController.hour, m = UserController.minute;
    if (h == null || m == null) return '모름';
    final h24 = h % 12 + (UserController.isPm ? 12 : 0);
    return '${two(h24)}:${two(m)}';
  }

  Widget start() => GestureDetector(
    onTap: () => print('클릭됨'),
    child: Container(
      width: 190, height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF85677B), Color(0xff3C1464)], begin: Alignment.topLeft, end: Alignment.bottomCenter, stops: [0.2, 0.8]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: const Color(0xffffe57f).withAlpha(40), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('시작하기', style: TextStyle(fontFamily: 'CustomFont', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
          Transform.translate(offset: const Offset(0, -2), child: Transform.flip(flipX: true, child: SvgPicture.asset('assets/arrow_back.svg', width: 24, height: 24))),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final b = UserController.birth;
    final birth = b == null ? '' : '${b.year}.${two(b.month)}.${two(b.day)}';
    return atTop(323,
      SizedBox(
        width: 284,
        child: Column(
          children: [
            pill('이름 : ${UserController.name}', 1),
            const SizedBox(height: 13),
            Row(children: [
              Expanded(child: pill('나이 : ${UserController.age}세', 2)),
              const SizedBox(width: 13),
              genderIcon(),
            ]),
            const SizedBox(height: 13),
            pill('생일 : $birth', 4),
            const SizedBox(height: 13),
            pill('태어난 시간 : ${time()}', 5),
            const SizedBox(height: 55),
            start(),
          ],
        ),
      ),
    );
  }
}

class BlankHome extends StatelessWidget {
  const BlankHome({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xff3C1161), Color(0xff200A33)], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 1]),
    ),
  );
}

Widget atTop(double y, Widget child) => Align(
  alignment: Alignment.topCenter,
  child: Padding(
    padding: EdgeInsets.only(top: y),
    child: child,
  ),
);
