import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spotify_castor/main.dart';

void main() {
  testWidgets('SpotifyCastorApp loads and shows main content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);

    expect(find.byType(Scaffold), findsWidgets);
  });
}
