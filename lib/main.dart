import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contacts_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ContactsApp());
}

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts',
        theme: AppTheme.light(),
        home: const SplashScreen(),
      ),
    );
  }
}
