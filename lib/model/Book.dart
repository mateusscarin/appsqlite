class Book {
  int? id;
  String? title;
  int? numChapters;
  int? numPages;
  String? summary;

  bookMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['title'] = title!;
    mapping['num_chapters'] = numChapters!;
    mapping['num_pages'] = numPages!;
    mapping['summary'] = summary!;
    return mapping;
  }
}
