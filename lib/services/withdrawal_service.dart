import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/withdrawal_reason_model.dart';


class WithdrawalService {
  final supabase = Supabase.instance.client;

  Future<void> saveWithdrawalReason(WithdrawalReasonModel data) async {
    try {
      await supabase.from('withdrawal_reasons').insert(data.toJson());
      print("탈퇴 사유가 성공적으로 저장되었습니다.");

    } catch (e) {
      print("탈퇴 사유 저장 중 오류 발생: $e");
      throw e;
    }
  }
}
