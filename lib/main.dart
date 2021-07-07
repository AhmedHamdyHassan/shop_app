import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_page_transition.dart';
import 'package:shop_app/screens/splash_screen.dart.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './providers/product_provider.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductProvider>(
            create: (context) => ProductProvider(null, null, []),
            update: (context, value, previous) => ProductProvider(value.token,
                value.userID, previous.items == null ? [] : previous.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order(null, null, []),
            update: (context, value, previous) => Order(value.token,
                value.userID, previous.orders == null ? [] : previous.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, value, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransition(),
                  TargetPlatform.iOS: CustomPageTransition()
                }),
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                textTheme:
                    TextTheme(bodyText1: TextStyle(color: Colors.white))),
            home: value.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: value.autoLogin(),
                    builder: (ctx, autoLoginvalue) =>
                        autoLoginvalue.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailsScreen.screenKey: (ctx) => ProductDetailsScreen(),
              CartScreen.screenKey: (ctx) => CartScreen(),
              OrdersScreen.screenKey: (ctx) => OrdersScreen(),
              UserProductScreen.screenKey: (ctx) => UserProductScreen(),
              EditProductScreen.screenKey: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}
