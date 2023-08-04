import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    this.automaticallyImplyLeading = true,
    super.key,
  });

  const AppHeader.hideBackArrow({
    this.automaticallyImplyLeading = false,
    super.key,
  });

  final bool automaticallyImplyLeading;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight); // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.sailing),
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium,
              children: const <TextSpan>[
                TextSpan(text: "R", style: TextStyle(color: Colors.red)),
                TextSpan(text: "egatta"),
                TextSpan(text: "B", style: TextStyle(color: Colors.red)),
                TextSpan(text: "uddy")
              ],
            ),
          ),
        ],
      ),
    );
  }
}