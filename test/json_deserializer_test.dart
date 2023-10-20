import 'package:flutter_test/flutter_test.dart';

import 'package:json_deserializer/json_deserializer.dart';

void main() {
  test('test json object deserialization', () {
    final dynamic object = {
      "attribute1": "attribute1 value",
    };

    final parsedObject = JSONObjectDeserializer().fromJson(object);

    expect(object, equals(parsedObject));
  });

  test('test json string deserialization', () {
    final dynamic object = {
      "attribute1": "attribute1 value",
    };

    final parsedObject = RawStringDeserializer().fromJson(object);

    expect(parsedObject, equals('{"attribute1":"attribute1 value"}'));
  });

  test('test json list deserialization', () {
    final dynamic object = ["data1", "data2", "data3"];

    final parsedObject = JsonListDeserializer(StringDeserializer()).fromJson(object);

    expect(parsedObject, equals(["data1", "data2", "data3"]));
  });
}
