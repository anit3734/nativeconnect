import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nativeconnect_example/main.dart';

void main() {
  testWidgets('CameraTest widget smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: NativeDemoScreen()));

    // Verify basic elements are present.
    expect(find.textContaining('NativeConnect'), findsWidgets);
  });
}
