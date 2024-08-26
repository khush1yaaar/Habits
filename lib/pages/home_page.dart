import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habits/database/habit_database.dart';
import 'package:habits/models/habit.dart';
import 'package:habits/utils/habit_util.dart';
import 'package:habits/widgets/habit_tile.dart';
import 'package:habits/widgets/heat_map.dart';
import 'package:habits/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeHabits();
  }

  Future<void> _initializeHabits() async {
    await Provider.of<HabitDatabase>(context, listen: false).readHabits();
    setState(() {}); // Trigger a rebuild after habits are loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
                Icons.restart_alt_outlined), // You can use any icon here
            onPressed: () {
              resetAllHabits();
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('CREATE NEW HABIT IS CALLED');
          createNewHabit();
        },
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDataBase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDataBase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: HabitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the data is being fetched
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Data is available, build the Heatmap
          return Heatmap(
            datasets: prepHeatMapDataSet(currentHabits),
            startDate: snapshot.data!,
          );
        } else if (snapshot.hasError) {
          // Handle any error that occurred during fetching data
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Handle the case when there's no data
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  void resetAllHabits() {
    final habitDatabase = context.read<HabitDatabase>();

    // Iterate over all current habits and set their completion status to false
    for (Habit habit in habitDatabase.currentHabits) {
      habitDatabase.updateHabitCompletion(habit.id, false);
    }
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;
    print('HABIT DATABASE');
    print(habitDatabase);
    if (currentHabits.isEmpty) {
      print('CURRENT HABIT LIST IS EMPTY');
      return const Center(
        child: Text('No habits yet!'),
      );
    }

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        final isCompletedToday = isHabitCompletedToday(habit.completedDays);
        return HabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              print('CANCEL HABIT');
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              print(newHabitName);
              if (newHabitName.isNotEmpty) {
                print('NEW HABIT IS NOT EMPTY');
                context
                    .read<HabitDatabase>()
                    .updateHabitName(habit.id, newHabitName);
              }

              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              print('CANCEL HABIT');
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Create a new Habit'),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              print(newHabitName);
              if (newHabitName.isNotEmpty) {
                print('NEW HABIT IS NOT EMPTY');
                context.read<HabitDatabase>().addHabit(newHabitName);
              }

              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              print('CANCEL HABIT');
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
