import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(DateTime dt) {
  return timeago.format(dt, allowFromNow: true, locale: 'en_short');
}

String formatScore(int score) {
  if (score >= 1000000) {
    return '${(score / 1000000).toStringAsFixed(1)}M';
  } else if (score >= 1000) {
    return '${(score / 1000).toStringAsFixed(1)}k';
  }
  return score.toString();
}
