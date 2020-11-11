import 'package:swampy/models/product.dart';
import 'package:swampy/models/order.dart';
//SAMPLE DATA
List<Product> sampleProducts = [
  // PRODUCT VENDOR, PRODUCT TYPE, PRODUCT NAME, AMOUNT IN INVENTORY, AMOUNT SOLD
  Product(id: '0', name: 'Example T-Shirt', type: 'T-Shirt', vendor: 'Shirt Co.', price: 20, amountInInventory: 45, amountSold: 5),
  Product(id: '1', name: 'Example Jeans', vendor: 'Jeans Co.', type: 'Pants', price: 30, amountInInventory: 42, amountSold: 6),
  Product(id: '2', name: 'Example Jacket', vendor: 'Jacket Co.', type: 'Jacket', price: 45, amountInInventory: 34, amountSold: 12),
  Product(id: '3', name: 'Dad Jorts', vendor: 'Pants Co.', type: 'Pants', price: 35, amountInInventory: 34, amountSold: 17),
  Product(id: '4', name: 'No Cap', vendor: 'Hat Co.', type: 'Hat', price: 25, amountInInventory: 12, amountSold: 9),
  Product(id: '5', name: 'Example Beanie', vendor: 'Hat Co.', type: 'Hat', price: 16, amountInInventory: 554, amountSold: 14),
  Product(id: '6', name: 'Example Backpack', vendor: 'Bag Co.', type: 'Bag', price: 35, amountInInventory: 45, amountSold: 34),
  Product(id: '7', name: 'Example Pantaloons', vendor: 'Pants Co.', type: 'Pants', price: 40, amountInInventory: 12, amountSold: 56),
  Product(id: '8', name: 'Example Knickers', vendor: 'Pants Co.', type: 'Pants', price: 20, amountInInventory: 69, amountSold: 15),
];

List<Order> sampleOrders = [
  Order(id: '00', orderNumber: '123444332', date: DateTime(2020, 10, 9), productsAndAmount: {sampleProducts[0]: 4}, total: 120.21, fulfilled: true),
  Order(id: '01', orderNumber: '123444333', date: DateTime(2020, 10, 10), productsAndAmount: {sampleProducts[3]: 2, sampleProducts[4]: 1}, total: 17.38, fulfilled: true),
  Order(id: '02', orderNumber: '123444334', date: DateTime(2020, 10, 10), productsAndAmount: {sampleProducts[7]: 1, sampleProducts[1]: 3}, total: 86.45, fulfilled: true),
  Order(id: '03', orderNumber: '123444335', date: DateTime(2020, 10, 11), productsAndAmount: {sampleProducts[2]: 2, sampleProducts[0]: 1}, total: 60.49, fulfilled: true),
  Order(id: '04', orderNumber: '123444336', date: DateTime(2020, 10, 13), productsAndAmount: {sampleProducts[1]: 1, sampleProducts[2]: 3}, total: 38.48, fulfilled: false),
  Order(id: '05', orderNumber: '123444337', date: DateTime(2020, 10, 13), productsAndAmount: {sampleProducts[0]: 1, sampleProducts[8]: 1}, total: 58.39, fulfilled: true),
  Order(id: '06', orderNumber: '123444338', date: DateTime(2020, 10, 14), productsAndAmount: {sampleProducts[5]: 1, sampleProducts[6]: 2}, total: 42.20, fulfilled: false),
  Order(id: '07', orderNumber: '123444339', date: DateTime(2020, 10, 19), productsAndAmount: {sampleProducts[3]: 2, sampleProducts[6]: 1}, total: 19.20, fulfilled: false),
  Order(id: '08', orderNumber: '123444340', date: DateTime(2020, 10, 20), productsAndAmount: {sampleProducts[3]: 1, sampleProducts[4]: 2}, total: 10.80, fulfilled: false),
  Order(id: '09', orderNumber: '123444341', date: DateTime(2020, 10, 20), productsAndAmount: {sampleProducts[2]: 2, sampleProducts[0]: 1}, total: 59.30, fulfilled: false),
  Order(id: '10', orderNumber: '123444342', date: DateTime(2020, 10, 20), productsAndAmount: {sampleProducts[8]: 2, sampleProducts[1]: 1}, total: 69.19, fulfilled: false),
];



