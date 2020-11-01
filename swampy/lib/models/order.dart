import 'package:meta/meta.dart';
import 'package:swampy/models/product.dart';

class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final Map<Product, int> productsAndAmount;
  final double total;
  final bool fulfilled; //could be enum with different statuses
  //maybe: billing stuff

  const Order({
    @required this.id,
    @required this.orderNumber,
    @required this.date,
    @required this.productsAndAmount,
    @required this.total,
    @required this.fulfilled
  });
}