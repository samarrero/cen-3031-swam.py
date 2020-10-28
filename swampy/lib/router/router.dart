import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:swampy/pages/home_page.dart';

class FluroRouter {
  static fluro.FluroRouter router = fluro.FluroRouter();
  // static fluro.Handler _productHandler = fluro.Handler(
  //     handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
  //         ProductPage(name: params['name'][0]));
  static fluro.Handler _homehandler = fluro.Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());
  static void setupRouter() {
    router.define(
      '/',
      handler: _homehandler,
    );
    // router.define(
    //   '/product/:name',
    //   handler: _productHandler,
    // );
  }
}

