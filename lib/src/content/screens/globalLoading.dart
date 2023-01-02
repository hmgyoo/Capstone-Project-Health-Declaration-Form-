import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GlobalLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loadingCard(),
        loadingCard(),
        loadingCard(),
        loadingCard(),
        loadingLabel(),
      ],
    );
  }

  Widget loadingCard() {
    return Card(
      elevation: 1,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: <Widget>[
              // containers
              Container(width: 100, height: 20, color: Colors.white),
              Expanded(child: Container()),
              Container(
                width: double.infinity,
                height: 15,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.blueGrey.shade300,
        highlightColor: Colors.blueGrey.shade600,
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
