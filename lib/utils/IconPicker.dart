import 'package:flutter/material.dart';

class IconPicker {
  IconData pick(String name) {
    switch (name) {
      case 'Электричество':
        return Icons.lightbulb;
      case 'Газ':
        return Icons.fireplace;
      case 'Мусор':
        return Icons.recycling;
      case 'Вода':
        return Icons.water_drop;
      case 'Отопление':
        return Icons.thermostat;
      case 'Интернет':
        return Icons.wifi;
      case 'Канализация':
        return Icons.plumbing;
      case 'Телефон':
        return Icons.phone;
      case 'Телевидение':
        return Icons.tv;
      case 'Домофон':
        return Icons.doorbell;
      case 'Охрана':
        return Icons.security;
      case 'Уборка':
        return Icons.cleaning_services;
      case 'Лифт':
        return Icons.elevator;
      case 'Парковка':
        return Icons.local_parking;
      case 'Освещение':
        return Icons.light_mode;
      case 'Кондиционирование':
        return Icons.ac_unit;
      case 'Содержание дома':
        return Icons.house;
      case 'Ремонт':
        return Icons.build;
      case 'Детская площадка':
        return Icons.child_friendly;
      case 'Сауна':
        return Icons.hot_tub;
      case 'Бассейн':
        return Icons.pool;
      case 'Фитнес-зал':
        return Icons.fitness_center;
      case 'Обслуживание сада':
        return Icons.grass;
      case 'Вентиляция':
        return Icons.air;
      case 'Вывоз снега':
        return Icons.ac_unit; // можно использовать ту же иконку для кондиционирования
      case 'Пожарная сигнализация':
        return Icons.fire_extinguisher;
      case 'Резервное питание':
        return Icons.power;
      case 'Питьевая вода':
        return Icons.local_drink;
      case 'Дезинсекция':
        return Icons.pest_control;
      case 'Благоустройство территории':
        return Icons.landscape;
      default:
        return Icons.question_mark;
    }
  }
}
