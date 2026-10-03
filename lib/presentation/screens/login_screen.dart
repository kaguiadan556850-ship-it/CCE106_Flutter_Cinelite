import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/slide_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/movie_repository.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/login_view_model.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scoped ViewModel: created here, lives only as long as this screen.
    return ChangeNotifierProvider(
      create: (ctx) => LoginViewModel(ctx.read<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<LoginViewModel>();
    final success = await vm.login(email: _email.text.trim(), password: _password.text);
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        FadeScalePageRoute(
          page: ChangeNotifierProvider(
            create: (ctx) => HomeViewModel(ctx.read<MovieRepository>())..load(),
            child: const HomeScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: AppColors.skyLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.navy, Color(0xFF2C5D87)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.videocam, color: Colors.white, size: 56),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'CinElite',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'LOG IN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: AppColors.textMuted,
                              ),
                            ),
                            if (!vm.isCloudConnected) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4D6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Offline mode: no Firebase project connected. '
                                  'Any email/password will work locally.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10.5, color: Color(0xFF8A6D00)),
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Enter your email' : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _password,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Enter your password' : null,
                            ),
                            if (vm.status == LoginStatus.error) ...[
                              const SizedBox(height: 10),
                              Text(
                                vm.errorMessage ?? 'Something went wrong.',
                                style: const TextStyle(color: AppColors.danger, fontSize: 12),
                              ),
                            ],
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: vm.status == LoginStatus.loading ? null : _login,
                              child: vm.status == LoginStatus.loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4),
                                      child: Text('LOG IN'),
                                    ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              "Don't have an account? Just log in — "
                              "we'll register it for you.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
