import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  int _selectedNav = 0;

  final List<String> _tabs = const ['Featured', 'Just Added', 'Popular', 'A-Z'];

  final List<MovieItem> _movies = const [
    MovieItem('Peacemaker', 'assets/Peacemaker.webp', MovieKind.hero),
    MovieItem('Titans', 'assets/Titans.jpg', MovieKind.poster),
    MovieItem(
      'Escuadron Suicida',
      'assets/Escuadron Suicida 2.jpg',
      MovieKind.poster,
    ),
    MovieItem(
      'Batman Caballero de la Noche',
      'assets/Batman Caballero de la Noche.jpg',
      MovieKind.wide,
    ),
    MovieItem('Aves de Presa', 'assets/Aves de Presa.jpg', MovieKind.wide),
    MovieItem('The Last of Us', 'assets/The Last of Us.webp', MovieKind.wide),
    MovieItem('It', 'assets/It.jpg', MovieKind.poster),
    MovieItem('Euphoria', 'assets/Euphoria.jpg', MovieKind.poster),
    MovieItem('Rick and Morty', 'assets/Rick and Morty.webp', MovieKind.wide),
    MovieItem(
      'The Big Bang Theory',
      'assets/The big bang Theory.jpg',
      MovieKind.wide,
    ),
    MovieItem('Friends', 'assets/The Friends.jpg', MovieKind.wide),
    MovieItem(
      'Looney Tunes',
      'assets/The Looney Tunes Show.webp',
      MovieKind.wide,
    ),
    MovieItem('Un show mas', 'assets/Un show Mas.jpg', MovieKind.wide),
    MovieItem(
      'Gumball',
      'assets/El maravillosamente extrano mundo de Gumball.webp',
      MovieKind.wide,
    ),
    MovieItem('My Hero Academia', 'assets/My Hero Academia.jpg', MovieKind.poster),
    MovieItem('Zombiland', 'assets/Zombiland.jpg', MovieKind.wide),
  ];

  List<MovieItem> get _visibleMovies {
    final sorted = [..._movies];

    if (_selectedTab == 1) {
      return sorted.reversed.toList();
    }
    if (_selectedTab == 2) {
      return [
        sorted[0],
        sorted[3],
        sorted[5],
        sorted[8],
        sorted[9],
        sorted[1],
        sorted[2],
        sorted[10],
      ];
    }
    if (_selectedTab == 3) {
      sorted.sort((a, b) => a.title.compareTo(b.title));
      return sorted;
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(
              tabs: _tabs,
              selectedTab: _selectedTab,
              onTabSelected: (index) => setState(() => _selectedTab = index),
              onBack: () => _showMessage('Volver'),
              onCast: () => _showMessage('Conectar pantalla'),
              onProfile: () => _showMessage('Perfil'),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedNav,
                children: [
                  _HomeSections(
                    movies: _visibleMovies,
                    onMovieTap: _showMovie,
                  ),
                  _SimpleLibraryPage(
                    title: 'Movies',
                    movies: _movies
                        .where((movie) => movie.kind != MovieKind.hero)
                        .toList(),
                    onMovieTap: _showMovie,
                  ),
                  _SimpleLibraryPage(
                    title: 'Series',
                    movies: _movies
                        .where(
                          (movie) =>
                              movie.title.contains('Theory') ||
                              movie.title.contains('Friends') ||
                              movie.title.contains('Gumball') ||
                              movie.title.contains('Rick') ||
                              movie.title.contains('Titans') ||
                              movie.title.contains('Euphoria'),
                        )
                        .toList(),
                    onMovieTap: _showMovie,
                  ),
                  _DownloadsPage(onMovieTap: _showMovie),
                  _SearchPage(movies: _movies, onMovieTap: _showMovie),
                ],
              ),
            ),
            _BottomNavigation(
              selectedIndex: _selectedNav,
              onSelected: (index) => setState(() => _selectedNav = index),
            ),
          ],
        ),
      ),
    );
  }

  void _showMovie(MovieItem movie) {
    _showMessage(movie.title);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          duration: const Duration(milliseconds: 800),
          backgroundColor: const Color(0xFF1E1E1E),
        ),
      );
  }
}

enum MovieKind { hero, poster, wide }

class MovieItem {
  const MovieItem(this.title, this.asset, this.kind);

