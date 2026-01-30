class Consumable {
  final String name;
  final String recommendation;
  final String interval;

  Consumable({
    required this.name, 
    required this.recommendation, 
    required this.interval
  });
}

class Car {
  final String name;
  final String image;
  final String description;
  int mileage;
  int lastOilChange;
  final List<String> specs;
  final List<Consumable> consumables;

  Car({
    required this.name,
    required this.image,
    required this.description,
    required this.mileage,
    required this.lastOilChange,
    required this.specs,
    required this.consumables,
  });

  // Расчет износа масла (интервал 8000 км)
  double get oilLife => (mileage - lastOilChange) / 8000;
}

List<Car> myGarage = [
  Car(
    name: 'Volkswagen Passat CC',
    image: 'assets/images/passat.png',
    description: 'Немецкое купе бизнес-класса.',
    mileage: 125000,
    lastOilChange: 118000,
    specs: ['1.8 TSI', 'DSG-7', '152 л.с.', '2012 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '5W-30 VW 504/507', interval: '8 000 км'),
      Consumable(name: 'Фильтр масляный', recommendation: 'MANN-FILTER W 712/94', interval: '8 000 км'),
      Consumable(name: 'Свечи зажигания', recommendation: 'NGK PFR7S8EG', interval: '60 000 км'),
    ],
  ),
  Car(
    name: 'BMW M5 F90',
    image: 'assets/images/m5.png',
    description: 'Спортивный седан 600 л.с.',
    mileage: 45000,
    lastOilChange: 44000,
    specs: ['4.4 V8 Twin-Turbo', 'M xDrive', '600 л.с.', '2020 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '0W-30 BMW M TwinPower', interval: '5 000 км'),
      Consumable(name: 'Тормозные колодки', recommendation: 'BMW M Performance (керамика)', interval: 'По износу'),
      Consumable(name: 'Воздушный фильтр', recommendation: 'BMW Original (2 шт.)', interval: '20 000 км'),
    ],
  ),
  Car(
    name: 'Toyota Land Cruiser 300',
    image: 'assets/images/300.png',
    description: 'Внедорожник для любых путей.',
    mileage: 15000,
    lastOilChange: 10000,
    specs: ['3.3 V6 Diesel', '10-АКПП', '299 л.с.', '2023 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '5W-30 Toyota Premium Fuel Economy', interval: '10 000 км'),
      Consumable(name: 'Топливный фильтр', recommendation: 'Toyota 23390-F0010', interval: '20 000 км'),
      Consumable(name: 'Салонный фильтр', recommendation: 'Угольный антибактериальный', interval: '15 000 км'),
    ],
  ),
  Car(
    name: 'Tesla Model 3',
    image: 'assets/images/tesla_model_3.png',
    description: 'Электрический инновационный седан.',
    mileage: 30000,
    lastOilChange: 0, 
    specs: ['Dual Motor', 'Long Range', '450 л.с.', '2021 г.'],
    consumables: [
      Consumable(name: 'Жидкость омывателя', recommendation: 'Зимняя/Летняя (без метанола)', interval: 'По мере расхода'),
      Consumable(name: 'Тормозная жидкость', recommendation: 'DOT 3 / DOT 4', interval: '2 года'),
      Consumable(name: 'Фильтр салона', recommendation: 'Tesla HEPA Filter', interval: '2 года'),
    ],
  ),
  Car(
    name: 'Porsche 911 Turbo S',
    image: 'assets/images/porsche_911.png',
    description: 'Икона спортивных автомобилей.',
    mileage: 5000,
    lastOilChange: 4500,
    specs: ['3.8 Flat-6', 'PDK', '650 л.с.', '2022 г.'],
    consumables: [
      Consumable(name: 'Масло ДВС', recommendation: '0W-40 Mobil 1 C40', interval: '7 500 км'),
      Consumable(name: 'Шины', recommendation: 'Michelin Pilot Sport Cup 2', interval: 'По состоянию'),
      Consumable(name: 'Трансмиссионное масло', recommendation: 'Porsche PDK Fluid', interval: '60 000 км'),
    ],
  ),
];