import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deletebyId;

  const ExerciseCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deletebyId,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == 'edit') {
            navigateEdit(item);
          } else if (value == 'delete') {
            deletebyId(id);
          }
        }, itemBuilder: (context) {
          return [
            const PopupMenuItem(
              child: Text('Edit'),
              value: 'edit',
            ),
            const PopupMenuItem(
              child: Text('Delete'),
              value: 'delete',
            ),
          ];
        }),
      ),
    );
  }
}
