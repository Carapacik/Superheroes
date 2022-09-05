import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/colors.dart';
import 'package:superheroes/resources/images.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({this.client, super.key});

  final http.Client? client;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(client: widget.client);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider.value(
        value: bloc,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: MainPageContent(),
              ),
            ),
          ),
        ),
      );
}

class MainPageContent extends StatelessWidget {
  MainPageContent({super.key});

  final FocusNode searchFiledFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          MainPageStateWidget(searchFiledFocusNode: searchFiledFocusNode),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 16, top: 12),
            child: SearchWidget(searchFiledFocusNode: searchFiledFocusNode),
          ),
        ],
      );
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({required this.searchFiledFocusNode, super.key});

  final FocusNode searchFiledFocusNode;

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final TextEditingController controller;
  bool haveSearchedText = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() {
        bloc.updateText(controller.text);
        final haveText = controller.text.isNotEmpty;
        if (haveSearchedText != haveText) {
          setState(() {
            haveSearchedText = haveText;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        focusNode: widget.searchFiledFocusNode,
        controller: controller,
        cursorColor: Colors.white,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.indigo75,
          isDense: true,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white54,
            size: 24,
          ),
          suffix: GestureDetector(
            onTap: controller.clear,
            child: const Icon(
              Icons.clear,
              color: Colors.white54,
              size: 24,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: haveSearchedText
                ? const BorderSide(color: Colors.white, width: 2)
                : const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
        ),
      );
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({required this.searchFiledFocusNode, super.key});

  final FocusNode searchFiledFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final state = snapshot.requireData;
        switch (state) {
          case MainPageState.loading:
            return const LoadingIndicator();
          case MainPageState.minSymbols:
            return const MinSymbolsWidget();
          case MainPageState.noFavorites:
            return NoFavoritesWidget(
              searchFiledFocusNode: searchFiledFocusNode,
            );
          case MainPageState.nothingFound:
            return NothingFoundWidget(
              searchFiledFocusNode: searchFiledFocusNode,
            );
          case MainPageState.loadingError:
            return const LoadingErrorWidget();
          case MainPageState.favorites:
            return SuperheroesList(
              title: 'Your favorites',
              stream: bloc.observeFavoriteSuperheroes(),
              ableToSwipe: true,
            );
          case MainPageState.searchResults:
            return SuperheroesList(
              title: 'Search results',
              stream: bloc.observeSearchedSuperheroes(),
              ableToSwipe: false,
            );
        }
      },
    );
  }
}

class NoFavoritesWidget extends StatelessWidget {
  const NoFavoritesWidget({required this.searchFiledFocusNode, super.key});

  final FocusNode searchFiledFocusNode;

  @override
  Widget build(BuildContext context) => Center(
        child: InfoWithButton(
          title: 'No favorites yet',
          subtitle: 'Search and add',
          buttonText: 'Search',
          assetImage: AppImages.ironman,
          imageHeight: 119,
          imageWidth: 108,
          imageTopPadding: 9,
          onTap: searchFiledFocusNode.requestFocus,
        ),
      );
}

class NothingFoundWidget extends StatelessWidget {
  const NothingFoundWidget({
    required this.searchFiledFocusNode,
    super.key,
  });

  final FocusNode searchFiledFocusNode;

  @override
  Widget build(BuildContext context) => Center(
        child: InfoWithButton(
          title: 'Nothing found',
          subtitle: 'Search for something else',
          buttonText: 'Search',
          assetImage: AppImages.hulk,
          imageHeight: 112,
          imageWidth: 84,
          imageTopPadding: 16,
          onTap: searchFiledFocusNode.requestFocus,
        ),
      );
}

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return Center(
      child: InfoWithButton(
        title: 'Error happened',
        subtitle: 'Please, try again',
        buttonText: 'Retry',
        assetImage: AppImages.superman,
        imageHeight: 106,
        imageWidth: 126,
        imageTopPadding: 22,
        onTap: bloc.retry,
      ),
    );
  }
}

class SuperheroesList extends StatelessWidget {
  const SuperheroesList({
    required this.ableToSwipe,
    required this.title,
    required this.stream,
    super.key,
  });

  final String title;
  final Stream<List<SuperheroInfo>> stream;
  final bool ableToSwipe;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final superheroes = snapshot.requireData;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: superheroes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTitleWidget(title: title);
              }
              final item = superheroes[index - 1];
              return ListTile(superhero: item, ableToSwipe: ableToSwipe);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          );
        },
      );
}

class ListTile extends StatelessWidget {
  const ListTile({
    required this.superhero,
    required this.ableToSwipe,
    super.key,
  });

  final SuperheroInfo superhero;
  final bool ableToSwipe;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    final card = SuperheroCard(
      superheroInfo: superhero,
      onTap: () async {
        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => SuperheroPage(id: superhero.id),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ableToSwipe
          ? Dismissible(
              key: ValueKey(superhero.id),
              background: const BackgroundCard(isLeft: true),
              secondaryBackground: const BackgroundCard(isLeft: false),
              onDismissed: (_) => bloc.removeFromFavorites(superhero.id),
              child: card,
            )
          : card,
    );
  }
}

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({required this.isLeft, super.key});

  final bool isLeft;

  @override
  Widget build(BuildContext context) => Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.red,
        ),
        child: Text(
          'Remove\nfrom\nfavorites'.toUpperCase(),
          textAlign: isLeft ? TextAlign.left : TextAlign.right,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class ListTitleWidget extends StatelessWidget {
  const ListTitleWidget({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 90, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}

class MinSymbolsWidget extends StatelessWidget {
  const MinSymbolsWidget({super.key});

  @override
  Widget build(BuildContext context) => const Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 110),
          child: Text(
            'Enter at least 3 symbols',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 110),
          child: CircularProgressIndicator(
            color: AppColors.blue,
          ),
        ),
      );
}
