import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  await themeProvider.loadFont();
  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  // ✅ add const + super.key
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Theme Store',
      theme: themeProvider.getTheme(),
      home: const ThemeStoreScreen(),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selectedTheme';
  static const String _customThemeKey = 'customThemeColors';
  static const String _fontKey = 'selectedFont';
  late ThemeData _currentTheme;
  final List<ThemeData> _themes = [
    ThemeData.light(),
    ThemeData.dark(),
  ];
  int _selectedThemeIndex = 0;

  Color _primaryColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  String _selectedFont = 'Roboto'; // Default font

  ThemeProvider() {
    _currentTheme = _themes[_selectedThemeIndex];
  }

  ThemeData getTheme() {
    return _currentTheme.copyWith(
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontFamily: _selectedFont),
        bodyMedium: TextStyle(fontFamily: _selectedFont),
        bodySmall: TextStyle(fontFamily: _selectedFont),
      ),
    );
  }

  int getSelectedThemeIndex() => _selectedThemeIndex;

  Color getPrimaryColor() => _primaryColor;

  Color getBackgroundColor() => _backgroundColor;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedThemeIndex = prefs.getInt(_themeKey) ?? 0;

    if (_selectedThemeIndex == _themes.length) {
      // Load custom theme
      final customColors = prefs.getStringList(_customThemeKey);
      if (customColors != null) {
        _primaryColor = Color(int.parse(customColors[0]));
        _backgroundColor = Color(int.parse(customColors[1]));
      }
      _currentTheme = _buildCustomTheme();
    } else {
      _currentTheme = _themes[_selectedThemeIndex];
    }

    notifyListeners();
  }

  Future<void> loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString(_fontKey) ?? 'Roboto'; // Load font
    notifyListeners();
  }

  Future<void> setTheme(int index) async {
    _selectedThemeIndex = index;
    _currentTheme =
        (index < _themes.length) ? _themes[index] : _buildCustomTheme();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, index);
  }

  Future<void> setCustomTheme(Color primary, Color background) async {
    _primaryColor = primary;
    _backgroundColor = background;
    _currentTheme = _buildCustomTheme();
    _selectedThemeIndex = _themes.length;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _selectedThemeIndex);
    await prefs.setStringList(_customThemeKey, [
      primary.value.toString(),
      background.value.toString(),
    ]);
  }

  Future<void> setFont(String font) async {
    _selectedFont = font;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontKey, font);
  }

  ThemeData _buildCustomTheme() {
    return ThemeData(
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: _backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: _primaryColor, fontFamily: _selectedFont),
        bodyMedium: TextStyle(color: _primaryColor, fontFamily: _selectedFont),
        bodySmall: TextStyle(color: _primaryColor, fontFamily: _selectedFont),
      ),
    );
  }

  List<ThemeData> getAvailableThemes() => _themes;
}

class ThemeStoreScreen extends StatefulWidget {
  const ThemeStoreScreen({super.key});  // ✅ add const 
  @override
  _ThemeStoreScreenState createState() => _ThemeStoreScreenState();
}

class _ThemeStoreScreenState extends State<ThemeStoreScreen> {
  Color _previewPrimaryColor = Colors.blue;
  Color _previewBackgroundColor = Colors.white;
  String _previewFont = 'Roboto';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Store'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select Theme
              Text(
                'Select a Theme:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: themeProvider.getAvailableThemes().length + 1,
                itemBuilder: (context, index) {
                  final isSelected =
                      index == themeProvider.getSelectedThemeIndex();
                  final isCustomTheme =
                      index == themeProvider.getAvailableThemes().length;

                  return Card(
                    elevation: isSelected ? 4 : 2,
                    color: isCustomTheme
                        ? themeProvider.getBackgroundColor()
                        : themeProvider
                            .getAvailableThemes()[index]
                            .scaffoldBackgroundColor,
                    child: ListTile(
                      title: Text(
                        isCustomTheme ? 'Custom Theme' : 'Theme ${index + 1}',
                        style: TextStyle(
                          color: isCustomTheme
                            ? themeProvider.getPrimaryColor()
                            : (index == 1 // Index 1 corresponds to Theme 2
                            ? Colors.white
                            : themeProvider.getAvailableThemes()[index].primaryColor),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        if (isCustomTheme) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomThemeCreator(),
                            ),
                          );
                        } else {
                          themeProvider.setTheme(index);
                        }
                      },
                    ),
                  );
                },
              ),
              // Font customization section
              SizedBox(height: 20),
              Text(
                'Select Font:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.blue,
                    ),
              ),
              DropdownButton<String>(
                value: themeProvider._selectedFont,
                onChanged: (font) {
                  if (font != null) {
                    setState(() {
                      _previewFont = font;
                    });
                    themeProvider.setFont(font);
                  }
                },
                items: ['Roboto', 'Serif', 'Sans-serif', 'Monospace']
                    .map((font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Text(
                      font,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              // Color picker for primary color
              SizedBox(height: 20),
              Text(
                'Pick Primary Color:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BlockPicker(
                pickerColor: _previewPrimaryColor,
                onColorChanged: (color) {
                  setState(() {
                    _previewPrimaryColor = color;
                  });
                  themeProvider.setCustomTheme(color, _previewBackgroundColor);
                },
              ),
              // Color picker for background color
              SizedBox(height: 20),
              Text(
                'Pick Background Color:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              BlockPicker(
                pickerColor: _previewBackgroundColor,
                onColorChanged: (color) {
                  setState(() {
                    _previewBackgroundColor = color;
                  });
                  themeProvider.setCustomTheme(_previewPrimaryColor, color);
                },
              ),
              // Real-time theme preview
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Real-Time Preview',
                      style: TextStyle(
                        fontFamily: _previewFont,
                        fontSize: 24,
                        color: _previewPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a preview of your selected theme. You can save it if you liked',
                      style: TextStyle(
                        fontFamily: _previewFont,
                        fontSize: 18,
                        color: _previewPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomThemeCreator extends StatefulWidget {
  const CustomThemeCreator({super.key});  // ✅ add const
  @override
  _CustomThemeCreatorState createState() => _CustomThemeCreatorState();
}

class _CustomThemeCreatorState extends State<CustomThemeCreator> {
  Color _primaryColor = Colors.blue;
  Color _backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Theme Creator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick Primary Color:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              BlockPicker(
                pickerColor: _primaryColor,
                onColorChanged: (color) {
                  setState(() {
                    _primaryColor = color;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Pick Background Color:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10),
              BlockPicker(
                pickerColor: _backgroundColor,
                onColorChanged: (color) {
                  setState(() {
                    _backgroundColor = color;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    themeProvider.setCustomTheme(
                        _primaryColor, _backgroundColor);
                    Navigator.pop(context);
                  },
                  child: Text('Save Custom Theme'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
