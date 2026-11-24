# EduMate - Developer & Agent Guide

Welcome to the **EduMate** project. This file provides everything an AI agent or developer needs to know to understand, develop, build, and debug this codebase efficiently.

---

## 1. Project Overview & Tech Stack

* **Application Name:** EduMate
* **Framework:** Flutter (Channel stable, 3.47+)
* **Language:** Dart 3.13+
* **Primary Target:** Android (API 21+ / Target SDK 34-36)
* **Local Storage / Database:** 100% Offline via **`hive_flutter: ^1.1.0`** (Pure Dart NoSQL storage engine, zero server dependencies).
* **Styling & Fonts:**
  * Custom monochrome/minimalist palette: [AppColors](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/theme/app_colors.dart)
  * Material 3 theme & Google Fonts (Montserrat): [AppTheme](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/theme/app_theme.dart)

---

## 2. Directory Structure & Key Files

```text
EduMate/
├── android/                        # Native Android configuration (Kotlin DSL gradle)
│   ├── app/
│   │   ├── build.gradle.kts        # JVM target 17, applicationId "com.example.edumate"
│   │   └── src/main/AndroidManifest.xml
│   └── build.gradle.kts
├── assets/
│   └── logos/edumate_logo.png     # App drawer logo
├── lib/
│   ├── main.dart                  # App entry point, Hive init & routes directly to HomePage
│   │
│   ├── services/
│   │   └── local_storage_service.dart # Centralized Hive service managing tasks, routines, courses
│   │
│   ├── theme/
│   │   ├── app_colors.dart        # Core color constants (primary #111111, surface #FFFFFF)
│   │   └── app_theme.dart         # Material 3 ThemeData with Montserrat typography
│   │
│   ├── home_page/
│   │   ├── home_page.dart         # Main dashboard, drawer navigation, today's tasks
│   │   ├── models/upcoming_exam_item.dart     # Exam item model
│   │   └── widgets/
│   │       ├── home_stat_card.dart            # Metric display card
│   │       ├── home_stats_grid.dart           # Dynamic grid reactive to Hive boxes
│   │       └── upcoming_exams_section.dart    # Weekly exams list
│   │
│   ├── tasks/
│   │   ├── task_page.dart                     # User task manager with ValueListenableBuilder
│   │   ├── Funtionalities/task_functionalities.dart # Local task CRUD helper
│   │   ├── widgets/
│   │   │   ├── task_item.dart                 # TaskItem model (id, title, detail, dueDate, isCompleted)
│   │   │   └── task_tile.dart                 # Individual task list tile with checkbox
│   │   └── utility/
│   │       ├── add_task_dialog.dart           # Modal dialog to create new task
│   │       └── edit_task_dialog.dart          # Modal dialog to edit or delete task
│   │
│   ├── routine/
│   │   ├── routine_page.dart                  # 3-step routine wizard (loads from Hive routine_box)
│   │   ├── pages/
│   │   │   ├── setup_page.dart                # Step 0: Set start time, duration, class/day counts
│   │   │   ├── grid_editor_page.dart          # Step 1: Interactive schedule table editor
│   │   │   └── final_page.dart                # Step 2: Read-only formatted routine grid
│   │   ├── input_validation/
│   │   │   ├── input_validation.dart          # calculateTime slot formatter
│   │   │   └── possible_class_validation.dart # classPossible 24-hour boundary checker
│   │   └── widgets/
│   │       ├── routine_action_button.dart
│   │       ├── routine_input_field.dart
│   │       └── routine_table_cell.dart
│   │
│   └── courses/
│       ├── courses_page.dart                  # Theory & Lab course directory (courses_box)
│       ├── course_details_page_template.dart  # Course tabs: Assignments & Lectures
│       └── utility/
│           ├── add_course_dialog.dart         # Create new course dialog (persists to Hive)
│           ├── add_item_dialog.dart           # Create assignment/lecture dialog (persists to Hive)
│           ├── assignment_details_page.dart   # Bottom sheet for assignment inspection
│           ├── assignment_item.dart           # AssignmentItem model
│           ├── assignment_tile.dart           # Assignment card widget
│           ├── course_item.dart               # CourseItem view model
│           ├── course_tile.dart               # Course card widget
│           ├── lecture_details_page.dart      # Bottom sheet for lecture inspection
│           ├── lecture_item.dart              # LectureItem model
│           └── lecture_tile.dart              # Lecture card widget
└── pubspec.yaml                               # Dependencies and asset declarations
```

