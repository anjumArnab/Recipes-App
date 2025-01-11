import 'dart:io';
import 'package:company_app/utils/image_pick.dart';
import 'package:flutter/material.dart';

class CreateCompany extends StatefulWidget {
  final String? name;
  final String? address;
  final String? phone;
  final bool isEditing;

  const CreateCompany({
    super.key,
    this.name,
    this.address,
    this.phone,
    this.isEditing = false,
  });

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.isEditing ? "Update Company Information" : "Add Company Information",
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Show dialog for choosing camera or gallery
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Select Image"),
                          content: const Text("Choose an option to upload your image."),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                // Close the dialog first
                                Navigator.pop(context);

                                // Create an instance of ImagePickerHelper
                                final imageHelper = ImagePickerHelper();

                                // Capture image from camera
                                await imageHelper.captureImageFromCamera(context);
                                setState(() {
                                  _selectedImage = imageHelper.selectedImage; // Update the image
                                });
                              },
                              child: const Text("Camera"),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Close the dialog first
                                Navigator.pop(context);

                                // Create an instance of ImagePickerHelper
                                final imageHelper = ImagePickerHelper();

                                // Pick image from gallery
                                await imageHelper.pickImageFromGallery(context);
                                setState(() {
                                  _selectedImage = imageHelper.selectedImage; // Update the image
                                });
                              },
                              child: const Text("Gallery"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog without action
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.blueAccent.withOpacity(0.2),
                          width: 75,
                          height: 75,
                          child: _selectedImage == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.blue,
                                )
                              : Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: 75,
                                  height: 75,
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter company name";
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Enter the company name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    hintText: "Enter the company address",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter the company phone number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        // Handle form submission
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(widget.isEditing ? "Update Information" : "Create Company"),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      // Handle saving to database
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade300,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Save To Database"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
