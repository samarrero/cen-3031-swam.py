import 'package:meta/meta.dart';

class Product {
  final String id;
  final String name;
  final String vendor;
  final double price;
  final int amountInInventory;
  final String type; //could be enum
  final int amountSold;

  const Product({
    @required this.id,
    @required this.name,
    @required this.vendor,
    @required this.price,
    @required this.amountInInventory,
    @required this.type,
    @required this.amountSold
  });
}