---

## 3. Local Storage Architecture (`LocalStorageService`)

All persistent data is stored locally in Hive boxes initialized on startup:

### 1. `tasks_box`
Key: `String` (ID)
```dart
{
  'id': String,
  'title': String,
  'detail': String?,
  'dueDate': String (ISO8601),
  'isCompleted': bool,
}
```
* Reactively listened to via `LocalStorageService().tasksListenable`.

### 2. `routine_box`
Key: `'current_routine'`
```dart
{
  'startTime': String,       // e.g. "08:00"
  'duration': String,        // minutes per class, e.g. "60"
  'numClasses': String,      // e.g. "5"
  'numDays': String,         // e.g. "6"
  'routineData': Map<String, String>, // Keyed by "rowIndex-colIndex", e.g. "0-0": "Mathematics"
  'updatedAt': String (ISO8601),
}
```
* Reactively listened to via `LocalStorageService().routineListenable`.

### 3. `courses_box`
Key: `String` (courseId)
```dart
{
  'id': String,
  'name': String,
  'instructor': String,
  'overview': String,
  'isTheory': bool,
  'createdAt': String (ISO8601),
}
```
* Reactively listened to via `LocalStorageService().coursesListenable`.

### 4. `assignments_box`
Key: `String` (assignmentId)
```dart
{
  'id': String,
  'courseId': String,
  'title': String,
  'date': String (ISO8601),
  'details': String,
}
```

### 5. `lectures_box`
Key: `String` (lectureId)
```dart
{
  'id': String,
  'courseId': String,
  'title': String,
  'date': String (ISO8601),
}
```

### 6. `exams_box`
Key: `String` (examId)
```dart
{
  'id': String,
  'examTitle': String,
  'courseName': String,
  'syllabus': String,
  'examDate': String (ISO8601),
}
```
* Reactively listened to via `LocalStorageService().examsListenable`.

---

## 4. Critical Build & Environment Rules

1. **Path Spacing Workaround & Native Assets:**
   * On Windows, if the repository path contains spaces (e.g., `Androidd studio`), Flutter's native asset hooks fail with `'D:\Androidd' is not recognized as an internal or external command`.
   * **Fix in place:** In `pubspec.yaml`, `dependency_overrides` pins `path_provider_foundation: 2.4.0`. This prevents `objective_c: ^9.3.0` and its build hooks from being pulled into the build. **Do NOT remove this override unless Flutter tools native assets quoting is resolved.**
   * Directory junctions without spaces exist at `D:\flutter` and `D:\apk_project`.

