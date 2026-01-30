import 'package:flutter/material.dart';
import 'post_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('МАГАЗИН АВТОТОВАРОВ'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          // 1. Состояние загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          // 2. Обработка ошибок (те самые "4 ошибки")
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Ошибка загрузки: ${snapshot.error}', textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: () => setState(() { futureProducts = fetchProducts(); }),
                    child: const Text('Повторить'),
                  )
                ],
              ),
            );
          }

          // 3. Если данных нет
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Каталог пуст'));
          }

          // 4. Успешный вывод данных (Сетка)
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 900 ? 3 : (screenWidth > 600 ? 2 : 1),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 130, // Высота карточки
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return _buildProductItem(item);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(product.image, width: 80, height: 80, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(product.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(' ${product.rating}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}