import 'package:flutter_test/flutter_test.dart';
import 'package:nativeconnect/nativeconnect.dart';

void main() {
  test('NativeConnect static methods are defined', () {
    expect(NativeConnect.getLocation, isNotNull);
    expect(NativeConnect.takePhoto, isNotNull);
    expect(NativeConnect.watchGravity, isNotNull);
  });
}
