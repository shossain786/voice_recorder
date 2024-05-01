import 'package:flutter/material.dart';

import '../main.dart';

class MyNaatScreen extends StatelessWidget {
  const MyNaatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Naats'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                color: kColorScheme.onPrimaryContainer.withOpacity(.4),
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ya Rasool Allah(ﷺ) Tere',
                        style: TextStyle(
                          color: kColorScheme.onSecondary,
                          fontSize: 20,
                        ),
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
