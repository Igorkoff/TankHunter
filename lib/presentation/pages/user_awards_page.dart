import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../components/app_bar.dart';

class UserAwardsPage extends StatefulWidget {
  const UserAwardsPage({Key? key}) : super(key: key);

  @override
  State<UserAwardsPage> createState() => _UserAwardsPageState();
}

class _UserAwardsPageState extends State<UserAwardsPage> {
  int _verifiedReportsCounter = 0;
  int _selectedAwardThreshold = 0;
  String _selectedAwardName = 'Volunteer - With Ukraine in Heart';
  String _selectedAward = 'Volunteer';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: (MediaQuery.of(context).size.height * .18)),
      children: [
        buildAppBar(context: context, title: 'Awards for Service'),
        _buildSelectedAward(_selectedAward),
        const SizedBox(height: 24.0),
        Center(child: Text(_selectedAwardName, style: Theme.of(context).textTheme.titleMedium)),
        const SizedBox(height: 6.0),
        Center(
            child: Text(
                _selectedAwardThreshold != 0
                    ? 'Awarded for $_selectedAwardThreshold Verified Reports'
                    : 'Awarded for installing Tank Hunter',
                style: Theme.of(context).textTheme.titleMedium)),
        const SizedBox(height: 24.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildAwardsGrid(),
        ),
      ],
    );
  }

  Widget _buildSelectedAward(String award) {
    return Container(
      height: 200.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffE5EBFA),
        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 20.0)],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Image.asset('assets/images/$award.png'),
    );
  }

  Widget _buildAwardsGrid() {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(userID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LoadingAnimationWidget.hexagonDots(color: const Color(0xff0037C3), size: 50),
          );
        }

        _verifiedReportsCounter = snapshot.data?['verified_reports'];

        return GridView.count(
          physics: const ScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 15.0,
          childAspectRatio: 0.85,
          shrinkWrap: true,
          children: [
            _buildAwardContainer('Badge_for_Services_to_the_AFU', 'Badge "For Services to the AFU"', 1),
            _buildAwardContainer('Medal_for_Assistance_to_the_AFU', 'Medal "For Assistance to the AFU"', 5),
            _buildAwardContainer('Medal_for_Defense_of_the_Motherland', 'Medal "For Defender of the Motherland"', 10),
            _buildAwardContainer('Order_for_Courage_III', 'Badge of the Order "For Courage" III class', 20),
            _buildAwardContainer('Order_of_Merit_III', 'Order of Merit III class', 25),
            _buildAwardContainer('Order_of_Merit_III_Swords', 'Order of Merit III class with Swords', 30),
            _buildAwardContainer('Order_of_Merit_II', 'Order of Merit II class', 30),
            _buildAwardContainer('Order_of_Merit_II_Swords', 'Order of Merit II class with Swords', 35),
            _buildAwardContainer('Hero_of_Ukraine', 'Hero of Ukraine', 50),
          ],
        );
      },
    );
  }

  Widget _buildAwardContainer(String file, String name, int threshold) {
    final progress = _verifiedReportsCounter / threshold;

    return InkWell(
      onTap: () {
        if (progress >= 1.0) {
          _selectedAward = file;
          _selectedAwardName = name;
          _selectedAwardThreshold = threshold;
          setState(() {});
        }
      },
      child: CircularPercentIndicator(
        radius: 55.0,
        backgroundColor: const Color(0xff9BAFFF),
        lineWidth: 4.0,
        percent: progress < 1.0 ? progress : 1.0,
        center: SizedBox(height: 75, child: Image.asset('assets/images/$file.png')),
        progressColor: const Color(0xff1D44A7),
      ),
    );
  }
}
