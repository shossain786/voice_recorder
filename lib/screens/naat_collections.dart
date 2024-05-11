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
      name: 'Maslake Ala Hazrat Salamat Rahe',
      naatKhawan: 'Sayyed Abdul Wasi',
      url:
          'https://www.thesunniway.com/jdownloads/Naat/Sayyid%20Abdul%20Wasi%20Barkati/Maslak%20e%20Ala%20Hazrat%20Salamat%20Rahe.mp3',
    ),
    NaatModule(
      name: 'Aaj Aye Nabioke Sardaar Mrhaba',
      naatKhawan: 'Owais Raza Qadri',
      url: 'https://owaisqadri.com/naats/aaj_aaye_nabiyon_ke_sardar.mp3',
    ),
    NaatModule(
      name: 'Balagal Ula Bekamalehi',
      naatKhawan: 'Syed Rehan Qadri',
      url:
          'https://www.alahazrat.info/naats/rqadri/mp3/balagalula_bekamalehi.mp3',
    ),
    NaatModule(
      name: 'Ae Sabz Gumbad Wale Manzoor Dua Karna',
      naatKhawan: 'Shahbaz Qamar Fareedi',
      url:
          'https://humariweb.com/naats/sqf/Ae_Sabz_Gumbad_Wale_Manzoor_Dua_Karna-(HamariWeb.com).mp3',
    ),
    NaatModule(
      name: 'Nabi Nabi(ﷺ)',
      naatKhawan: 'Asad Iqbal',
      url:
          'https://www.thesunniway.com/jdownloads/Naat/Asad%20Iqbal/01_nabi_nabi.mp3',
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
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red,
                    Colors.yellow,
                  ],
                ),
              ),
              child: Card(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
