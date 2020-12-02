import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/utilities/helper_file.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AppUserProfileRepository {
  final userProfileCollection = FirebaseFirestore.instance.collection('userProfiles');
  final FileHelper fileHelper = FileHelper();

  Future<User> getUserProfile() async {
    AuthProviderUserDetails currentUser = await AuthProviderRepository().getUser();
    if (currentUser != null) {
      return userProfileCollection.doc(currentUser.id).get().then((snapshot) {
        if (snapshot.data() != null) {
          return User.fromJson(snapshot.data());
        } else {
          User appUserProfile = User.fromAuthProviderUserDetails(currentUser);
          updateUserProfile(userProfile: appUserProfile, authProviderUserDetails: currentUser);
          return appUserProfile;
        }
      });
    }
    return User();
  }

  Future<User> getUser(String id) async{
    User user;
    await userProfileCollection.doc(id).get().then((snapshot) {
      print(snapshot.data());
      user = User.fromJson(snapshot.data());
    }
    );
    return user;
  }

  Future<List<User>> getGroupUsers(List<String> ids) async{
    List<User> users = List<User>();
    for(var id in ids){
      users.add(await getUser(id));
    }
       //ids.forEach((element) async {users.add(await getUser(element));});
    return users;
  }

  Future<List<User>> getUserByEmail() async{
    List<User> users = List<User>();
//    await userProfileCollection.snapshots().forEach((element) async {
//      element.docs.forEach((snap) {
//        print(snap.data());
//        users.add(User.fromJson(snap.data()));
//        return users;
//      });
//
//    });
    QuerySnapshot querySnapshot = await userProfileCollection.getDocuments();
    querySnapshot.documents.forEach((snap) {
      print(snap.data());
      users.add(User.fromJson(snap.data()));
    });
    return users;
  }




  Future<User> getFriendProfile(String email) async{
    List<User> users = await getUserByEmail();
    User user;
    users.forEach((element) {
      if(element.email == email){
        user = element;
      }
    });
    print(user);
    return user;
  }

  Future<void> updateUserProfile({User userProfile, AuthProviderUserDetails authProviderUserDetails}) async {
    await userProfileCollection.doc(userProfile.uid).set(userProfile.copyWith(id: userProfile.uid).toJson(), SetOptions(merge: true));
  }

  Future<void> updateProfile(String key, dynamic data) async {
    if (key == null) return;
    return await userProfileCollection.doc(key).update(data);
  }

  // Future<String> uploadImage(User profile, String imagePath, String imageName) async {
  //   String fileExtension = imageName.split('.').last;
  //   StorageReference storageReference = FirebaseStorage.instance.ref().child(profile.uid).child('profilePic.$fileExtension');
  //   try {
  //     String fileUrl = await fileHelper.uploadSingleImage(filePath: imagePath, fileName: imageName, storageRef: storageReference, forProfile: true);
  //     return fileUrl;
  //   } catch (exception) {
  //     throw exception;
  //   }
  // }
}