2. **Java 17 Requirement:**
   * Android Gradle Plugin requires JDK 17.
   * `JAVA_HOME` is set to `C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot\`.
   * Flutter is preconfigured:
     ```powershell
     flutter config --jdk-dir "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
     flutter config --android-sdk "C:\Users\Dark\AppData\Local\Android\sdk"
     ```

3. **Reactive UI with Hive:**
   * Instead of Firestore's `StreamBuilder<QuerySnapshot>`, use `ValueListenableBuilder(valueListenable: LocalStorageService().xxxListenable, builder: ...)`.
   * This provides instant, synchronous, 60fps reactive updates across screen navigation with zero loading spinners or network lag.

4. **Wireless Device Debugging:**
   * Wireless debugging is enabled with `adb` (located at `C:\Users\Dark\AppData\Local\Android\sdk\platform-tools\adb.exe`).
   * To reconnect: `adb connect <IP>:<PORT>`.

---

## 5. Common Development Commands

* **Run on connected device/wireless phone:**
  ```powershell
  flutter run
  ```
* **Build debug APK:**
  ```powershell
  flutter build apk --debug
  ```
* **Run static code analysis:**
  ```powershell
  flutter analyze
  ```
* **Install dependencies:**
  ```powershell
  flutter pub get
  ```
* **Check attached devices:**
  ```powershell
  flutter devices
  ```

---

## 6. Changelog / Architecture Changes Log
*(IMPORTANT: Every agent modifying this codebase MUST append their changes to this section)*

### [2026-10-27] - Complete Migration from Firebase to Offline Hive Storage
* **Removed All Firebase Dependencies:**
  * Uninstalled `firebase_core`, `firebase_auth`, and `cloud_firestore` from [pubspec.yaml](file:///d:/Androidd%20studio/apk%20project/EduMate/pubspec.yaml).
  * Removed Google Services Gradle plugins from `android/app/build.gradle.kts` and `android/settings.gradle.kts`.
  * Deleted `android/app/google-services.json`, `firebase.json`, and `lib/firebase_options.dart`.
  * Removed `lib/courses/firebase/firebase_service.dart`.
* **Removed Authentication & Login Barrier:**
  * Removed `lib/login&registration` module.
  * Updated [main.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/main.dart) to launch directly into [HomePage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/home_page.dart).
  * Removed sign-out action from `HomePage` AppBar.
* **Implemented 100% Offline Hive Storage:**
  * Installed `hive_flutter: ^1.1.0`.
  * Created [LocalStorageService](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/services/local_storage_service.dart) with 5 dedicated boxes (`tasks_box`, `routine_box`, `courses_box`, `assignments_box`, `lectures_box`).
  * Migrated [TaskPage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/tasks/task_page.dart), [TaskFunctionalities](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/tasks/Funtionalities/task_functionalities.dart), and [edit_task_dialog.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/tasks/utility/edit_task_dialog.dart) to use Hive with real-time `ValueListenableBuilder`.
  * Migrated [RoutinePage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/routine/routine_page.dart) to persist schedule matrix and setup parameters locally.
  * Migrated [CoursesPage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/courses/courses_page.dart), [CourseDetailPage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/courses/course_details_page_template.dart), [add_course_dialog.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/courses/utility/add_course_dialog.dart), and [add_item_dialog.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/courses/utility/add_item_dialog.dart) to Hive.
  * Made [HomeStatsGrid](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/widgets/home_stats_grid.dart) dynamic, calculating active task, assignment, and course counts directly from Hive.

### [2026-10-27] - Home Page Stat Card Update
* Updated [HomeStatsGrid](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/widgets/home_stats_grid.dart):
  * Replaced the fourth metric card title from **"Lab Courses"** to **"No. of Courses"**.
  * Updated value computation to reflect `storage.getAllCourses().length` (total enrolled/created courses across both Theory and Lab).

### [2026-10-27] - Add Task & Edit Task Date Picker Fixes
* **[add_task_dialog.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/tasks/utility/add_task_dialog.dart):**
  * Set `firstDate: DateUtils.dateOnly(DateTime.now())` to prevent users from selecting past dates.
  * Initialized `_selectedDate` with `DateUtils.dateOnly(DateTime.now())`.
  * Clamped `initialDate` safely within `[firstDate, lastDate]` to prevent assertion crashes.
* **[edit_task_dialog.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/tasks/utility/edit_task_dialog.dart):**
  * Normalized initial date to `DateUtils.dateOnly(widget.initialTask.dueDate)`.
  * Set `firstDate: DateUtils.dateOnly(DateTime.now())` to prevent selecting past dates on task edits.
  * Clamped `initialDate` safely to `today` if the existing task date precedes today, avoiding Flutter `showDatePicker` bounds assertion errors.
  * Preserved `id` and `isCompleted` on task update.

### [2026-10-27] - Exams Management Section & Sidebar Integration
* **Exams Feature Module (`lib/exams/`):**
  * Created [ExamsPage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/exams/exams_page.dart) with full listing, empty state, and floating action button to schedule exams.
  * Created [ExamTile](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/exams/widgets/exam_tile.dart) displaying exam title, course name, syllabus excerpt, and a stylized calendar date badge.
  * Created [showAddExamDialog()](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/exams/dialogs/add_exam_dialog.dart) with title, course, syllabus inputs, and date picker restricted to today or future dates.
  * Created [showEditExamDialog()](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/exams/dialogs/edit_exam_dialog.dart) to view, edit, or delete existing exams.
* **Navigation Drawer (Sidebar):**
  * Added `_examsTile()` to the drawer in [HomePage](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/home_page.dart) with `Icons.assignment_turned_in_outlined` icon, navigating to `/exams`.
  * Registered `/exams` route in [main.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/main.dart).
* **Dynamic Local Storage & Home Integration:**
  * Added `exams_box` in [LocalStorageService](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/services/local_storage_service.dart) with methods `getAllExams()`, `getUpcomingExamsThisWeek()`, `addExam()`, `updateExam()`, and `deleteExam()`.
  * Seeded initial sample exams for immediate testing.
  * Updated [UpcomingExamsSection](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/widgets/upcoming_exams_section.dart) to reactively observe `storage.examsListenable` and display exams scheduled within the next 7 days, with an arrow header button linking directly to the full Exams page.
  * Updated [HomeStatsGrid](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/widgets/home_stats_grid.dart) so the "Upcoming Exams" stat card dynamically calculates `storage.getUpcomingExamsThisWeek().length`.

### [2026-10-27] - Course Deletion Feature
* **[course_details_page_template.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/courses/course_details_page_template.dart):**
  * Added delete course button in the `AppBar` actions (`IconButton` with delete icon).
  * Added a prominent "Delete Course" text button with delete icon in the Overview section.
  * Added `_confirmDeleteCourse()` which displays an `AlertDialog` confirmation warning that the course and all its associated assignments and lectures will be deleted.
  * On confirmation, executes `LocalStorageService().deleteCourse(widget.courseId)`, pops back to the Courses screen, and displays a SnackBar notification.
  * Automatically cascades deletion of all associated assignments and lectures in Hive via `LocalStorageService.deleteCourse()`.

### [2026-10-27] - Courses Page Heading Style Update
* **[courses_page.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/courses/courses_page.dart):**
  * Removed redundant top `Courses` header text from the scrollable body.
  * Promoted section headings to **"Theory Courses"** and **"Lab Courses"**.
  * Applied the header typography (`fontSize: 28, fontWeight: FontWeight.bold`) directly to the `SectionTitle` component.

### [2026-11-24] - Removed Hardcoded Sample Exams Seeding
* **[upcoming_exam_item.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/home_page/models/upcoming_exam_item.dart):**
  * Removed `buildDummyUpcomingExamItems()` and unused `package:flutter/material.dart` import.
* **[local_storage_service.dart](file:///d:/Androidd%20studio/apk%20project/EduMate/lib/services/local_storage_service.dart):**
  * Removed startup seeding of `exams_box` when empty in `LocalStorageService.init()`.
  * Added cleanup of legacy seeded sample exam keys (`dummy_quiz_1`, `dummy_mid_1`, `dummy_viva_1`) if already present in `exams_box`.

### [2026-11-24] - Upgraded Android Gradle, AGP, and Kotlin Versions
* **[gradle-wrapper.properties](file:///d:/Androidd%20studio/apk%20project/EduMate/android/gradle/wrapper/gradle-wrapper.properties):**
  * Upgraded Gradle wrapper distribution from `8.14` to `9.3.1`.
* **[settings.gradle.kts](file:///d:/Androidd%20studio/apk%20project/EduMate/android/settings.gradle.kts):**
  * Upgraded `com.android.application` (AGP) from `8.11.1` to `9.1.0`.
  * Upgraded `org.jetbrains.kotlin.android` (KGP) from `2.2.20` to `2.4.0`.
* **[app/build.gradle.kts](file:///d:/Androidd%20studio/apk%20project/EduMate/android/app/build.gradle.kts):**
  * Removed explicit `id("kotlin-android")` plugin declaration and migrated `kotlinOptions` to top-level `kotlin { compilerOptions { jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17 } }`.



