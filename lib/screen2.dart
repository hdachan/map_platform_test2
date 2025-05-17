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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AppBar(
              backgroundColor: const Color(0xFFFFFFFF),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 24, color: Color(0xFF1C1B1F)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '모디챗 설정',
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => debugPrint('완료 Pressed'),
                    child: const Text(
                      '완료',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: const Divider(
                color: Color(0xFFE7E7E7),
                thickness: 1,
                height: 0.5,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddBox(
                      label: '큐레이션 리스트',
                      count: curationItems.length,
                      max: maxCuration,
                      onAdd: () {
                        if (curationItems.length < maxCuration) {
                          setState(() =>
                              curationItems.add('큐레이션 리스트 ${curationItems.length + 1}'));
                        }
                      },
                    ),
                    _buildDivider(),
                    if (widget.categoryItems.isNotEmpty)
                      Padding(
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
                                    color: isAdded
                                        ? const Color(0xFFF6F6F6)
                                        : const Color(0xFFFFFFFF),
                                    border: Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    cat,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF3D3D3D),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    _buildDivider(),
                    for (int i = 0; i < curationItems.length; i++) ...[
                      _buildEditableBox(
                        text: curationItems[i],
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Screen3(itemName: curationItems[i])),
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
            ),
          ),
        ],
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
    return Padding(
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
                color: Colors.transparent,
              ),
              child: const Center(
                child: Icon(Icons.add, size: 12, color: Color(0xFF888888)),
              ),
            ),
          ),
        ],
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
        Padding(
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
        _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0xFFE7E7E7), thickness: 0.1, height: 0.1);
  }
}
