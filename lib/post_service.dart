import 'dart:convert';
import 'package:http/http.dart' as http;

// КЛАСС ДЛЯ ДЕТАЛЬНОГО ЭКРАНА (ЦЕНЫ)
class PartPrice {
  final String partName;
  final String price;

  PartPrice({required this.partName, required this.price});

  factory PartPrice.fromJson(Map<String, dynamic> json) {
    return PartPrice(
      partName: json['name'] ?? 'Запчасть',
      price: "${json['price']} \$",
    );
  }
}

// КЛАСС ДЛЯ МАГАЗИНА (POSTS SCREEN)
class Product {
  final String title;
  final String price;
  final String category;
  final String image;
  final String rating;

  Product({
    required this.title, 
    required this.price, 
    required this.category, 
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] ?? 'Товар',
      price: "${json['price']} \$",
      category: json['category'] ?? 'Аксессуары',
      image: json['image'] ?? '',
      rating: json['rating'] != null ? json['rating']['rate'].toString() : '0.0',
    );
  }
}

// ФУНКЦИЯ ДЛЯ DETAIL SCREEN
Future<List<PartPrice>> fetchPartPrices(String carModel) async {
  try {
    // Используем FakeStore как временный источник данных для ТО
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products?limit=3'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => PartPrice.fromJson(json)).toList();
    } else {
      return [PartPrice(partName: "Фильтр (Локально)", price: "15 \$")];
    }
  } catch (e) {
    return [PartPrice(partName: "Данные загружены из кэша", price: "-")];
  }
}

// ФУНКЦИЯ ДЛЯ POSTS SCREEN
Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/electronics'));
  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Ошибка загрузки');
  }
}