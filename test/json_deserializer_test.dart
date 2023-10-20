import 'package:flutter_test/flutter_test.dart';

import 'package:json_deserializer/json_deserializer.dart';
import 'package:json_deserializer/src/serialization.dart';

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

    final parsedObject = JSONEncodedStringDeserializer().fromJson(object);

    expect(parsedObject, equals('{"attribute1":"attribute1 value"}'));
  });

  test('test json list deserialization', () {
    final dynamic object = ["data1", "data2", "data3"];

    final parsedObject = JsonListDeserializer(StringDeserializer()).fromJson(object);

    expect(parsedObject, equals(["data1", "data2", "data3"]));
  });

  test('test optional deserialization', () {
    final dynamic object1 = {"value": null};
    final dynamic object2 = {"value": "some value"};

    final deserializer = JsonOptionalDeserializer(StringDeserializer());

    final String? value1 = deserializer.fromJson(object1['value']);
    expect(value1, equals(null));

    final String? value2 = deserializer.fromJson(object2['value']);
    expect(value2, equals('some value'));
  });

  test('test integer deserialization', () {
    final dynamic object1 = {"value": 1};
    final dynamic object2 = {"value": 1.0};

    final deserializer = IntDeserializer();

    final int value1 = deserializer.fromJson(object1['value']);
    expect(value1, equals(1));

    expect(
        () => deserializer.fromJson(object2['value']), throwsA(isA<JSONDeserializerException>()));
  });
}
