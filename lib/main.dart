import 'package:auth/features/auth/data/firebase_auth_repo.dart';
import 'package:auth/features/auth/presentation/components/loading.dart';
import 'package:auth/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:auth/features/auth/presentation/cubits/auth_state.dart';
import 'package:auth/features/auth/presentation/pages/auth_page.dart';
import 'package:auth/features/home/presentation/pages/home_page.dart';
import 'package:auth/firebase_options.dart';
import 'package:auth/themes/dark_mode.dart';
import 'package:auth/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyAoo());
}

class MyAoo extends StatelessWidget {
  MyAoo({super.key});

  //auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //provide cubit to app
      providers: [
        //auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: ThemeMode.system,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            print(state);
            if (state is Unauthenticated) {
              return AuthPage();
            }
            if (state is Authenticated) {
              return const HomePage();
            } else {
              return const Loading();
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
