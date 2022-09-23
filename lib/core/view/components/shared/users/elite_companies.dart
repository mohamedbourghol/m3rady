import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/advertisers/advertisers_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';

import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/widgets/builders/elite_companies/elite_company_builder.dart';





class WEliteCompanies extends StatefulWidget {

  @override
  _WEliteCompaniesState createState() => _WEliteCompaniesState();
}

class _WEliteCompaniesState extends State<WEliteCompanies>
     {
  final AdvertisersController advertisersController =
  Get.put(AdvertisersController());


  var elite=[].obs;
  var start=0.obs;
  late Timer _myTimer;


  @override
  void initState() {
    super.initState();



    /// Init and start timer
    initAndStartTimer();
  }


  /// Init and start timer
  Future<void> initAndStartTimer() async {
    /// Elite companies timer

     elite.value= await advertisersController.fetchNewEliteCompanies();

     _myTimer = Timer.periodic( // assing new timer to our variable.
     Duration(
     seconds: 8,
     ), (timer) {
       if(start.value+4>elite.length)
         {
           start.value=0;
         }
       else{
         start.value=  start.value+4;
       }

    });
    }



  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.5,
                ),
              ],
              borderRadius:const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible:
                    elite.length > 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 4,
                        bottom: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: assets['elites'],
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Elite Advertisers'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              //color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            if(elite.length>0)
                            for(int i= start.value;i< start.value+4;i++)
                              if(i<elite.length)
                              GestureDetector(
                                onTap: () {
                                  if (elite[i].id!=GlobalVariables.user.id) {
                                    Get.toNamed('/advertiser/profile', arguments: {
                                      'id': elite[i].id,
                                    });
                                  } else {
                                    Get.toNamed('/profile/me');
                                  }
                                },
                                child: BEliteCompany(
                                  id: elite[i].id,
                                  imageUrl: elite[i].imageUrl!,
                                  name: elite[i].fullName!,
                                ),
                              ),
                          ]


                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: elite.length > 0,
            child: CBr(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();


    _myTimer.cancel();
    /// Delete controllers
    Get.delete<AdvertisersController>();
  }
}
