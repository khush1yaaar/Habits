import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const HabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // This ActionPane appears when sliding from right to left (Edit)
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: editHabit,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      // This ActionPane appears when sliding from left to right (Delete)
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: Colors.red.shade800,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color.fromARGB(255, 65, 143, 68)
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: ListTile(
            title: Text(
              text,
              // style: TextStyle(
              //   color: isCompleted
              // ),
            ),
            leading: Checkbox(
              activeColor: const Color.fromARGB(255, 65, 143, 68),
              value: isCompleted,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
