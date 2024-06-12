class CommonUtils {
  static double getIndicatorPosition({
    required double reachedNum,
    required double maxNum,
    required double percentageRange,
  }) {
    if ((maxNum <= 0 && reachedNum <= 0) || percentageRange <= 0) {
      return 0;
    } else if (maxNum >= 0 && reachedNum < 0) {
      return percentageRange;
    } else if (reachedNum >= maxNum) {
      return percentageRange;
    }
    double reachedNumInPercent = (reachedNum / maxNum) * percentageRange;
    return reachedNumInPercent;
  }
}
