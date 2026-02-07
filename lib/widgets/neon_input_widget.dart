import 'package:flutter/material.dart';

class NeonInputBox extends StatefulWidget {
  final TextEditingController? controller;
  final List<String> tabs;

  const NeonInputBox({
    super.key,
    this.controller,
    required this.tabs,
  });

  @override
  State<NeonInputBox> createState() => _NeonInputBoxState();
}

class _NeonInputBoxState extends State<NeonInputBox> {
  late final TextEditingController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Color colorForIndex(int index) {
    const colors = [
      Color(0xFF8B5CF6), // purple
      Color(0xFF3B82F6), // blue
      Color(0xFFEC4899), // pink
      Color(0xFF22C55E), // green (extra safe)
    ];
    return colors[index % colors.length];
  }

  Color get activeBorderColor => colorForIndex(selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: _buildTabs(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  colors: [
                    activeBorderColor,
                    activeBorderColor.withOpacity(0.5),
                  ],
                ),
              ),
              child: Container(
                height: 260,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Write ${widget.tabs[selectedIndex]} here…",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.settings, color: Colors.white),
                        Text(
                          "${_controller.text.length}/500",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // =======================
  // FIXED TABS
  // =======================
  Widget _buildTabs() {
    const overlap = 30.0;
    const tabWidth = 110.0;

    final tabWidgets = <Widget>[];

    for (int i = 0; i < widget.tabs.length; i++) {
      tabWidgets.add(
        Positioned(
          left: i * (tabWidth - overlap),
          child: _tab(widget.tabs[i], i),
        ),
      );
    }

    // Active tab on top
    tabWidgets.sort((a, b) {
      final aChild = (a as Positioned).child as InkWell;
      final bChild = (b as Positioned).child as InkWell;

      final aIndex = ((bChild.key as ValueKey<int>).value);
      final bIndex = ((aChild.key as ValueKey<int>).value);

      return (aIndex - selectedIndex)
          .abs()
          .compareTo((bIndex - selectedIndex).abs());
    });

    return SizedBox(
      height: 100,
      width: widget.tabs.length * (tabWidth - overlap) + overlap,
      child: Stack(children: tabWidgets),
    );
  }

  Widget _tab(String text, int index) {
    final isActive = index == selectedIndex;
    final color = colorForIndex(index);

    return InkWell(
      key: ValueKey(index),
      onTap: () => setState(() => selectedIndex = index),
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        key: ValueKey(index),
        duration: Duration(milliseconds: 500),
        curve: Curves.bounceOut,
        height: 150,
        width: 100,
        margin: EdgeInsets.only(top: isActive ? 4 : 8),
        padding:
            EdgeInsets.symmetric(horizontal: 14, vertical: isActive ? 8 : 3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
