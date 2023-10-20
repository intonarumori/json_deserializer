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
  Person fromJSON(json) {
    return Person(
      name: StringDeserializer().fromJSON(json['name']),
      age: IntDeserializer().fromJSON(json['age']),
      boss: OptionalDeserializer(PersonDeserializer()).fromJSON(json['boss']),
      children:
          OptionalDeserializer(ListDeserializer(PersonDeserializer())).fromJSON(json['children']),
    );
  }
}

final data = {
    "name": "George",
    "age": 42,
    "boss": {"name": "Arianne", "age": 55},
    "children": [
    {"name": "Nicky", "age": 11},
    {"name": "Peter", "age": 13},
    ]
};

final person = PersonDeserializer().fromJSON(data);

```

## License

MIT License.