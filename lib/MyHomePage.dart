import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DashBoard.dart';
import 'models/LoginResponse.dart';
import 'theme/app_theme.dart';
import 'widgets/app_widgets.dart';
import 'network/api_logger.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.GSMID});

  final String title, GSMID;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  bool _loading = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Test credentials are pre-filled only in debug builds, never in release.
    if (kDebugMode) {
      userIdController.text = 'ANISHKA';
      passwordController.text = '59005';
    }
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> logIn(String userId, String password) async {
    final Map<String, dynamic> body = {
      'UserName': userId,
      'Password': password,
      'LastLoginWith': 'W',
      'DisplayCode': 'RAMFAG',
      'GroupCode': '01',
      'SocietyCode': '002',
      'GSMID': widget.GSMID
    };

    try {
      final response = await apiClient
          .post(
            Uri.parse(
                'http://stonemen.bsninfotech.org/api/LoginApi/UserAuthentication'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
            encoding: Encoding.getByName('utf-8'),
          );

      final decoded = json.decode(response.body);
      if (decoded is! List || decoded.isEmpty) {
        _showError("Something went wrong. Please try again.");
        return;
      }

      final loginResponse = LoginResponse.fromJson(decoded[0]);
      if (loginResponse.userId != 0) {
        final pref = await SharedPreferences.getInstance();
        Clipboard.setData(ClipboardData(text: widget.GSMID));
        await pref.setString('userData', jsonEncode(loginResponse));
        await pref.setString("token", widget.GSMID);
        if (!mounted) return;
        _sendDataToSecondScreen(context, loginResponse);
      } else {
        _showError("Incorrect User ID or password");
      }
    } on TimeoutException {
      _showError("The server is taking too long. Please try again.");
    } catch (e) {
      appLogger.e('login error', error: e);
      _showError("Unable to sign in. Check your connection and try again.");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    showAppSnack(context, message, error: true);
  }

  void _sendDataToSecondScreen(
      BuildContext context, LoginResponse loginResponse) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Dashboard(
          loginResponse: loginResponse,
          LoginResponse: loginResponse,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await logIn(userIdController.text.trim(), passwordController.text);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
              children: [
                _header(media.padding.top),
                Transform.translate(
                  offset: const Offset(0, -48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: _formCard(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: media.padding.bottom + 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock_outline_rounded,
                          size: 14, color: AppColors.textMuted),
                      SizedBox(width: 6),
                      Text(
                        "Secure sign-in  •  Version 2.0",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget _header(double topInset) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28, topInset + 36, 28, 84),
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -70,
            top: -90,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandMark(size: 60),
              const SizedBox(height: 28),
              const Text(
                "Welcome back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sign in to manage visitors and meetings",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Sign in",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Use the credentials provided by your administrator.",
              style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            _label("User ID"),
            TextFormField(
              controller: userIdController,
              enabled: !_loading,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              validator: (v) => (v == null || v.trim().length < 2)
                  ? "Please enter your User ID"
                  : null,
              decoration: const InputDecoration(
                hintText: "Enter your user ID",
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 18),
            _label("Password"),
            TextFormField(
              controller: passwordController,
              focusNode: _passwordFocus,
              enabled: !_loading,
              obscureText: !_passwordVisible,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
              validator: (v) => (v == null || v.length < 2)
                  ? "Please enter your password"
                  : null,
              decoration: InputDecoration(
                hintText: "Enter your password",
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _passwordVisible ? 'Hide password' : 'Show password',
                  icon: Icon(_passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => showAppSnack(
                  context,
                  "Please contact your administrator to reset your password.",
                ),
                child: const Text("Forgot password?"),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.7),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _loading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        key: ValueKey('label'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sign in"),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
}
