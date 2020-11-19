part of 'group_cubit.dart';

class MainGroupState extends Equatable {
  final Group group;

  MainGroupState({this.group});

  @override
  List<Object> get props => [group];

  MainGroupState copyWith({
    Group group,
  }) {
    if ((group == null || identical(group, this.group))) {
      return this;
    }

    return new MainGroupState(
      group: group ?? this.group,
    );
  }
}

abstract class GroupState extends Equatable {
  final MainGroupState mainGroupState;

  const GroupState(this.mainGroupState);

  @override
  List<Object> get props => [mainGroupState];
}

class GroupInitial extends GroupState {
  GroupInitial() : super(MainGroupState());
}

class GroupLoading extends GroupState {
  GroupLoading(MainGroupState mainGroupState) : super(mainGroupState);
}

class GroupLoaded extends GroupState {
  GroupLoaded(MainGroupState mainGroupState) : super(mainGroupState);
}

class GroupError extends GroupState {
  GroupError(MainGroupState mainGroupState) : super(mainGroupState);
}
