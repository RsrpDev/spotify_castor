import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function onPressed;
  final Widget? icon;
  final String label;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: const ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          overlayColor: WidgetStatePropertyAll(Colors.white12),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
          side: WidgetStatePropertyAll(BorderSide(color: Colors.white60)),
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 48)),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              SizedBox(
                width: 24,
                height: 24,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  child: icon,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: icon != null ? 16 : 0),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
