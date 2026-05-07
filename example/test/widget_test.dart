import 'package:flutter_test/flutter_test.dart';

import 'package:nativeconnect_example/main.dart';

void main() {
  testWidgets('CameraTest widget smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the ElevatedButton is present.
    expect(find.text('Take Photo Automatically'), findsOneWidget);
  });
}
