class eventData {
  eventData({required this.title, required this.date});
  String title;
  DateTime date;

  @override
  String toString() {
    // TODO: implement toString
    return '${title}:${date}';
  }
}
