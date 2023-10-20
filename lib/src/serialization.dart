import 'dart:convert';

abstract class JsonDeserializer<T> {
  T fromJson(dynamic json);
}

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

/// Returns the JSON encoded String value of the passed object.
/// Perfect for debugging and seeing what the data looks like.
class RawStringDeserializer implements JsonDeserializer<String> {
  @override
  String fromJson(json) {
    return jsonEncode(json);
  }
}

/// Returns the object as a `String`.
class StringDeserializer implements JsonDeserializer<String> {
  @override
  String fromJson(json) {
    return json as String;
  }
}

class JSONObjectDeserializer implements JsonDeserializer<dynamic> {
  @override
  dynamic fromJson(json) {
    return json;
  }
}
