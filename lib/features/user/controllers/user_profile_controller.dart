import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splach/features/relationship/models/relationship.dart';
import 'package:splach/features/user/models/user.dart';
import 'package:splach/features/relationship/repositories/relationship_repository.dart';

class UserProfileController extends GetxController {
  UserProfileController(this.user);

  final RelationshipRepository _relationshipRepository = Get.find();

  final User user;
  final User currentUser = Get.find();
  final relationships = <Relationship>[].obs;
  final followers = <Relationship>[].obs;
  final followings = <Relationship>[].obs;

  bool get isOwner => user.id == currentUser.id;

  bool get isFollowingUser =>
      followers.any((follower) => follower.userIds.contains(currentUser.id!));

  bool get isFollowedByUser => followings
      .any((following) => following.userIds.contains(currentUser.id!));

  bool get isRelationshipMutual => isFollowingUser && isFollowedByUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadRelationships();
  }

  Future<void> loadRelationships() async {
    relationships.value = await _relationshipRepository.getAll(userId: user.id);

    debugPrint(
        'Founded ${relationships.length} relationships for user with Id ${user.id}');

    getFollowers();
    getFollowing();
  }

  void getFollowers() {
    followers.value = relationships
        .where((relationship) =>
            relationship.follower != user.id || relationship.isMutual)
        .toList();

    debugPrint(
        'Founded ${followers.length} followers for user with Id ${user.id}');
  }

  void getFollowing() {
    followings.value = relationships
        .where((relationship) =>
            relationship.follower == user.id || relationship.isMutual)
        .toList();

    debugPrint(
        'Founded ${followings.length} followings for user with Id ${user.id}');
  }

  Future<void> follow() async {
    final relationship = Relationship(
      userIds: [
        currentUser.id!,
        user.id!,
      ],
      follower: currentUser.id!,
      createdAt: DateTime.now(),
      // updatedAt: DateTime.now(),
    );

    final relationshipId =
        await _relationshipRepository.saveAndGetId(relationship);
    relationship.id = relationshipId;
    followers.add(relationship);
  }

  Future<void> unfollow() async {
    final relationship = followers.firstWhere((follower) {
      return follower.userIds.contains(currentUser.id!);
    });

    if (relationship.isMutual) {
      relationship.follower = user.id!;
      _relationshipRepository.update(relationship);
    } else {
      _relationshipRepository.delete(relationship.id!);
    }
    followers.remove(relationship);
  }
}
