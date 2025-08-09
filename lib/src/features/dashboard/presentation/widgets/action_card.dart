import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ActionCard extends StatelessWidget {
  final String labelText;
  final String actionText;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionCard({
    super.key,
    required this.labelText,
    required this.actionText,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: GhostButton(
          density: ButtonDensity.compact,
          onPressed: onPressed,
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 64),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(labelText).tr().x3Large,
                          Text(
                            actionText,
                            style: TextStyle(color: Colors.red),
                          ).tr().muted.large,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
