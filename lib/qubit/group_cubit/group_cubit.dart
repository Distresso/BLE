import 'package:bloc/bloc.dart';
import 'package:distressoble/Model/GroupModel.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/store/firebase_group_repository.dart';
import 'package:equatable/equatable.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());
  FirebaseGroupRepository groupRepository = FirebaseGroupRepository();

  Future<Group> loadGroup({User user})async{
    emit(GroupLoading());
    try{
      Group group = await groupRepository.getUserGroup(appUser: user);
      emit(GroupLoaded(group: group));
    }catch(error){
      emit(GroupError());
      print(error.toString());
    }
  }

  Future<void> leaveGroup({User user})async{
    emit(GroupLoading());
    try{
      groupRepository.leaveGroup(userProfile: user, group: state.group);
      emit(GroupLoaded(group: null));
    }catch(error){
      emit(GroupError());
    }
  }

  Future<void> createGroup({User user, String groupName})async{
    emit(GroupLoading());
    try{
      groupRepository.createGroup(userProfile: user, groupName: groupName);
      Group group = await groupRepository.getUserGroup(appUser: user);
      emit(GroupLoaded(group: group));
    }catch(error){
      print(error.toString());
    }
  }
  Future<void> updateGroup({User user, Group group})async{
    emit(GroupLoading());
    try{
    await groupRepository.updateGroup(group: group, userProfile: user);
    Group updatedGroup = await groupRepository.getUserGroup(appUser: user);
    emit(GroupLoaded(group: updatedGroup));
    }catch(error){
      emit(GroupError());
      print(error.toString());
    }
  }
}
