import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/follow/follow_controller.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

class FollowButton extends StatefulWidget {
  FollowButton({
    required this.user,
    this.dense = false,
    this.isHideUnFollowInDense = false,
  });

  var user;
  bool dense = false;
  bool isHideUnFollowInDense = false;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  final FollowController followController = Get.put(FollowController());
  var isFollowed = false;
  FollowStatus followStatus = FollowStatus.unfollowed;

  @override
  void initState() {
    super.initState();

    /// After loading
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        /// Get and set is followed
        getAndSetIsFollowed();
      },
    );
  }

  /// Get and set is followed
  void getAndSetIsFollowed() {
    /// Set from current user
    this.followStatus = widget.user.followStatus;

    if (GlobalVariables.usersFollowStatus
        .containsKey("${widget.user.type}.${widget.user.id}")) {
      this.isFollowed = GlobalVariables
              .usersFollowStatus["${widget.user.type}.${widget.user.id}"] ==
          true;
    } else {
      this.isFollowed = widget.user.isFollowed == true;

      /// Set globally
      GlobalVariables
              .usersFollowStatus["${widget.user.type}.${widget.user.id}"] =
          this.isFollowed || this.followStatus == FollowStatus.pending;
    }
  }

  /// Toggle follow state
  Future toggleFollowState() async {
    GlobalVariables.usersFollowStatus["${widget.user.type}.${widget.user.id}"] =
        !GlobalVariables
            .usersFollowStatus["${widget.user.type}.${widget.user.id}"];

    this.isFollowed = GlobalVariables
        .usersFollowStatus["${widget.user.type}.${widget.user.id}"];

    /// Send request
    var follow = await followController.toggleFollowUser(
      userId: widget.user.id,
      userType: widget.user.type,
      isFollow: isFollowed,
    );

    /// If fail
    if (follow == false) {
      GlobalVariables
              .usersFollowStatus["${widget.user.type}.${widget.user.id}"] =
          !GlobalVariables
              .usersFollowStatus["${widget.user.type}.${widget.user.id}"];

      this.isFollowed = GlobalVariables
          .usersFollowStatus["${widget.user.type}.${widget.user.id}"];
    }
  }

  @override
  Widget build(BuildContext context) {
    /// If self
    if (widget.user.isSelf == true ||
        GlobalVariables.isUserAuthenticated.value == false) {
      return SizedBox();
    }

    /// If dense
    if (widget.dense == true) {
      return Obx(
        () => (GlobalVariables.usersFollowStatus[
                        "${widget.user.type}.${widget.user.id}"] ==
                    true &&
                widget.isHideUnFollowInDense == true)
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      /// Follow or unfollow
                      toggleFollowState();
                    },
                    child: Text(
                      GlobalVariables.usersFollowStatus[
                                  "${widget.user.type}.${widget.user.id}"] ==
                              true
                          ? 'Unfollow'.tr
                          : 'Follow'.tr,
                      style: TextStyle(
                        color: (GlobalVariables.usersFollowStatus[
                                    "${widget.user.type}.${widget.user.id}"] ==
                                true
                            ? Colors.grey
                            : Colors.orange),
                      ),
                    ),
                  ),
                ),
              ),
      );
    }

    return Obx(
      () => Container(
        width: (GlobalVariables.usersFollowStatus[
                    "${widget.user.type}.${widget.user.id}"] ==
                true
            ? 130
            : 100),
        height: 30,
        child: CMaterialButton(
          height: 30,
          borderColor: (GlobalVariables.usersFollowStatus[
                      "${widget.user.type}.${widget.user.id}"] ==
                  true
              ? Colors.grey
              : Colors.blue),
          color: (GlobalVariables.usersFollowStatus[
                      "${widget.user.type}.${widget.user.id}"] ==
                  true
              ? Colors.grey
              : Colors.blue),
          child: Text(
            (GlobalVariables.usersFollowStatus[
                            "${widget.user.type}.${widget.user.id}"] ==
                        true
                    ? (this.followStatus == FollowStatus.pending
                        ? 'Pending'
                        : 'Unfollow')
                    : 'Follow')
                .tr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            /// Follow or unfollow
            toggleFollowState();
          },
        ),
      ),
    );
  }
}
