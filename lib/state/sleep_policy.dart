abstract class SleepPolicy {
  bool feedbackGiven;

  SleepPolicy(
    this.feedbackGiven,
  );
}

class SleepPolicyOff extends SleepPolicy {
  SleepPolicyOff(
    bool feedbackGiven,
  ) : super(feedbackGiven);

  @override
  bool operator ==(Object other) {
    return other is SleepPolicyOff;
  }

  @override
  int get hashCode => feedbackGiven.hashCode;
}

class SleepPolicyTimer extends SleepPolicy {
  final Duration duration;
  final int _millisecond;

  SleepPolicyTimer(
    this.duration,
    this._millisecond,
    bool feedbackGiven,
  ) : super(feedbackGiven);

  @override
  bool operator ==(Object other) {
    return other is SleepPolicyTimer &&
        other.duration == duration &&
        other._millisecond == _millisecond;
  }

  @override
  int get hashCode => Object.hash(duration.hashCode, _millisecond.hashCode);

  @override
  String toString() {
    return 'SleepPolicyTimer($duration, $_millisecond)';
  }
}

class SleepPolicyEndOfEpisode extends SleepPolicy {
  SleepPolicyEndOfEpisode(
    bool feedbackGiven,
  ) : super(feedbackGiven);

  @override
  bool operator ==(Object other) {
    return other is SleepPolicyEndOfEpisode;
  }

  @override
  int get hashCode => feedbackGiven.hashCode;
}

SleepPolicy sleepPolicyEndOfEpisode([bool feedbackGiven = false]) =>
    SleepPolicyEndOfEpisode(feedbackGiven);

SleepPolicy sleepPolicyOff([bool feedbackGiven = false]) =>
    SleepPolicyOff(feedbackGiven);

SleepPolicy sleepPolicyMinutes(int minutes) => SleepPolicyTimer(
      Duration(minutes: minutes),
      DateTime.now().millisecondsSinceEpoch,
      false,
    );
