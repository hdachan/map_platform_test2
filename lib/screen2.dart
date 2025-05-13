import 'package:flutter/material.dart';
import 'screen3.dart';

class Screen2 extends StatefulWidget {
  final List<String> categoryItems;
  const Screen2({Key? key, required this.categoryItems}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<String> curationItems = [];
  static const int maxCuration = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        '모디챗 설정',
        const Color(0xFF888888),
            () => debugPrint('완료 Pressed'),
        buttonText: '완료',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Color(0xFFE7E7E7), thickness: 5, height: 0.5),

            // 1) 큐레이션 리스트 추가 박스
            _buildAddBox(
              label: '큐레이션 리스트',
              count: curationItems.length,
              max: maxCuration,
              onAdd: () {
                if (curationItems.length < maxCuration) {
                  setState(() => curationItems.add('큐레이션 리스트 ${curationItems.length + 1}'));
                }
              },
            ),

            const Divider(color: Color(0xFFE7E7E7), thickness: 0.1, height: 0.5),

            // 2) 카테고리 토글 버튼
            if (widget.categoryItems.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.categoryItems.map((cat) {
                        final isAdded = curationItems.contains(cat);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isAdded) {
                                curationItems.remove(cat);
                              } else if (curationItems.length < maxCuration) {
                                curationItems.add(cat);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isAdded ? const Color(0xFFF6F6F6) : const Color(0xFFFFFFFF),
                              border: Border.all(color: Colors.transparent), // 테두리 없음
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isAdded ? const Color(0xFF3D3D3D) : const Color(0xFF3D3D3D),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

            const Divider(color: Color(0xFFE7E7E7), thickness: 0.1, height: 0.1),

            // 3) 생성된 큐레이션 리스트 박스들
            for (int i = 0; i < curationItems.length; i++) ...[
              _buildEditableBox(
                text: curationItems[i],
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Screen3(itemName: curationItems[i])),
                  );
                },
                onDelete: () {
                  setState(() => curationItems.removeAt(i));
                },
              ),
            ],
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }

  Widget _buildAddBox({
    required String label,
    required int count,
    required int max,
    required VoidCallback onAdd,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('$count/$max', style: const TextStyle(fontSize: 12)),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent, // 배경색 투명
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 12, color: Color(0xFF888888)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableBox({
    required String text,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFF3D3D3D),
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: const Icon(Icons.more_vert, size: 20),
                    color: const Color(0xFFE9EFF0),
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      else if (value == 'delete') onDelete();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('수정하기')),
                      PopupMenuItem(value: 'delete', child: Text('삭제하기')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Color(0xFFE7E7E7), thickness: 0.1, height: 0.1),
      ],
    );
  }
}

// AppBar 재사용
PreferredSizeWidget customAppBar(
    BuildContext context,
    String title,
    Color completeButtonColor,
    VoidCallback onCompletePressed, {
      String buttonText = '완료',
    }) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(56),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      centerTitle: true,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF000000),
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back_ios_new, color: Color(0xFF1C1B1F), size: 24),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: onCompletePressed,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Color(0xFF888888), fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
