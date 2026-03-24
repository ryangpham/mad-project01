# PantherBites

PantherBites is a Flutter app built for students who want to quickly find food near campus without blowing their weekly budget. It combines restaurant discovery, quick filtering, favorites, budget tracking, and an in-app meal matcher to suggest places based on mood, budget, and schedule.

## Project Summary

PantherBites helps you:

- Browse nearby restaurants around the GSU area using preloaded seed data.
- Filter by price tier (`$`, `$$`, `$$$`) and distance.
- Save favorite restaurants for faster repeat choices.
- Log meals and track spending against a weekly budget.
- Use the AI Meal Matcher to get top restaurant picks based on how you are feeling and how much time/money you have.

## Team Members

- Ryan Pham - Responsible for Budget screen, Favorites screen, SQLite database integration, SharedPreferences setup, and AI meal matcher implementation
- Devin Major - Responsible for Home screen, Restaurant Details screen, Search bar implementation and functionality, widget implementations

## Features

- Search nearby restaurants around the GSU area using seeded campus-friendly data.
- Filter restaurants by price tier and walking distance.
- View restaurant details, including menu items and quick meal logging.
- Save and manage favorite restaurants locally.
- Set a weekly food budget and track remaining spend.
- Log meals manually or from restaurant detail screens.
- Use the in-app AI Meal Matcher to rank restaurants by mood, budget, schedule, and favorites history.

## Technologies Used

- Flutter SDK: `3.38.7` (`flutter --version`)
- Dart SDK: `3.10.7`
- UI framework: Flutter with Material 3
- Packages: `sqflite`, `sqflite_common_ffi`, `sqflite_common_ffi_web`, `path`, `shared_preferences`, `cupertino_icons`
- Tools: Flutter CLI, local SQLite storage, Shared Preferences, `flutter_test`, `flutter_lints`

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

## Usage Guide

### Launch and Navigation

1. Open the app and wait for the splash screen to finish.
2. Use the bottom navigation bar to move between `Home`, `Favorites`, and `Budget`.

### Find Restaurants (Home)

1. Enter a restaurant name in the search bar and tap the arrow/search.
2. Tap the filter icon to set price tier and maximum distance.
3. Tap a restaurant card to open details.

### Use AI Meal Matcher

1. From Home, tap the `AI Match` floating button.
2. Choose your mood and toggles such as strict budget mode, rush mode, and next class timing.
3. Tap `Get Recommendations`.
4. Review the ranked matches and explanation breakdown.

### Save Favorites

1. Open a restaurant details page.
2. Tap `Add to Favorites`.
3. Go to the `Favorites` tab to view or remove saved restaurants.
4. You can also manually add a favorite from the `+` button in Favorites.

### Track Budget and Meals

1. Go to the `Budget` tab.
2. Tap `Set Budget` to define your weekly spending limit.
3. Add meals using either the `+` button in Budget or menu items on a restaurant details page.
4. Watch `Budget`, `Spent`, and `Remaining` values update.

## Database Schema

PantherBites stores local data in a SQLite database named `pantherbites.db`.

### `meals`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key, auto-increment |
| `mealName` | `TEXT` | Logged meal name |
| `restaurantName` | `TEXT` | Source restaurant |
| `price` | `REAL` | Meal cost |
| `date` | `TEXT` | ISO-8601 timestamp |

### `favorites`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | `INTEGER` | Primary key, auto-increment |
| `name` | `TEXT` | Restaurant name |
| `price` | `TEXT` | Price tier (`$`, `$$`, `$$$`) |
| `distance` | `REAL` | Distance in miles |
| `hours` | `TEXT` | Displayed operating hours |

## Data Notes

- Restaurant and menu content are seeded in-app.
- Favorites and meals are stored locally in SQLite.
- Budget and filter preferences are stored locally with Shared Preferences.

## Known Issues

- The AI Meal Matcher is a local rule-based ranking system rather than a live external AI service.
- Restaurant data is seeded locally, so listings do not update in real time.
- Database migrations are not implemented beyond the initial schema version.

## Future Enhancements

- Add live restaurant data and hours from a remote API.
- Add authentication and optional cloud sync for favorites and meal history.
- Expand restaurant coverage beyond the current seeded GSU-area set.
- Add analytics views for weekly and monthly spending patterns.

