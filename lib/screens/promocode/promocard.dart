import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String promoCardName = "assets/images/vecs.svg";
    final Widget promocard = SvgPicture.asset(
      promoCardName,
      semanticsLabel: 'Acme Logo',
      colorFilter: ColorFilter.srgbToLinearGamma(),
    );
    return Stack(
      children: [
        promocard,
        Positioned(
            top: 25,
            left: 45,
            child: SizedBox(
                height: 60,
                width: 60,
                child: Image.asset('assets/images/grab.png'))),
        Positioned(bottom: 30, left: 45, child: Text("\$2 Off")),
        Positioned(
            top: 20,
            left: 157,
            child: Text(
              "Promo",
              style: TextStyle(color: Colors.green, fontSize: 30),
            )),
        Positioned(
            top: 50,
            left: 157,
            child: Text("CNY2020", style: TextStyle(fontSize: 30))),
        Positioned(
            top: 86,
            left: 158,
            child: Text("Last Redemption:", style: TextStyle(fontSize: 14))),
        Positioned(
            top: 107,
            left: 157,
            child: Icon(
              Icons.calendar_month_rounded,
              color: Colors.grey,
            )),
        Positioned(
            top: 109,
            left: 187,
            child: Text(DateTime.now().toString().substring(0, 10))),
      ],
    );
  }
}
