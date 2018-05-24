// Creates a [Duration] with given [milliseconds]
Duration us(int microseconds) => new Duration(microseconds: microseconds);

// Creates a [Duration] with given [milliseconds]
Duration ms(int milliseconds) => new Duration(milliseconds: milliseconds);

// Creates a [Duration] with given [seconds]
Duration seconds(int seconds) => new Duration(seconds: seconds);

// Creates a [Duration] with given [minutes]
Duration minutes(int minutes) => new Duration(minutes: minutes);

// Creates a [Duration] with given [minutes]
Duration hours(int hours) => new Duration(hours: hours);

// Creates a [Duration] with given [days]
Duration days(int days) => new Duration(days: days);


class PrettyDuration {

  final Duration duration;
  String days;
  String hours;
  String minutes;
  String seconds;

  PrettyDuration(this.duration) {
    if (duration.inDays > 0) {
      if (duration.inDays < 10){
        days = "0" + duration.inDays.toString();
      } else {
        days = duration.inDays.toString();
      }
    } else {
      days = "00";
    }

    final int intHours = duration.inHours % 24;
    if (intHours > 0) {
      if (intHours < 10){
        hours = "0" + intHours.toString();
      } else {
        hours = intHours.toString();
      }
    } else {
      hours = "00";
    }

    final int intMinutes = duration.inMinutes % 60;
    if (intMinutes > 0) {
      if (intMinutes < 10){
        minutes = "0" + intMinutes.toString();
      } else {
        minutes = intMinutes.toString();
      }
    } else {
      minutes = "00";
    }

    final int intSeconds = duration.inSeconds % 60;
    if (intSeconds > 0) {
      if (intSeconds < 10){
        seconds = "0" + intSeconds.toString();
      } else {
        seconds = intSeconds.toString();
      }
    } else {
      seconds = "00";
    }
  }
}