import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_app_flutter/MyHomePage.dart';
import 'package:visitor_app_flutter/NotificationService.dart';
import 'package:visitor_app_flutter/models/LoginResponse.dart';

import 'DashBoard.dart';
import 'theme/app_theme.dart';
import 'widgets/app_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String? GSMId;
  final NotificationService notificationService = NotificationService();

  /// One-shot entrance animation (staggered).
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  /// Endless gentle floating / loader animation.
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  Animation<double> _interval(double begin, double end,
          {Curve curve = Curves.easeOutCubic}) =>
      CurvedAnimation(
          parent: _intro, curve: Interval(begin, end, curve: curve));

  @override
  void initState() {
    super.initState();
    _intro.forward();
    _loop.repeat();

    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    notificationService.isTokenRefresh();

    _start();
  }

  Future<void> _start() async {
    // Wait for the device token (max 4s) and let the intro play (min 2.4s).
    final tokenFuture = notificationService
        .getDeviceToken()
        .then<String?>((value) => value)
        .timeout(const Duration(seconds: 4), onTimeout: () => null)
        .catchError((_) => null);

    final results = await Future.wait<dynamic>([
      tokenFuture,
      Future.delayed(const Duration(milliseconds: 2400)),
    ]);
    GSMId = results[0] as String?;
    if (kDebugMode) {
      print('device token');
      print(GSMId);
    }

    final pref = await SharedPreferences.getInstance();
    final userdata = pref.getString("userData");
    final token = pref.getString("token");
    if (!mounted) return;

    if (token != null &&
        userdata != null &&
        token.length > 1 &&
        userdata.length > 1) {
      final user = LoginResponse.fromJson(jsonDecode(userdata));
      Navigator.of(context).pushReplacement(
        _fadeRoute(Dashboard(loginResponse: user, LoginResponse: user)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        _fadeRoute(MyHomePage(title: "Login Page", GSMID: GSMId ?? "")),
      );
    }
  }

  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0, 0.04), end: Offset.zero)
                .animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heroSize =
        math.min(math.min(size.width * 0.74, size.height * 0.38), 340.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFF1EFFD), Color(0xFFE7E3FC)],
            ),
          ),
          child: Stack(
            children: [
              // Floating colour blobs in the four category colours
              _blob(top: size.height * 0.08, left: -40, size: 140,
                  color: AppColors.violet, phase: 0.0),
              _blob(top: size.height * 0.18, right: -50, size: 120,
                  color: AppColors.teal, phase: 0.3),
              _blob(bottom: size.height * 0.22, left: -60, size: 130,
                  color: AppColors.orange, phase: 0.55),
              _blob(bottom: -50, right: -30, size: 170,
                  color: AppColors.pink, phase: 0.8),

              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    // Brand row
                    _fadeSlide(
                      _interval(0.0, 0.35),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BrandMark(size: 40),
                          SizedBox(width: 10),
                          Text(
                            'Visitor App',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Hero illustration with halo + floating chips
                    SizedBox(
                      width: heroSize + 40,
                      height: heroSize,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          ScaleTransition(
                            scale: Tween<double>(begin: 0.6, end: 1).animate(
                                _interval(0.1, 0.6, curve: Curves.easeOutBack)),
                            child: FadeTransition(
                              opacity: _interval(0.1, 0.45),
                              child: _halo(heroSize),
                            ),
                          ),
                          _floating(
                            amplitude: 6,
                            phase: 0,
                            child: FadeTransition(
                              opacity: _interval(0.25, 0.65),
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.85, end: 1)
                                    .animate(_interval(0.25, 0.7,
                                        curve: Curves.easeOutBack)),
                                child: Padding(
                                  padding: EdgeInsets.all(heroSize * 0.12),
                                  child: Image.asset(
                                    'assets/images/splasg_ic.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.groups_rounded,
                                      size: heroSize * 0.4,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: heroSize * 0.04,
                            left: 0,
                            child: _chipIn(
                              _interval(0.5, 0.8, curve: Curves.easeOutBack),
                              const Offset(-0.4, 0),
                              _floating(
                                amplitude: 5,
                                phase: 0.35,
                                child: _infoChip(
                                  icon: Icons.check_rounded,
                                  color: AppColors.green,
                                  title: 'Visitor allowed',
                                  subtitle: 'Just now',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: heroSize * 0.06,
                            right: 0,
                            child: _chipIn(
                              _interval(0.6, 0.9, curve: Curves.easeOutBack),
                              const Offset(0.4, 0),
                              _floating(
                                amplitude: 5,
                                phase: 0.7,
                                child: _infoChip(
                                  icon: Icons.schedule_rounded,
                                  color: AppColors.orange,
                                  title: 'Meeting at 10:30',
                                  subtitle: 'Design review',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Headline
                    _fadeSlide(
                      _interval(0.45, 0.8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            const Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 28,
                                  height: 1.2,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                                children: [
                                  TextSpan(text: 'Welcome every visitor,\n'),
                                  TextSpan(
                                    text: 'effortlessly.',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Schedule, approve and track meetings\nall in one place.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.45,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Loader
                    FadeTransition(
                      opacity: _interval(0.7, 1.0),
                      child: _dotsLoader(),
                    ),
                    const SizedBox(height: 18),
                    FadeTransition(
                      opacity: _interval(0.75, 1.0),
                      child: const Text(
                        'Version 2.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------- pieces

  Widget _fadeSlide(Animation<double> a, Widget child) {
    return FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
            .animate(a),
        child: child,
      ),
    );
  }

  Widget _chipIn(Animation<double> a, Offset from, Widget child) {
    return FadeTransition(
      opacity: a.drive(Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: const Interval(0, 0.6)))),
      child: SlideTransition(
        position: Tween<Offset>(begin: from, end: Offset.zero).animate(a),
        child: child,
      ),
    );
  }

  /// Moves [child] gently up and down forever.
  Widget _floating(
      {required double amplitude,
      required double phase,
      required Widget child}) {
    return AnimatedBuilder(
      animation: _loop,
      builder: (context, c) {
        final t = (_loop.value + phase) * 2 * math.pi;
        return Transform.translate(
          offset: Offset(0, math.sin(t) * amplitude),
          child: c,
        );
      },
      child: child,
    );
  }

  Widget _halo(double s) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.06),
          ),
        ),
        Container(
          width: s * 0.8,
          height: s * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 40,
                offset: const Offset(0, 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoChip({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1B4B).withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _blob({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    required Color color,
    required double phase,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: FadeTransition(
        opacity: _interval(0.0, 0.5),
        child: _floating(
          amplitude: 10,
          phase: phase,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.22),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Three bouncing dots in brand colours.
  Widget _dotsLoader() {
    const colors = [AppColors.violet, AppColors.teal, AppColors.orange];
    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final t = ((_loop.value * 2) - i * 0.18) % 1.0;
            final bounce = math.sin(t * math.pi).clamp(0.0, 1.0).toDouble();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 9,
              height: 9,
              transform: Matrix4.translationValues(0, -8 * bounce, 0),
              decoration: BoxDecoration(
                color: colors[i],
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
