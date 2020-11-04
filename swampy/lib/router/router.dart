import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:swampy/pages/pages.dart';

class FluroRouter {
  static fluro.FluroRouter router = fluro.FluroRouter();
  static fluro.Handler _productHandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductPage(id: params['id'][0]));
  static fluro.Handler _homehandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());
  static fluro.Handler _productshandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          ProductsPage());
  static fluro.Handler _ordershandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          OrdersPage());
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
    // to do: add individual order
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
