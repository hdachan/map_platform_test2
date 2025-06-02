import 'package:flutter/material.dart';
import 'curation_log_cards.dart';

class CurationLogCarousel extends StatefulWidget {
  const CurationLogCarousel({super.key});

  @override
  State<CurationLogCarousel> createState() => _CurationLogCarouselState();
}

class _CurationLogCarouselState extends State<CurationLogCarousel> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: const [
                CurationLogCard1(),
                CurationLogCard2(),
                CurationLogCard3(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = currentPage == index;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isActive ? 12 : 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xff3D3D3D) : const Color(0xffE7E7E7),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
