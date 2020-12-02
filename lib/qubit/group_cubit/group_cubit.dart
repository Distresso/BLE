import 'package:bloc/bloc.dart';
import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/Model/GroupModel.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/qubit/profile_cubit/profile_cubit.dart';
import 'package:distressoble/store/firebase_group_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());
  FirebaseGroupRepository groupRepository = FirebaseGroupRepository();

   loadGroup({User user})async{
    emit(GroupLoading(state.mainGroupState));
    try{
      Group group = await groupRepository.getUserGroup(appUser: user) ?? Group(memberCount: 0, users: List<String>());
      emit(GroupLoaded(state.mainGroupState.copyWith(group: group)));
    }catch(error){
      emit(GroupError(state.mainGroupState));
      print(error.toString());
    }
  }

  Future<void> leaveGroup({User user})async{
    emit(GroupLoading(state.mainGroupState));
    try{
      groupRepository.leaveGroup(userProfile: user, group: state.mainGroupState.group);
      emit(GroupLoaded(state.mainGroupState.copyWith(group: null)));
    }catch(error){
      emit(GroupError(state.mainGroupState));
    }
  }

  Future<void> createGroup({User user, String groupName, BuildContext context})async{
    emit(GroupLoading(state.mainGroupState));
    try{
      String groupID = await groupRepository.createGroup(userProfile: user, groupName: groupName);
      await BlocProvider.of<ProfileCubit>(context).updateProfile(user.copyWith(groupId: groupID));
      Group group = await groupRepository.getUserGroup(appUser: BlocProvider.of<ProfileCubit>(context).state.mainProfileState.user);
      emit(GroupLoaded(state.mainGroupState.copyWith(group: group)));
    }catch(error){
      print(error.toString());
    }
  }
  Future<void> updateGroup({User user, Group group})async{
    emit(GroupLoading(state.mainGroupState));
    try{
    await groupRepository.updateGroup(group: group, userProfile: user);
    Group updatedGroup = await groupRepository.getUserGroup(appUser: user);
    emit(GroupLoaded(state.mainGroupState.copyWith(group: updatedGroup)));
    }catch(error){
      emit(GroupError(state.mainGroupState));
      print(error.toString());
    }
  }
}
