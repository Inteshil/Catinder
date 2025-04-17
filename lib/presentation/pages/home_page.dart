import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catinder/domain/entities/cat.dart';
import 'package:catinder/domain/repositories/cat_repository.dart';
import 'package:catinder/presentation/blocs/home/home_bloc.dart';
import 'package:catinder/presentation/blocs/home/home_event.dart';
import 'package:catinder/presentation/blocs/home/home_state.dart';
import 'package:catinder/presentation/widgets/cat_card.dart';
import 'package:catinder/presentation/pages/liked_cats_page.dart';
import 'package:catinder/di.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catinder'),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LikedCatsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.currentCat != null
                  ? Dismissible(
                      key: Key(state.currentCat!.id),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          context.read<HomeBloc>().add(LikeCat(state.currentCat!));
                        } else {
                          context.read<HomeBloc>().add(DislikeCat(state.currentCat!));
                        }
                        context.read<HomeBloc>().add(LoadNextCat());
                      },
                      child: CatCard(
                        cat: state.currentCat!,
                        onLike: () {
                          context.read<HomeBloc>().add(LikeCat(state.currentCat!));
                          context.read<HomeBloc>().add(LoadNextCat());
                        },
                        onDislike: () {
                          context.read<HomeBloc>().add(DislikeCat(state.currentCat!));
                          context.read<HomeBloc>().add(LoadNextCat());
                        },
                      ),
                    )
                  : const Center(child: Text('Нет доступных котов')),
        );
      },
    );
  }
}