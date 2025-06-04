import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:examcheck_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:examcheck_app/web/JuryPage.dart';
import 'package:examcheck_app/web/AdminPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<void> registerUser() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        errorMessage = "Email invalide.";
        isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        errorMessage = "Mot de passe trop court (min 6 caractères).";
        isLoading = false;
      });
      return;
    }

    try {
      // 🔐 Vérification dans Firestore "roles"
      final roleDoc = await FirebaseFirestore.instance
          .collection('roles')
          .doc(email)
          .get();

      if (!roleDoc.exists) {
        setState(() {
          errorMessage = "Vous n'êtes pas autorisé à créer un compte.";
          isLoading = false;
        });
        return;
      }

      final role = roleDoc['role']; // 'jury' ou 'admin'

      // 🔐 Création du compte utilisateur
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ Redirection selon le rôle
      if (role == 'jury') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const JuryPage()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminPage()),
        );
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Erreur inconnue';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Image.asset('assets/images/login(1).png', height: 100),
            const SizedBox(height: 30),
            const Text("Inscription (Jury/Admin)", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.text2),
                      )
                    : const Text(
                        "S'inscrire",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text2),
                      ),
              ),
            ),

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Déjà un compte ?"),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text("Se connecter", style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
