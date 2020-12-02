import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distressoble/Model/GroupModel.dart';
import 'package:distressoble/Model/UserModel.dart';
class FirebaseGroupRepository{
  CollectionReference groupCollection = FirebaseFirestore.instance.collection('Group');

  Future<Group> getUserGroup({User appUser}) async {
    return await groupCollection.doc(appUser.groupId).get().then((snapshot) {
      if (snapshot.data() != null) {
        return Group.fromJson(snapshot.data());
      }
      return null;
    });
  }
  Future<void> updateGroup({User userProfile, Group group}) async {
    await groupCollection.doc(userProfile.groupId).set(group.copyWith(groupName: group.groupName, groupNameId: group.groupNameId, users: group.users, memberCount: group.memberCount).toJson(), SetOptions(merge: true));
  }
  Future<void> leaveGroup({User userProfile, Group group})async{
    List<String> users = List<String>();
        group.users.forEach((element) {element != userProfile.uid? users.add(element): print('');});
    if(users.length == 0) {
      await groupCollection.doc(userProfile.groupId).delete();
    }else{
      await groupCollection.doc(userProfile.groupId).set(group.copyWith(groupName: group.groupName, groupNameId: group.groupNameId, users: users, memberCount: group.memberCount).toJson(), SetOptions(merge: true));
    }
  }

  Future<String> createGroup({String groupName, User userProfile})async{
    List<String> groupUsers = List<String>();
    groupUsers.add(userProfile.uid);
    Group newGroup = Group(groupName: groupName, users: groupUsers, memberCount: 1);
    DocumentReference reference = await groupCollection.add(newGroup.toJson());
    groupCollection = reference.collection('Group');
    return reference.id;
  }
}