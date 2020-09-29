class Constants {
  static final base_url = "https://bybrisk.com/apiV1/";
  final String login = base_url + "admin_module/config/login.php";
  final String counts = base_url + "admin_module/read/counts.php";

  //  =-------------- FETCH OVERVIEW DETAILS-----------------
  final String pendingOverview =
      base_url + "admin_module/read/pendingDeliveryWithArea.php";
  final String pickedOverview =
      base_url + "admin_module/read/pickedDeliveriesWithArea.php";
  final String shippingOverview =
      base_url + "admin_module/read/shippingDeliveriesWithArea.php";
  final String outfrodeliveryoverview =
      base_url + "admin_module/read/outfordeliverWithArea.php";
  final String deliveredOverview =
      base_url + "admin_module/read/deliveredDeliveriesWithArea.php";

  //-----------FETCH DELIVERIES---------------------------------
  final String pendingDeliveries = base_url + "admin_module/read/pending.php";
  final String pickedDeliveries = base_url + "admin_module/read/picked.php";
  final String shippingDeliveries = base_url + "admin_module/read/shipping.php";
  final String outfordelivery =
      base_url + "admin_module/read/outForDelivery.php";
  final String deliveredDeliveries =
      base_url + "admin_module/read/delivered.php";

  //--------------UPDATE DELIVERIES OPERATIONS------------------
  final String pickedTpShipping =
      base_url + "admin_module/update/deliveryForShipping.php";
  final String makeOutforDeliver =
      base_url + "admin_module/update/makeReadyForDelivered.php";

  //------------PINCODE MANAGEMENT APIS-----------------------
  final String fetchPincodes=base_url+"admin_module/read/pincodes.php";
  final String addPincode=base_url+"admin_module/add/addPincode.php";

  // -----------EMPLOYEE MANAGEMENT CONSOLE----------------------
  final String fetchEmployee = base_url + "admin_module/read/employee.php";
  final String acceptEmployee = base_url + "admin_module/update/changeEmployeeStatus.php";
//
  final String rejectEmployee = base_url + "admin_module/delete/deliveryBoyDelete.php";
  final String updatePincodeEmployee = base_url + "admin_module/add/insertPincodeToDeliveryBoys.php";

}
