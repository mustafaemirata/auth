import 'package:auth/features/auth/presentation/components/my_button.dart';
import 'package:auth/features/auth/presentation/components/my_textfield.dart';
import 'package:auth/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;

  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namecontroller = TextEditingController();

  final emailcontroller = TextEditingController();
  final pw = TextEditingController();
  final Cpw = TextEditingController();

  void kayit() async {
    final String name = namecontroller.text;
    final String email = emailcontroller.text;
    final String password = pw.text;
    final String conf = Cpw.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty &&
        name.isNotEmpty &&
        password.isNotEmpty &&
        conf.isNotEmpty) {
      // pw match
      if (password == conf) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Şifreler aynı değil.")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lütfen tüm alanları doldurun!.")));
    }
  }

  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    pw.dispose();
    Cpw.dispose();
    super.dispose();
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
            SizedBox(height: 20),
            Text(
              "Haydi hesap oluşturalım!",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 17),
            MyTextfield(
              controller: namecontroller,
              hintText: "Name",
              obscure: false,
            ),
            SizedBox(height: 10),
            MyTextfield(
              controller: emailcontroller,
              hintText: "Email",
              obscure: false,
            ),
            SizedBox(height: 10),
            MyTextfield(controller: pw, hintText: "Password", obscure: true),
            SizedBox(height: 10),

            MyTextfield(
              controller: Cpw,
              hintText: "Şifre doğrulama",
              obscure: true,
            ),

            SizedBox(height: 15),
            MyButton(onTap: kayit, text: "Kayıt Ol"),
            SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hesabınız var mı?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 4),

                GestureDetector(
                  onTap: widget.togglePages,
                  child: Text(
                    "Giriş yapın!",
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
