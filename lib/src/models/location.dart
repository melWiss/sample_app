import 'dart:convert';

import 'package:sample_app/src/models/coordinate.dart';
import 'package:sample_app/src/models/parent.dart';

class Location {
  String? id;
  String? name;
  String? disassembledName;
  Coordinate? coord;
  String? type;
  bool? isBest;
  Parent? parent;
  Location({
    this.id,
    this.name,
    this.disassembledName,
    this.coord,
    this.type,
    this.isBest,
    this.parent,
  });

  Location copyWith({
    String? id,
    String? name,
    String? disassembledName,
    Coordinate? coord,
    String? type,
    bool? isBest,
    Parent? parent,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      disassembledName: disassembledName ?? this.disassembledName,
      coord: coord ?? this.coord,
      type: type ?? this.type,
      isBest: isBest ?? this.isBest,
      parent: parent ?? this.parent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'disassembledName': disassembledName,
      'coord': coord?.toList(),
      'type': type,
      'isBest': isBest,
      'parent': parent?.toMap(),
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      name: map['name'],
      disassembledName: map['disassembledName'],
      coord: map['coord'] != null
          ? Coordinate.fromList(List<double>.from(map['coord']))
          : null,
      type: map['type'],
      isBest: map['isBest'],
      parent: map['parent'] != null ? Parent.fromMap(map['parent']) : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  // String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Location(id: $id, name: $name, disassembledName: $disassembledName, coord: $coord, type: $type, isBest: $isBest, parent: $parent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Location &&
        other.id == id &&
        other.name == name &&
        other.disassembledName == disassembledName &&
        other.coord == coord &&
        other.type == type &&
        other.isBest == isBest &&
        other.parent == parent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        disassembledName.hashCode ^
        coord.hashCode ^
        type.hashCode ^
        isBest.hashCode ^
        parent.hashCode;
  }
}
