import 'package:flutter/material.dart';
import 'package:row_counter_app/constant.dart';
import 'package:row_counter_app/screens/update_project_form.dart';

import '../db/project_database.dart';
import '../model/project.dart';

class CreateNewProjectPage extends StatefulWidget {
  final Project? project;

  const CreateNewProjectPage({Key? key, this.project}) : super(key: key);

  @override
  State<CreateNewProjectPage> createState() => _CreateNewProjectPageState();
}

class _CreateNewProjectPageState extends State<CreateNewProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late int numOfRow;

  @override
  void initState() {
    super.initState();

    title = '';
    numOfRow = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Project",
          style: TextStyle(
            color: kAppBarColor,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: kAppBarColor,
        ),
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: UpdateProjectForm(
          title: title,
          numOfRow: numOfRow,
          onChangedTitle: (title) => setState(
            () {
              this.title = title;
            },
          ),
          onChangedNumOfRow: (numOfRow) => setState(
            () {
              if (numOfRow == null) {
                this.numOfRow = 0;
              } else {
                this.numOfRow = numOfRow;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isInputValid = title.isNotEmpty;
    return IconButton(
      onPressed: addProject,
      icon: const Icon(Icons.done),
      color: isInputValid ? kAppBarColor : null,
    );
  }

  void addProject() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      await addNewProject();
      print("new project created");
    }
    Navigator.of(context).pop();
  }

  Future addNewProject() async {
    final project = Project(
      //unique id generator
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      numOfRow: numOfRow,
    );

    await ProjectDatabase.instance.create(project);
  }
}
