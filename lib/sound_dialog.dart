import 'package:flutter/material.dart';

void showSoundDiagnosis(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Библиотека звуков', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          Expanded(
            child: ListView(
              children: const [
                ListTile(title: Text('Свист при разгоне'), subtitle: Text('Проверьте ремень генератора или турбину.')),
                ListTile(title: Text('Гул при езде'), subtitle: Text('Вероятно, изношен ступичный подшипник.')),
                ListTile(title: Text('Стук на кочках'), subtitle: Text('Проверьте стойки стабилизатора.')),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}