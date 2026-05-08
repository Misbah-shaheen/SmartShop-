# SmartShop+ 🛍️
### A Complete Flutter E-Commerce Application

> **University Mobile Application Development — Lab Project**  
> Flutter SDK 3.29+ · Dart · Provider · Streams · Material Design 3

---

## 📁 Project Structure

```
smartshop_plus/
│
├── lib/
│   ├── main.dart                       ← App entry, MultiProvider, routing
│   │
│   ├── models/
│   │   └── product.dart                ← Product + CartItem model classes
│   │
│   ├── providers/
│   │   └── cart_provider.dart          ← ChangeNotifier cart state manager
│   │
│   ├── services/
│   │   └── product_service.dart        ← Async data layer (Firebase-ready)
│   │
│   ├── streams/
│   │   └── cart_stream.dart            ← StreamController + broadcast stream
│   │
│   ├── screens/
│   │   ├── splash_screen.dart          ← Animated splash + auto-navigation
│   │   ├── login_screen.dart           ← Login form + validation
│   │   ├── home_screen.dart            ← Product listing, search, categories
│   │   ├── product_detail_screen.dart  ← Full product view + add to cart
│   │   └── cart_screen.dart            ← Cart with StreamBuilder
│   │
│   ├── widgets/
│   │   ├── product_card.dart           ← Reusable product grid card
│   │   └── cart_item_tile.dart         ← Reusable cart item row
│   │
│   └── utils/
│       └── constants.dart              ← Colors, styles, routes, theme
│
├── pubspec.yaml
└── README.md
```

---

## ⚡ Setup Instructions

### Step 1 — Prerequisites

Make sure these are installed:
```bash
# Check Flutter
flutter --version    # Must be 3.29+

# Check Dart
dart --version       # Must be 3.0+
```

### Step 2 — Create the Project

```bash
flutter create smartshop_plus
cd smartshop_plus
```

Then **replace** the contents of `lib/` with all files provided.

### Step 3 — Update pubspec.yaml

Replace the default `pubspec.yaml` with the provided one, then run:

```bash
flutter pub get
```

### Step 4 — Create Assets Folder

```bash
mkdir -p assets/images assets/fonts
```

> **Note:** The app uses `google_fonts` package (downloads fonts at runtime), so no local font files are required. You can remove the `fonts:` section from `pubspec.yaml` if you don't add local font files.

### Step 5 — Run the App

```bash
# Run on connected device or emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Build APK
flutter build apk --release
```

### Step 6 — Demo Credentials

```
Email:    demo@smartshop.com
Password: password123
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2       # State management
  google_fonts: ^6.2.1   # Typography
  cupertino_icons: ^1.0.8
```

Install with:
```bash
flutter pub get
```

---

## 🔥 Firebase Setup (Optional)

The app is architected to be Firebase-ready. To enable Firebase:

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
```

### 2. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 3. Configure Firebase
```bash
flutterfire configure
```

### 4. Enable Firebase packages in pubspec.yaml
Uncomment these lines:
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.14.0
```

### 5. Replace dummy auth in login_screen.dart
```dart
// Replace this:
await Future.delayed(const Duration(milliseconds: 1500));

// With this:
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: _emailController.text.trim(),
  password: _passwordController.text,
);
```

### 6. Replace dummy data in product_service.dart
```dart
// Replace _fetchFromDummy() with:
final snapshot = await FirebaseFirestore.instance
    .collection('products')
    .get();
return snapshot.docs
    .map((doc) => Product.fromMap({...doc.data(), 'id': doc.id}))
    .toList();
```

---

## 🎓 Flutter Concepts Coverage

