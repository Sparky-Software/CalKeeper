import 'package:calcard_app/models/tester.dart';
import 'package:calcard_app/pages/test_creation/widgets/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/services/tester_service.dart';
import 'package:calcard_app/widgets/custom_text_form_field.dart';

class TesterDetailsPage extends StatefulWidget {
  const TesterDetailsPage({super.key});

  @override
  State<TesterDetailsPage> createState() => _TesterDetailsPageState();
}

class _TesterDetailsPageState extends State<TesterDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _companyNameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _niceicNumberController;
  late TextEditingController _calcardSerialNumberController;
  bool warningShown = false;

  bool get isEditing {
    final testerService = Provider.of<TesterService>(context, listen: false);
    return testerService.getActiveTester() != null;
  }

  @override
  void initState() {
    super.initState();
    TesterService testerService = Provider.of<TesterService>(context, listen: false);
    Tester? activeTester = testerService.getActiveTester();

    _nameController = TextEditingController(text: activeTester?.name ?? '');
    _companyNameController = TextEditingController(text: activeTester?.companyName ?? '');
    _addressController = TextEditingController(text: activeTester?.address ?? '');
    _emailController = TextEditingController(text: activeTester?.email ?? '');
    _phoneController = TextEditingController(text: activeTester?.phone ?? '');
    _niceicNumberController = TextEditingController(text: activeTester?.NICEICNumber ?? '');
    _calcardSerialNumberController = TextEditingController(text: activeTester?.calcardSerialNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _niceicNumberController.dispose();
    _calcardSerialNumberController.dispose();
    super.dispose();
  }

  void _saveTester() {
    final address = _addressController.text;

    if (address.split('\n').length <= 1 && address != ""&&!warningShown) {
      _showAddressWarningDialog();
      warningShown = true;
    } else {
      if (_formKey.currentState?.validate() ?? false) {
        final testService = Provider.of<TestService>(context, listen: false);
        final testerService = Provider.of<TesterService>(context, listen: false);

        final tester = Tester(
          name: _nameController.text,
          companyName: _companyNameController.text,
          address: address,
          email: _emailController.text,
          phone: _phoneController.text,
          NICEICNumber: _niceicNumberController.text,
          calcardSerialNumber: _calcardSerialNumberController.text,
        );

        if (isEditing) {
          testerService.deleteTester(testerService.getActiveTester()!.id);
          Navigator.pop(context);
        } else {
          if (testerService.testers.isEmpty) {
            Navigator.pushNamed(context, '/home');
          } else {
            Navigator.pushNamed(context, '/selectTesterPage');
          }
        }
        testerService.inTestCreation = false;
        testService.updateTester(testService.getActiveTest()!, tester);
        testerService.addTester(tester);
        testerService.clearActiveTester();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Test Engineer Details' : 'Enter Test Engineer details'),
        actions: [
          if (isEditing&&Provider.of<TesterService>(context, listen: false).inTestCreation)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final testerService = Provider.of<TesterService>(context, listen: false);
                testerService.deleteTester(testerService.getActiveTester()!.id);
                testerService.inTestCreation = false;
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomTextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '*Name of Engineer'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                textCapitalization: TextCapitalization.words,
              ),
              CustomTextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                multiLine: true,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
              ),
              CustomTextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              CustomTextFormField(
                controller: _niceicNumberController,
                decoration: const InputDecoration(labelText: 'NICEIC Number'),
              ),
              CustomTextFormField(
                controller: _calcardSerialNumberController,
                decoration: const InputDecoration(labelText: 'CalCard Serial Number'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTester,
                child: Text(isEditing ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showAddressWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          onProceed: _saveTester,
        );
      },
    );
  }

}
