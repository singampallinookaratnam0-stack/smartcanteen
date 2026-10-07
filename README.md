# 🍽️ Smart Canteen - Food Pre-Ordering System

> **A Modern Flutter Web Mini-Project for College Canteen Food Pre-Ordering**  
> *Developed with Flutter, Dart, Material 3, and ChangeNotifier/Provider State Management.*

---

## 📌 1. Problem Statement & Motivation

During college lunch and short breaks, students and staff waste **15 to 25 minutes** standing in long canteen queues. This causes:
* Rushed meals and late attendance to subsequent lectures.
* Overcrowding and chaos at food pickup counters.
* Inefficient canteen kitchen demand planning and excessive food wastage.

### 💡 The Solution: Smart Canteen
**Smart Canteen** is a responsive web application that enables students to browse the daily canteen menu, customize their order in a shopping cart, submit verified student pickup details, and track their order through live preparation stages (`Order Received` ➔ `Preparing` ➔ `Ready for Pickup` ➔ `Completed`).

---

## ✨ 2. Key Features

| Feature | Description |
| :--- | :--- |
| **🍔 Dynamic Food Catalog** | Browse 16 realistic college canteen items across Breakfast, Meals, Snacks, and Beverages. |
| **🔍 Instant Search & Filter** | Real-time search by food name/ingredients and category chip filtering. |
| **🌿 Dietary & Prep Badges** | Green vegetarian indicator, preparation time (5–15 mins), and star ratings. |
| **🛒 Interactive Cart** | Live quantity increment/decrement, subtotal calculation, free campus fee badge, and empty states. |
| **📋 Verified Checkout Form** | Strict student validation for Name, Roll Number / Student ID, 10-digit Phone, and Time Slot. |
| **🧾 Instant Order Receipt** | Generates unique formatted token (`SC20261007XXX`) with itemized billing and summary. |
| **⏱️ Live Order Stepper** | 4-stage tracking timeline with viva demo controls (Manual Step, Auto-Advance Timer, and Counter Guides). |
| **🌐 Offline & Zero-Backend** | Runs 100% locally with mock Dart state management; requires no Firebase or paid APIs. |

---

## 🏗️ 3. Project Architecture & Structure

```
smartcanteen/
├── lib/
│   ├── main.dart                       # App entry point, MultiProvider & Material 3 setup
│   ├── models/
│   │   ├── food_item.dart              # FoodItem data class with null safety
│   │   └── order.dart                  # Order, OrderItem & OrderStatus enum with extensions
│   ├── data/
│   │   └── food_data.dart              # Mock catalog with 16 realistic canteen items & categories
│   ├── theme/
│   │   └── app_theme.dart              # Custom Material 3 food-canteen warm palette & styles
│   ├── providers/
│   │   └── cart_provider.dart          # State management (Cart, billing, and active order lifecycle)
│   ├── widgets/
│   │   ├── food_card.dart              # Food item card with web hover & cart controls
│   │   ├── cart_item.dart              # Cart row with +/- quantity controls
│   │   ├── category_chip.dart          # Category filter pill with icon & animations
│   │   └── order_status_stepper.dart   # Visual timeline stepper with 4 stages
│   └── screens/
│       ├── home_screen.dart            # Menu browsing, search bar, banner, and responsive grid
│       ├── cart_screen.dart            # Shopping cart overview & billing summary
│       ├── checkout_screen.dart        # Student details form with input validation
│       ├── confirmation_screen.dart    # Success acknowledgment & token receipt
│       └── order_tracking_screen.dart  # Live tracker with viva demo controls & counter directions
├── web/
│   ├── index.html                      # Flutter Web entry point & loading screen
│   ├── manifest.json                   # Web PWA manifest
│   ├── favicon.png                     # Browser icon
│   └── icons/                          # Application icons
├── preview/
│   └── index.html                      # Zero-dependency instant browser demo mirror
├── pubspec.yaml                        # Project metadata, Flutter SDK & dependencies
├── analysis_options.yaml               # Dart lint rules
└── README.md                           # Documentation & presentation guide
```

