import 'dart:convert';

class Parent {
  String? id;
  String? name;
  String? type;
  Parent({
    this.id,
    this.name,
    this.type,
  });

  Parent copyWith({
    String? id,
    String? name,
    String? type,
  }) {
    return Parent(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
    return Parent(
      id: map['id'],
      name: map['name'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Parent.fromJson(String source) => Parent.fromMap(json.decode(source));

  @override
  String toString() => 'Parent(id: $id, name: $name, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Parent &&
        other.id == id &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode;
}
