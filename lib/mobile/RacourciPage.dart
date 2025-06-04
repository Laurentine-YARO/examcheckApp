import 'package:examcheck_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:examcheck_app/mobile/CheckPage.dart';

class RacourciPage extends StatefulWidget {
  const RacourciPage({super.key});

  @override
  State<RacourciPage> createState() => _RacourciPageState();
}

class _RacourciPageState extends State<RacourciPage> {
  final TextEditingController nameController = TextEditingController();
  bool notificationsEnabled = false;
  String selectedLanguage = 'Français';
  bool isSettingsVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.text),
            onPressed: () {
              setState(() {
                isSettingsVisible = !isSettingsVisible;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
          child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

                const Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Champ nom (optionnel)
                // TextField(
                //   controller: nameController,
                //   decoration: const InputDecoration(
                //     prefixIcon: Icon(Icons.person),
                //     hintText: "Full name",
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(height: 30),

                // Bouton "Search Results"
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckPage()),
                      );
                    },
                    icon: const Icon(Icons.search, color: AppColors.textPrimary),
                    label: const Text(
                      "Search Results",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.text),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Bouton "View History"
                //SizedBox(
                  //width: double.infinity,
                  //height: 50,
                  //child: OutlinedButton.icon(
                   // onPressed: () {
                     // Navigator.push(
                       // context,
                        //MaterialPageRoute(builder: (context) => const HistoryPage()),
                      //);
                    //},
                    //icon: const Icon(Icons.history, color: AppColors.textPrimary),
                    //label: const Text(
                     // "View History",
                      //style: TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w400),
                    //),
                    //style: OutlinedButton.styleFrom(
                     // side: const BorderSide(color: AppColors.primary, width: 2),
                     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                   // ),
                  //),
               // ),

                const SizedBox(height: 20),

                // Bouton "Create Account"
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    icon: const Icon(Icons.person_add, color: AppColors.text2),
                    label: const Text(
                      "Espace jury",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text2),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Affichage des paramètres s'ils sont visibles
                Visibility(
                  visible: isSettingsVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text),
                      ),
                      const SizedBox(height: 20),

                      // Notifications
                      //Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //children: [
                          //const Row(
                           //// children: [
                           //   Icon(Icons.notifications, color: AppColors.primary),
                           //   SizedBox(width: 10),
                           //   Text('Notifications', style: TextStyle(fontSize: 18, color: AppColors.text)),
                           // ],
                          //),
                          //Switch(
                           // value: notificationsEnabled,
                            //onChanged: (bool value) {
                             // setState(() {
                              //  notificationsEnabled = value;
                             // });
                          //  },
                           // activeColor: AppColors.primary,
                           // inactiveThumbColor: AppColors.text,
                         // ),
                        //],
                      //),

                      const SizedBox(height: 20),

                      // Langue
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.language, color: AppColors.primary),
                              SizedBox(width: 10),
                              Text('Langue', style: TextStyle(fontSize: 18, color: AppColors.text)),
                            ],
                          ),
                          DropdownButton<String>(
                            value: selectedLanguage,
                            items: ['Français', 'English']
                                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                                .toList(),
                            onChanged: (String? newLang) {
                              setState(() {
                                selectedLanguage = newLang!;
                                // TODO: appliquer traduction plus tard
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
    
  }
}
