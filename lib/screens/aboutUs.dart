import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aboutUs.jpg'),
              fit: BoxFit.cover
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Text('Pet care هو تطبيق يساعدك علي اختيار افضل العيادات و المدربين\n'
                    'يوفر لك مستلزمات و أدوية العناية بحيوانك الاليف\n'
                    'بحث عن شركاء تزاوج للحصول انقى السلالات\n'
                    'شراء كل ما يلزم من أطعمة والاكسسوارات\n'
                    'مهمتنا توفير كل ما يحتاجه حيوانك الأليف من خلال pet care', style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.right,),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('Pet care it is an application that helps you choose the best clinics and trainers.\n'
                    '\n'
                    'Provides you with supplies and medicines to take care of your pet.\n'
                    '\n'
                    'Look for mating partners to get the purest breeds.\n'
                    '\n'
                    'Buy all the necessary food and accessories.\n'
                    '\n'
                    'Our mission is to provide everything your pet needs through pet care.', style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
