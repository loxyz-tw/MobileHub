class Event {
  String url;
  DateTime published;
  String title;
  String summary;
  String content;
  int res;

  Event({
    this.url,
    this.published,
    this.title,
    this.summary,
    this.content,
    this.res
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    url: json['url'],
    published: DateTime.parse(json['published']),
    title: json['title'],
    summary: json['summary'],
    content: json['content'],
    res: 1,
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'published': published.toIso8601String(),
    'title': title,
    'summary': summary,
    'content': content,
    'res': 1,
  };
}