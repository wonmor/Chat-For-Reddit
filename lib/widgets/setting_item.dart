import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final GestureTapCallback? onTap;

  const SettingItem({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.leadingIconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            if (leadingIcon != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (leadingIconColor ?? Colors.grey).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(leadingIcon, color: leadingIconColor, size: 20),
              ),
            if (leadingIcon != null) const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}
