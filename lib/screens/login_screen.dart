// screens/login_screen.dart
// Concept: StatefulWidget, Form validation, async/await, Future, Navigator

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (_emailCtrl.text.trim() == DummyAuth.email &&
          _passCtrl.text == DummyAuth.password) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        _snack('Incorrect email or password.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(14),
      ));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(children: [
            // ---- top hero ----
            Container(
              height: size.height * 0.35,
              width: double.infinity,
              color: AppColors.primary,
              child: FadeTransition(
                opacity: _fade,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.accent.withOpacity(0.4),
                                blurRadius: 24,
                                spreadRadius: 2)
                          ],
                        ),
                        child: const Icon(Icons.shopping_bag_rounded,
                            color: AppColors.white, size: 34),
                      ),
                      const SizedBox(height: 16),
                      Text('SmartShop+',
                          style: AppTextStyles.h1
                              .copyWith(color: AppColors.white, fontSize: 28)),
                      const SizedBox(height: 4),
                      Text('Shop smarter, live better',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white38)),
                    ]),
              ),
            ),

            // ---- form ----
            Expanded(
              child: SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    color: AppColors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sign in to your account',
                                style: AppTextStyles.h2.copyWith(fontSize: 18)),
                            const SizedBox(height: 24),

                            // email
                            _label('Email'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTextStyles.body,
                              decoration: const InputDecoration(
                                hintText: 'you@example.com',
                                prefixIcon: Icon(Icons.email_outlined,
                                    size: 18, color: AppColors.midGrey),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Email is required';
                                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$')
                                    .hasMatch(v.trim()))
                                  return 'Enter a valid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // password
                            _label('Password'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscure,
                              style: AppTextStyles.body,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline,
                                    size: 18, color: AppColors.midGrey),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      _obscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18,
                                      color: AppColors.midGrey),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Password is required';
                                if (v.length < 6) return 'Minimum 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                child: Text('Forgot password?',
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _login,
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                                AppColors.white)))
                                    : Text('Sign In',
                                        style: AppTextStyles.button),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
          fontSize: 12));
}
