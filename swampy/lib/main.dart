import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swampy/router/route_names.dart';
import 'package:swampy/router/router.dart';
import 'package:swampy/services/firebase_auth_service.dart';
import 'package:swampy/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            )
          ],
          child: Swampy()
      )
  );
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