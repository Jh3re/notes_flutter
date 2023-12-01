class Task {
  String id;
  String name;
  bool isDone;
  String details;
 
  Task({required this.id,required this.name, this.isDone = false, this.details = ''});

  get createdAt => null;

  static fromMap(Map<String, dynamic> data) {}
Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }
}





  //}