import 'package:flutter/material.dart';

const String tableProjects = 'projects';

//column names on SQL
class ProjectFields {
  static final List<String> values = [
    id,
    title,
    numOfRow,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String numOfRow = 'numOfRow';
}

class Project {
  final int? id;
  final String title;
  final int numOfRow;

  const Project({
    this.id,
    required this.title,
    required this.numOfRow,
  });

  static Project fromJSON(Map<String, Object?> json) {
    return Project(
        id: json[ProjectFields.id] as int?,
        title: json[ProjectFields.title] as String,
        numOfRow: json[ProjectFields.numOfRow] as int);
  }

  Map<String, Object?> toJSON() => {
        ProjectFields.id: id,
        ProjectFields.title: title,
        ProjectFields.numOfRow: numOfRow,
      };

  Project copy({
    int? id,
    String? title,
    int? numOfRow,
  }) =>
      Project(
        id: id ?? this.id,
        title: title ?? this.title,
        numOfRow: numOfRow ?? this.numOfRow,
      );
}
