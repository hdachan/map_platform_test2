import 'package:flutter/material.dart';

class CurationCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final String date;

  const CurationCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      width: 58,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  StatIndicator(icon: Icons.favorite_border, count: likeCount),
                  StatIndicator(icon: Icons.chat_bubble_outline, count: commentCount),
                  StatIndicator(icon: Icons.visibility_outlined, count: viewCount),
                  const Spacer(),
                  Text(
                    date,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Color(0xff888888),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: Color(0xFFE7E7E7),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}


class StatIndicator extends StatelessWidget {
  final IconData icon;
  final int count;

  const StatIndicator({
    super.key,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Icon(
            icon,
            color: Color(0xff888888),
            size: 16,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: Color(0xff888888),
          ),
        ),
        SizedBox(width: 8)
      ],
    );
  }
}
