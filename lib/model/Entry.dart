class Entry {
  String url;
  DateTime published;
  String title;
  String summary;
  String content;

  Entry({
    this.url,
    this.published,
    this.title,
    this.summary,
    this.content,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    url: json["url"],
    published: DateTime.parse(json["published"]),
    title: json["title"],
    summary: json["summary"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "published": published.toIso8601String(),
    "title": title,
    "summary": summary,
    "content": content,
  };
}