---

## 🚀 4. How to Run the Project

### Option A: Running via Flutter Web (Standard)

#### Step 1: Install Flutter SDK
If you haven't installed Flutter yet:
1. Download the Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows).
2. Extract it to `C:\src\flutter` (or another preferred location).
3. Add `C:\src\flutter\bin` to your system `PATH` environment variable.
4. Verify by opening a terminal and running:
   ```bash
   flutter doctor
   ```

#### Step 2: Install Project Dependencies
In the root directory of this project (`c:\smartcanteen`), run:
```bash
flutter pub get
```

#### Step 3: Run on Google Chrome
Launch the application directly in Chrome in development mode:
```bash
flutter run -d chrome
```

#### Step 4: Build for Production Web
To compile an optimized production web build:
```bash
flutter build web --release
```
The output files will be created in `build/web/`.

---

### Option B: Instant Browser Demo (Zero Setup Required)

If you need to test or demonstrate the application immediately without waiting to download or configure the Flutter SDK:

1. Open your file explorer at `C:\smartcanteen\preview`.
2. Double-click **`index.html`** to open it directly in Chrome or Edge.
3. **OR** run a lightweight local HTTP server using Python:
   ```bash
   cd c:\smartcanteen\preview
   python -m http.server 8080
   ```
   Open `http://localhost:8080` in your web browser.

---

## 🎓 5. College Viva / Demonstration Flow

Follow this step-by-step walkthrough during your project presentation:

1. **Menu Browsing & Search:**
   * Showcase the warm Material 3 design and hero banner.
   * Type `"Dosa"` or `"Coffee"` in the search bar to demonstrate instant real-time filtering.
   * Click different category chips (**Breakfast**, **Meals**, **Snacks**, **Beverages**) to filter by category.
2. **Cart Management:**
   * Click **“Add”** on 2–3 food items. Notice the floating badge update dynamically.
   * Open the Cart by clicking the cart icon in the top right.
   * Test the `+` and `–` quantity controls and verify that the Subtotal and Total update accurately.
3. **Checkout & Form Validation:**
   * Click **“Proceed to Checkout”**.
   * Try clicking **“Place Order”** with empty fields to show the faculty the validation messages.
   * Enter sample student information:
     * **Name:** Rahul Sharma
     * **Student ID:** 21BCE1042
     * **Phone:** 9876543210
     * **Pickup Time:** 12:30 PM (Lunch Break)
   * Click **“Place Order”**.
4. **Order Confirmation:**
   * Observe the generated Order ID (e.g., `SC20261007421`), itemized breakdown, and pickup summary.
5. **Live Order Tracking Simulation:**
   * Click **“Track Order Status”**.
   * Use the **“Simulate Next Stage”** button to transition between:
     * `Order Received` ➔ `Preparing Food` ➔ `Ready for Pickup` ➔ `Completed`.
     * Or toggle **“Auto Advance (Every 4s)”** for a hands-free presentation!
   * Point out the Canteen Counter Guidelines (Counter 1 vs. Counter 2).

---

## 🌐 6. Deployment Guide

To host this project online for free (e.g., GitHub Pages, Firebase Hosting, Netlify, or Vercel):

### Deploying to GitHub Pages:
```bash
flutter build web --base-href "/smartcanteen/"
cd build/web
git init
git checkout -b gh-pages
git add .
git commit -m "Deploy Smart Canteen Web"
git remote add origin https://github.com/<your-username>/smartcanteen.git
git push -u origin gh-pages --force
```

### Deploying to Netlify / Vercel:
1. Drag and drop the `build/web` folder into the Netlify Dashboard (or link the GitHub repo).
2. Set the build command to `flutter build web` and publish directory to `build/web`.

---

## 📄 License
This project is open-source and built for educational and demonstration purposes.
