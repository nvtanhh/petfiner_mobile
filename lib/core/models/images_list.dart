class ImagesList {
  List<String> images;

  ImagesList({this.images});

  factory ImagesList.fromJson(List<dynamic> parsedJson) {
    List<String> images =
        parsedJson.map((imageJson) => imageJson['Url'] as String).toList();

    return new ImagesList(images: images);
  }
}
