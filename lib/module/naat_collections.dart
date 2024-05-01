import 'package:flutter/material.dart';

import '../screens/naat_playing_screen.dart';
import 'naat_module.dart';

class NaatCollections extends StatelessWidget {
  NaatCollections({super.key});

  final List<NaatModule> naatCollections = [
    NaatModule(
      name: 'Ya Rasool Allah(ﷺ) Tere',
      url:
          'https://humariweb.com/naats/ARQ/Ya-Rasool-Allah-(S.A.W)-Tere-(Hamariweb.com).mp3',
    ),
    NaatModule(
      name: 'Kyal e Gumbad e Khazra',
      url:
          'https://www.thesunniway.com/jdownloads/Naat/Asad%20Iqbal/30_khayal-e-gumbad-e-khizra.mp3',
    ),
    NaatModule(
      name: 'Nabi Nabi(ﷺ)',
      url:
          'https://www.thesunniway.com/jdownloads/Naat/Asad%20Iqbal/01_nabi_nabi.mp3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Naat Collections'),
      ),
      body: ListView.builder(
        itemCount: naatCollections.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              naatCollections[index].name,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayNaatScreen(
                    name: naatCollections[index].name,
                    url: naatCollections[index].url,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
