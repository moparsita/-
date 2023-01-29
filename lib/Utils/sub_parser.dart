import 'package:chewie/chewie.dart';

enum SubStates {
  indexNumber,
  timing,
  content,
  empty,
}

class SubParser {
  String subtitle = "";
  SubStates nextState = SubStates.indexNumber;

  Subtitles subtitles = Subtitles([]);

  SubParser.parse(subtitle) {
    this.subtitle = subtitle;
    List<String> list = subtitle.toString().split('\n');
    print(list.length);
    Duration start = Duration(seconds: 0);
    Duration end = Duration(seconds: 10);
    int lastIndex = 0;
    String text = "";
    for (var sub in list) {
      RegExp numberRegExp = RegExp('^[0-9]*\$');
      if (sub.trim().isEmpty) {
        nextState = SubStates.empty;
      } else if (numberRegExp.hasMatch(sub)) {
        lastIndex = int.parse(sub);
        nextState = SubStates.indexNumber;
      }

      switch (nextState) {
        case SubStates.indexNumber:
          nextState = SubStates.timing;
          break;
        case SubStates.timing:
          List<String> times = sub.split(' --> ');
          if (times.length > 1) {
            List<String> startSub = times[0].trim().split(':');
            List<String> endSub = times[1].trim().split(':');
            start = Duration(
              hours: int.parse(
                startSub[0],
              ),
              minutes: int.parse(
                startSub[1],
              ),
              seconds: int.parse(
                startSub[2].split(',').first,
              ),
              milliseconds: int.parse(
                startSub[2].split(',').last,
              ),
            );
            end = Duration(
              hours: int.parse(
                endSub[0],
              ),
              minutes: int.parse(
                endSub[1],
              ),
              seconds: int.parse(
                endSub[2].split(',').first,
              ),
              milliseconds: int.parse(
                endSub[2].split(',').last,
              ),
            );
          }
          nextState = SubStates.content;
          break;
        case SubStates.content:
          text += "${sub}";
          break;
        case SubStates.empty:
          this.subtitles.subtitle.add(Subtitle(
                index: lastIndex,
                start: start,
                end: end,
                text: text,
              ));
          text = "";
          nextState = SubStates.indexNumber;
          break;
      }
    }
  }
}

class SubChunk {}
