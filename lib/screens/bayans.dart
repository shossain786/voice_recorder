import 'package:flutter/material.dart';

import '../main.dart';
import '../module/bayan_module.dart';
import 'naat_playing_screen.dart';

class BayansScreen extends StatelessWidget {
  BayansScreen({super.key});

  final List<BayanModule> bayanCollections = [
    BayanModule(
      name: 'Surah e Yaseen',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url: 'https://www.alahazrat.info/speeches/mujeebali/mp3/surah_YASEEN.mp3',
    ),
    BayanModule(
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      name: 'Tazeem e Rasool(ﷺ) Ka Munkir Kaafir Hay',
      url:
          'https://www.alahazrat.info/speeches/mujeebali/mp3/tazeem_e_rasool_ka_munkir_kafir_hay.mp3',
    ),
    BayanModule(
      name: 'Iman Ki Hifazat',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url:
          'https://www.alahazrat.info/speeches/mujeebali/mp3/iman_ki_hifazat.mp3',
    ),
    BayanModule(
      name: 'Dour e Hazir Kay Fitnay',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url:
          'https://www.alahazrat.info/speeches/mujeebali/mp3/doure_hazir_k_fitnay.mp3',
    ),
    BayanModule(
      name: 'Seerat e Farooq e Azam(رضی اللہ تعالی عنہ)',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url:
          'https://www.alahazrat.info/speeches/mujeebali/mp3/seerate_farooq-e-azam.mp3',
    ),
    BayanModule(
      name: 'Azmate Namaz',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url: 'https://www.alahazrat.info/speeches/mujeebali/mp3/azmate_namaz.mp3',
    ),
    BayanModule(
      name: 'Radde Suleh Kulliyath',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url:
          'https://www.alahazrat.info/speeches/mujeebali/mp3/radde_suleh_kuliyath.mp3',
    ),
    BayanModule(
      name: 'Azaab e Qabar',
      naatKhawan: 'Hazrat Allama Maulana Muhammad Mujeeb Ali Razvi Qadri',
      url: 'https://www.alahazrat.info/speeches/mujeebali/mp3/azab_e_qabar.mp3',
    ),
    BayanModule(
      name: 'Khidmaat e Alahazrat',
      naatKhawan: 'Hazrat Allama Maulana Zia ul Mustafa',
      url:
          'https://www.alahazrat.info/speeches/ziaulmustafa/mp3/khidmat_e_alahazrat2.mp3',
    ),
    BayanModule(
      name: 'Sirf Ahlesunnat Haq Per Hain',
      naatKhawan: 'Mufti Syed Rizwan Rifai Shafai',
      url:
          'https://www.alahazrat.info/speeches/mufti-syed-rizwan-shafai/Sirf%20Ahlesunnat%20Haq%20Per%20Hain.mp3',
    ),
    BayanModule(
      name: 'Qurbani Ka Masla',
      naatKhawan: 'Mufti Syed Rizwan Rifai Shafai',
      url:
          'https://www.alahazrat.info/speeches/mufti-syed-rizwan-shafai/Qurbani%20Ka%20Masla%20(Mariz%20Ki%20Taraf%20Se%20Jani%20Sadqa%20Dena%20ibadat%20Hai).mp3',
    ),
    BayanModule(
      name: 'Mout Ka Bayan',
      naatKhawan: 'Hazrat Allama Maulana Syed Shah Turab ul Haq Qadri',
      url:
          'https://www.alahazrat.info/Dars-e-Fiqah/23-Mout%20Ka%20Bayan_26-Jan-2014.mp3',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khususi Bayans'),
      ),
      body: ListView.builder(
        itemCount: bayanCollections.length,
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
                      bayanCollections[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kColorScheme.onSecondary,
                      ),
                    ),
                    subtitle: Text(
                      bayanCollections[index].naatKhawan,
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
                            name: bayanCollections[index].name,
                            url: bayanCollections[index].url,
                            voice: bayanCollections[index].naatKhawan,
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
