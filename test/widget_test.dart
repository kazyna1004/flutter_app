// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_truck/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CleanTruckApp());

    // Verify that our app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
