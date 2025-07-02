import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/models/country_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationBottomSheet extends StatefulWidget {
  @override
  _LocationBottomSheetState createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  List<Country> allCountries = [
    Country(name: "Afghanistan", code: "AF", emoji: "🇦🇫"),
    Country(name: "Albania", code: "AL", emoji: "🇦🇱"),
    Country(name: "Algeria", code: "DZ", emoji: "🇩🇿"),
    Country(name: "American Samoa", code: "AS", emoji: "🇦🇸"),
    Country(name: "Andorra", code: "AD", emoji: "🇦🇩"),
    Country(name: "Angola", code: "AO", emoji: "🇦🇴"),
    Country(name: "Anguilla", code: "AI", emoji: "🇦🇮"),
    Country(name: "Antarctica", code: "AQ", emoji: "🇦🇶"),
    Country(name: "Antigua & Barbuda", code: "AG", emoji: "🇦🇬"),
    Country(name: "Argentina", code: "AR", emoji: "🇦🇷"),
    Country(name: "Armenia", code: "AM", emoji: "🇦🇲"),
    Country(name: "Aruba", code: "AW", emoji: "🇦🇼"),
    Country(name: "Australia", code: "AU", emoji: "🇦🇺"),
    Country(name: "Austria", code: "AT", emoji: "🇦🇹"),
    Country(name: "Azerbaijan", code: "AZ", emoji: "🇦🇿"),
    Country(name: "Bahamas", code: "BS", emoji: "🇧🇸"),
    Country(name: "Bahrain", code: "BH", emoji: "🇧🇭"),
    Country(name: "Bangladesh", code: "BD", emoji: "🇧🇩"),
    Country(name: "Barbados", code: "BB", emoji: "🇧🇧"),
    Country(name: "Belarus", code: "BY", emoji: "🇧🇾"),
    Country(name: "Belgium", code: "BE", emoji: "🇧🇪"),
    Country(name: "Belize", code: "BZ", emoji: "🇧🇿"),
    Country(name: "Benin", code: "BJ", emoji: "🇧🇯"),
    Country(name: "Bermuda", code: "BM", emoji: "🇧🇲"),
    Country(name: "Bhutan", code: "BT", emoji: "🇧🇹"),
    Country(name: "Bolivia", code: "BO", emoji: "🇧🇴"),
    Country(name: "Bosnia & Herzegovina", code: "BA", emoji: "🇧🇦"),
    Country(name: "Botswana", code: "BW", emoji: "🇧🇼"),
    Country(name: "Bouvet Island", code: "BV", emoji: "🇧🇻"),
    Country(name: "Brazil", code: "BR", emoji: "🇧🇷"),
    Country(name: "British Indian Ocean Territory", code: "IO", emoji: "🇮🇴"),
    Country(name: "British Virgin Islands", code: "VG", emoji: "🇻🇬"),
    Country(name: "Brunei", code: "BN", emoji: "🇧🇳"),
    Country(name: "Bulgaria", code: "BG", emoji: "🇧🇬"),
    Country(name: "Burkina Faso", code: "BF", emoji: "🇧🇫"),
    Country(name: "Burundi", code: "BI", emoji: "🇧🇮"),
    Country(name: "Cambodia", code: "KH", emoji: "🇰🇭"),
    Country(name: "Cameroon", code: "CM", emoji: "🇨🇲"),
    Country(name: "Canada", code: "CA", emoji: "🇨🇦"),
    Country(name: "Cape Verde", code: "CV", emoji: "🇨🇻"),
    Country(name: "Caribbean Netherlands", code: "BQ", emoji: "🇧🇶"),
    Country(name: "Cayman Islands", code: "KY", emoji: "🇰🇾"),
    Country(name: "Central African Republic", code: "CF", emoji: "🇨🇫"),
    Country(name: "Chad", code: "TD", emoji: "🇹🇩"),
    Country(name: "Chile", code: "CL", emoji: "🇨🇱"),
    Country(name: "China", code: "CN", emoji: "🇨🇳"),
    Country(name: "Christmas Island", code: "CX", emoji: "🇨🇽"),
    Country(name: "Cocos (Keeling) Islands", code: "CC", emoji: "🇨🇨"),
    Country(name: "Colombia", code: "CO", emoji: "🇨🇴"),
    Country(name: "Comoros", code: "KM", emoji: "🇰🇲"),
    Country(name: "Congo - Brazzaville", code: "CG", emoji: "🇨🇬"),
    Country(name: "Congo - Kinshasa", code: "CD", emoji: "🇨🇩"),
    Country(name: "Cook Islands", code: "CK", emoji: "🇨🇰"),
    Country(name: "Costa Rica", code: "CR", emoji: "🇨🇷"),
    Country(name: "Croatia", code: "HR", emoji: "🇭🇷"),
    Country(name: "Cuba", code: "CU", emoji: "🇨🇺"),
    Country(name: "Curaçao", code: "CW", emoji: "🇨🇼"),
    Country(name: "Cyprus", code: "CY", emoji: "🇨🇾"),
    Country(name: "Czechia", code: "CZ", emoji: "🇨🇿"),
    Country(name: "Côte d’Ivoire", code: "CI", emoji: "🇨🇮"),
    Country(name: "Denmark", code: "DK", emoji: "🇩🇰"),
    Country(name: "Djibouti", code: "DJ", emoji: "🇩🇯"),
    Country(name: "Dominica", code: "DM", emoji: "🇩🇲"),
    Country(name: "Dominican Republic", code: "DO", emoji: "🇩🇴"),
    Country(name: "Ecuador", code: "EC", emoji: "🇪🇨"),
    Country(name: "Egypt", code: "EG", emoji: "🇪🇬"),
    Country(name: "El Salvador", code: "SV", emoji: "🇸🇻"),
    Country(name: "Equatorial Guinea", code: "GQ", emoji: "🇬🇶"),
    Country(name: "Eritrea", code: "ER", emoji: "🇪🇷"),
    Country(name: "Estonia", code: "EE", emoji: "🇪🇪"),
    Country(name: "Eswatini", code: "SZ", emoji: "🇸🇿"),
    Country(name: "Ethiopia", code: "ET", emoji: "🇪🇹"),
    Country(name: "Falkland Islands", code: "FK", emoji: "🇫🇰"),
    Country(name: "Faroe Islands", code: "FO", emoji: "🇫🇴"),
    Country(name: "Fiji", code: "FJ", emoji: "🇫🇯"),
    Country(name: "Finland", code: "FI", emoji: "🇫🇮"),
    Country(name: "France", code: "FR", emoji: "🇫🇷"),
    Country(name: "French Guiana", code: "GF", emoji: "🇬🇫"),
    Country(name: "French Polynesia", code: "PF", emoji: "🇵🇫"),
    Country(name: "French Southern Territories", code: "TF", emoji: "🇹🇫"),
    Country(name: "Gabon", code: "GA", emoji: "🇬🇦"),
    Country(name: "Gambia", code: "GM", emoji: "🇬🇲"),
    Country(name: "Georgia", code: "GE", emoji: "🇬🇪"),
    Country(name: "Germany", code: "DE", emoji: "🇩🇪"),
    Country(name: "Ghana", code: "GH", emoji: "🇬🇭"),
    Country(name: "Gibraltar", code: "GI", emoji: "🇬🇮"),
    Country(name: "Greece", code: "GR", emoji: "🇬🇷"),
    Country(name: "Greenland", code: "GL", emoji: "🇬🇱"),
    Country(name: "Grenada", code: "GD", emoji: "🇬🇩"),
    Country(name: "Guadeloupe", code: "GP", emoji: "🇬🇵"),
    Country(name: "Guam", code: "GU", emoji: "🇬🇺"),
    Country(name: "Guatemala", code: "GT", emoji: "🇬🇹"),
    Country(name: "Guernsey", code: "GG", emoji: "🇬🇬"),
    Country(name: "Guinea", code: "GN", emoji: "🇬🇳"),
    Country(name: "Guinea-Bissau", code: "GW", emoji: "🇬🇼"),
    Country(name: "Guyana", code: "GY", emoji: "🇬🇾"),
    Country(name: "Haiti", code: "HT", emoji: "🇭🇹"),
    Country(name: "Heard & McDonald Islands", code: "HM", emoji: "🇭🇲"),
    Country(name: "Honduras", code: "HN", emoji: "🇭🇳"),
    Country(name: "Hong Kong SAR China", code: "HK", emoji: "🇭🇰"),
    Country(name: "Hungary", code: "HU", emoji: "🇭🇺"),
    Country(name: "Iceland", code: "IS", emoji: "🇮🇸"),
    Country(name: "India", code: "IN", emoji: "🇮🇳"),
    Country(name: "Indonesia", code: "ID", emoji: "🇮🇩"),
    Country(name: "Iran", code: "IR", emoji: "🇮🇷"),
    Country(name: "Iraq", code: "IQ", emoji: "🇮🇶"),
    Country(name: "Ireland", code: "IE", emoji: "🇮🇪"),
    Country(name: "Isle of Man", code: "IM", emoji: "🇮🇲"),
    Country(name: "Israel", code: "IL", emoji: "🇮🇱"),
    Country(name: "Italy", code: "IT", emoji: "🇮🇹"),
    Country(name: "Jamaica", code: "JM", emoji: "🇯🇲"),
    Country(name: "Japan", code: "JP", emoji: "🇯🇵"),
    Country(name: "Jersey", code: "JE", emoji: "🇯🇪"),
    Country(name: "Jordan", code: "JO", emoji: "🇯🇴"),
    Country(name: "Kazakhstan", code: "KZ", emoji: "🇰🇿"),
    Country(name: "Kenya", code: "KE", emoji: "🇰🇪"),
    Country(name: "Kiribati", code: "KI", emoji: "🇰🇮"),
    Country(name: "Kuwait", code: "KW", emoji: "🇰🇼"),
    Country(name: "Kyrgyzstan", code: "KG", emoji: "🇰🇬"),
    Country(name: "Laos", code: "LA", emoji: "🇱🇦"),
    Country(name: "Latvia", code: "LV", emoji: "🇱🇻"),
    Country(name: "Lebanon", code: "LB", emoji: "🇱🇧"),
    Country(name: "Lesotho", code: "LS", emoji: "🇱🇸"),
    Country(name: "Liberia", code: "LR", emoji: "🇱🇷"),
    Country(name: "Libya", code: "LY", emoji: "🇱🇾"),
    Country(name: "Liechtenstein", code: "LI", emoji: "🇱🇮"),
    Country(name: "Lithuania", code: "LT", emoji: "🇱🇹"),
    Country(name: "Luxembourg", code: "LU", emoji: "🇱🇺"),
    Country(name: "Macao SAR China", code: "MO", emoji: "🇲🇴"),
    Country(name: "Madagascar", code: "MG", emoji: "🇲🇬"),
    Country(name: "Malawi", code: "MW", emoji: "🇲🇼"),
    Country(name: "Malaysia", code: "MY", emoji: "🇲🇾"),
    Country(name: "Maldives", code: "MV", emoji: "🇲🇻"),
    Country(name: "Mali", code: "ML", emoji: "🇲🇱"),
    Country(name: "Malta", code: "MT", emoji: "🇲🇹"),
    Country(name: "Marshall Islands", code: "MH", emoji: "🇲🇭"),
    Country(name: "Martinique", code: "MQ", emoji: "🇲🇶"),
    Country(name: "Mauritania", code: "MR", emoji: "🇲🇷"),
    Country(name: "Mauritius", code: "MU", emoji: "🇲🇺"),
    Country(name: "Mayotte", code: "YT", emoji: "🇾🇹"),
    Country(name: "Mexico", code: "MX", emoji: "🇲🇽"),
    Country(name: "Micronesia", code: "FM", emoji: "🇫🇲"),
    Country(name: "Moldova", code: "MD", emoji: "🇲🇩"),
    Country(name: "Monaco", code: "MC", emoji: "🇲🇨"),
    Country(name: "Mongolia", code: "MN", emoji: "🇲🇳"),
    Country(name: "Montenegro", code: "ME", emoji: "🇲🇪"),
    Country(name: "Montserrat", code: "MS", emoji: "🇲🇸"),
    Country(name: "Morocco", code: "MA", emoji: "🇲🇦"),
    Country(name: "Mozambique", code: "MZ", emoji: "🇲🇿"),
    Country(name: "Myanmar (Burma)", code: "MM", emoji: "🇲🇲"),
    Country(name: "Namibia", code: "NA", emoji: "🇳🇦"),
    Country(name: "Nauru", code: "NR", emoji: "🇳🇷"),
    Country(name: "Nepal", code: "NP", emoji: "🇳🇵"),
    Country(name: "Netherlands", code: "NL", emoji: "🇳🇱"),
    Country(name: "New Caledonia", code: "NC", emoji: "🇳🇨"),
    Country(name: "New Zealand", code: "NZ", emoji: "🇳🇿"),
    Country(name: "Nicaragua", code: "NI", emoji: "🇳🇮"),
    Country(name: "Niger", code: "NE", emoji: "🇳🇪"),
    Country(name: "Nigeria", code: "NG", emoji: "🇳🇬"),
    Country(name: "Niue", code: "NU", emoji: "🇳🇺"),
    Country(name: "Norfolk Island", code: "NF", emoji: "🇳🇫"),
    Country(name: "North Korea", code: "KP", emoji: "🇰🇵"),
    Country(name: "North Macedonia", code: "MK", emoji: "🇲🇰"),
    Country(name: "Northern Mariana Islands", code: "MP", emoji: "🇲🇵"),
    Country(name: "Norway", code: "NO", emoji: "🇳🇴"),
    Country(name: "Oman", code: "OM", emoji: "🇴🇲"),
    Country(name: "Pakistan", code: "PK", emoji: "🇵🇰"),
    Country(name: "Palau", code: "PW", emoji: "🇵🇼"),
    Country(name: "Palestinian Territories", code: "PS", emoji: "🇵🇸"),
    Country(name: "Panama", code: "PA", emoji: "🇵🇦"),
    Country(name: "Papua New Guinea", code: "PG", emoji: "🇵🇬"),
    Country(name: "Paraguay", code: "PY", emoji: "🇵🇾"),
    Country(name: "Peru", code: "PE", emoji: "🇵🇪"),
    Country(name: "Philippines", code: "PH", emoji: "🇵🇭"),
    Country(name: "Pitcairn Islands", code: "PN", emoji: "🇵🇳"),
    Country(name: "Poland", code: "PL", emoji: "🇵🇱"),
    Country(name: "Portugal", code: "PT", emoji: "🇵🇹"),
    Country(name: "Puerto Rico", code: "PR", emoji: "🇵🇷"),
    Country(name: "Qatar", code: "QA", emoji: "🇶🇦"),
    Country(name: "Romania", code: "RO", emoji: "🇷🇴"),
    Country(name: "Russia", code: "RU", emoji: "🇷🇺"),
    Country(name: "Rwanda", code: "RW", emoji: "🇷🇼"),
    Country(name: "Réunion", code: "RE", emoji: "🇷🇪"),
    Country(name: "Samoa", code: "WS", emoji: "🇼🇸"),
    Country(name: "San Marino", code: "SM", emoji: "🇸🇲"),
    Country(name: "Saudi Arabia", code: "SA", emoji: "🇸🇦"),
    Country(name: "Senegal", code: "SN", emoji: "🇸🇳"),
    Country(name: "Serbia", code: "RS", emoji: "🇷🇸"),
    Country(name: "Seychelles", code: "SC", emoji: "🇸🇨"),
    Country(name: "Sierra Leone", code: "SL", emoji: "🇸🇱"),
    Country(name: "Singapore", code: "SG", emoji: "🇸🇬"),
    Country(name: "Sint Maarten", code: "SX", emoji: "🇸🇽"),
    Country(name: "Slovakia", code: "SK", emoji: "🇸🇰"),
    Country(name: "Slovenia", code: "SI", emoji: "🇸🇮"),
    Country(name: "Solomon Islands", code: "SB", emoji: "🇸🇧"),
    Country(name: "Somalia", code: "SO", emoji: "🇸🇴"),
    Country(name: "South Africa", code: "ZA", emoji: "🇿🇦"),
    Country(name: "South Georgia & South Sandwich Islands", code: "GS", emoji: "🇬🇸"),
    Country(name: "South Korea", code: "KR", emoji: "🇰🇷"),
    Country(name: "South Sudan", code: "SS", emoji: "🇸🇸"),
    Country(name: "Spain", code: "ES", emoji: "🇪🇸"),
    Country(name: "Sri Lanka", code: "LK", emoji: "🇱🇰"),
    Country(name: "St. Barthélemy", code: "BL", emoji: "🇧🇱"),
    Country(name: "St. Helena", code: "SH", emoji: "🇸🇭"),
    Country(name: "St. Kitts & Nevis", code: "KN", emoji: "🇰🇳"),
    Country(name: "St. Lucia", code: "LC", emoji: "🇱🇨"),
    Country(name: "St. Martin", code: "MF", emoji: "🇲🇫"),
    Country(name: "St. Pierre & Miquelon", code: "PM", emoji: "🇵🇲"),
    Country(name: "St. Vincent & Grenadines", code: "VC", emoji: "🇻🇨"),
    Country(name: "Sudan", code: "SD", emoji: "🇸🇩"),
    Country(name: "Suriname", code: "SR", emoji: "🇸🇷"),
    Country(name: "Svalbard & Jan Mayen", code: "SJ", emoji: "🇸🇯"),
    Country(name: "Sweden", code: "SE", emoji: "🇸🇪"),
    Country(name: "Switzerland", code: "CH", emoji: "🇨🇭"),
    Country(name: "Syria", code: "SY", emoji: "🇸🇾"),
    Country(name: "São Tomé & Príncipe", code: "ST", emoji: "🇸🇹"),
    Country(name: "Taiwan", code: "TW", emoji: "🇹🇼"),
    Country(name: "Tajikistan", code: "TJ", emoji: "🇹🇯"),
    Country(name: "Tanzania", code: "TZ", emoji: "🇹🇿"),
    Country(name: "Thailand", code: "TH", emoji: "🇹🇭"),
    Country(name: "Timor-Leste", code: "TL", emoji: "🇹🇱"),
    Country(name: "Togo", code: "TG", emoji: "🇹🇬"),
    Country(name: "Tokelau", code: "TK", emoji: "🇹🇰"),
    Country(name: "Tonga", code: "TO", emoji: "🇹🇴"),
    Country(name: "Trinidad & Tobago", code: "TT", emoji: "🇹🇹"),
    Country(name: "Tunisia", code: "TN", emoji: "🇹🇳"),
    Country(name: "Turkmenistan", code: "TM", emoji: "🇹🇲"),
    Country(name: "Turks & Caicos Islands", code: "TC", emoji: "🇹🇨"),
    Country(name: "Tuvalu", code: "TV", emoji: "🇹🇻"),
    Country(name: "Türkiye", code: "TR", emoji: "🇹🇷"),
    Country(name: "U.S. Outlying Islands", code: "UM", emoji: "🇺🇲"),
    Country(name: "U.S. Virgin Islands", code: "VI", emoji: "🇻🇮"),
    Country(name: "Uganda", code: "UG", emoji: "🇺🇬"),
    Country(name: "Ukraine", code: "UA", emoji: "🇺🇦"),
    Country(name: "United Arab Emirates", code: "AE", emoji: "🇦🇪"),
    Country(name: "United Kingdom", code: "GB", emoji: "🇬🇧"),
    Country(name: "United States", code: "US", emoji: "🇺🇸"),
    Country(name: "Uruguay", code: "UY", emoji: "🇺🇾"),
    Country(name: "Uzbekistan", code: "UZ", emoji: "🇺🇿"),
    Country(name: "Vanuatu", code: "VU", emoji: "🇻🇺"),
    Country(name: "Vatican City", code: "VA", emoji: "🇻🇦"),
    Country(name: "Venezuela", code: "VE", emoji: "🇻🇪"),
    Country(name: "Vietnam", code: "VN", emoji: "🇻🇳"),
    Country(name: "Wallis & Futuna", code: "WF", emoji: "🇼🇫"),
    Country(name: "Western Sahara", code: "EH", emoji: "🇪🇭"),
    Country(name: "Yemen", code: "YE", emoji: "🇾🇪"),
    Country(name: "Zambia", code: "ZM", emoji: "🇿🇲"),
    Country(name: "Zimbabwe", code: "ZW", emoji: "🇿🇼"),
    Country(name: "Åland Islands", code: "AX", emoji: "🇦🇽"),
  ];


  Country? selectedCountry;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Country> filteredCountries = allCountries.where((country) =>
        country.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 14),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Title and Close

            addHeight(52),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addText400('Country',

                        fontSize: 32,
                        height: 40,
                        fontFamily: 'Caprasimo'),
               GestureDetector(
                   onTap: (){
                     Get.back();
                   },
                   child: Icon(Icons.cancel_outlined)),
              ],
            ),

            // Search Bar
            addHeight(16),
            CustomTextField(
              hintText: 'Search',
              prefixIcon: Image.asset(AppAssets.searchIcon,height: 24,width: 24,).marginOnly(left: 8),
            onChanged: (value){
              setState(() {
                searchQuery = value;
              });
            },
            ),
            addHeight(10),
            // Use current location
            // build_location_box(),
            // Country List
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  Country country = filteredCountries[index];
                  final isSelected = selectedCountry == country;

                  return build_country_box(onTap: (){
                    setState(() {
                      selectedCountry = country;
                    });
                  },country: country,isSelected: isSelected);
                  return ListTile(
                    tileColor: isSelected ? Colors.purple.shade50 : Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                    leading: Text(
                      country.emoji ?? '',
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(country.name ?? ''),
                  );
                },
              ),
            ),

            // Save Button
            AppButton(
                onButtonTap: selectedCountry != null
                    ? () async{
                  // final AudioPlayer _audioPlayer = AudioPlayer();
                  // await _audioPlayer.play(AssetSource(AppAssets.actionButtonTapSound));

                  Navigator.pop(context, selectedCountry);
                }
                    : null,
                buttonText: 'Save',buttonColor: selectedCountry != null?AppColors.primaryColor:AppColors.buttonDisableColor),
            addHeight(30),
          ],
        ),
      ),
    );
  }

  build_location_box() {
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        children: [
          Image.asset(AppAssets.mapIcon,height: 24,width: 24,),
          addWidth(10),
          addText500('Use current location',fontSize: 16,height: 22)
        ],
      ),
    );
  }

  build_country_box({VoidCallback? onTap, Country? country,bool? isSelected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected==true?AppColors.purpleLightColor:AppColors.whiteColor,
          borderRadius: BorderRadius.circular(50)
        ),
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Row(
          children: [
            addText500(country!.emoji,fontSize: 20),
            addWidth(10),
            addText500(country.name,fontSize: 16,height: 22)
          ],
        ),
      ),
    );
  }
}
