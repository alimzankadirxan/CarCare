class MyCar {
  final String model;
  final int year;
  int mileage;
  int lastOilChange;
  int lastAntifreezeChange;

  MyCar({
    required this.model,
    required this.year,
    required this.mileage,
    required this.lastOilChange,
    required this.lastAntifreezeChange,
  });

  // Логика напоминаний
  bool get needsOil => (mileage - lastOilChange) >= 8000;
  bool get needsAntifreeze => (mileage - lastAntifreezeChange) >= 40000;
}