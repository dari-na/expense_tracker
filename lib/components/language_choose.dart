import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../provider/locale_provider.dart';

class LanguageChoose extends StatelessWidget{
  const LanguageChoose({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return DropdownButtonHideUnderline(
        child: DropdownButton(
          value: locale,
          icon: Container(width:12),
          items: L10n.all
              .map((locale){
                final flag = L10n.getFlag(locale.languageCode);
                return DropdownMenuItem(
                    value: locale,
                  onTap: (){
                      provider.setLocale(locale);
                  },
                    child: Center(
                      child: Text(
                        flag,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                );
          })
              .toList(),
          onChanged: (_) {},)
    );
  }}