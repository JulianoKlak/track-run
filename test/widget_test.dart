import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:track_run/main.dart';

void main() {
  testWidgets('Track Run app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrackRunApp());

    // Wait for the AuthChecker to complete
    await tester.pumpAndSettle();

    // Verify that we see the login screen (since no user is logged in)
    expect(find.text('Track Run'), findsOneWidget);
    expect(find.text('Conquiste território correndo!'), findsOneWidget);
  });
}
