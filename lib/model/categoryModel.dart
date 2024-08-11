// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

CategoryModel dataFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String dataToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<Category> category;

  CategoryModel({
    required this.category,
  });

  CategoryModel copyWith({
    List<Category>? category,
  }) =>
      CategoryModel(
        category: category ?? this.category,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
  };
}

class Category {
  int id;
  String name;
  List<Product> product;

  Category({
    required this.id,
    required this.name,
    required this.product,
  });

  Category copyWith({
    int? id,
    String? name,
    List<Product>? product,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        product: product ?? this.product,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    product: List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "product": List<dynamic>.from(product.map((x) => x.toJson())),
  };
}

class Product {
  int id;
  String name;
  int minQty;
  int discount;
  int mrp;
  double price;
  int count;

  Product({
    required this.id,
    required this.name,
    required this.minQty,
    required this.discount,
    required this.mrp,
    required this.price,
    this.count = 0,
  });

  Product copyWith({
    int? id,
    String? name,
    int? minQty,
    int? discount,
    int? mrp,
    double? price,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        minQty: minQty ?? this.minQty,
        discount: discount ?? this.discount,
        mrp: mrp ?? this.mrp,
        price: price ?? this.price,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    minQty: json["min_qty"],
    discount: json["discount"],
    mrp: json["mrp"],
    price: json["price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "min_qty": minQty,
    "discount": discount,
    "mrp": mrp,
    "price": price,
  };
}
