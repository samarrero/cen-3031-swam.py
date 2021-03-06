import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/pages/pages.dart';

class FluroRouter {
  static fluro.FluroRouter router = fluro.FluroRouter();
  static fluro.Handler _productHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          final args = context.settings.arguments as Product;
          return ProductPage(id: params['id'][0], product: args);
    });
  static fluro.Handler _homehandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());
  static fluro.Handler _productshandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductsPage());
  static fluro.Handler _ordershandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrdersPage());
  static fluro.Handler _orderhandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          final args = context.settings.arguments as Order;
          return OrderPage(id: params['id'][0], order: args);
      });
  static fluro.Handler _analyticshandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          AnalyticsPage());
  static fluro.Handler _accountHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          AccountPage());
  static void setupRouter() {
    router.define(
      '/',
      handler: _homehandler,
    );
    router.define(
      '/products',
      handler: _productshandler,
    );
    router.define(
      '/products/:id',
      handler: _productHandler,
    );
    router.define(
      '/orders',
      handler: _ordershandler,
    );
    router.define(
      '/orders/:id',
      handler: _orderhandler,
    );
    router.define(
      '/analytics',
      handler: _analyticshandler,
    );
    router.define(
      '/account',
      handler: _accountHandler,
    );
    // router.define(
    //   '/product/:name',
    //   handler: _productHandler,
    // );
  }
}
