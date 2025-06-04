import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:examcheck_app/utils/app_colors.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Panneau d\'administration'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final email = user['email'];
              final role = user['role'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(email),
                  subtitle: Text("Rôle : $role"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔁 Changer rôle
                      IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: () async {
                          final newRole = role == 'admin' ? 'jury' : 'admin';
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .update({'role': newRole});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Rôle changé en $newRole')),
                          );
                        },
                      ),
                      // 🗑️ Supprimer
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Utilisateur supprimé')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
