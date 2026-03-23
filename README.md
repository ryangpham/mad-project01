# PantherBites

PantherBites is a Flutter app built for students who want to quickly find food near campus without blowing their weekly budget. It combines restaurant discovery, quick filtering, favorites, budget tracking, and an in-app meal matcher to suggest places based on mood, budget, and schedule.

## Project Summary

PantherBites helps you:

- Browse nearby restaurants around the GSU area using preloaded seed data.
- Filter by price tier (`$`, `$$`, `$$$`) and distance.
- Save favorite restaurants for faster repeat choices.
- Log meals and track spending against a weekly budget.
- Use the AI Meal Matcher to get top restaurant picks based on how you are feeling and how much time/money you have.

### Tech Stack

- Flutter (Material 3 UI)
- Dart
- SQLite (`sqflite`, `sqflite_common_ffi`, `sqflite_common_ffi_web`) for local meals/favorites data
- Shared Preferences for saved filters and budget settings

## Step-by-Step Setup

### 1) Install Flutter

Install Flutter SDK from the official docs:

- https://docs.flutter.dev/get-started/install

Then verify your environment:

```bash
flutter doctor
```

### 2) Clone the Project

```bash
git clone https://github.com/ryangpham/mad-project01
cd mad-project01
```

### 3) Install Dependencies

```bash
flutter pub get
```

### 4) Run the App

Start an emulator/simulator (or connect a device), then run:

```bash
flutter run
```

Optional web run:

```bash
flutter run -d chrome
```

### 5) Run Tests (Optional)

```bash
flutter test
```

## Simple User Guide

### Launch and Navigation

1. Open the app and wait for the splash screen to finish.
2. Use the bottom navigation bar to move between:
   - `Home`
   - `Favorites`
   - `Budget`

### Find Restaurants (Home)

1. Enter a restaurant name in the search bar and tap the arrow/search.
2. Tap the filter icon to set:
   - Price tier (`Any`, `$`, `$$`, `$$$`)
   - Max distance (miles)
3. Tap a restaurant card to open details.

### Use AI Meal Matcher

1. From Home, tap the `AI Match` floating button.
2. Choose your mood and toggles (strict budget, rush mode, next class timing).
3. Tap `Get Recommendations`.
4. Review the top matches and explanation breakdown.

### Save Favorites

1. Open a restaurant details page.
2. Tap `Add to Favorites`.
3. Go to the `Favorites` tab to view/remove saved restaurants.
4. You can also manually add a favorite from the `+` button in Favorites.

### Track Budget and Meals

1. Go to the `Budget` tab.
2. Tap `Set Budget` to define your weekly spending limit.
3. Add meals using either:
   - `+` in Budget (manual logging), or
   - Tapping menu items on a restaurant details page.
4. Watch `Budget`, `Spent`, and `Remaining` values update.

## Data Notes

- Restaurant and menu content are seeded in-app.
- Favorites and meals are stored locally in SQLite.
- Budget and filter preferences are stored locally with Shared Preferences.
