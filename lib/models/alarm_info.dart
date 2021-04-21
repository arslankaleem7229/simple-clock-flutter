class AlarmInfo {
  int id;
  String title;
  DateTime alarmDateTime;
  bool isPending = true;
  int gradientColorIndex;

  AlarmInfo(
      {this.id,
      this.title,
      this.alarmDateTime,
      this.isPending,
      this.gradientColorIndex});

  factory AlarmInfo.fromMap(Map<String, dynamic> json) {
    bool _pendingStatus;
    if (json["isPending"] == 1)
      _pendingStatus = true;
    else
      _pendingStatus = false;
    print(json["isPending"]);
    AlarmInfo(
      id: json["id"],
      title: json["title"],
      alarmDateTime: DateTime.parse(json["alarmDateTime"]),
      isPending: _pendingStatus,
      gradientColorIndex: json["gradientColorIndex"],
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isPending": isPending,
        "gradientColorIndex": gradientColorIndex,
      };
}
