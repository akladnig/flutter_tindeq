//TODO enum localization
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

enum GripType {
  halfCrimp('Half Crimp'),
  fourFingerOpen('Four Finger Open'),
  threeFingerDrag('3 Finger Drag'),
  fullCrimp('Full Crimp'),
  frontTwo('Front Two'),
  backTwo('Back Two'),
  oneArmLockOff('One Arm Lock Off');

  const GripType(this.label);
  final String label;
}

final class User {
  String userName = "";
  double weight = 70.0;
  int redPointGrade = 24;
  GripType gripType = GripType.halfCrimp;
  int edgeSize = 20;
  String notes = "";
}

@riverpod
User user(UserRef ref) {
  return User();
}
