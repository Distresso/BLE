part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  final Group group;
  const GroupState({this.group});
  @override
  List<Object> get props => [group];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  GroupLoaded({Group group}): super(group: group);
}

class GroupError extends GroupState {}
