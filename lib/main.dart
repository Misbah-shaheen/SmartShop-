// ============================================================
// main.dart
// App entry point — sets up Provider, theme, and named routes.
// Concept: Provider (MultiProvider), ChangeNotifierProvider,
//          MaterialApp, named routes, theme, runApp().
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'utils/constants.dart';

/// App entry point.
/// Sets up the global Provider tree ABOVE MaterialApp so that
/// all screens can access shared state.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for consistent mobile experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // System UI overlay style — status bar colour
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // For Firebase, initialize here:
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SmartShopApp());
}

/// Root widget — wraps the app in a MultiProvider.
/// Concept: MultiProvider, ChangeNotifierProvider, Provider setup.
class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Register all app-wide providers here.
      // CartProvider is available to every screen in the widget tree.
      // Concept: ChangeNotifierProvider — creates + provides CartProvider
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        // Add more providers here as the app grows:
        //   ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        //   ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        // App metadata
        title: 'SmartShop+',
        debugShowCheckedModeBanner: false,

        // Theme — defined in constants.dart
        theme: buildAppTheme(),

        // ============================================================
        // NAMED ROUTES
        // Concept: Navigation and routing
        // ============================================================
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.cart: (_) => const CartScreen(),
        },

        // onGenerateRoute handles routes that need arguments (e.g. product detail)
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.productDetail) {
            return MaterialPageRoute(
              builder: (_) => const ProductDetailScreen(),
              settings: settings, // passes arguments to the screen
            );
          }
          // Fallback — unknown route
          return MaterialPageRoute(
            builder: (_) => const _NotFoundScreen(),
          );
        },
      ),
    );
  }
}

/// Simple 404 fallback screen
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.midGrey),
            const SizedBox(height: 16),
            Text('Page not found', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
