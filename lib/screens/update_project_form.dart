import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:row_counter_app/constant.dart';

class UpdateProjectForm extends StatelessWidget {
  final String? title;
  final int? numOfRow;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<int?> onChangedNumOfRow;

  const UpdateProjectForm({
    Key? key,
    this.title = '',
    this.numOfRow,
    required this.onChangedTitle,
    required this.onChangedNumOfRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTitle(),
            const SizedBox(
              height: 24,
            ),
            buildNumOfRow(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.grey),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildNumOfRow() => TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        initialValue: numOfRow.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          //hintText: '0',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        validator: (numOfRow) => numOfRow != null && numOfRow.isEmpty
            ? 'Please set the number of rows'
            : null,
        onChanged: (numberChanged) => {
          onChangedNumOfRow(
            int.tryParse(numberChanged),
          ),
        },
      );
}
