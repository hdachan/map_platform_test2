class WithdrawalReasonModel {
  final String userId;
  final List<String> reasons;

  WithdrawalReasonModel({required this.userId, required this.reasons});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'reason': reasons.join(', '), // 리스트를 문자열로 변환
    };
  }
}
