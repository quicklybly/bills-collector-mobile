import 'package:flutter/material.dart';

class IconPicker {
  IconData pick(String name) {
    switch (name) {
      case 'Электричество':
        return Icons.lightbulb;
      case 'Газ':
        return Icons.fireplace;
      default:
        return Icons.question_mark;
    }
  }
}