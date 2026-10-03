import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const BottomNavItem({required this.icon, required this.selectedIcon, required this.label});
}

/// A simple, self-drawn bottom nav bar (not Flutter's stock
/// [BottomNavigationBar]) so CinElite has its own distinct look —
/// flat navy underline + icon/label pair — rather than reusing a
/// generic Material nav bar style.
class AppBottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              final item = items[i];
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: item.label,
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 3,
                          width: 28,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.navy : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Icon(
                          selected ? item.selectedIcon : item.icon,
                          size: 22,
                          color: selected ? AppColors.navy : AppColors.textMuted,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                            color: selected ? AppColors.navy : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
