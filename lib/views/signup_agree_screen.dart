import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/designSize.dart';
import '../widgets/cutstom_appbar.dart';
import 'signup_email_screen.dart';

class AgreePage extends StatefulWidget {
  const AgreePage({Key? key}) : super(key: key);

  @override
  _AgreePageState createState() => _AgreePageState();
}

class _AgreePageState extends State<AgreePage> {
bool agreeToAllTerms = false; // 전체 동의
bool agreeToRequiredTerms1 = false; // (필수) 이용 약관 동의
bool agreeToRequiredTerms2 = false; // (필수) 전금 금융 거래 이용 약관 동의
bool agreeToRequiredTerms3 = false; // (필수) 개인정보 수집 동의
bool agreeToSelectTerms = false; // (선택) 이벤트 및 마케팅 이용 약관 동의
bool isButtonPressed = false; // 다음 버튼 활성화 여부

// 전체 동의 처리 메서드
void _toggleAgreement() {
  setState(() {
    agreeToAllTerms = !agreeToAllTerms;
    agreeToRequiredTerms1 = agreeToAllTerms;
    agreeToRequiredTerms2 = agreeToAllTerms;
    agreeToRequiredTerms3 = agreeToAllTerms;
    agreeToSelectTerms = agreeToAllTerms;
    isButtonPressed = agreeToAllTerms; // 전체 동의 시 버튼 활성화
  });
}

// (필수) 이용 약관 동의 메서드
void _toggleTermsAgreement() {
  setState(() {
    agreeToRequiredTerms1 = !agreeToRequiredTerms1;
    isButtonPressed = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3;
    agreeToAllTerms = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3 && agreeToSelectTerms;
  });
}

// (필수) 전금 금융 거래 이용 약관 동의 메서드
void _toggleTermsAgreement1() {
  setState(() {
    agreeToRequiredTerms2 = !agreeToRequiredTerms2;
    isButtonPressed = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3;
    agreeToAllTerms = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3 && agreeToSelectTerms;
  });
}

// (필수) 개인정보 수집 동의 메서드
void _toggleTermsAgreement2() {
  setState(() {
    agreeToRequiredTerms3 = !agreeToRequiredTerms3;
    isButtonPressed = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3;
    agreeToAllTerms = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3 && agreeToSelectTerms;
  });
}

// (선택) 이벤트 및 마케팅 이용 약관 동의 메서드
void _toggleSelectTerms() {
  setState(() {
    agreeToSelectTerms = !agreeToSelectTerms;
    agreeToAllTerms = agreeToRequiredTerms1 && agreeToRequiredTerms2 && agreeToRequiredTerms3 && agreeToSelectTerms;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF1A1A1A),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              CustomAppBar(title: '모디랑 회원가입', context: context),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: ResponsiveUtils.getResponsiveWidth(428, 360, constraints),
                      height: 592,
                      child: Padding(
                        padding: EdgeInsets.only(top: 54, bottom: 130, right: 16.w, left: 16.w),
                        child: Container(
                          height: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '모디랑\n이용약관 동의',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '모디랑 서비스 시작 및 가입을 위해\n정보 제공에 동의해 주세요!',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                  letterSpacing: -0.35,
                                ),
                              ),
                              SizedBox(height: 48),
                              InkWell(
                                onTap: _toggleAgreement,
                                child: Container(
                                  width: ResponsiveUtils.getResponsiveWidth(428, 360, constraints),
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: agreeToAllTerms ? Color(0xFF05FFF7) : Colors.transparent,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Color(0xFF05FFF7),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                agreeToAllTerms
                                                    ? 'assets/image/checkOn_icon.png'
                                                    : 'assets/image/Oncheck_icon.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '전체 약관동의',
                                          style: TextStyle(
                                            color: agreeToAllTerms ? Color(0xFF242424) : Color(0xFF888888),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            height: 1.0,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  AgreementButton(
                                    isAgreed: agreeToRequiredTerms1,
                                    text: '(필수) 이용 약관 동의',
                                    checkedImage: 'assets/image/check_icon.png',
                                    uncheckedImage: 'assets/image/Oncheck_icon.png',
                                    onTap: _toggleTermsAgreement,
                                  ),
                                  MoreButton(context),
                                ],
                              ),
                              Row(
                                children: [
                                  AgreementButton(
                                    isAgreed: agreeToRequiredTerms2,
                                    text: '(필수) 전금 금융 거래 이용 약관 동의',
                                    checkedImage: 'assets/image/check_icon.png',
                                    uncheckedImage: 'assets/image/Oncheck_icon.png',
                                    onTap: _toggleTermsAgreement1,
                                  ),
                                  MoreButton(context),
                                ],
                              ),
                              Row(
                                children: [
                                  AgreementButton(
                                    isAgreed: agreeToRequiredTerms3,
                                    text: '(필수) 개인정보 수집 동의',
                                    checkedImage: 'assets/image/check_icon.png',
                                    uncheckedImage: 'assets/image/Oncheck_icon.png',
                                    onTap: _toggleTermsAgreement2,
                                  ),
                                  MoreButton(context),
                                ],
                              ),
                              Row(
                                children: [
                                  AgreementButton(
                                    isAgreed: agreeToSelectTerms,
                                    text: '(선택) 이벤트 및 마케팅 이용 약관 동의',
                                    checkedImage: 'assets/image/check_icon.png',
                                    uncheckedImage: 'assets/image/Oncheck_icon.png',
                                    onTap: _toggleSelectTerms,
                                  ),
                                  MoreButton(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: ResponsiveUtils.getResponsiveWidth(360, 360, constraints),
                    height: 62.h,
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8, bottom: 8),
                    child: Container(
                      height: 48.h,
                      width: ResponsiveUtils.getResponsiveWidth(428, 360, constraints),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: MaterialButton(
                        onPressed: isButtonPressed
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        }
                            : null, // 버튼 비활성화 시 null로 설정
                        color: isButtonPressed ? Color(0xFF05FFF7) : Color(0xFFAFA6FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '다음',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: -0.5,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

Widget MoreButton(BuildContext context) {
  return Container(
    width: 31,
    height: 24,
    margin: EdgeInsets.only(right: 12),
    padding: EdgeInsets.symmetric(vertical: 6),
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () async {
        const url = 'https://holybaits-modir.notion.site/132a2688a39a8092bdefcea510e0fd86';
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('링크를 열 수 없습니다.')),
          );
        }
      },
      child: Text(
        '더보기',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFB0B0B0),
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFB0B0B0),
          height: 1,
          letterSpacing: -0.3,
        ),
      ),
    ),
  );
}

Widget AgreementButton({
  required bool isAgreed,
  required String text,
  required String checkedImage,
  required String uncheckedImage,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        height: 48,
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isAgreed ? checkedImage : uncheckedImage),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isAgreed ? Colors.white : Color(0xFF888888),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: -0.35,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}