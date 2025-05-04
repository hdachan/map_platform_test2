import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Test4()));
}

class Test4 extends StatefulWidget {
  const Test4({super.key});

  @override
  State<Test4> createState() => _Test4State();
}

class _Test4State extends State<Test4> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _hasUpperLowerNumberSpecial = false;
  bool _isLengthValid = false;
  bool _noSequentialChars = false;

  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  void _validatePassword(String value) {
    setState(() {
      _hasUpperLowerNumberSpecial =
          RegExp(r'(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9])').hasMatch(value);

      _isLengthValid = value.length >= 8 && value.length <= 16;

      _noSequentialChars = !RegExp(r'(.)\1\1').hasMatch(value);

      _isPasswordValid = _hasUpperLowerNumberSpecial && _isLengthValid && _noSequentialChars;
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      _isConfirmPasswordValid = value == _passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allValid = _isPasswordValid && _isConfirmPasswordValid;

    return Scaffold(
      appBar: customAppBar(
        context,
        "모디랑 회원가입",
        const Color(0xFFFFFFFF),
            () => print('Complete Pressed'),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 148,
                  padding: const EdgeInsets.only(top: 48),
                  color: const Color(0xFF1A1A1A),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "비밀번호 입력",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "로그인에 사용할 비밀번호를 입력해주세요",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFFFFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  color: const Color(0xFF1A1A1A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '비밀번호를 입력해주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFFFFFFFF),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _passwordController.text.isEmpty || _isPasswordValid
                                ? Colors.transparent
                                : Color(0xFFFF3333),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 16, right: 4),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onChanged: _validatePassword,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "password",
                            hintStyle: const TextStyle(
                              fontFamily: 'Pretendard',
                              color: Color(0xFF888888),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF888888),
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 138,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      buildRuleRow('영문, 숫자, 특수문자 조합하기', _hasUpperLowerNumberSpecial),
                      const SizedBox(height: 16),
                      buildRuleRow('8자 이상 입력하기', _isLengthValid),
                      const SizedBox(height: 16),
                      buildRuleRow('연속된 문자 사용하지 않기', _noSequentialChars),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '비밀번호 확인을 위해 한번 더 입력해 주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _confirmPasswordController.text.isEmpty || _isConfirmPasswordValid
                                ? Colors.transparent
                                : Color(0xFFFF3333),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 16, right: 4),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onChanged: _validateConfirmPassword,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'check password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Pretendard',
                              color: Color(0xFF888888),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF888888),
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!_isConfirmPasswordValid &&
                          _confirmPasswordController.text.isNotEmpty)
                        const Text(
                          '암호를 다시 확인해주세요',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            color: Color(0xFFFF3333),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(allValid),
    );
  }

  Widget buildRuleRow(String text, bool isValid) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: isValid ? Colors.white : const Color(0xFF888888),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.check,
            color: isValid ? const Color(0xFF05FFF7) : const Color(0xFF888888),
            size: 24,
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget customAppBar(
    BuildContext context,
    String title,
    Color completeButtonColor,
    VoidCallback onCompletePressed,
    ) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(56),
    child: Container(
      color: const Color(0xFF1A1A1A),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => print('뒤로가기'),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget bottomBar(bool isEnabled) {
  return Container(
    height: 68,
    color: const Color(0xFF1A1A1A),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: isEnabled
                      ? () {
                    print('다음');
                  }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? const Color(0xFF05FFF7)
                          : const Color(0xFF888888),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: isEnabled
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFF3D3D3D),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
