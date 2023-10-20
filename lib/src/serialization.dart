import 'dart:convert';

abstract class JSONDeserializer<T> {
  T fromJson(dynamic json);
}

/// An optional deserializer.
/// Wrap your normal deserializer with `OptionalDeserializer` if a value can be `null` in the
/// JSON data.
///
/// ```
/// final json = {"value": null};
/// final String? value = OptionalDeserializer(StringDeserializer()).fromJson(json['value']);
/// ```
class OptionalDeserializer<T> implements JSONDeserializer<T?> {
  final JSONDeserializer<T> deserializer;

  OptionalDeserializer(this.deserializer);

  @override
  T? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    try {
      return deserializer.fromJson(json);
    } catch (error) {
      rethrow;
    }
  }
}

class ListDeserializer<T> implements JSONDeserializer<List<T>> {
  JSONDeserializer<T> deserializer;
  ListDeserializer(this.deserializer);

  @override
  List<T> fromJson(dynamic json) {
    final list = json as List<dynamic>;
    try {
      final result = list.map((e) => deserializer.fromJson(e)).toList();
      return result;
    } catch (error) {
      rethrow;
    }
  }
}

/// Returns the object as a `String`.
class StringDeserializer implements JSONDeserializer<String> {
  @override
  String fromJson(json) {
    return json as String;
  }
}

/// Returns the object as a `int`.
class IntDeserializer implements JSONDeserializer<int> {
  @override
  int fromJson(json) {
    if (json is! int) {
      throw JSONDeserializerException('Value is not an int: $json');
    }
    return json;
  }
}

/// Returns the object as a `double`.
class DoubleDeserializer implements JSONDeserializer<double> {
  @override
  double fromJson(json) {
    if (json is double) {
      return json;
    }
    if (json is int) {
      return json.toDouble();
    }
    throw JSONDeserializerException('Value is not a double: $json');
  }
}

// MARK: - Helpers

/// Returns the JSON encoded String value of the passed object.
/// Perfect for debugging and seeing what the data looks like.
class JSONEncodedStringDeserializer implements JSONDeserializer<String> {
  @override
  String fromJson(json) {
    return jsonEncode(json);
  }
}

// Returns the exact sample object that you pass it.
// Useful for debugging.
class ObjectDeserializer implements JSONDeserializer<dynamic> {
  @override
  dynamic fromJson(json) {
    return json;
  }
}

// MARK: - Exceptions

class JSONDeserializerException implements Exception {
  final String message;
  JSONDeserializerException(this.message);
}
