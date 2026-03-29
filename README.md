# 🚀 FLODO AI: The High-Agency Task Architect
### *Track B: The Mobile Specialist Edition*

Welcome to **Flodo AI**, a task management experience designed for those who demand precision, persistence, and a refined aesthetic. This isn't just a To-Do list; it's a productivity engine built with a "zero-data-loss" philosophy and a sleek, emerald-on-onyx visual language.



---

## ✨ The Specialist Edge (Features)

I chose **Track B (Mobile Specialist)** because a professional app should feel alive and resilient. Here’s how I leveled up the core requirements:

* **🛡️ Battle-Proof Drafts:** Implementation of a real-time caching system using `SharedPreferences`. If a user accidentally swipes back while drafting a task, their progress is automatically restored upon return.
* **⛓️ Logic-Aware UI (Blocked-By):** A sophisticated dependency check. If Task B is blocked by Task A, Task B is visually locked (lower opacity/lock icon) and non-tappable until Task A is moved to the "Done" status.
* **🏆 Gamified Productivity:** Every task completed awards **+3 Points**. Users can track their standing via a custom **Leaderboard** and review their legacy in a dedicated **Completed Tasks** screen.
* **♻️ The Infinite Loop (Stretch Goal):** I implemented **Recurring Tasks**. When a recurring task is completed, the app clones the logic for the next day, ensuring consistent habits while keeping original logs intact.
* **🌓 Dark Mode by Default:** Designed with a high-contrast "Piano Black" and "Emerald Green" palette for a premium, developer-centric feel.

---

## 🛠️ The Tech Stack

* **Framework:** Flutter (3.x)
* **State Management:** `Provider` (Clean, reactive architectural flow)
* **Local Database:** `Hive` (High-performance NoSQL for instant persistence)
* **Local Storage:** `Shared_Preferences` (For non-blocking Draft persistence)
* **Logic:** Service-Provider Pattern

---

## 🚀 Step-by-Step Setup

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/flodo_ai_task_manager.git](https://github.com/YOUR_USERNAME/flodo_ai_task_manager.git)
    cd flodo_ai_task_manager
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate Database Adapters (Crucial):**
    Because we use Hive for high-speed data handling, you must run the build runner to generate the `task_model.g.dart` file:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Launch the App:**
    ```bash
    flutter run
    ```

---

## 🤖 AI Usage Report

I utilized Gemini/Claude as a pair-programmer to accelerate specific architectural patterns.

* **The Most Helpful Prompt:** *"Implement a try-finally block within a ChangeNotifier async method to ensure the isLoading state is toggled off even if the Hive database write fails."*
* **AI Hallucination & Fix:** The AI initially suggested a basic `ListView` for all tasks. I had to manually override the logic to create `computed getters` (`tasks` vs `completedTasks`) to ensure that tasks move between screens automatically when their status changes to "Done," satisfying the points-trigger requirement.

---

## 📽️ Submission Details

* **Track Chosen:** Track B (Mobile Specialist)
* **Stretch Goal:** Recurring Tasks & Points/Leaderboard System.
* **Demo Video:** [INSERT YOUR GOOGLE DRIVE LINK HERE]
* **Technical Decision I'm Proud Of:** I'm particularly proud of the **Atomic Save Logic**. By wrapping the database write and the state update in a `try...finally` block, I ensured the "buffering" overlay never hangs, even if the disk is full or the database encounters a lock. This provides a "High-Agency" user experience where the UI never feels broken or unresponsive.

---
*Built with precision for the Flodo AI Take-Home Assignment.*
