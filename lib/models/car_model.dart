import 'package:flutter/material.dart';

// 1. НОВОЕ: Модель расхода
class Expense {
  final String category; // Бензин, Ремонт, Мойка, Запчасти, Налог, Страховка
  final double amount;
  final DateTime date;
  final String note;

  Expense({
    required this.category,
    required this.amount,
    required this.date,
    this.note = "",
  });
}

class Consumable {
  final String name;
  final String recommendation;
  final String interval;
  final double kmInterval;

  Consumable({
    required this.name, 
    required this.recommendation, 
    required this.interval,
    required this.kmInterval,
  });
}

class Car {
  final String name;
  final String image;
  final String description;
  
  int mileage;
  int lastOilChange;
  int lastAntifreezeChange;
  String nextTehosmotr; 
  
  final List<String> specs;
  final List<Consumable> consumables;
  final bool isElectric;

  // 2. НОВОЕ: Список расходов для конкретной машины
  List<Expense> expenses;

  Car({
    required this.name,
    required this.image,
    required this.description,
    required this.mileage,
    required this.lastOilChange,
    this.lastAntifreezeChange = 0,
    this.nextTehosmotr = "05.2026",
    required this.specs,
    required this.consumables,
    this.isElectric = false,
    List<Expense>? expenses, // Инициализация списка
  }) : this.expenses = expenses ?? [];

  // Расчет износа масла
  double get oilLife {
    if (isElectric) return 0.0;
    
    double interval = consumables
        .firstWhere((c) => c.name.contains('Масло'), 
          orElse: () => Consumable(name: '', recommendation: '', interval: '', kmInterval: 8000))
        .kmInterval;
        
    return ((mileage - lastOilChange) / interval).clamp(0.0, 1.0);
  }

  // Расчет износа антифриза
  double get antifreezeLife {
    return ((mileage - lastAntifreezeChange) / 40000).clamp(0.0, 1.0);
  }

  // 3. НОВОЕ: Геттеры для финансовой аналитики
  double get totalExpenses {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  double get fuelExpenses {
    return expenses
        .where((e) => e.category == 'Бензин' || e.category == 'Зарядка')
        .fold(0, (sum, item) => sum + item.amount);
  }
  
  void updateMileage(int newKm) {
    if (newKm >= mileage) {
      mileage = newKm;
    }
  }

  // Метод для быстрого добавления расхода
  void addExpense(String category, double amount, {String note = ""}) {
    expenses.add(Expense(
      category: category,
      amount: amount,
      date: DateTime.now(),
      note: note,
    ));
  }
}

// Твой обновленный гараж с данными о расходах
List<Car> myGarage = [
  Car(
    name: 'Volkswagen Passat CC',
    image: 'assets/images/passat.png',
    description: 'Немецкое купе бизнес-класса.',
    mileage: 125000,
    lastOilChange: 118000,
    lastAntifreezeChange: 100000,
    nextTehosmotr: "03.2026",
    specs: ['1.8 TSI', 'DSG-7', '152 л.с.', '2012 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '5W-30 VW 504/507', interval: '8 000 км', kmInterval: 8000),
      Consumable(name: 'Фильтр масляный', recommendation: 'MANN-FILTER W 712/94', interval: '8 000 км', kmInterval: 8000),
    ],
    expenses: [
      Expense(category: 'Бензин', amount: 12500, date: DateTime.now(), note: 'АИ-95 Helios'),
      Expense(category: 'Мойка', amount: 3500, date: DateTime.now(), note: 'Комплекс'),
    ],
  ),
  Car(
    name: 'BMW M5 F90',
    image: 'assets/images/m5.png',
    description: 'Спортивный седан 600 л.с.',
    mileage: 45000,
    lastOilChange: 44000,
    lastAntifreezeChange: 30000,
    nextTehosmotr: "11.2026",
    specs: ['4.4 V8 Twin-Turbo', 'M xDrive', '600 л.с.', '2020 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '0W-30 BMW M TwinPower', interval: '5 000 км', kmInterval: 5000),
    ],
    expenses: [
      Expense(category: 'Бензин', amount: 25000, date: DateTime.now(), note: 'АИ-98 Qazaq Oil'),
      Expense(category: 'Запчасти', amount: 85000, date: DateTime.now(), note: 'Тормозные колодки'),
    ],
  ),
  Car(
    name: 'Toyota Land Cruiser 300',
    image: 'assets/images/300.png',
    description: 'Внедорожник для любых путей.',
    mileage: 15000,
    lastOilChange: 10000,
    lastAntifreezeChange: 10000,
    nextTehosmotr: "08.2027",
    specs: ['3.3 V6 Diesel', '10-АКПП', '299 л.с.', '2023 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '5W-30 Toyota Premium', interval: '10 000 км', kmInterval: 10000),
    ],
    expenses: [
      Expense(category: 'Бензин', amount: 18000, date: DateTime.now(), note: 'Дизель'),
    ],
  ),
  Car(
    name: 'Tesla Model 3',
    image: 'assets/images/Tesla Model 3.png', 
    description: 'Электрический инновационный седан.',
    mileage: 30000,
    lastOilChange: 0,
    lastAntifreezeChange: 20000,
    nextTehosmotr: "01.2027",
    isElectric: true,
    specs: ['Dual Motor', 'Long Range', '450 л.с.', '2021 г.'],
    consumables: [
      Consumable(name: 'Фильтр салона', recommendation: 'Tesla HEPA', interval: '2 года', kmInterval: 40000),
    ],
    expenses: [
      Expense(category: 'Зарядка', amount: 2000, date: DateTime.now(), note: 'Supercharger'),
    ],
  ),
  Car(
    name: 'Porsche 911 Turbo S',
    image: 'assets/images/Porsche 911 Turbo S.png', 
    description: 'Икона спортивных автомобилей.',
    mileage: 5000,
    lastOilChange: 4500,
    lastAntifreezeChange: 0,
    nextTehosmotr: "12.2026",
    specs: ['3.8 Flat-6', 'PDK', '650 л.с.', '2022 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '0W-40 Mobil 1 C40', interval: '7 500 км', kmInterval: 7500),
    ],
  ),
];