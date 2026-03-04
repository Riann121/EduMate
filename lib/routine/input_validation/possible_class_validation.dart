
int classPossible(String startTime, int duration, int classes) {
  try {
    List<String> parts = startTime.split(':');
    int startHour = int.parse(parts[0]);
    int startMin = parts.length > 1 ? int.parse(parts[1]) : 0;
    int startTotal = (startHour * 60) + startMin;

    if (startTotal >= 1440 || duration <= 0) return 0;
    int remainingMinutes = 1440 - startTotal;
    int classesPossible = remainingMinutes ~/ duration;
    if (classesPossible >= classes){
      return classes;
    } else {
      return classesPossible;
    }
  } catch (e) {
    return 0;
  }
}
