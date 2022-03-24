import 'package:flutter/material.dart';
import 'package:row_counter_app/db/project_database.dart';
import 'package:row_counter_app/model/project.dart';
import 'package:row_counter_app/screens/edit_project_page.dart';
import 'package:row_counter_app/screens/project_list_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant.dart';

class CounterPage extends StatefulWidget {
  final int projectID;

  const CounterPage({
    Key? key,
    required this.projectID,
  }) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late Project project;
  bool isLoading = false;
  int numOfRow = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshProject();
  }

  Future refreshProject() async {
    setState(() {
      isLoading = true;
    });
    project = await ProjectDatabase.instance.readProject(widget.projectID);
    final numOfRowCalled = project.numOfRow;
    setState(() {
      numOfRow = numOfRowCalled;
      isLoading = false;
    });
  }

  void _incrementCounter() {
    setState(() {
      numOfRow++;
    });
  }

  void _decrementCounter() {
    setState(() {
      numOfRow--;
    });
  }

  void _resetCounter() {
    setState(() {
      numOfRow = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Row Counter",
          style: TextStyle(
            color: kAppBarColor,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            Project newProject = project.copy(numOfRow: numOfRow);
            await ProjectDatabase.instance.update(newProject);

            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kAppBarColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Project newProject = project.copy(numOfRow: numOfRow);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProjectPage(
                    project: newProject,
                  ),
                ),
              );
              refreshProject();
            },
            icon: const Icon(
              Icons.edit,
              color: kAppBarColor,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: kAppBarColor,
            ),
            onPressed: () async {
              await ProjectDatabase.instance.delete(widget.projectID);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48.0),
                  color: Colors.white,
                  border: Border.all(
                    width: 2.0,
                    color: kTileBorderColor,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Text(
                        numOfRow.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: _resetCounter,
                          icon: const Icon(Icons.restart_alt_rounded),
                        ),
                        IconButton(
                          onPressed: _decrementCounter,
                          icon: const Icon(Icons.remove),
                        ),
                        IconButton(
                          onPressed: _incrementCounter,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const ProjectListPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
