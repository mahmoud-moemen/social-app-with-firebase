import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:social_app/social_layout/layoutCubit/layout_cubit.dart';
import 'package:social_app/social_layout/layoutCubit/layout_states.dart';

import '../../shared/components/components.dart';

class EditProfileScreen extends StatelessWidget
{

var nameController=TextEditingController();
var bioController=TextEditingController();
var phoneController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state)
      {

      },
      builder: (context,state)
      {
        var userModel=LayoutCubit.get(context).userModel;
        var profileImage=LayoutCubit.get(context).profileImage;
        var coverImage=LayoutCubit.get(context).coverImage;

        nameController.text=userModel!.name!;
        bioController.text=userModel!.bio!;
        phoneController.text=userModel!.phone!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions:
            [
  ////////////////////update button//////////////////
              defaultTextButton(callback: ()
              {
                LayoutCubit.get(context)
                    .updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text);
              }, text: 'Update'),
              SizedBox(width: 20.0),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:
                [
                  if(state is LayoutUserUpdateLoadingState )
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment:AlignmentDirectional.bottomCenter ,
                      children:
                      [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children:
                            [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image:coverImage ==null? NetworkImage(
                                        '${userModel!.cover}'):
                                    FileImage(coverImage)as ImageProvider,
                                    fit: BoxFit.cover,

                                  ),
                                ),
                              ),
                              IconButton(
                                  icon:CircleAvatar(

                                    radius: 20.0,
                                    child: Icon(
                                    IconBroken.Camera,
                                      size: 16.0,
                                    ),
                                  ) ,
                                  onPressed: ()
                                  {
                                    LayoutCubit.get(context).getCoverImage();
                                  }),
                            ],
                          ),
                          alignment:AlignmentDirectional.topCenter ,
                        ),
                        Stack(
                          alignment:AlignmentDirectional.bottomEnd,
                          children:
                          [
                            CircleAvatar(
                              radius: 59.0,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 55.0,
                                backgroundImage:profileImage == null ? NetworkImage('${userModel!.image}'):
                                (FileImage(profileImage) as ImageProvider) ,
                              ),
                            ),
                            IconButton(
                                icon:CircleAvatar(

                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ) ,
                                onPressed: ()
                                {
                                 LayoutCubit.get(context).getProfileImage();

                                }),

                          ],
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  if(LayoutCubit.get(context).profileImage !=null||
                      LayoutCubit.get(context).coverImage !=null
                   )
                    Row(
                    children:
                    [
                      if(LayoutCubit.get(context).profileImage !=null)
                      Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              callback: ()
                              {
                                LayoutCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                );
                              },
                              text: 'upload profile ',
                            ),
                            if(state is LayoutUserUpdateLoadingState)
                            SizedBox(height: 5.0,),
                            if(state is LayoutUserUpdateLoadingState)
                            LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      if(LayoutCubit.get(context).coverImage !=null)
                      Expanded(
                        child: Column(
                          children:
                          [
                            defaultButton(
                              callback: ()
                              {
                                LayoutCubit.get(context).uploadcoverImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              text: 'upload cover ',
                            ),
                            if(state is LayoutUserUpdateLoadingState)
                            SizedBox(height: 5.0,),
                            if(state is LayoutUserUpdateLoadingState)
                            LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(LayoutCubit.get(context).profileImage !=null||
                      LayoutCubit.get(context).coverImage !=null
                  )
                    SizedBox(height: 20.0,),

                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'name must not be empty';
                        }
                        return null;


                      },
                      label: 'Name',
                      prefix: IconBroken.User),

                  SizedBox(height: 10.0,),
                  defaultFormField(
                      controller: bioController,
                      type: TextInputType.text,
                      validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'bio must not be empty';
                        }
                        return null;


                      },
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle),

                  SizedBox(height: 10.0,),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'phone must not be empty';
                        }
                        return null;


                      },
                      label: 'Phone',
                      prefix: IconBroken.Call),

                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
