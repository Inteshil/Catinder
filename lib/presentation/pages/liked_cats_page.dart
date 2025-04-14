import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/repositories/cat_repository.dart';
import 'package:catinder/presentation/blocs/liked_cats/liked_cats_bloc.dart';
import 'package:catinder/presentation/widgets/cat_list_item.dart';
import 'package:catinder/presentation/pages/detail_screen.dart';
import 'package:catinder/di.dart';

class LikedCatsPage extends StatelessWidget {
  const LikedCatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikedCatsBloc(getIt<CatRepository>())..add(LoadLikedCats()),
      child: const LikedCatsView(),
    );
  }
}

class LikedCatsView extends StatelessWidget {
  const LikedCatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
      ),
      body: BlocBuilder<LikedCatsBloc, LikedCatsState>(
        builder: (context, state) {
          if (state is LikedCatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LikedCatsLoaded) {
            final cats = state.cats;
            if (cats.isEmpty) {
              return const Center(child: Text('No liked cats yet'));
            }
            return ListView.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) {
                final cat = cats[index];
                return CatListItem(
                  cat: cat,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(cat: cat),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is LikedCatsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}