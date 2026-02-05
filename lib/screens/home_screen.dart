import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

// ИСПРАВЛЕННЫЕ ИМПОРТЫ:
import 'package:car_care/models/car_model.dart';
import 'package:car_care/configs/car_config.dart';
import 'package:car_care/screens/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  
  // Контроллеры для новой записи ТО
  final TextEditingController _serviceTaskController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _servicePlaceController = TextEditingController();

  // Данные профиля
  String _userName = "Driver Karaganda";
  String _userEmail = "volkswagen_fan@mail.kz";
  String _profilePic = 'https://i.pravatar.cc/300?img=11';

  // Список истории обслуживания (локальное состояние)
  final List<Map<String, String>> _maintenanceLogs = [
    {"title": "Замена масла", "place": "Right Auto Parts", "date": "15.01.2026", "price": "18 500 ₸", "type": "check"},
    {"title": "Комплект фильтров", "place": "Right Auto Parts", "date": "15.01.2026", "price": "12 000 ₸", "type": "check"},
    {"title": "Замена тормозных дисков", "place": "СТО Karaganda", "date": "10.12.2025", "price": "45 000 ₸", "type": "history"},
  ];

  // Метод для открытия внешних ссылок
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showToast("Не удалось открыть ссылку");
      }
    } catch (e) {
      _showToast("Ошибка подключения: $e");
    }
  }

  // Функция поиска по VIN
  void _onVinSearch() {
    String vin = _vinController.text.trim();
    if (vin.isEmpty) {
      _showToast("Пожалуйста, введите VIN код");
      return;
    }
    _showToast("Поиск запчастей для VIN: $vin");
    _launchURL("https://kaspi.kz/shop/search/?text=$vin");
  }

  // --- НОВОЕ: МОДУЛЬ ТЕЛЕМЕТРИИ ---
  void _showTelemetryControl(Car car) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Telemetry",
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: CarConfig.cardDark.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: CarConfig.accentBlue.withOpacity(0.5)),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(car.name.toUpperCase(), 
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 30),
                  const Icon(Icons.security_rounded, color: Colors.greenAccent, size: 80),
                  const SizedBox(height: 10),
                  const Text("СИСТЕМА ПОД ОХРАНОЙ", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTeleStat(Icons.battery_charging_full, "12.7V", "АКБ"),
                      _buildTeleStat(Icons.thermostat_rounded, "84°C", "ДВС"),
                      _buildTeleStat(Icons.ac_unit_rounded, "-15°C", "САЛОН"),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildTeleAction(Icons.power_settings_new_rounded, "АВТОЗАПУСК", Colors.orangeAccent, () {
                    Navigator.pop(context);
                    _showToast("Команда запуска отправлена...");
                  }),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: _buildTeleAction(Icons.lock_open_rounded, "ОТКРЫТЬ", Colors.white10, () => _showToast("Авто открыто"))),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTeleAction(Icons.lock_outline_rounded, "ЗАКРЫТЬ", CarConfig.accentBlue, () => _showToast("Авто закрыто"))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeleStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _buildTeleAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarConfig.primaryDark,
      extendBodyBehindAppBar: true,
      drawer: _buildSideDrawer(),
      appBar: _buildAppBar(),
      body: _buildCurrentScreen(),
      floatingActionButton: _selectedIndex == 0 ? _buildNeonFab() : null,
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

  // --- ЛОГИКА ПЕРЕКЛЮЧЕНИЯ ЭКРАНОВ ---
  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0: return _buildGarageGrid(); 
      case 1: return _buildShopScreen(); 
      case 2: return _buildProfileScreen(); 
      default: return _buildGarageGrid();
    }
  }

  // --- 1. ЭКРАН ГАРАЖА ---
  Widget _buildGarageGrid() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CarConfig.primaryDark, Colors.black],
        ),
      ),
      child: myGarage.isEmpty 
        ? const Center(child: Text("Гараж пуст. Нажми +", style: TextStyle(color: Colors.white24, fontSize: 18)))
        : GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 110),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 25,
              childAspectRatio: 1.6,
            ),
            itemCount: myGarage.length,
            itemBuilder: (context, index) => _buildCarCard(context, index),
          ),
    );
  }

  Widget _buildCarCard(BuildContext context, int index) {
    final car = myGarage[index];
    double health = 1.0 - car.oilLife;

    return GestureDetector(
      onLongPress: () => _confirmDelete(index),
      onTap: () => Navigator.pushNamed(context, '/my_car', arguments: car),
      child: Hero(
        tag: car.name,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(image: AssetImage(car.image), fit: BoxFit.cover),
            boxShadow: [BoxShadow(color: CarConfig.accentBlue.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.95), Colors.transparent],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(car.name.toUpperCase(), 
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, decoration: TextDecoration.none)),
                    // ИКОНКА ТЕЛЕМЕТРИИ
                    GestureDetector(
                      onTap: () => _showTelemetryControl(car),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CarConfig.accentBlue.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: CarConfig.accentBlue.withOpacity(0.5))
                        ),
                        child: Icon(Icons.shield_outlined, color: CarConfig.accentNeon, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: health,
                          backgroundColor: Colors.white10,
                          color: health < 0.2 ? Colors.redAccent : CarConfig.accentNeon,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text("${car.mileage} KM", style: const TextStyle(color: Colors.white70, fontSize: 12, decoration: TextDecoration.none)),
                  ],
                ),
                if (health < 0.2)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("НЕОБХОДИМО ТЕХОБСЛУЖИВАНИЕ", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 2. ЭКРАН МАГАЗИНА ---
  Widget _buildShopScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPromoBanner(),
          const SizedBox(height: 30),
          const Text("ПОИСК ЗАПЧАСТЕЙ ПО VIN", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: CarConfig.cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: CarConfig.accentBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _vinController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Введите 17 знаков VIN...",
                      hintStyle: TextStyle(color: Colors.white24),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _onVinSearch,
                  icon: Icon(Icons.search_rounded, color: CarConfig.accentBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text("КАТЕГОРИИ RIGHT AUTO", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.5,
            children: [
              _buildCategoryTile(Icons.oil_barrel, "МАСЛА", "масло"),
              _buildCategoryTile(Icons.tire_repair, "ШИНЫ", "шины"),
              _buildCategoryTile(Icons.bolt, "СВЕЧИ", "свечи"),
              _buildCategoryTile(Icons.filter_alt, "ФИЛЬТРЫ", "фильтр"),
            ],
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: _buildQuickActionBtn("ПРОВЕРИТЬ ЗАПЧАСТЬ ПО VIN", Icons.search, Colors.orangeAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SPECIAL OFFER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 10),
          const Text("Скидка -15% на первый заказ в Right Auto Parts", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => _launchURL("https://kaspi.kz/shop/search/?text=Right%20Auto%20Parts"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: const StadiumBorder()),
            child: const Text("ПОЛУЧИТЬ"),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryTile(IconData icon, String label, String query) {
    return GestureDetector(
      onTap: () => _launchURL("https://kaspi.kz/shop/search/?text=Right%20Auto%20Parts%20$query"),
      child: Container(
        decoration: BoxDecoration(color: CarConfig.cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: CarConfig.accentBlue, size: 30),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- 3. ЭКРАН ПРОФИЛЯ (С АНАЛИТИКОЙ) ---
  Widget _buildProfileScreen() {
    double totalSpend = myGarage.isNotEmpty ? myGarage[0].totalExpenses : 0;

    return Stack(
      children: [
        Positioned(top: -50, right: -50, child: CircleAvatar(radius: 120, backgroundColor: CarConfig.accentBlue.withOpacity(0.05))),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: CarConfig.accentBlue, width: 3)),
                child: CircleAvatar(radius: 65, backgroundImage: NetworkImage(_profilePic)),
              ),
              const SizedBox(height: 20),
              Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
              Text(_userEmail, style: TextStyle(color: CarConfig.accentNeon, letterSpacing: 1.2)),
              
              const SizedBox(height: 30),
              
              GestureDetector(
                onTap: () {
                  if(myGarage.isNotEmpty) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsScreen(car: myGarage[0])));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statMiniColumn("РАСХОДЫ", "${totalSpend.toInt()} ₸"),
                      Container(width: 1, height: 30, color: Colors.white10),
                      _statMiniColumn("ТО ЧЕРЕЗ", "1 250 км"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              _buildGlassActionBtn(Icons.shopping_bag_outlined, "МОИ ЗАКАЗЫ", () => setState(() => _selectedIndex = 1)),
              _buildGlassActionBtn(Icons.analytics_outlined, "АНАЛИТИКА РАСХОДОВ", () {
                if(myGarage.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsScreen(car: myGarage[0])));
                } else {
                  _showToast("Гараж пуст");
                }
              }),
              _buildGlassActionBtn(Icons.settings_suggest_outlined, "НАСТРОЙКИ АККАУНТА", _showEditProfileSheet),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statMiniColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(color: CarConfig.accentNeon, fontSize: 16, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildGlassActionBtn(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            tileColor: Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
            leading: Icon(icon, color: CarConfig.accentBlue),
            title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white24),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  // --- ИСТОРИЯ ОБСЛУЖИВАНИЯ ---
  void _showMaintenanceHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: CarConfig.primaryDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
      builder: (context) => StatefulBuilder( 
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ИСТОРИЯ ТО", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  IconButton(
                    onPressed: () => _showAddServiceLogDialog(setModalState),
                    icon: Icon(Icons.add_circle_outline, color: CarConfig.accentNeon, size: 30),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _maintenanceLogs.length,
                  itemBuilder: (context, index) {
                    final log = _maintenanceLogs[index];
                    return _historyItem(
                      log["title"]!, 
                      log["place"]!, 
                      log["date"]!, 
                      log["price"]!, 
                      log["type"] == "check" ? Icons.check_circle : Icons.history
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddServiceLogDialog(Function setModalState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CarConfig.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("НОВАЯ ЗАПИСЬ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildServiceField(_serviceTaskController, "Что сделали?", Icons.build),
              _buildServiceField(_servicePlaceController, "Где (СТО/Магазин)?", Icons.place),
              _buildServiceField(_servicePriceController, "Стоимость (₸)", Icons.payments),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ОТМЕНА")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CarConfig.accentBlue),
            onPressed: () {
              if (_serviceTaskController.text.isNotEmpty) {
                final now = DateTime.now();
                final dateStr = "${now.day}.${now.month}.${now.year}";
                
                setState(() {
                  _maintenanceLogs.insert(0, {
                    "title": _serviceTaskController.text,
                    "place": _servicePlaceController.text.isEmpty ? "Частное обслуживание" : _servicePlaceController.text,
                    "date": dateStr,
                    "price": "${_servicePriceController.text} ₸",
                    "type": "check"
                  });
                });
                
                setModalState(() {});
                _serviceTaskController.clear();
                _servicePlaceController.clear();
                _servicePriceController.clear();
                Navigator.pop(context);
                _showToast("Запись добавлена!");
              }
            }, 
            child: const Text("ДОБАВИТЬ")
          ),
        ],
      ),
    );
  }

  Widget _buildServiceField(TextEditingController ctrl, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white24),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CarConfig.accentBlue.withOpacity(0.3))),
        ),
      ),
    );
  }

  Widget _historyItem(String title, String place, String date, String price, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: CarConfig.cardDark, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, color: CarConfig.accentBlue, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      Text("$date • $place", style: const TextStyle(color: Colors.white38, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ]
                  ),
                ),
              ],
            ),
          ),
          Text(price, style: TextStyle(color: CarConfig.accentNeon, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- ВСПОМОГАТЕЛЬНЫЕ ОКНА ---
  void _showAddCarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CarConfig.cardDark,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("ДОБАВИТЬ В ГАРАЖ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            TextField(
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Напр: Mercedes-Benz W211",
                hintStyle: const TextStyle(color: Colors.white24),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CarConfig.accentBlue)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: CarConfig.accentBlue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  setState(() {
                    myGarage.insert(0, Car(
                      name: _nameController.text,
                      image: 'assets/images/passat.png', 
                      description: 'Новый проект в гараже',
                      mileage: 0,
                      lastOilChange: 0,
                      specs: ['2026'],
                      consumables: [],
                    ));
                  });
                  _nameController.clear();
                  Navigator.pop(context);
                  _showToast("Автомобиль добавлен!");
                }
              }, 
              child: const Text("СОХРАНИТЬ"),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet() {
    final nameEdit = TextEditingController(text: _userName);
    showModalBottomSheet(
      context: context,
      backgroundColor: CarConfig.cardDark,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 30, left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("ИЗМЕНИТЬ ПРОФИЛЬ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            TextField(controller: nameEdit, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Ваше имя")),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                setState(() => _userName = nameEdit.text);
                Navigator.pop(context);
                _showToast("Профиль обновлен");
              }, 
              child: const Text("ОБНОВИТЬ")
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CarConfig.cardDark,
        title: const Text("Удалить авто?", style: TextStyle(color: Colors.white)),
        content: const Text("Это действие нельзя отменить.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ОТМЕНА")),
          TextButton(onPressed: () {
            setState(() => myGarage.removeAt(index));
            Navigator.pop(context);
            _showToast("Автомобиль удален");
          }, child: const Text("УДАЛИТЬ", style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }

  // --- ИНТЕРФЕЙС ---
  Widget _buildNeonFab() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: CarConfig.accentBlue.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
      ),
      child: FloatingActionButton(
        backgroundColor: CarConfig.accentBlue,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
        onPressed: () => _showAddCarSheet(context),
      ),
    );
  }

  Widget _buildBottomNavbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 0, 25, 25),
      height: 75,
      decoration: BoxDecoration(
        color: CarConfig.cardDark.withOpacity(0.95), 
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.directions_car_rounded, 0),
          _navItem(Icons.shopping_bag_rounded, 1),
          _navItem(Icons.person_rounded, 2),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(icon, color: isSelected ? CarConfig.accentBlue : Colors.white24, size: 32),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), child: Container(color: Colors.transparent))),
      title: const Text('CARCARE', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
      centerTitle: true,
    );
  }

  Widget _buildSideDrawer() {
    return Drawer(
      backgroundColor: CarConfig.primaryDark,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: CarConfig.cardDark),
            accountName: Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(_userEmail),
            currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(_profilePic)),
          ),
          _drawerItem(Icons.map_outlined, "Карта СТО (2ГИС)", () => _launchURL("https://2gis.kz/karaganda/search/СТО")),
          _drawerItem(Icons.history_edu_rounded, "История обслуживания", () {
            Navigator.pop(context);
            _showMaintenanceHistory();
          }),
          _drawerItem(Icons.analytics_outlined, "Аналитика расходов", () {
            Navigator.pop(context);
            if(myGarage.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsScreen(car: myGarage[0])));
            }
          }),
          const Spacer(),
_drawerItem(Icons.logout, "Выход", () {
  // Очищаем историю навигации и возвращаемся на экран входа
  Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
}, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, {Color color = Colors.white}) {
    return ListTile(leading: Icon(icon, color: color), title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)), onTap: onTap);
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, backgroundColor: CarConfig.accentBlue));
  }

  Widget _buildQuickActionBtn(String title, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 15),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}