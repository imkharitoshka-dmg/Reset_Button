String formatRussianDate(DateTime date) {
  const monthNames = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
}

String formatRussianDateTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');

  return '${formatRussianDate(date)}, $hour:$minute';
}

String formatDurationMinutes(int minutes) {
  if (minutes == 1) {
    return '1 минута';
  }

  if (minutes >= 2 && minutes <= 4) {
    return '$minutes минуты';
  }

  return '$minutes минут';
}