  final String title;
  final String asset;
  final MovieKind kind;
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onBack,
    required this.onCast,
    required this.onProfile,
  });

  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onBack;
  final VoidCallback onCast;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      color: Colors.black,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(-1, -0.35),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            ),
          ),
          const Align(
            alignment: Alignment(0, -0.72),
            child: _DcLogo(),
          ),
          Align(
            alignment: const Alignment(0.62, -0.33),
            child: IconButton(
              onPressed: onCast,
              icon: const Icon(Icons.cast, color: Colors.white, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, -0.33),
            child: GestureDetector(
              onTap: onProfile,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0A84FF), width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/Batman Caballero de la Noche.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: _CategoryTabs(
              tabs: tabs,
              selectedTab: selectedTab,
              onTabSelected: onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _DcLogo extends StatelessWidget {
  const _DcLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0B315A),
        border: Border.all(color: const Color(0xFF159CFF), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xAA008CFF),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Text(
        'MAX',
        style: TextStyle(
          color: Color(0xFF59C7FF),
          fontFamily: 'ArchivoBlack',
          fontSize: 21,
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < tabs.length; index++) ...[
          Expanded(
            child: _CategoryPill(
              label: tabs[index],
              selected: index == selectedTab,
              onTap: () => onTabSelected(index),
            ),
          ),
          if (index != tabs.length - 1) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.black,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? Colors.white : Colors.white38),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeSections extends StatelessWidget {
  const _HomeSections({required this.movies, required this.onMovieTap});

  final List<MovieItem> movies;
  final ValueChanged<MovieItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    final hero = movies.firstWhere(
      (movie) => movie.kind == MovieKind.hero,
      orElse: () => movies.first,
    );
    final posters = movies.where((movie) => movie.kind == MovieKind.poster).toList();
    final wide = movies.where((movie) => movie.kind == MovieKind.wide).toList();
    final orderedMovies = [
      hero,
      ...posters,
      ...wide,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 22),
      children: [
        _HeroImage(movie: hero, onTap: () => onMovieTap(hero)),
        const SizedBox(height: 14),
        _SectionBlock(
          title: 'Epic Origin Stories',
          child: _HorizontalPosters(movies: posters, onMovieTap: onMovieTap),
        ),
        const SizedBox(height: 16),
        _SectionBlock(
          title: 'More to Watch',
          child: _HorizontalWideMovies(movies: wide, onMovieTap: onMovieTap),
        ),
        const SizedBox(height: 16),
        _SectionBlock(
          title: 'All Movies',
          child: _MovieGrid(movies: orderedMovies, onMovieTap: onMovieTap),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.movie, required this.onTap});

  final MovieItem movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TappableImage(
      movie: movie,
      height: 132,
      width: double.infinity,
      alignment: const Alignment(0, -0.2),
      onTap: onTap,
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        const SizedBox(height: 9),
        child,
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'BebasNeue',
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1,
      ),
    );
  }
}

class _HorizontalPosters extends StatelessWidget {
  const _HorizontalPosters({required this.movies, required this.onMovieTap});

  final List<MovieItem> movies;
  final ValueChanged<MovieItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _TappableImage(
            movie: movie,
            width: 134,
            height: 154,
            alignment: Alignment.topCenter,
            onTap: () => onMovieTap(movie),
          );
        },
      ),
    );
  }
}

class _HorizontalWideMovies extends StatelessWidget {
  const _HorizontalWideMovies({required this.movies, required this.onMovieTap});

  final List<MovieItem> movies;
  final ValueChanged<MovieItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _TappableImage(
            movie: movie,
            width: 136,
            height: 76,
            alignment: Alignment.center,
            onTap: () => onMovieTap(movie),
          );
        },
      ),
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid({required this.movies, required this.onMovieTap});

  final List<MovieItem> movies;
  final ValueChanged<MovieItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 9,
        crossAxisSpacing: 9,
        childAspectRatio: 1.42,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _TappableImage(
          movie: movie,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          onTap: () => onMovieTap(movie),
        );
      },
    );
  }
}

class _SimpleLibraryPage extends StatelessWidget {
  const _SimpleLibraryPage({
    required this.title,
    required this.movies,
    required this.onMovieTap,
  });

  final String title;
  final List<MovieItem> movies;
  final ValueChanged<MovieItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 22),
      children: [
        _SectionBlock(
          title: title,
          child: _MovieGrid(movies: movies, onMovieTap: onMovieTap),
        ),
      ],
    );
  }
}

class _DownloadsPage extends StatelessWidget {
  const _DownloadsPage({required this.onMovieTap});

  final ValueChanged<MovieItem> onMovieTap;

  @override
  Widget build(BuildContext context) {
    const downloads = [
      MovieItem('Peacemaker', 'assets/Peacemaker.webp', MovieKind.hero),
      MovieItem('The Last of Us', 'assets/The Last of Us.webp', MovieKind.wide),
      MovieItem('Titans', 'assets/Titans.jpg', MovieKind.poster),
      MovieItem(
        'Batman',
        'assets/Batman Caballero de la Noche.jpg',
        MovieKind.wide,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 22),
      children: [
        _SectionBlock(
          title: 'Downloads',
          child: _MovieGrid(movies: downloads, onMovieTap: onMovieTap),
        ),
      ],
    );
  }
}

class _SearchPage extends StatefulWidget {
  const _SearchPage({required this.movies, required this.onMovieTap});

  final List<MovieItem> movies;
  final ValueChanged<MovieItem> onMovieTap;

  @override
  State<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = widget.movies
        .where(
          (movie) => movie.title.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 22),
      children: [
        TextField(
          onChanged: (value) => setState(() => _query = value),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: const Icon(Icons.search, color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF151515),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _MovieGrid(movies: results, onMovieTap: widget.onMovieTap),
      ],
    );
  }
}

class _TappableImage extends StatelessWidget {
  const _TappableImage({
    required this.movie,
    required this.width,
    required this.height,
    required this.alignment,
    required this.onTap,
  });

  final MovieItem movie;
  final double width;
  final double height;
  final Alignment alignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color(0xFF101010),
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: AssetImage(movie.asset),
                fit: BoxFit.cover,
                alignment: alignment,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.home_outlined,
      Icons.movie_creation_outlined,
      Icons.live_tv_outlined,
      Icons.file_download_outlined,
      Icons.search,
    ];

    return Container(
      height: 52,
      color: const Color(0xFF151515),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var index = 0; index < icons.length; index++)
            IconButton(
              onPressed: () => onSelected(index),
              icon: Icon(
                icons[index],
                color: index == selectedIndex ? Colors.white : Colors.white54,
                size: 21,
              ),
            ),
        ],
      ),
    );
  }
}
