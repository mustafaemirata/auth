import 'package:auth/features/auth/domain/entities/app_user.dart';
import 'package:auth/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception("Kullanıcı girişi yapılmadı.");
      }
      await user.delete();
      await logout();
    } on FirebaseAuthException catch (e) {
      throw Exception("Hesap silme işlemi başarısız: ${e.message}");
    } catch (e) {
      throw Exception(
        "Hesap silme işlemi sırasında beklenmeyen bir hata oluştu: $e",
      );
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!);
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        return null;
      }
      return AppUser(uid: user.uid, email: user.email!);
    } on FirebaseAuthException catch (e) {
      throw Exception("Giriş başarısız: ${e.message}");
    } catch (e) {
      throw Exception("Giriş sırasında beklenmeyen bir hata oluştu: $e");
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        return null;
      }
      await user.updateDisplayName(name); // Kullanıcı adına `name` alanını ekle
      return AppUser(uid: user.uid, email: user.email!);
    } on FirebaseAuthException catch (e) {
      throw Exception("Kayıt başarısız: ${e.message}");
    } catch (e) {
      throw Exception("Kayıt sırasında beklenmeyen bir hata oluştu: $e");
    }
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Sıfırlama maili gönderildi. Lütfen kontrol ediniz.";
    } on FirebaseAuthException catch (e) {
      return "Şifre sıfırlama maili gönderilirken hata oluştu: ${e.message}";
    } catch (e) {
      return "Şifre sıfırlama maili gönderilirken beklenmeyen bir hata oluştu: $e";
    }
  }

  @override
  Future<AppUser?> sigInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return null;
      }
      return AppUser(uid: firebaseUser.uid, email: firebaseUser.email ?? '');
    } on FirebaseAuthException catch (e) {
      throw Exception("Apple ile giriş başarısız: ${e.message}");
    } catch (e) {
      print(
        "Apple girişi hatalı: $e",
      ); // hata sadece konsola yazdırılır, fırlatılmaz
      return null;
    }
  }

  // Bu kısım sınıfın en üstünde olmalı, her metotta yeniden oluşturulmamalı.

  @override
  Future<AppUser?> sigInWithGoogle() async {
    try {
      // 1. Sınıf seviyesinde tanımlanmış _googleSignIn nesnesini kullan.
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      // Kullanıcı Google oturumunu iptal ettiyse işlemden çık.
      if (gUser == null) {
        return null;
      }

      // 2. Google kimlik doğrulama bilgilerini al.
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // 3. Firebase'in anlayacağı bir kimlik bilgisi (credential) oluştur.
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // 4. Oluşturulan credential ile Firebase'de oturum aç.
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      // Firebase kullanıcı nesnesi null ise hata fırlat veya null dön.
      if (user == null) {
        throw Exception("Firebase kullanıcısı oluşturulamadı.");
      }

      // 5. Firebase'den gelen bilgilerle AppUser nesnesi oluştur ve geri dön.
      return AppUser(uid: user.uid, email: user.email ?? '');
    } on FirebaseAuthException catch (e) {
      // Firebase özelindeki hataları yakala ve daha anlaşılır bir mesajla fırlat.
      throw Exception("Google ile giriş başarısız: ${e.message}");
    } catch (e) {
      // Diğer beklenmeyen hataları yakala.
      throw Exception(
        "Google ile giriş sırasında beklenmeyen bir hata oluştu: $e",
      );
    }
  }
}
