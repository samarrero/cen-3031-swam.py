import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swampy/models/order.dart';
import 'package:swampy/models/product.dart';
import 'package:swampy/router/route_names.dart';
import 'package:swampy/router/router.dart';
import 'package:swampy/services/firebase_auth_service.dart';
import 'package:swampy/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data/data.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((v) => null);
  getFirebaseCollection();
  FluroRouter.setupRouter();
  runApp(
      // Swampy()
      MultiProvider(
          providers: [
            Provider(
              create: (_) => FirebaseAuthService(),
            ),
            StreamProvider(
              create: (context) => context.read<FirebaseAuthService>().onAuthStateChanged,
            ),
          ],
          child: Swampy()
      )
  );
}
Future getFirebaseCollection() async {
  Stopwatch stopwatch = new Stopwatch()..start();
  FirebaseFirestore.instance.collection('products').get().then((products) {
    for (int i = 0; i < products.docs.length; i++) {
      var doc = products.docs[i];
      var data = doc.data();
      productsList.add(new Product(id: data['id'], name: data['name'], vendor: data['vendor'], price: data['price'], amountInInventory: data['inventory'], type: data['type'], amountSold: data['amount_sold']));
    }
  });

  // var top5 = await FirebaseFirestore.instance.collection('products').orderBy('price', descending: true).limit(5).get();
  // for (var doc in top5.docs) {
  //   print(doc.data());
  // }



  FirebaseFirestore.instance.collection('orders').get().then((orders) {
    for (int i = 1; i < orders.docs.length; i++) {
      var doc = orders.docs[i];
      var data = doc.data();
      ordersList.add(new Order(id: data['id'], orderNumber: data['order_number'], date: DateTime.fromMillisecondsSinceEpoch(data['date'].seconds * 1000), productsAndAmount: {productsList[3]: 2, productsList[4]: 1}, total: data['total'], fulfilled: data['fulfilled']));
    }
  });


  print('getFirebaseCollection() executed in ${stopwatch.elapsed}');
}

DateTime reformatDateTime(String s) {
  var inputFormat = DateFormat('MM/dd/yyyy');
  var date1 = inputFormat.parse(s);

  var outputFormat = DateFormat('yyyy-MM-dd');
  return outputFormat.parse('$date1');
}



class Swampy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Style.theme,
      initialRoute: HomeRoute,
      onGenerateRoute: FluroRouter.router.generator,
    );
  }
}