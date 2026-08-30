import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../data/wasiyyah_repository.dart';
import '../models/wasiyyah_model.dart';

class WasiyyahScreen extends ConsumerStatefulWidget {
  const WasiyyahScreen({super.key});

  @override
  ConsumerState<WasiyyahScreen> createState() => _WasiyyahScreenState();
}

class _WasiyyahScreenState extends ConsumerState<WasiyyahScreen> {
  final _repo = WasiyyahRepository();
  bool _isLoading = true;

  late TextEditingController _nameController;
  late TextEditingController _testimonyController;
  late TextEditingController _prayersController;
  late TextEditingController _fastsController;
  late TextEditingController _khumsController;
  late TextEditingController _debtsController;
  late TextEditingController _thirdEstateController;
  late TextEditingController _adviceController;
  late TextEditingController _executorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _testimonyController = TextEditingController();
    _prayersController = TextEditingController();
    _fastsController = TextEditingController();
    _khumsController = TextEditingController();
    _debtsController = TextEditingController();
    _thirdEstateController = TextEditingController();
    _adviceController = TextEditingController();
    _executorController = TextEditingController();
    _loadWasiyyah();
  }

  Future<void> _loadWasiyyah() async {
    final w = await _repo.getWasiyyah();
    setState(() {
      _nameController.text = w.fullName;
      _testimonyController.text = w.spiritualTestimony;
      _prayersController.text = '${w.prayersToMakeUp}';
      _fastsController.text = '${w.fastsToMakeUp}';
      _khumsController.text = w.khumsZakatStatus;
      _debtsController.text = w.financialDebtsAndCredits;
      _thirdEstateController.text = w.thirdOfEstateInstructions;
      _adviceController.text = w.ethicalAdviceToHeirs;
      _executorController.text = w.executorName;
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    final w = IslamicWasiyyah(
      fullName: _nameController.text.trim(),
      spiritualTestimony: _testimonyController.text.trim(),
      prayersToMakeUp: int.tryParse(_prayersController.text.trim()) ?? 0,
      fastsToMakeUp: int.tryParse(_fastsController.text.trim()) ?? 0,
      khumsZakatStatus: _khumsController.text.trim(),
      financialDebtsAndCredits: _debtsController.text.trim(),
      thirdOfEstateInstructions: _thirdEstateController.text.trim(),
      ethicalAdviceToHeirs: _adviceController.text.trim(),
      executorName: _executorController.text.trim(),
      lastUpdated: DateTime.now(),
    );

    await _repo.saveWasiyyah(w);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('وصیت‌نامه با موفقیت ذخیره شد')),
      );
    }
  }

  void _copyFormattedText(bool isPersian) {
    final w = IslamicWasiyyah(
      fullName: _nameController.text.trim(),
      spiritualTestimony: _testimonyController.text.trim(),
      prayersToMakeUp: int.tryParse(_prayersController.text.trim()) ?? 0,
      fastsToMakeUp: int.tryParse(_fastsController.text.trim()) ?? 0,
      khumsZakatStatus: _khumsController.text.trim(),
      financialDebtsAndCredits: _debtsController.text.trim(),
      thirdOfEstateInstructions: _thirdEstateController.text.trim(),
      ethicalAdviceToHeirs: _adviceController.text.trim(),
      executorName: _executorController.text.trim(),
      lastUpdated: DateTime.now(),
    );

    final text = _repo.formatAsText(w, isPersian: isPersian);
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('متن وصیت‌نامه در حافظه کپی شد')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _testimonyController.dispose();
    _prayersController.dispose();
    _fastsController.dispose();
    _khumsController.dispose();
    _debtsController.dispose();
    _thirdEstateController.dispose();
    _adviceController.dispose();
    _executorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'تنظیم وصیت‌نامه شرعی و معنوی' : 'Islamic Will & Testament'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: isPersian ? 'کپی متن وصیت‌نامه' : 'Copy Text',
            onPressed: () => _copyFormattedText(isPersian),
          ),
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: isPersian ? 'ذخیره' : 'Save',
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Intro Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.history_edu_rounded, size: 28, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isPersian
                          ? '«ما یَنبَغِی لِامْرِئٍ مُسلِمٍ أن یَبِیتَ لَیلَةً إلّا وَ وَصِیَّتُهُ تَحتَ رَأسِهِ» (پیامبر اکرم ص)'
                          : 'Fulfill the Sunnah of maintaining a prepared spiritual and legal Islamic testament.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Personal & Executor Details
          _buildSectionHeader(isPersian ? '۱. مشخصات و وصی منتخب' : '1. Personal & Executor Details'),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: isPersian ? 'نام و نام خانوادگی موصی' : 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _executorController,
            decoration: InputDecoration(
              labelText: isPersian ? 'نام وصی (مجری وصیت‌نامه)' : 'Executor Name (Wasi)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Spiritual Testimony
          _buildSectionHeader(isPersian ? '۲. اقرار به شهادتین و عقاید حقه' : '2. Spiritual Testimony of Faith'),
          TextField(
            controller: _testimonyController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: isPersian ? 'متن اقرار به توحید، نبوت و ولایت...' : 'Statement of Creed...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Religious Obligations (Prayers & Fasts)
          _buildSectionHeader(isPersian ? '۳. نماز و روزه قضا' : '3. Missed Prayers & Fasts'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _prayersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: isPersian ? 'مدت نماز قضا (روز/ماه)' : 'Missed Prayers',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _fastsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: isPersian ? 'تعداد روزه قضا (روز)' : 'Missed Fasts (Days)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Financial Bequests & Khums
          _buildSectionHeader(isPersian ? '۴. حقوق شرعی و دیون مالی' : '4. Religious Dues & Debts'),
          TextField(
            controller: _khumsController,
            decoration: InputDecoration(
              labelText: isPersian ? 'وضعیت خمس، زکات و رد مظالم' : 'Khums / Zakat Status',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _debtsController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: isPersian ? 'بدهی‌ها، مطالبات و امانات نزد دیگران' : 'Debts & Trusts',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),

          // 5. 1/3 of Wealth Instructions
          _buildSectionHeader(isPersian ? '۵. وصیت در مورد ثلث مال' : '5. One-Third Estate Bequest (Thuluth)'),
          TextField(
            controller: _thirdEstateController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: isPersian ? 'دستورات مربوط به ثلث مال در امور خیریه...' : 'Instructions for 1/3 estate...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),

          // 6. Ethical Advice to Heirs
          _buildSectionHeader(isPersian ? '۶. سفارش‌های اخلاقی و معنوی به بازماندگان' : '6. Ethical Advice to Heirs'),
          TextField(
            controller: _adviceController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: isPersian ? 'توصیه به تقوا، نماز، صله رحم و...' : 'Advice on piety, prayer, kinship...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(isPersian ? 'ذخیره و ثبت وصیت‌نامه' : 'Save & Register Wasiyyah'),
            onPressed: _save,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
