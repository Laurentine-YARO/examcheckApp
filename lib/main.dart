import 'package:examcheck_app/AdminPage.dart';
import 'package:examcheck_app/EchecPage.dart';
import 'package:examcheck_app/JuryPage.dart';
import 'package:examcheck_app/RacourciPage.dart';
import 'package:examcheck_app/SecondTourPage.dart';
import 'package:examcheck_app/SignPage.dart';
import 'package:examcheck_app/SuccessPage.dart';
import 'package:examcheck_app/WelcomePage.dart';
import 'package:examcheck_app/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:examcheck_app/LoginPage.dart';
import 'package:examcheck_app/CheckPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Évite l'initialisation multiple
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(ExamCheckApp());
}

class ExamCheckApp extends StatefulWidget {
  const ExamCheckApp({super.key});

  @override
  State<ExamCheckApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(locale);
  }
}

class _MyAppState extends State<ExamCheckApp> {
  Locale _locale = const Locale('fr');

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/racourci': (context) => const RacourciPage(),
        '/login': (context) => const LoginPage(),
        '/sign': (context) => const SignUpPage(),
        '/check': (context) => const CheckPage(),
        'jury': (context) => const JuryPage(),
        'admin': (context) => const AdminPage(),
        
        'success': (context) => const SuccessPage(
              nom: '',
              prenom: '',
              numeroPV: '',
              jury: '',
              serie: '',
              moyenne: 0.0,
              notes: {},
              type: '',
            ),
        'releve': (context) => const SuccessPage(
              nom: '',
              prenom: '',
              numeroPV: '',
              jury: '',
              serie: '',
              moyenne: 0.0,
              notes: {},
              type: 'releve',
            ),
        'second': (context) => const SecondTourPage(moyenne: 0.0),
        'echec': (context) => const EchecPage(moyenne: 0.0),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/success') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SuccessPage(
              nom: args['nom'],
              prenom: args['prenom'],
              numeroPV: args['numeroPV'],
              jury: args['jury'],
              serie: args['serie'],
              moyenne: args['moyenne'],
              notes: Map<String, double>.from(args['notes']),
              type: '',
            ),
          );
        }
        return null;
      },
    );
  }
}
