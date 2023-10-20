# JSON Deserialization

A simple JSON deserialization package for Dart and Flutter.

## Features

Very simple and manual JSON parsing, no code generations, no annotations.

## Getting started

- Add the package as a dependency:
```
flutter pub add json_deserializer
```

## Usage

- Create your model objects and accompany each of them with a custom deserializer.
- Use `OptionalDeserializer` and `ListDeserializer` to parse optional values and lists respectively.

```
class Person {
  final String name;
  final int age;
  final Person? boss;
  final List<Person>? children;

  Person({required this.name, required this.age, this.boss, this.children});
}

class PersonDeserializer implements JSONDeserializer<Person> {
  @override
  Person fromJson(json) {
    return Person(
      name: json['name'],
      age: json['age'],
      boss: OptionalDeserializer(PersonDeserializer()).fromJson(json['boss']),
      children:
          OptionalDeserializer(ListDeserializer(PersonDeserializer())).fromJson(json['children']),
    );
  }
}
```

## License

MIT License.