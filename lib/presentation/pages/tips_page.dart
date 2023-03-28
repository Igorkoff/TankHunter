import 'package:flutter/material.dart';
import 'package:tank_hunter/presentation/components/buttons.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/tips_background.jpeg"), fit: BoxFit.cover, opacity: 0.25)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 50.0),
            child: Column(
              children: [
                Text(
                  'Some tips for using Tank Hunter',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(color: const Color(0xffD6E1FE), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Before taking a photo of the vehicle, make sure that it\'s not ours. Russian tanks often marked with: Z, O and V.',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: const Color(0xffD6E1FE), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'After you took a photo, our AI will validate it. If you could not upload the report immediately, you have about 12 hours to upload it from Pending Reports page.',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: const Color(0xffD6E1FE), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40.0),
                buildButton(context: context, title: 'Understood', onPressed: () => Navigator.of(context).pop())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
