/// function to get views count in integer and returns string views count without providing exact view count
String getViewCount(int viewCount) {
  if (viewCount < 5) {
    return viewCount.toString();
  } else if (viewCount < 10) {
    return "5+";
  } else if (viewCount < 20) {
    return "10+";
  } else if (viewCount < 30) {
    return "20+";
  } else if (viewCount < 50) {
    return "30+";
  } else if (viewCount < 100) {
    return "50+";
  } else {
    int nearestHundred = (viewCount + 99) ~/ 100 * 100;
    return "$nearestHundred+";
  }
}
