import 'package:cloud_firestore/cloud_firestore.dart';

class AudiosModel {
  final String id, audiourl, thumimage, title, des;
  final double dur;
  DateTime? dateadd = DateTime.now();

  AudiosModel(
      {this.id = '',
      this.audiourl = 'Ester Dony',
      this.title =
          'Hopefully Audrey can get surgery soon, recover from her illness, Hopefully Audrey can get surgery soon, recover from her illness, ',
      this.thumimage = 'assets/images/user.jpeg',
      required this.dur,
      this.des = "",
      this.dateadd});
  factory AudiosModel.fromJson(Map<dynamic, dynamic> json, ids) => AudiosModel(
        id: ids,
        audiourl: json["audiourl"],
        title: json["title"],
        thumimage: json["thumimage"],
        des: json["des"],
        dur: double.parse(json["dur"]),
        dateadd: DateTime.parse(json["dateadd"]),
      );

  Map<String, dynamic> toJson() => {
        'audiourl': audiourl,
        'title': title,
        'thumimage': thumimage,
        'des': des,
        'dateadd': dateadd!.toIso8601String(),
        'dur': dur.toString()
      };
}

class StoriesModel {
  final String userid, id, text, type, url, background;
  final int dur;
  DateTime? dateadd = DateTime.now();

  StoriesModel(
      {this.userid = "a",
      this.type = 'image',
      this.id = '',
      required this.dur,
      required this.background,
      this.text =
          'Hopefully Audrey can get surgery soon, recover from her illness, Hopefully Audrey can get surgery soon, recover from her illness, ',
      this.url = 'assets/images/user.jpeg',
      this.dateadd});
  factory StoriesModel.fromJson(Map<String, dynamic> json) => StoriesModel(
        url: json["url"],
        dur: json["dur"],
        background: json["background"],
        text: json["text"],
        type: json["type"],
        userid: json["userid"],
        dateadd: json["dateadd"],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'text': text,
        'type': type,
        'userid': userid,
        'background': background,
        "dur": dur,
        'dateadd': dateadd,
      };

  StoriesModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> json)
      : url = json["url"],
        text = json["text"],
        type = json["type"],
        id = json.id,
        background = json['background'],
        dur = json['dur'],
        userid = json["userid"],
        dateadd = json["dateadd"].toDate();
}
