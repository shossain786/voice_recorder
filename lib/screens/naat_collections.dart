import 'package:flutter/material.dart';
import 'package:voice_recorder/main.dart';

import 'naat_playing_screen.dart';
import '../module/naat_module.dart';

class NaatCollections extends StatelessWidget {
  NaatCollections({super.key});

  final List<NaatModule> naatCollections = [
    NaatModule(
      name: 'Ya Rasool Allah(ﷺ) Tere',
      naatKhawan: 'Owais Raza Qadri',
      url:
          'https://humariweb.com/naats/ARQ/Ya-Rasool-Allah-(S.A.W)-Tere-(Hamariweb.com).mp3',
    ),
    NaatModule(
      name: 'Aaj Aye Nabioke Sardaar Mrhaba',
      naatKhawan: 'Owais Raza Qadri',
      url: 'https://owaisqadri.com/naats/aaj_aaye_nabiyon_ke_sardar.mp3',
    ),
    NaatModule(
      name: 'Nabi Nabi(ﷺ)',
      naatKhawan: 'Owais Raza Qadri',
      url:
          'https://www.thesunniway.com/jdownloads/Naat/Asad%20Iqbal/01_nabi_nabi.mp3',
    ),
    NaatModule(
      name: 'Subho Taiba me hui',
      naatKhawan: 'Owais Raza Qadri',
      url:
          'https://owaisqadri.com/mehfils/21-10-17/Subha%20Taiba%20Mein%20Hui.mp3',
    ),
    NaatModule(
      name: 'Mustafa(ﷺ) Jaan-e-Rahmat Pe Lakhoon Salam',
      naatKhawan: 'Owais Raza Qadri',
      url:
          'https://owaisqadri.com/mehfils/17-01-17/Mustafa%20Jaan-e-Rehmat%20Pe%20Laakhon%20Salam.mp3',
    ),
    NaatModule(
      name: 'Noor Wala Aya Hai',
      naatKhawan: 'Owais Raza Qadri',
      url: 'https://owaisqadri.com/naats/Noor%20Wala%20Aaya%20Hai%202013.mp3',
    ),
    NaatModule(
      name: 'Allah Allah Hoo Allah Hoo',
      naatKhawan: 'Owais Raza Qadri',
      url: 'https://owaisqadri.com/naats/Allah%20Allah%20Hoo%20Allah%20Hoo.mp3',
    ),
    NaatModule(
      name: 'Teri Choukhat Pe Mangta Tera As Gaya',
      naatKhawan: 'Owais Raza Qadri',
      url: 'https://owaisqadri.com/naats/Teri-Chokhat-Pe-Mangta.mp3',
    ),
    NaatModule(
      name: 'Qaseedah Burdah Shareef',
      naatKhawan: 'Owais Raza Qadri',
      url: 'https://owaisqadri.com/naats/Qaseeda-Burdah-Shareef.mp3',
    ),
    NaatModule(
      name: 'Durrod E Taj',
      naatKhawan: 'Hafiz Muhammad Tahir Qadri',
      url: 'https://humariweb.com/naats/HMTQ/Durrod-E-Taj-(Hamariweb.com).mp3',
    )
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
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.only(
                    left: 10, top: 4, bottom: 4, right: 10),
                dense: true,
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/madina.png'),
                  ),
                ),
                title: Text(
                  naatCollections[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kColorScheme.onSecondary,
                  ),
                ),
                subtitle: Text(
                  naatCollections[index].naatKhawan,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kColorScheme.onSecondary,
                  ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
