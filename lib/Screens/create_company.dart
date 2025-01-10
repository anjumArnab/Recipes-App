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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.isEditing ? "Update Company Information" : "Add Company Information"),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle upload action here
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.blueAccent.withOpacity(0.2), // Background color
                          width: 75, // Width of the oval
                          height: 75, // Height of the oval
                          child: const Icon(
                            Icons.camera_alt, // Camera icon
                            size: 30,
                            color: Colors.blue, // Icon color
                          ),
                        ),
                      ),
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
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter the company name",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: "Address",
                      hintText: "Enter the company address",
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Enter the company phone number",
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade300, // Button background color
                      foregroundColor: Colors.white, // Text color
                      fixedSize: const Size(200, 50), // Fixed size for width and height
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: Text(widget.isEditing ?  "Update Information" : "Create Company"),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade300, // Button background color
                      foregroundColor: Colors.white, // Text color
                      fixedSize: const Size(200, 50), // Same size as the first button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: const Text("Save To Database"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
