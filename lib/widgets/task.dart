class Tasks {
  String title;
  String subtitle;
  bool check;
  bool strick;

  Tasks({
    required this.title,
    this.subtitle = '',
    this.check = false,
    this.strick = false,
  });
}