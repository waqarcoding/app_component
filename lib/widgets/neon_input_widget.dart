import 'package:flutter/material.dart';

class NeonInputBox extends StatefulWidget {
  final TextEditingController? controller;
  final List<String> tabs;
  final String? hint;

  /// Optional custom colors for each tab index
  final List<Color>? tabColors;

  /// Optional bottom-left widget (default is settings icon)
  final Widget? bottomLeftWidget;
  const NeonInputBox({
    super.key,
    this.controller,
    required this.tabs,
    this.tabColors,
    this.bottomLeftWidget,
    this.hint,
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

    // Add listener to update character count dynamically
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Color colorForIndex(int index) {
    if (widget.tabColors != null && index < widget.tabColors!.length) {
      return widget.tabColors![index];
    }

    const defaultColors = [
      Color(0xFF8B5CF6), // purple
      Color(0xFF3B82F6), // blue
      Color(0xFFEC4899), // pink
      Color(0xFF22C55E), // green
    ];

    return defaultColors[index % defaultColors.length];
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
                          hintText: widget.hint ??
                              "Write ${widget.tabs[selectedIndex]} here…",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.bottomLeftWidget ??
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

    final tabWidgets = <Positioned>[];

    for (int i = 0; i < widget.tabs.length; i++) {
      tabWidgets.add(
        Positioned(
          left: i * (tabWidth - overlap),
          child: _tab(widget.tabs[i], i),
        ),
      );
    }

    // Sort so active tab is drawn last (on top)
    tabWidgets.sort((a, b) {
      final aIndex = (a.child.key as ValueKey<int>).value;
      final bIndex = (b.child.key as ValueKey<int>).value;

      if (aIndex == selectedIndex) return 1; // active tab last
      if (bIndex == selectedIndex) return -1;
      return aIndex.compareTo(bIndex);
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
    // Distance from active tab
    final distance = (index - selectedIndex).abs();

    // Active tab margin animates
    final topMargin = isActive
        ? 4.0 // small top margin for active tab
        : 4.0 + distance * 4; // neighbors stay in place

    return InkWell(
      key: ValueKey(index),
      onTap: () {
        // Update active tab index on click
        setState(() {
          selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // neighbors do not animate
        curve: Curves.bounceOut,
        height: 150,
        width: 100,
        margin: EdgeInsets.only(top: topMargin),
        padding: EdgeInsets.symmetric(vertical: isActive ? 4 : 1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
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
