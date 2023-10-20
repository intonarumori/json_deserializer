import 'dart:convert';

abstract class JsonDeserializer<T> {
  T fromJson(dynamic json);
}

/// An optional deserializer.
/// Wrap your normal deserializer with `JsonOptionalDeserializer` if a value can be `null` in the
/// JSON data.
///
/// ```
/// final json = {"value": null};
/// final String? value = JsonOptionalDeserializer(StringDeserializer()).fromJson(json['value']);
/// ```
class JsonOptionalDeserializer<T> implements JsonDeserializer<T?> {
  final JsonDeserializer<T> deserializer;

  JsonOptionalDeserializer(this.deserializer);

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

class JsonListDeserializer<T> implements JsonDeserializer<List<T>> {
  JsonDeserializer<T> deserializer;
  JsonListDeserializer(this.deserializer);

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
class StringDeserializer implements JsonDeserializer<String> {
  @override
  String fromJson(json) {
    return json as String;
  }
}

/// Returns the object as a `int`.
class IntDeserializer implements JsonDeserializer<int> {
  @override
  int fromJson(json) {
    if (json is! int) {
      throw JSONDeserializerException('Value is not an int: $json');
    }
    return json;
  }
}

/// Returns the object as a `double`.
class DoubleDeserializer implements JsonDeserializer<double> {
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
class JSONEncodedStringDeserializer implements JsonDeserializer<String> {
  @override
  String fromJson(json) {
    return jsonEncode(json);
  }
}

// Returns the exact sample object that you pass it.
// Useful for debugging.
class JSONObjectDeserializer implements JsonDeserializer<dynamic> {
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
