import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:m3rady/core/models/posts/like/likes.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

class LikesView extends StatefulWidget {
  var likesModel;
   LikesView({Key? key,required this.likesModel}) : super(key: key);

  @override
  _LikesViewState createState() => _LikesViewState();
}

class _LikesViewState extends State<LikesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 12,
          title: Text(
            "Liked people".tr,
            style: Get.theme.appBarTheme.titleTextStyle,
          ),


          elevation: 0,

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              widget.likesModel.length>0?
              ListView.separated(
                reverse: true,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>   Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Image
                          GestureDetector(
                            onTap: () {


                            },
                            child: WUserImage(
                              widget.likesModel[index].imageUrl ?? '',
                              isElite: false,
                              radius: 24,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xffF1F2F6),
                                  borderRadius: BorderRadius.all(
                                    const Radius.circular(14),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1,
                                      color: Color(0xffF1F2F6),
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /// Name
                                    Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 1,
                                            maxWidth: Get.width / 1.4,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {



                                            },
                                            child: Text(
                                              widget.likesModel[index].name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/icons/like.jpg')
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: widget.likesModel.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(
                      width: 8,
                      height: 12,
                    ),

              ):
              Container(
                height:  MediaQuery.of(context).size.height*0.8,
                child: Center(
                  child: Text(
                    "No Likes".tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,


                    ),
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
