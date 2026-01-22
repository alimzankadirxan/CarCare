import 'package:flutter/material.dart';

void main() {
  runApp(CarCareApp());
}

class CarCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarCare',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800],
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[700],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/consumables': (context) => ConsumablesScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главная — CarCare')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Карточка с машиной
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Volkswagen Passat CC',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900]),
                    ),
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://avatars.mds.yandex.net/get-autoru-vos/2158086/967eda01771ff8715b776197f2ea61df/1200x900',
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Кнопка перехода
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ConsumablesScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOut;
                      var tween =
                          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                  ),
                );
              },
              icon: Icon(Icons.list_alt, size: 24),
              label: Text('Посмотреть расходники'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsumablesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> consumables = [
    {'name': 'Масло моторное', 'icon': Icons.oil_barrel},
    {'name': 'Фильтр воздушный', 'icon': Icons.filter_alt},
    {'name': 'Фильтр масляный', 'icon': Icons.build},
    {'name': 'Свечи зажигания', 'icon': Icons.flash_on},
    {'name': 'Тормозные колодки', 'icon': Icons.car_repair},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Расходники')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: consumables.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(consumables[index]['icon'], color: Colors.blueGrey[700]),
              title: Text(
                consumables[index]['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${consumables[index]['name']} выбрано'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
