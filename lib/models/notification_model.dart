class NotificationModel {
  final int? id;
  final String? classs;
  final int? homeId;
  final String? title;
  final String? description;
  final String? datetime;
  final bool? isRead;

  const NotificationModel({
    this.id,
    this.classs,
    this.homeId,
    this.title,
    this.description,
    this.datetime,
    this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'class': classs,
      'home_id': homeId,
      'title': title,
      'description': description,
      'datetime': datetime,
      'is_read': isRead,
    };
  }

  @override
  String toString() {
    return '''
      Notification{
        id: $id, 
        classs: $classs, 
        home_id: $homeId, 
        title: $title,
        description: $description,
        datetime: $datetime,
        isRead: $isRead,
        }
    ''';
  }
}
