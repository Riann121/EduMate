import 'package:flutter/material.dart';

class CourseItem {
  final String courseName;
  final String teacherName;
  final Widget page;

  const CourseItem(this.courseName, this.teacherName, this.page);
}