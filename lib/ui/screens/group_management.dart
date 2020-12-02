import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/Model/GroupModel.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/qubit/group_cubit/group_cubit.dart';
import 'package:distressoble/qubit/profile_cubit/profile_cubit.dart';
import 'package:distressoble/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
class GroupManagementScreen extends StatefulWidget {
  @override
  _GroupManagementScreenState createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  ProfileCubit _profileCubit;
  String emailValue = '';
  List<User> _users;
  String _nameValue = '';

  _populateUsers(Group group)async{
    _users = await _profileCubit.getGroupUsers(group.users);
    setState(() {

    });
  }

  _kickUser(User user)async{
    await BlocProvider.of<GroupCubit>(context).leaveGroup(user: user);
    user = user.copyWith(groupId: '');
    await _profileCubit.updateProfile(user);
  }

  _addMember(String email, Group group) async{
    User user = await _profileCubit.getProfileByEmail(email);
    if(user != null){
      _users.add(user);
      List<String> ids = List<String>();
      _users.forEach((user) => ids.add(user.uid));
      await BlocProvider.of<GroupCubit>(context).updateGroup(user: _profileCubit.state.mainProfileState.user, group: group.copyWith(users: ids));
      user = user.copyWith(groupId: _users[0].groupId);
      await _profileCubit.updateProfile(user);
      await _populateUsers(group);
      setState(() {

      });
    }
    else{
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Error: E-mail is not registered or user is already in a group')),
          ),
        );
    }
  }

  _createGroup(String name)async{
    await BlocProvider.of<GroupCubit>(context).createGroup(user: _profileCubit.state.mainProfileState.user, groupName: name, context: context);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _profileCubit = BlocProvider.of<ProfileCubit>(context);
    _populateUsers(BlocProvider.of<GroupCubit>(context).state.mainGroupState.group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if(state is GroupLoaded && state.mainGroupState.group != null && state.mainGroupState.group.users.length > 0){
            return ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      color: Colors.black,
                      child: Center(
                        child: Text(state.mainGroupState.group.groupName, style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      color: Colors.black,
                      child: Center(
                        child: Text('Members', style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        itemCount: state.mainGroupState.group.users.length,
                        itemBuilder: (context, index){
                         User user = _users[index];
                          return Column(
                            children: [
                              Card(
                                color: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text('${user.name} ${user.surname}', style: TextStyle(color: Colors.white),),),
                                      Expanded(child: Text('${user.email}', style: TextStyle(color: Colors.white),),),
                                      IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: () => _kickUser(user),)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12,),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      color: Colors.black,
                      child: Center(
                        child: Text('Add a member', style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),

                    ),
                    Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              initialValue: emailValue,
                              decoration: InputDecoration(
                                labelText: 'Member e-mail address',
                                labelStyle: TextStyle(color: Colors.white)
                              ),
                              onChanged: (value) => emailValue = value,
                            ),
                        ),
                        SizedBox(width: 15,),
                        RaisedButton(
                          elevation: 12,
                          color: Colors.blue,
                          child: Center(
                            child: Text('Add Member'),
                          ),
                          onPressed: () => _addMember(emailValue, state.mainGroupState.group),
                        )
                      ],
                    )
                  ],
                )
              ],
            );
          }
          if((state is GroupLoaded || state.mainGroupState.group == null || state.mainGroupState.group.users?.length == 0) || state is GroupError){
            return Column(
              children: [
                SizedBox(height: 30,),
                Container(
                  height: 50,
                  color: Colors.black,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          initialValue: _nameValue,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: 'Group Name'
                          ),
                          onChanged: (value) {_nameValue = value;
                          },
                        ),
                      ),
                      SizedBox(width: 15,),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed:  () => _createGroup(_nameValue),
                        child: Text('Create Group', style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}
