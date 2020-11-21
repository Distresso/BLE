import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/qubit/group_cubit/group_cubit.dart';
import 'package:distressoble/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
class GroupManagementScreen extends StatefulWidget {
  @override
  _GroupManagementScreenState createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if(state is GroupLoaded && state.mainGroupState.group != null){
            // Group management
            return LoadingIndicator();
          }
          if(state is GroupLoaded && state.mainGroupState.group == null){
            return LoadingIndicator();
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}
