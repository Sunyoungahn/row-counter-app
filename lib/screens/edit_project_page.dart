import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:row_counter_app/db/project_database.dart';
import 'package:row_counter_app/screens/update_project_form.dart';

import '../constant.dart';
import '../model/project.dart';

class EditProjectPage extends StatefulWidget {
  final Project? project;

  const EditProjectPage({Key? key, this.project}) : super(key: key);

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late int numOfRow;

  @override
  void initState() {
    super.initState();

    title = widget.project?.title ?? '';
    numOfRow = widget.project?.numOfRow ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Project",
          style: TextStyle(
            color: kAppBarColor,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            Project newProject = widget.project!.copy(numOfRow: numOfRow);
            await ProjectDatabase.instance.update(newProject);

            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kAppBarColor,
          ),
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
      onPressed: addOrEditProject,
      icon: const Icon(Icons.done),
      color: isInputValid ? kAppBarColor : null,
    );
  }

  void addOrEditProject() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.project != null;
      if (isUpdating) {
        await updateProject();
        print("current project is updated!");
      } else {
        await addProject();
        print("new project created");
      }
      Navigator.of(context).pop();
    }
  }

  Future updateProject() async {
    final project = widget.project!.copy(
      id: widget.project!.id,
      title: title,
      numOfRow: numOfRow,
    );

    await ProjectDatabase.instance.update(project);
  }

  Future addProject() async {
    final project = Project(
      //unique id generator
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      numOfRow: numOfRow,
    );

    await ProjectDatabase.instance.create(project);
  }
}
