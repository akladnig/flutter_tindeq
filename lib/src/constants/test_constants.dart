const int countdownTime = 4;

typedef TestTimes = ({int countdownTime, int hangTime, int restTime, int reps, int totalDuration});

const int cftHangTime = 7;
const int cftRestTime = 3;
const int cftRepetitions = 24;
const int cftTotalDuration =
    (cftHangTime + cftRestTime) * cftRepetitions;

const TestTimes cftTimes = (
  countdownTime: countdownTime,
  hangTime: cftHangTime,
  restTime: cftRestTime,
  reps: cftRepetitions,
  totalDuration: cftTotalDuration
);

const int maxHangTime = 4;
const int maxRestTime = 1;
const int maxRepetitions = 1;
const int maxTotalDuration =
    (maxHangTime + maxRestTime) * maxRepetitions;
const TestTimes maxTimes = (
  countdownTime: countdownTime,
  hangTime: maxHangTime,
  restTime: maxRestTime,
  reps: maxRepetitions,
  totalDuration: maxTotalDuration

);

const int rfdHangTime = 5;
const int rfdRestTime = 1;
const int rfdRepetitions = 1;
const int rfdTotalDuration =
    (rfdHangTime + rfdRestTime) * rfdRepetitions;
const TestTimes rfdTimes = (
  countdownTime: countdownTime,
  hangTime: rfdHangTime,
  restTime: rfdRestTime,
  reps: rfdRepetitions,
  totalDuration: rfdTotalDuration

);

// triggerLevel is the minimum level for points to be analysed
int triggerLevel = 3;
