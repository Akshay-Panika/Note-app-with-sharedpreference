import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note_screen.dart';
import 'note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {


  // getData
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

  int noteListLength(){
    return noteList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(elevation: 1,
        title:  const Text("Note app with sharedpreference"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:15.0),
            child: Center(child: Text(noteListLength().toString(),style: const TextStyle(fontSize: 19),)),
          ),
        ],
      ),

      // NoteScreen
      body: noteList.isEmpty ? const Center(child: Text('No data',style: TextStyle(fontSize: 19),),):
      ListView.builder(
        itemCount:noteList.length,
        itemBuilder: (context, index) {
          var indexNo = 1;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 1)),
              leading: CircleAvatar(child: Text('${index+indexNo}'),),
              title: Text(noteList[index].title.toString()),
              subtitle:Text(noteList[index].descriptions.toString()),
              trailing: IconButton(onPressed: () {
                setState(() {
                  noteList.remove(noteList[index]);
                  List<String> stringList = noteList.map((item) => json.encode(item.toMap())).toList();
                  sharedPreferences.setStringList('list', stringList);
                });
              }, icon: const Icon(Icons.delete),),
            ),
          );
        },),

      // floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          String refresh = await
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNoteScreen()));
          if(refresh == 'loadData'){
            setState(() {
              getData();
            });
          }

        },child: const Icon(Icons.add),
      ),
    );
  }
}
