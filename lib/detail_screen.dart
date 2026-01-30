import 'package:flutter/material.dart';
import 'car_model.dart'; // ПРОВЕРЬ: есть ли тут класс Car и Consumable
import 'post_service.dart'; // ПРОВЕРЬ: есть ли тут PartPrice и fetchPartPrices

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Безопасное получение аргументов
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    
    if (args == null || args is! Car) {
      return const Scaffold(body: Center(child: Text("Ошибка: Данные авто не найдены")));
    }

    final Car car = args;

    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        backgroundColor: Colors.blueGrey[50],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Картинка с обработкой ошибки загрузки
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  car.image, 
                  height: 300, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300, 
                    color: Colors.grey[300], 
                    child: const Icon(Icons.directions_car, size: 100)
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text('ТЕХНИЧЕСКИЕ ХАРАКТЕРИСТИКИ', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              
              // Характеристики
              ...car.specs.map((s) => ListTile(
                leading: const Icon(Icons.settings, color: Colors.blueGrey), 
                title: Text(s),
                visualDensity: VisualDensity.compact,
              )),
              
              const Divider(height: 40),
              const Text('РАСХОДНИКИ И ТО', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              
              // Расходники
              ...car.consumables.map((c) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  leading: const Icon(Icons.build_circle_outlined, color: Colors.orange),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Интервал: ${c.interval}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Рекомендация: ${c.recommendation}', 
                        style: const TextStyle(color: Colors.blueGrey, fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
              )),

              const SizedBox(height: 20),
              const Text('ЦЕНЫ ИЗ API МАГАЗИНА', 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 10),
              
              // Блок API
              FutureBuilder<List<PartPrice>>(
                future: fetchPartPrices(car.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text('Ошибка подключения к серверу цен');
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      children: snapshot.data!.map((p) => ListTile(
                        title: Text(p.partName),
                        trailing: Text(p.price, 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                      )).toList(),
                    );
                  }
                  return const Text('Данные о ценах временно недоступны');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}