# Memora - Flashcards App

A simple yet powerful Flashcards app built as part of the **GDG VITC App Development Recruitment Assignment**.  
The app helps users learn effectively by creating, organizing, and reviewing flashcards with ease.

---

## App Idea & Features Implemented

The app is designed to make learning interactive and structured.  
Here’s what’s implemented:

### Level 1: Basic Flashcards
- Create new flashcards with **question & answer**.
- Flip cards to toggle between question and answer.
- View all flashcards in a clean UI.

### Level 2: Navigation & Progress
- Navigate between multiple flashcards (swipe or next/prev).
- Show current card progress (e.g., *3 of 10*).
- Add images to flashcards.
- Mark cards as **learned** (they won’t appear again in the review).

### Level 3: Categories & Persistence
- Organize flashcards into categories (Math, Science, History, etc.).
- Save flashcards and progress in **local storage** (Hive DB).
- Added **Dark Mode** toggle.

---

## 🛠️ Tech Stack & Libraries Used

- **Framework:** Flutter (Dart)
- **State Management:** GetX
- **Local Storage:** Hive
- **UI:** Material Design with custom shades of blue
- **Other Packages:**
  - `flip_card` → for card flipping animations  
  - `get` → state management & navigation  
  - `hive` & `hive_flutter` → persistent local storage  
  - `flutter_card_swiper` → for navigating through flashcards

---

## ▶️ Steps to Run the Project

1. **Clone the repository**
   ```bash
   git clone https://github.com/adithiyaks/memora.git
   cd memora

2. **Install dependencies**
    flutter pub get

3. **Generate Hive adapters**
    flutter packages pub run build_runner build

4. **Run the app**
    flutter run

## Screenshots:
