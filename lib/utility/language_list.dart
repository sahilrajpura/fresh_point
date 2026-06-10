import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    //English
    'en_US': {
      // Common
      'login': 'Login',
      'register': 'Register',
      'mobile_number': 'Mobile number',
      'password': 'Password',
      'enter_mobile': 'Enter mobile number',
      'enter_password': 'Enter password',
      'gujarati': 'Gujarati',
      'english': 'English',

      // Register
      'name': 'Name',
      'area': 'Area',
      'village': 'Village',
      'address': 'Address',
      'enter_name': 'Enter your name',
      'select_area': 'Select area',
      'select_village': 'Select Village',
      'enter_address': 'Enter your full address',
      'already_account': ' Already have an account?',

      // Drop Down
      'gadha': 'Gadha',
      'vaktapur': 'Vaktapur',
      'ilol': 'Ilol',
      'kanai': 'Kanai',
      'himmatnagar': 'Himmatnagar',
      'virpur': 'Virpur',
      'golden_vas': 'Golden Vas',
      'talav': 'Talav',
      'pahadiya': 'Pahadiya',
      'darbar_ghadh': 'Darbar Ghadh',

      // Login
      'no_account': 'Don’t have an account?',
      'register_now': 'Register now',

      // Validation
      'mobile_required': 'Mobile number is required',
      'mobile_invalid': 'Enter valid mobile number',
      'password_required': 'Password is required',
      'password_length': 'Password must be at least 6 characters',
      'name_required': 'Name is required',
      'name_length': 'Name must be at least 3 characters',
      'enter_full_address': 'Enter your full address',
      'address_min_length': 'Address must be at least 10 characters',

      // Home
      'greeting': 'Hello',
      'search_hint': 'Write fruits or vegetables name...',
      'next_delivery_date': 'Next delivery date for your area:',
      'fresh_vegetables': 'Fresh vegetables',
      'fresh_fruits': 'Fresh fruits',
      'view_all': 'View all',
      'home': 'Home',

      // Product List
      'products': 'Products',
      'search_products': 'Write fruits or vegetables name...',
      'vegetables': 'Vegetables',
      'fruits': 'Fruits',
      'dry_fruits': 'Dry fruits',
      'all': 'All',

      // Product Detail
      'product_detail': 'Product detail',
      'add_to_cart': 'Add to cart',

      // Cart
      'your_cart': 'Your cart',
      'cart': 'Cart',
      'bill_details': 'Bill details',
      'proceed_order': 'Proceed to order',
      'my_order': 'My order',
      'product_price': 'Product price',
      'delivery_charge': 'Delivery charge',
      'total_amount': 'Total amount',

      // profile
      'profile': 'Profile',
      'facilities': 'Facilities',
      'all_orders': 'All orders',
      'contact_admin': 'Contact admin',
      'policies': 'Policies',
      'share_app': 'Share application',
      'change_language': 'Change language',

      // Order Detail
      'order': 'Order',
      'order_details': 'Order details',
      'order_id': 'Order ID',
      'current_price': 'Current price:',
      'adjust_weight': 'Adjusted weight:',
      'adjust_price': 'Adjusted price:',
      'shipping_tracking': 'Shipping tracking',
      'order_placed': 'Order placed',
      'order_placed_desc': 'Your order has been placed.',
      'order_confirmed': 'Order confirmed',
      'Total': 'Total :',
      'order_confirmed_desc': 'Order confirmed with price.',
      'order_delivered': 'Order delivered',
      'order_delivered_desc': 'Your order has been delivered.',

      // Admin Contact
      'contact_us': 'Contact us',
      'mobile_number_label': 'Mobile number:',
      'address_label': 'Address:',
    },

    //Gujrati
    'gu_IN': {
      // Common
      'login': 'લોગિન કરો',
      'register': 'રજીસ્ટર કરો',
      'mobile_number': 'મોબાઇલ નંબર',
      'password': 'પાસવર્ડ',
      'enter_mobile': 'મોબાઇલ નંબર લખો',
      'enter_password': 'પાસવર્ડ દાખલ કરો',
      'gujarati': 'ગુજરાતી',
      'english': 'અંગ્રેજી',

      // Register
      'name': 'નામ',
      'area': 'વિસ્તાર',
      'village': 'ગામ',
      'address': 'સરનામું',
      'enter_name': 'તમારું નામ લખો',
      'select_area': 'વિસ્તાર પસંદ કરો',
      'select_village': 'ગામ પસંદ કરો',
      'enter_address': 'તમારું સંપૂર્ણ સરનામું લખો',
      'already_account': 'પહેલાથી એકાઉન્ટ છે?',

      // Drop Down
      'gadha': 'ગઢા',
      'vaktapur': 'વક્તાપુર',
      'ilol': 'ઇલોલ',
      'kanai': 'કણાઈ',
      'himmatnagar': 'હિંમતનગર',
      'virpur': 'વિરપુર',
      'golden_vas': 'ગોલ્ડન વસ',
      'talav': 'તલાવ',
      'pahadiya': 'પહાડિયા',
      'darbar_ghadh': 'દરબાર ગઢ',

      // Login
      'no_account': 'એકાઉન્ટ નથી?',
      'register_now': 'રજીસ્ટર કરવા માટે અહીં ક્લિક કરો',

      // Validation
      'mobile_required': 'મોબાઇલ નંબર જરૂરી છે',
      'mobile_invalid': 'માન્ય મોબાઇલ નંબર દાખલ કરો',
      'password_required': 'પાસવર્ડ જરૂરી છે',
      'password_length': 'પાસવર્ડ ઓછામાં ઓછો 6 અક્ષરનો હોવો જોઈએ',
      'name_required': 'નામ જરૂરી છે',
      'name_length': 'નામ ઓછામાં ઓછું 3 અક્ષરનું હોવું જોઈએ',
      'enter_full_address': 'તમારું સંપૂર્ણ સરનામું લખો',
      'address_min_length': 'સરનામું ઓછામાં ઓછું 10 અક્ષરનું હોવું જોઈએ',

      // Home
      'greeting': 'નમસ્તે',
      'search_hint': 'ફળો અથવા શાકભાજીના નામ લખો...',
      'next_delivery_date': 'તમારા વિસ્તાર માટેની આગામી ડિલિવરી તારીખ :',
      'fresh_vegetables': 'તાજા શાકભાજી',
      'fresh_fruits': 'તાજા ફળો',
      'view_all': 'બધા બતાવો',
      'home': 'હોમ',

      // Product List
      'products': 'પ્રોડક્ટ્સ',
      'search_products': 'ફળો અથવા શાકભાજીનો નામ લખો...',
      'vegetables': 'શાકભાજી',
      'fruits': 'ફળો',
      'dry_fruits': 'ડ્રાય ફ્રૂટ',
      'all': 'બધા',

      // Product Detail
      'product_detail': 'પ્રોડક્ટ વિગત',
      'add_to_cart': 'કાર્ટમાં ઉમેરો',

      // Cart
      'your_cart': 'તમારું કાર્ટ',
      'cart': 'કાર્ટ',
      'bill_details': 'બિલનો હિસાબ',
      'proceed_order': 'ઓર્ડર માટે આગળ વધો',
      'my_order': 'મારો ઓર્ડર',
      'product_price': 'પ્રોડક્ટની કિંમત',
      'delivery_charge': 'ડિલિવરી ચાર્જ',
      'total_amount': 'કુલ રકમ',

      // profile
      'profile': 'પ્રોફાઇલ',
      'facilities': 'સુવિધાઓ',
      'all_orders': 'બધા ઓર્ડર્સ',
      'contact_admin': 'એડમિન સાથે સંપર્ક કરો',
      'policies': 'પોલિસીસ',
      'share_app': 'એપ્લિકેશન શેર કરો',
      'change_language': 'ભાષા બદલો',

      // Order Detail
      'order': 'ઓર્ડર',
      'order_details': 'ઓર્ડર વિગતો',
      'order_id': 'ઓર્ડર આઈડી',
      'current_price': 'હાલ કિંમત :',
      'adjust_weight': 'એડજસ્ટ વજન :',
      'adjust_price': 'એડજસ્ટ કિંમત :',
      'shipping_tracking': 'શિપિંગ ટ્રેકિંગ',
      'order_placed': 'ઓર્ડર મૂકવામાં આવ્યો',
      'order_placed_desc': 'તમારું ઓર્ડર મૂકવામાં આવ્યું છે.',
      'Total': 'કુલ :',
      'order_confirmed': 'ઓર્ડર પુષ્ટિ કરવામાં આવ્યો',
      'order_confirmed_desc': 'કિંમત સાથેનો ઓર્ડર પુષ્ટિ કરવામાં આવ્યો છે.',
      'order_delivered': 'ઓર્ડર પહોંચાડવામાં આવ્યો',
      'order_delivered_desc': 'તમારું ઓર્ડર પહોંચાડવામાં આવ્યું છે.',

      // Admin Contact
      'contact_us': 'અમારો સંપર્ક',
      'mobile_number_label': 'મોબાઈલ નંબર :',
      'address_label': 'સરનામું:',
    },
  };
}
