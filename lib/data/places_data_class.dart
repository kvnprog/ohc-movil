import 'dart:convert';

import 'package:flutter/material.dart';

class Places {

  String name;
  IconData icon;
  bool isActive;
  String? timeStart;
  String? timeEnd;
  int? numeroDeIncidencias;

  
  Places({
    required this.name,
    required this.icon,
    required this.isActive,
    this.timeStart,
    this.timeEnd,
    this.numeroDeIncidencias,
  });

  Places copyWith({
    String? name,
    IconData? icon,
    bool? isActive,
    String? timeStart,
    String? timeEnd,
    int? numeroDeIncidencias,
  }) {
    return Places(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      numeroDeIncidencias: numeroDeIncidencias ?? this.numeroDeIncidencias,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'isActive': isActive,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'numeroDeIncidencias': numeroDeIncidencias,
    };
  }

  factory Places.fromMap(Map<String, dynamic> map) {
    return Places(
      name: map['name'] ?? '',
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      isActive: map['isActive'] ?? false,
      timeStart: map['timeStart'],
      timeEnd: map['timeEnd'],
      numeroDeIncidencias: map['numeroDeIncidencias']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Places.fromJson(String source) => Places.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Places(name: $name, icon: $icon, isActive: $isActive, timeStart: $timeStart, timeEnd: $timeEnd, numeroDeIncidencias: $numeroDeIncidencias)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Places &&
      other.name == name &&
      other.icon == icon &&
      other.isActive == isActive &&
      other.timeStart == timeStart &&
      other.timeEnd == timeEnd &&
      other.numeroDeIncidencias == numeroDeIncidencias;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      icon.hashCode ^
      isActive.hashCode ^
      timeStart.hashCode ^
      timeEnd.hashCode ^
      numeroDeIncidencias.hashCode;
  }
}
