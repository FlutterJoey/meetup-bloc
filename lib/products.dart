class Product {
  String name;
  double price;
  int stock;
  String id;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'],
      stock: map['stock'],
      price: map['price'],
    );
  }
}
