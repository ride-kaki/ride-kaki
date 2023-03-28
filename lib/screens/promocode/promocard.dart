import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromoCard extends StatelessWidget {
  const PromoCard(
      {super.key,
      this.promoDetails,
      this.promoCode,
      this.lastRedemptionDate,
      this.imageString});

  final String? promoDetails;
  final String? promoCode;
  final String? lastRedemptionDate;
  final String? imageString;
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
                height: 60, width: 60, child: Image.asset(imageString ?? ""))),
        Positioned(bottom: 30, left: 45, child: Text(promoDetails ?? "")),
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
            child: Text(promoCode ?? "", style: TextStyle(fontSize: 30))),
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
            child: Text(lastRedemptionDate ?? "")),
      ],
    );
  }
}
