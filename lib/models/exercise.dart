import 'package:flutter/material.dart';
import 'package:flutter_bloc_app/models/add_exercide.dart';
import 'package:flutter_bloc_app/services/todo_services.dart';
import 'package:flutter_bloc_app/widget/cards_exercise.dart';

import '../utils/snackbar_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise List')),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Exercise Added',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return ExerciseCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      deletebyId: deleteById);
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToExercisePage,
        label: const Text('Add Exercise'),
      ),
    );
  }

  Future<void> navigateToExercisePage() async {
    final route = MaterialPageRoute(builder: (context) => AddExercise());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddExercise(
              todo: item,
            ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await ExerciseService.fetchData();
    //print(response.statusCode);
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showSuccessMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await ExerciseService.deleteById(id);
    if (isSuccess == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      showSuccessMessage(context, message: 'Exercise successfully deleted');
    }
  }
}
