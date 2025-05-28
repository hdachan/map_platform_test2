import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Test1(),
  ));
}

class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "마이 큐레이션"),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 202,
                      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/bgimage.jpg'),
                          fit: BoxFit.fitWidth, // width 크기에 맞춰 이미지 크기 달라짐
                          //none 으로 하면 기존 이미지 크기에서 잘려서 나옴 / fill 으로 하면 크기 맞춰짐
                          colorFilter: ColorFilter.mode(
                            Color(0x66000000),
                            BlendMode.srcOver,
                          ),
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

PreferredSizeWidget customAppBar(
  BuildContext context,
  String title,
) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(56),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),

                // more_vert 아이콘
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    print("more_vert 클릭");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
