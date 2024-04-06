import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<NoteModel> noteList =[];
  late SharedPreferences sharedPreferences;
  getData()async{
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? stringList = sharedPreferences.getStringList('list');
    if(stringList != null){
      noteList = stringList.map((item) => NoteModel.fromMap(json.decode(item))).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      // App bar
      appBar: AppBar(
      title: const Text('Add Note'),),

      body: Column(
        children: [

          // Container
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(controller: titleController,decoration: const InputDecoration(hintText: 'Title'),),
                TextField(controller: descriptionController,decoration: const InputDecoration(hintText: 'Subtitle'),),
              ],
            ),
          ),

          const SizedBox(height: 10,),

          // Save button
          InkWell(
            onTap: () {
              noteList.insert(0, NoteModel(title: titleController.text, descriptions: descriptionController.text));
              List<String> stringList = noteList.map((item) => json.encode(item.toMap())).toList();
              sharedPreferences.setStringList('list', stringList);
              Navigator.pop(context, 'loadData');
            },
            child: Container(
              height: 45,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                color: Colors.blue
              ),
              child: const Center(child: Text('Save',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),),
            ),
          )
        ],
      ),
    );
  }
}
