import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examcheck_app/web/adminPage.dart';
import 'package:examcheck_app/utils/app_colors.dart';
import 'package:examcheck_app/web/SignPage.dart';
import 'package:flutter/material.dart';
import 'package:examcheck_app/web/JuryPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String emailUser = userCredential.user!.email!;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('roles')
          .doc(emailUser)
          .get();

      if (!snapshot.exists) {
        setState(() {
          errorMessage = "Accès refusé. Utilisateur non autorisé.";
        });
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>?;

      if (data == null || !data.containsKey('role')) {
        setState(() {
          errorMessage = "Rôle non défini. Accès refusé.";
        });
        return;
      }

      String role = data['role'];
      print("Utilisateur connecté : $emailUser");
      print("Rôle récupéré : $role");

      if (role == 'jury') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const JuryPage()));
      } else if (role == 'admin') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AdminPage()));
      } else {
        setState(() {
          errorMessage = "Rôle non reconnu. Accès refusé.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Erreur inconnue lors de la connexion.";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors de la connexion : ${e.toString()}";
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/login(1).png', height: 100),
            const SizedBox(height: 20),
            const Text(
              "Authentification",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // 🔒 Email
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

            // 🔑 Mot de passe avec visibilité
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
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

            // 🔁 Mot de passe oublié
            TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Veuillez entrer votre email.")),
                  );
                } else {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email)
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Lien de réinitialisation envoyé.")),
                    );
                  });
                }
              },
              child: const Text("Mot de passe oublié ?"),
            ),

            const SizedBox(height: 30),

            // ✅ Bouton de connexion
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.text2),
                      )
                    : const Text(
                        "Se connecter",
                        style: TextStyle(color: AppColors.text2),
                      ),
              ),
            ),

            const SizedBox(height: 10),

            if (errorMessage.isNotEmpty)
              Center(
                child: Text(errorMessage,
                    style: const TextStyle(color: Colors.red)),
              ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous n'avez pas encore de compte?"),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  ),
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(color: AppColors.primary),
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
