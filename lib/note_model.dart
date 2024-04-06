
class NoteModel{
  String title;
  String descriptions;
  NoteModel({required this.title, required this.descriptions});

  NoteModel.fromMap(Map map):
      title = map['title'],
      descriptions = map['descriptions'];

  Map toMap(){
    return {
      'title':title,
      'descriptions':descriptions,
    };
  }
}