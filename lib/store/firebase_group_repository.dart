import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distressoble/Model/GroupModel.dart';
import 'package:distressoble/Model/UserModel.dart';
class FirebaseGroupRepository{
  CollectionReference groupCollection = FirebaseFirestore.instance.collection('Group');

  Future<Group> getUserGroup({User appUser}){
    return groupCollection.doc(appUser.groupId).get().then((snapshot) {
      if (snapshot.data() != null) {
        return Group.fromJson(snapshot.data());
      }
      return null;
    });
  }
  Future<void> updateGroup({User userProfile, Group group}) async {
    await groupCollection.doc(userProfile.uid).set(group.copyWith(groupName: group.groupName, groupNameId: group.groupNameId, users: group.users, memberCount: group.memberCount).toJson(), SetOptions(merge: true));
  }
  Future<void> leaveGroup({User userProfile, Group group})async{
    group.users.forEach((element) {element.uid == userProfile.uid? group.users.remove(element): print('');});
    if(group.users.length == 0) {
      await groupCollection.doc(userProfile.uid).delete();
    }else{
      await groupCollection.doc(userProfile.uid).set(group.copyWith(groupName: group.groupName, groupNameId: group.groupNameId, users: group.users, memberCount: group.memberCount).toJson(), SetOptions(merge: true));
    }
  }

  Future<void> createGroup({String groupName, User userProfile})async{
    List<User> groupUsers = List<User>();
    groupUsers.add(userProfile);
    Group newGroup = Group().copyWith(groupName: groupName, users: groupUsers, memberCount: 1);
    DocumentReference reference = await groupCollection.add(newGroup.toJson());
    groupCollection = reference.collection('Group');
  }
}