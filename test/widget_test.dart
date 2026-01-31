// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:contacts_app/main.dart';

void main() {
  testWidgets('ContactsApp builds (smoke test)', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactsApp());

    // Basic sanity checks: the app and initial screen render.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
