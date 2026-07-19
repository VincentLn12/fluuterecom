import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/recipe_controller.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({super.key, this.recipe});

  final Recipe? recipe;

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _prepTimeController = TextEditingController(text: '10');
  final _cookTimeController = TextEditingController(text: '10');
  final _servingsController = TextEditingController(text: '2');
  final _ratingController = TextEditingController(text: '4.5');
  final List<_IngredientInput> _ingredients = [];
  final List<TextEditingController> _stepControllers = [];
  int? _categoryId;
  String _difficulty = AppConstants.difficulties.first;
  bool _isSaving = false;

  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;
    if (recipe != null) {
      _nameController.text = recipe.name;
      _descriptionController.text = recipe.description;
      _imageUrlController.text = recipe.imageUrl;
      _prepTimeController.text = recipe.prepTime.toString();
      _cookTimeController.text = recipe.cookTime.toString();
      _servingsController.text = recipe.servings.toString();
      _ratingController.text = recipe.rating.toString();
      _categoryId = recipe.categoryId;
      _difficulty = recipe.difficulty;
      _ingredients.addAll(recipe.ingredients.map(_IngredientInput.fromIngredient));
      _stepControllers.addAll(recipe.steps.map((step) => TextEditingController(text: step)));
    } else {
      _ingredients.add(_IngredientInput.empty());
      _stepControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _ratingController.dispose();
    for (final item in _ingredients) {
      item.dispose();
    }
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeController = Get.find<RecipeController>();
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'แก้ไขสูตรอาหาร' : 'เพิ่มสูตรอาหาร')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อเมนู'),
                validator: (value) => Validators.requiredText(value, 'ชื่อเมนู'),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'คำอธิบาย'),
                maxLines: 3,
                validator: (value) => Validators.requiredText(value, 'คำอธิบาย'),
              ),
              SizedBox(height: 12.h),
              Obx(
                () => DropdownButtonFormField<int>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'หมวดหมู่'),
                  items: recipeController.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                  validator: (value) => value == null ? 'หมวดหมู่ห้ามว่าง' : null,
                ),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL รูปภาพ'),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prepTimeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'เวลาเตรียม'),
                      validator: (value) => Validators.zeroOrPositiveInt(value, 'เวลาเตรียม'),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      controller: _cookTimeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'เวลาปรุง'),
                      validator: (value) => Validators.zeroOrPositiveInt(value, 'เวลาปรุง'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _servingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'จำนวนเสิร์ฟ'),
                      validator: (value) => Validators.positiveInt(value, 'จำนวนเสิร์ฟ'),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'คะแนน'),
                      validator: Validators.rating,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                initialValue: _difficulty,
                decoration: const InputDecoration(labelText: 'ระดับความยาก'),
                items: AppConstants.difficulties
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) => setState(() => _difficulty = value ?? _difficulty),
              ),
              SizedBox(height: 18.h),
              _DynamicHeader(
                title: 'วัตถุดิบ',
                onAdd: () => setState(() => _ingredients.add(_IngredientInput.empty())),
              ),
              ..._ingredients.indexed.map(
                (entry) => _IngredientFields(
                  input: entry.$2,
                  onDelete: _ingredients.length > 1
                      ? () => setState(() {
                            final removed = _ingredients.removeAt(entry.$1);
                            removed.dispose();
                          })
                      : null,
                ),
              ),
              SizedBox(height: 18.h),
              _DynamicHeader(
                title: 'ขั้นตอนการทำ',
                onAdd: () => setState(() => _stepControllers.add(TextEditingController())),
              ),
              ..._stepControllers.indexed.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.$2,
                          decoration: InputDecoration(labelText: 'ขั้นตอนที่ ${entry.$1 + 1}'),
                          validator: (value) => Validators.requiredText(value, 'ขั้นตอน'),
                        ),
                      ),
                      IconButton(
                        onPressed: _stepControllers.length > 1
                            ? () => setState(() {
                                  final removed = _stepControllers.removeAt(entry.$1);
                                  removed.dispose();
                                })
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'บันทึกการแก้ไข' : 'เพิ่มสูตรอาหาร'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final ingredients = _ingredients.map((item) => item.toIngredient()).toList();
    final steps = _stepControllers.map((item) => item.text.trim()).toList();
    if (ingredients.isEmpty || steps.isEmpty) {
      Get.snackbar('ข้อมูลไม่ครบ', 'ต้องมีวัตถุดิบและขั้นตอนอย่างน้อย 1 รายการ');
      return;
    }
    final recipeController = Get.find<RecipeController>();
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    if (currentUser == null) {
      Get.snackbar('กรุณาเข้าสู่ระบบ', 'ต้องเข้าสู่ระบบก่อนเพิ่มสูตรอาหาร');
      return;
    }
    final category = recipeController.categoryById(_categoryId);
    final recipe = Recipe(
      id: widget.recipe?.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      categoryId: _categoryId!,
      categoryName: category?.name ?? '',
      imageUrl: _imageUrlController.text.trim(),
      prepTime: int.parse(_prepTimeController.text),
      cookTime: int.parse(_cookTimeController.text),
      servings: int.parse(_servingsController.text),
      difficulty: _difficulty,
      rating: double.parse(_ratingController.text),
      isFavorite: widget.recipe?.isFavorite ?? false,
      ownerId: widget.recipe?.ownerId ?? currentUser.id ?? currentUser.email,
      ownerName: widget.recipe?.ownerName ?? currentUser.name,
      ingredients: ingredients,
      steps: steps,
    );
    setState(() => _isSaving = true);
    try {
      if (_isEditing) {
        await recipeController.updateRecipe(recipe);
      } else {
        await recipeController.addRecipe(recipe);
      }
      Get.snackbar('สำเร็จ', _isEditing ? 'แก้ไขสูตรอาหารแล้ว' : 'เพิ่มสูตรอาหารแล้ว');
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _DynamicHeader extends StatelessWidget {
  const _DynamicHeader({required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('เพิ่ม'),
        ),
      ],
    );
  }
}

class _IngredientFields extends StatelessWidget {
  const _IngredientFields({required this.input, this.onDelete});

  final _IngredientInput input;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: input.nameController,
              decoration: const InputDecoration(labelText: 'ชื่อวัตถุดิบ'),
              validator: (value) => Validators.requiredText(value, 'วัตถุดิบ'),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: input.amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ปริมาณ'),
              validator: (value) {
                final number = double.tryParse(value ?? '');
                if (number == null || number <= 0) {
                  return 'ต้องมากกว่า 0';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: input.unitController,
              decoration: const InputDecoration(labelText: 'หน่วย'),
              validator: (value) => Validators.requiredText(value, 'หน่วย'),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    );
  }
}

class _IngredientInput {
  _IngredientInput({
    required this.nameController,
    required this.amountController,
    required this.unitController,
  });

  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController unitController;

  factory _IngredientInput.empty() {
    return _IngredientInput(
      nameController: TextEditingController(),
      amountController: TextEditingController(text: '1'),
      unitController: TextEditingController(),
    );
  }

  factory _IngredientInput.fromIngredient(Ingredient ingredient) {
    return _IngredientInput(
      nameController: TextEditingController(text: ingredient.name),
      amountController: TextEditingController(text: ingredient.amount.toString()),
      unitController: TextEditingController(text: ingredient.unit),
    );
  }

  Ingredient toIngredient() {
    return Ingredient(
      name: nameController.text.trim(),
      amount: double.parse(amountController.text),
      unit: unitController.text.trim(),
    );
  }

  void dispose() {
    nameController.dispose();
    amountController.dispose();
    unitController.dispose();
  }
}
