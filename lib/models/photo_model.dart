import 'dart:convert';

class PhotoModel {
  static List<PhotoModel> items = [];

  String? key;
  String? title;
  String? description;
  String? data1;
  String? imageLink;
  String? date;
  PhotoModel({
    this.key,
    this.title,
    this.description,
    this.data1,
    this.imageLink,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'title': title,
      'description': description,
      'data1': data1,
      'imageLink': imageLink,
      'date': date,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      key: map['key'] != null ? map['key'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      data1: map['data1'] != null ? map['data1'] as String : null,
      imageLink: map['imageLink'] != null ? map['imageLink'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoModel.fromJson(String source) => PhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhotoModel(key: $key, title: $title, description: $description, data1: $data1, imageLink: $imageLink, date: $date)';
  }

  @override
  bool operator ==(covariant PhotoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.key == key &&
      other.title == title &&
      other.description == description &&
      other.data1 == data1 &&
      other.imageLink == imageLink &&
      other.date == date;
  }

  @override
  int get hashCode {
    return key.hashCode ^
      title.hashCode ^
      description.hashCode ^
      data1.hashCode ^
      imageLink.hashCode ^
      date.hashCode;
  }
}
