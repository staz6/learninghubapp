import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learninghubapp/repository/creator/creator_bloc.dart';
import 'package:learninghubapp/repository/creator/subscribecubit.dart';

class CreatorsPage extends StatelessWidget {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatorsCubit(currentUserUid),
      child: Scaffold(
        body: BlocBuilder<CreatorsCubit, CreatorsState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.creators.length,
              itemBuilder: (context, index) {
                final creator = state.creators[index];

                return BlocProvider(
                  create: (context) => SubscribeCubit(currentUserUid, creator.id),
                  child: Card(
                    color: Color(0xFF2d2d2d),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            creator['fullName'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(creator['speciality']),
                          SizedBox(height: 4),
                          Text(creator['aboutMe']),
                          SizedBox(height: 4),
                          Text('Location: ${creator['country']}, ${creator['city']}'),
                          SizedBox(height: 4),
                          Text('Date of birth: ${creator['dateOfBirth']}'),
                          SizedBox(height: 8),
                          BlocBuilder<SubscribeCubit, SubscriptionStatus>(
                            builder: (context, subscriptionStatus) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (subscriptionStatus == SubscriptionStatus.subscribed) {
                                        context.read<SubscribeCubit>().unsubscribe();
                                      } else {
                                        context.read<SubscribeCubit>().subscribe();
                                      }
                                    },
                                    child: Text(subscriptionStatus == SubscriptionStatus.subscribed ? 'Unsubscribe' : 'Subscribe'),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


