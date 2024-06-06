import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../OLD_screens/account.dart';
import 'language_choose.dart';

class TopNav extends StatelessWidget implements PreferredSizeWidget{
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Expenser',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF4F518D),
      leading: IconButton(
          icon: const Icon(Icons.account_circle_rounded),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Account()),
          )),
      actions: const [LanguageChoose(), SizedBox(width: 12)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
