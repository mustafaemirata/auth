import 'package:auth/features/auth/presentation/components/apple_giris_btn.dart';
import 'package:auth/features/auth/presentation/components/google_girs_btn.dart';
import 'package:auth/features/auth/presentation/components/my_button.dart';
import 'package:auth/features/auth/presentation/components/my_textfield.dart';
import 'package:auth/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final pw = TextEditingController();
  late final authCubit = context.read<AuthCubit>();

  void giris() {
    final String email = emailcontroller.text;
    final String sifre = pw.text;

    if (email.isNotEmpty && sifre.isNotEmpty) {
      authCubit.login(email, sifre);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tüm alanları doldurunuz!")));
    }
  }

  void openForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Şifrenizi mi unuttunuz?"),
        content: MyTextfield(
          controller: emailcontroller,
          hintText: "Email",
          obscure: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              String message = await authCubit.forgotPassword(
                emailcontroller.text,
              );
              if (message ==
                  "Sıfırlama maili gönderildi. Lütfen kontrol ediniz.") {
                Navigator.pop(context);
                emailcontroller.clear();
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            child: const Text("Sıfırla"),
          ),
        ],
      ),
    );
  }

  // 👇 Google giriş fonksiyonu
  void googleGiris() async {
    authCubit.signInWithGoogle();
  }

  // 👇 Apple giriş fonksiyonu
  void appleGiris() async {
    authCubit.signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_open,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              "Haydi, giriş yapın!",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 17),
            MyTextfield(
              controller: emailcontroller,
              hintText: "Email",
              obscure: false,
            ),
            const SizedBox(height: 10),
            MyTextfield(controller: pw, hintText: "Password", obscure: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: openForgotPassword,
                  child: Text(
                    "Şifrenizi mi unuttunuz?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // OR bölümü
            Row(
              children: [
                Expanded(
                  child: Divider(color: Theme.of(context).colorScheme.tertiary),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Sosyal giriş butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppleGiris(onTap: appleGiris),
                const SizedBox(width: 20),
                GoogleGiris(onTap: googleGiris),
              ],
            ),
            const SizedBox(height: 20),

            MyButton(onTap: giris, text: "Giriş Yap"),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hesabınız yok mu?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.togglePages,
                  child: Text(
                    "Hemen üye olun!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