| Concept | File | Description |
|---------|------|-------------|
| `StatelessWidget` | `product_card.dart`, `product_detail_screen.dart`, `cart_item_tile.dart` | Widgets with no mutable state |
| `StatefulWidget` | `splash_screen.dart`, `login_screen.dart`, `home_screen.dart` | Widgets that rebuild on state change |
| Widget tree | `main.dart` | MultiProvider → MaterialApp → Screens → Widgets |
| Material Design | All screens | AppBar, Card, ElevatedButton, SnackBar, etc. |
| Custom widgets | `product_card.dart`, `cart_item_tile.dart` | Reusable encapsulated components |
| Navigation | All screens | `pushNamed`, `pushReplacementNamed`, arguments |
| `Provider` | `main.dart`, all screens | `MultiProvider`, `ChangeNotifierProvider` |
| `ChangeNotifier` | `cart_provider.dart` | Base class for CartProvider |
| `Consumer<T>` | `home_screen.dart`, `product_detail_screen.dart` | Granular rebuilds |
| `notifyListeners()` | `cart_provider.dart` | Triggers UI rebuilds |
| `async/await` | `product_service.dart`, `login_screen.dart`, `splash_screen.dart` | Async operations |
| `Future` | `product_service.dart` | Return type for async methods |
| `FutureBuilder` | `home_screen.dart` | Reactive async UI rendering |
| `Future.delayed()` | `splash_screen.dart`, `login_screen.dart` | Simulated delays |
| `Stream` | `cart_stream.dart` | Broadcast stream of cart data |
| `StreamController` | `cart_stream.dart` | Manages the stream lifecycle |
| `StreamBuilder` | `cart_screen.dart` | Real-time cart UI updates |
| `MediaQuery` | `splash_screen.dart`, `home_screen.dart` | Responsive sizing |
| `Flexible`/`Expanded` | All screens | Responsive flex layouts |
| `ListView.builder` | `home_screen.dart`, `cart_screen.dart` | Efficient list rendering |
| `GridView` | `home_screen.dart` | 2/3-column product grid |
| Form validation | `login_screen.dart` | `Form`, `GlobalKey`, `validator` |
| Model classes | `models/product.dart` | `Product`, `CartItem` with `fromMap`/`toMap` |
| Service layer | `services/product_service.dart` | Data access separation |
| Separation of concerns | All files | MVC-inspired architecture |

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────┐
│                   UI Layer                   │
│  Screens (StatelessWidget / StatefulWidget)  │
│  Widgets (Reusable components)               │
└──────────────────┬──────────────────────────┘
                   │ reads / writes
┌──────────────────▼──────────────────────────┐
│               State Layer                    │
│  CartProvider (ChangeNotifier + Provider)    │
│  CartStream (StreamController + broadcast)   │
└──────────────────┬──────────────────────────┘
                   │ calls
┌──────────────────▼──────────────────────────┐
│               Service Layer                  │
│  ProductService (async, Firebase-ready)      │
└──────────────────┬──────────────────────────┘
                   │ maps to/from
┌──────────────────▼──────────────────────────┐
│               Data Layer                     │
│  Product model, CartItem model               │
│  (Dummy data → replace with Firestore)       │
└─────────────────────────────────────────────┘
```

---

## 🖼️ Screen Flow

```
Splash Screen (2.5s)
    │
    └──► Login Screen (form validation)
              │
              └──► Home Screen (product grid)
                        │
                        ├──► Product Detail Screen (add to cart)
                        │
                        └──► Cart Screen (StreamBuilder, checkout)
```

---

## 💡 Key Implementation Notes

### Why StreamBuilder in CartScreen?
`CartProvider.notifyListeners()` updates `Consumer` widgets.  
`CartStream.updateCart()` pushes to a broadcast stream.  
`StreamBuilder` in `CartScreen` listens to this stream for **real-time** updates — demonstrating that multiple mechanisms can drive UI simultaneously.

### Why broadcast stream?
A regular `StreamController` allows only **one** listener. Using `.broadcast()` lets both the `AppBar` badge (via `Consumer`) and the `CartScreen` (via `StreamBuilder`) receive updates at the same time.

### Firebase-Ready Pattern
All model classes have `fromMap()` / `toMap()` factory methods that mirror Firestore document format. Replacing the dummy data source in `ProductService` requires only changing the method body — the rest of the app remains unchanged.

---

## 🧪 Viva Discussion Points

1. **What is the difference between StatelessWidget and StatefulWidget?**  
   → StatelessWidget has no mutable state (immutable). StatefulWidget holds a `State` object that can change and trigger rebuilds via `setState()`.

2. **How does Provider work?**  
   → `ChangeNotifierProvider` wraps the widget tree and injects `CartProvider`. `Consumer<CartProvider>` rebuilds when `notifyListeners()` is called.

3. **What is the difference between Future and Stream?**  
   → `Future<T>` delivers **one** value asynchronously. `Stream<T>` delivers **multiple** values over time — ideal for real-time updates.

4. **Why use FutureBuilder?**  
   → `FutureBuilder` automatically handles the three states of an async operation: `waiting` (loading), `done` (data), and `error` — cleanly mapping them to UI states.

5. **Why is the app Firebase-ready?**  
   → All data access goes through a service layer. Models use `fromMap()`/`toMap()` matching Firestore structure. Auth logic is isolated in one method. Swapping the data source requires minimal code changes.
