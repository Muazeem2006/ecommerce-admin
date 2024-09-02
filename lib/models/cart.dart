import 'product.dart';

class Cart {
  final int id;
  final Map<Product, int> products;
  double get total => products.entries.fold<double>(
        0.0,
        (previousValue, entry) {
          return previousValue + (int.parse(entry.key.price) * entry.value);
        },
      );
  Cart({
    required this.id,
    required this.products,
  });
}
