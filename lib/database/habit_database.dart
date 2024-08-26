import 'package:flutter/material.dart';
import 'package:habits/models/app_settings.dart';
import 'package:habits/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static Isar? _isar; // Nullable Isar instance to avoid multiple initializations

  // Initialize the database only once
  static Future<void> initialize() async {
    if (_isar == null) {
      try {
        final dir = await getApplicationCacheDirectory();
        _isar = await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
        print('Database initialized');
      } catch (e) {
        print('Error initializing database: $e');
      }
    } else {
      print('Database already initialized');
    }
  }

  Isar get isar => _isar!; // Non-null assertion when accessing Isar

  // Save first launch date if it doesn't exist
  static Future<void> saveFirstLaunchDate() async {
    final existingSettings = await _isar!.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await _isar!.writeTxn(() => _isar!.appSettings.put(settings));
    }
  }

  static Future<DateTime?> getFirstLaunchDate() async {
    final settings = await _isar!.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  List<Habit> currentHabits = [];

  // Add a new habit and refresh the list
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(() async {
      await isar.habits.put(newHabit);
    });
    await readHabits(); // Refresh the list after adding a new habit
  }

  // Read all habits and update the UI
  Future<void> readHabits() async {
    final fetchedHabits = await isar.habits.where().findAll();
    currentHabits = fetchedHabits; // Directly assign the list
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Update habit completion status
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(todayDate)) {
          habit.completedDays.add(todayDate);
        } else {
          habit.completedDays.removeWhere((date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        }
        await isar.habits.put(habit);
      });
      await readHabits(); // Refresh the list after updating a habit
    }
  }

  // Update habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
      await readHabits(); // Refresh the list after updating the habit name
    }
  }

  // Delete a habit and refresh the list
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    await readHabits(); // Refresh the list after deleting a habit
  }
}
