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

  Future<void> updateUserProfile({User userProfile, AuthProviderUserDetails authProviderUserDetails}) async {
    await userProfileCollection.doc(authProviderUserDetails.id).set(userProfile.copyWith(id: authProviderUserDetails.id).toJson(), SetOptions(merge: true));
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
