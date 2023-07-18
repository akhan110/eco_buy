import 'package:eco_buy/screens/mobile_side.dart/layout_page.dart';
import 'package:eco_buy/screens/web_side/cart_items.dart';
import 'package:eco_buy/screens/web_side/delete_products.dart';
import 'package:eco_buy/screens/web_side/update_products.dart';
import 'package:eco_buy/screens/web_side/web_main_screen.dart';
import 'package:eco_buy/screens/web_side/web_login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDOaPG9Y6WqBzUVfgZxqqe0lN3udS6b6L4",
            authDomain: "eco-buy-1053c.firebaseapp.com",
            projectId: "eco-buy-1053c",
            storageBucket: "eco-buy-1053c.appspot.com",
            messagingSenderId: "623296416843",
            appId: "1:623296416843:web:fe2b3944a2ecba1bdf11ce"));
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sizer',
          theme: ThemeData.light(),
          home: const LayoutPage(),
          routes: {
            WebLoginScreen.id: (context) => WebLoginScreen(),
            WebAdminScreen.id: (context) => WebAdminScreen(),
            UpdateProductsScreen.id: (context) => const UpdateProductsScreen(),
            DeleteProductScreen.id: (context) => const DeleteProductScreen(),
            CartItemsScreen.id: (context) => CartItemsScreen(),
          },
        );
      },
    );
  }
}
