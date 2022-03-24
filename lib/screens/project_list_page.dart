import 'package:flutter/material.dart';
import 'package:row_counter_app/db/project_database.dart';
import 'package:row_counter_app/screens/components/project_card.dart';
import 'package:row_counter_app/screens/create_new_project_page.dart';
import 'package:row_counter_app/screens/counter_page.dart';

import '../constant.dart';
import '../model/project.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late List<Project> projects;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshProject();
  }

  @override
  void dispose() {
    ProjectDatabase.instance.close();
    super.dispose();
  }

  Future refreshProject() async {
    setState(() {
      isLoading = true;
    });

    projects = await ProjectDatabase.instance.readAllProjects();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Project List",
          style: TextStyle(
            color: kAppBarColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateNewProjectPage(),
                ),
              );
              refreshProject();
            },
            icon: const Icon(
              Icons.add,
            ),
            color: kAppBarColor,
          ),
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : projects.isEmpty
              ? const Center(
                  child: Text(
                    "Add new project!",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : buildProject(),
    );
  }

  Widget buildProject() => GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: projects.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        int reverseIndex = projects.length - index - 1;
        final project = projects[reverseIndex];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CounterPage(
                  projectID: project.id!,
                ),
              ),
            );
            refreshProject();
          },
          child: ProjectCard(
            projectTitle: project.title,
            numOfRow: project.numOfRow,
          ),
        );
      });

  // Widget buildProject() => ListView.builder(
  //       itemCount: projects.length,
  //       itemBuilder: (context, index) {
  //         Size size = MediaQuery.of(context).size;
  //         final project = projects[index];
  //         return GestureDetector(
  //           onTap: () async {
  //             await Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) => CounterPage(
  //                   projectID: project.id!,
  //                 ),
  //               ),
  //             );

  //             refreshProject();
  //           },
  //           child: ProjectCard(
  //             size: size,
  //             projectTitle: project.title,
  //             numOfRow: project.numOfRow,
  //           ),
  //         );
  //       },
  //     );
}
