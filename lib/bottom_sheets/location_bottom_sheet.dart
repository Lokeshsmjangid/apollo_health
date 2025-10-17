import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/models/country_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationBottomSheet extends StatefulWidget {
  @override
  _LocationBottomSheetState createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  List<Country> allCountries = [
    Country(name: "Afghanistan", code: "AF", emoji: "https://flagcdn.com/w80/af.png"),
    Country(name: "Albania", code: "AL", emoji: "https://flagcdn.com/w80/al.png"),
    Country(name: "Algeria", code: "DZ", emoji: "https://flagcdn.com/w80/dz.png"),
    Country(name: "American Samoa", code: "AS", emoji: "https://flagcdn.com/w80/as.png"),
    Country(name: "Andorra", code: "AD", emoji: "https://flagcdn.com/w80/ad.png"),
    Country(name: "Angola", code: "AO", emoji: "https://flagcdn.com/w80/ao.png"),
    Country(name: "Anguilla", code: "AI", emoji: "https://flagcdn.com/w80/ai.png"),
    Country(name: "Antarctica", code: "AQ", emoji: "https://flagcdn.com/w80/aq.png"),
    Country(name: "Antigua & Barbuda", code: "AG", emoji: "https://flagcdn.com/w80/ag.png"),
    Country(name: "Argentina", code: "AR", emoji: "https://flagcdn.com/w80/ar.png"),
    Country(name: "Armenia", code: "AM", emoji: "https://flagcdn.com/w80/am.png"),
    Country(name: "Aruba", code: "AW", emoji: "https://flagcdn.com/w80/aw.png"),
    Country(name: "Australia", code: "AU", emoji: "https://flagcdn.com/w80/au.png"),
    Country(name: "Austria", code: "AT", emoji: "https://flagcdn.com/w80/at.png"),
    Country(name: "Azerbaijan", code: "AZ", emoji: "https://flagcdn.com/w80/az.png"),
    Country(name: "Bahamas", code: "BS", emoji: "https://flagcdn.com/w80/bs.png"),
    Country(name: "Bahrain", code: "BH", emoji: "https://flagcdn.com/w80/bh.png"),
    Country(name: "Bangladesh", code: "BD", emoji: "https://flagcdn.com/w80/bd.png"),
    Country(name: "Barbados", code: "BB", emoji: "https://flagcdn.com/w80/bb.png"),
    Country(name: "Belarus", code: "BY", emoji: "https://flagcdn.com/w80/by.png"),
    Country(name: "Belgium", code: "BE", emoji: "https://flagcdn.com/w80/be.png"),
    Country(name: "Belize", code: "BZ", emoji: "https://flagcdn.com/w80/bz.png"),
    Country(name: "Benin", code: "BJ", emoji: "https://flagcdn.com/w80/bj.png"),
    Country(name: "Bermuda", code: "BM", emoji: "https://flagcdn.com/w80/bm.png"),
    Country(name: "Bhutan", code: "BT", emoji: "https://flagcdn.com/w80/bt.png"),
    Country(name: "Bolivia", code: "BO", emoji: "https://flagcdn.com/w80/bo.png"),
    Country(name: "Bosnia & Herzegovina", code: "BA", emoji: "https://flagcdn.com/w80/ba.png"),
    Country(name: "Botswana", code: "BW", emoji: "https://flagcdn.com/w80/bw.png"),
    Country(name: "Bouvet Island", code: "BV", emoji: "https://flagcdn.com/w80/bv.png"),
    Country(name: "Brazil", code: "BR", emoji: "https://flagcdn.com/w80/br.png"),
    Country(name: "British Indian Ocean Territory", code: "IO", emoji: "https://flagcdn.com/w80/io.png"),
    Country(name: "British Virgin Islands", code: "VG", emoji: "https://flagcdn.com/w80/vg.png"),
    Country(name: "Brunei", code: "BN", emoji: "https://flagcdn.com/w80/bn.png"),
    Country(name: "Bulgaria", code: "BG", emoji: "https://flagcdn.com/w80/bg.png"),
    Country(name: "Burkina Faso", code: "BF", emoji: "https://flagcdn.com/w80/bf.png"),
    Country(name: "Burundi", code: "BI", emoji: "https://flagcdn.com/w80/bi.png"),
    Country(name: "Cambodia", code: "KH", emoji: "https://flagcdn.com/w80/kh.png"),
    Country(name: "Cameroon", code: "CM", emoji: "https://flagcdn.com/w80/cm.png"),
    Country(name: "Canada", code: "CA", emoji: "https://flagcdn.com/w80/ca.png"),
    Country(name: "Cape Verde", code: "CV", emoji: "https://flagcdn.com/w80/cv.png"),
    Country(name: "Caribbean Netherlands", code: "BQ", emoji: "https://flagcdn.com/w80/bq.png"),
    Country(name: "Cayman Islands", code: "KY", emoji: "https://flagcdn.com/w80/ky.png"),
    Country(name: "Central African Republic", code: "CF", emoji: "https://flagcdn.com/w80/cf.png"),
    Country(name: "Chad", code: "TD", emoji: "https://flagcdn.com/w80/td.png"),
    Country(name: "Chile", code: "CL", emoji: "https://flagcdn.com/w80/cl.png"),
    Country(name: "China", code: "CN", emoji: "https://flagcdn.com/w80/cn.png"),
    Country(name: "Christmas Island", code: "CX", emoji: "https://flagcdn.com/w80/cx.png"),
    Country(name: "Cocos (Keeling) Islands", code: "CC", emoji: "https://flagcdn.com/w80/cc.png"),
    Country(name: "Colombia", code: "CO", emoji: "https://flagcdn.com/w80/co.png"),
    Country(name: "Comoros", code: "KM", emoji: "https://flagcdn.com/w80/km.png"),
    Country(name: "Congo - Brazzaville", code: "CG", emoji: "https://flagcdn.com/w80/cg.png"),
    Country(name: "Congo - Kinshasa", code: "CD", emoji: "https://flagcdn.com/w80/cd.png"),
    Country(name: "Cook Islands", code: "CK", emoji: "https://flagcdn.com/w80/ck.png"),
    Country(name: "Costa Rica", code: "CR", emoji: "https://flagcdn.com/w80/cr.png"),
    Country(name: "Croatia", code: "HR", emoji: "https://flagcdn.com/w80/hr.png"),
    Country(name: "Cuba", code: "CU", emoji: "https://flagcdn.com/w80/cu.png"),
    Country(name: "Curaçao", code: "CW", emoji: "https://flagcdn.com/w80/cw.png"),
    Country(name: "Cyprus", code: "CY", emoji: "https://flagcdn.com/w80/cy.png"),
    Country(name: "Czechia", code: "CZ", emoji: "https://flagcdn.com/w80/cz.png"),
    Country(name: "Côte d’Ivoire", code: "CI", emoji: "https://flagcdn.com/w80/ci.png"),
    Country(name: "Denmark", code: "DK", emoji: "https://flagcdn.com/w80/dk.png"),
    Country(name: "Djibouti", code: "DJ", emoji: "https://flagcdn.com/w80/dj.png"),
    Country(name: "Dominica", code: "DM", emoji: "https://flagcdn.com/w80/dm.png"),
    Country(name: "Dominican Republic", code: "DO", emoji: "https://flagcdn.com/w80/do.png"),
    Country(name: "Ecuador", code: "EC", emoji: "https://flagcdn.com/w80/ec.png"),
    Country(name: "Egypt", code: "EG", emoji: "https://flagcdn.com/w80/eg.png"),
    Country(name: "El Salvador", code: "SV", emoji: "https://flagcdn.com/w80/sv.png"),
    Country(name: "Equatorial Guinea", code: "GQ", emoji: "https://flagcdn.com/w80/gq.png"),
    Country(name: "Eritrea", code: "ER", emoji: "https://flagcdn.com/w80/er.png"),
    Country(name: "Estonia", code: "EE", emoji: "https://flagcdn.com/w80/ee.png"),
    Country(name: "Eswatini", code: "SZ", emoji: "https://flagcdn.com/w80/sz.png"),
    Country(name: "Ethiopia", code: "ET", emoji: "https://flagcdn.com/w80/et.png"),
    Country(name: "Falkland Islands", code: "FK", emoji: "https://flagcdn.com/w80/fk.png"),
    Country(name: "Faroe Islands", code: "FO", emoji: "https://flagcdn.com/w80/fo.png"),
    Country(name: "Fiji", code: "FJ", emoji: "https://flagcdn.com/w80/fj.png"),
    Country(name: "Finland", code: "FI", emoji: "https://flagcdn.com/w80/fi.png"),
    Country(name: "France", code: "FR", emoji: "https://flagcdn.com/w80/fr.png"),
    Country(name: "French Guiana", code: "GF", emoji: "https://flagcdn.com/w80/gf.png"),
    Country(name: "French Polynesia", code: "PF", emoji: "https://flagcdn.com/w80/pf.png"),
    Country(name: "French Southern Territories", code: "TF", emoji: "https://flagcdn.com/w80/tf.png"),
    Country(name: "Gabon", code: "GA", emoji: "https://flagcdn.com/w80/ga.png"),
    Country(name: "Gambia", code: "GM", emoji: "https://flagcdn.com/w80/gm.png"),
    Country(name: "Georgia", code: "GE", emoji: "https://flagcdn.com/w80/ge.png"),
    Country(name: "Germany", code: "DE", emoji: "https://flagcdn.com/w80/de.png"),
    Country(name: "Ghana", code: "GH", emoji: "https://flagcdn.com/w80/gh.png"),
    Country(name: "Gibraltar", code: "GI", emoji: "https://flagcdn.com/w80/gi.png"),
    Country(name: "Greece", code: "GR", emoji: "https://flagcdn.com/w80/gr.png"),
    Country(name: "Greenland", code: "GL", emoji: "https://flagcdn.com/w80/gl.png"),
    Country(name: "Grenada", code: "GD", emoji: "https://flagcdn.com/w80/gd.png"),
    Country(name: "Guadeloupe", code: "GP", emoji: "https://flagcdn.com/w80/gp.png"),
    Country(name: "Guam", code: "GU", emoji: "https://flagcdn.com/w80/gu.png"),
    Country(name: "Guatemala", code: "GT", emoji: "https://flagcdn.com/w80/gt.png"),
    Country(name: "Guernsey", code: "GG", emoji: "https://flagcdn.com/w80/gg.png"),
    Country(name: "Guinea", code: "GN", emoji: "https://flagcdn.com/w80/gn.png"),
    Country(name: "Guinea-Bissau", code: "GW", emoji: "https://flagcdn.com/w80/gw.png"),
    Country(name: "Guyana", code: "GY", emoji: "https://flagcdn.com/w80/gy.png"),
    Country(name: "Haiti", code: "HT", emoji: "https://flagcdn.com/w80/ht.png"),
    Country(name: "Heard & McDonald Islands", code: "HM", emoji: "https://flagcdn.com/w80/hm.png"),
    Country(name: "Honduras", code: "HN", emoji: "https://flagcdn.com/w80/hn.png"),
    Country(name: "Hong Kong SAR China", code: "HK", emoji: "https://flagcdn.com/w80/hk.png"),
    Country(name: "Hungary", code: "HU", emoji: "https://flagcdn.com/w80/hu.png"),
    Country(name: "Iceland", code: "IS", emoji: "https://flagcdn.com/w80/is.png"),
    Country(name: "India", code: "IN", emoji: "https://flagcdn.com/w80/in.png"),
    Country(name: "Indonesia", code: "ID", emoji: "https://flagcdn.com/w80/id.png"),
    Country(name: "Iran", code: "IR", emoji: "https://flagcdn.com/w80/ir.png"),
    Country(name: "Iraq", code: "IQ", emoji: "https://flagcdn.com/w80/iq.png"),
    Country(name: "Ireland", code: "IE", emoji: "https://flagcdn.com/w80/ie.png"),
    Country(name: "Isle of Man", code: "IM", emoji: "https://flagcdn.com/w80/im.png"),
    Country(name: "Israel", code: "IL", emoji: "https://flagcdn.com/w80/il.png"),
    Country(name: "Italy", code: "IT", emoji: "https://flagcdn.com/w80/it.png"),
    Country(name: "Jamaica", code: "JM", emoji: "https://flagcdn.com/w80/jm.png"),
    Country(name: "Japan", code: "JP", emoji: "https://flagcdn.com/w80/jp.png"),
    Country(name: "Jersey", code: "JE", emoji: "https://flagcdn.com/w80/je.png"),
    Country(name: "Jordan", code: "JO", emoji: "https://flagcdn.com/w80/jo.png"),
    Country(name: "Kazakhstan", code: "KZ", emoji: "https://flagcdn.com/w80/kz.png"),
    Country(name: "Kenya", code: "KE", emoji: "https://flagcdn.com/w80/ke.png"),
    Country(name: "Kiribati", code: "KI", emoji: "https://flagcdn.com/w80/ki.png"),
    Country(name: "Kuwait", code: "KW", emoji: "https://flagcdn.com/w80/kw.png"),
    Country(name: "Kyrgyzstan", code: "KG", emoji: "https://flagcdn.com/w80/kg.png"),
    Country(name: "Laos", code: "LA", emoji: "https://flagcdn.com/w80/la.png"),
    Country(name: "Latvia", code: "LV", emoji: "https://flagcdn.com/w80/lv.png"),
    Country(name: "Lebanon", code: "LB", emoji: "https://flagcdn.com/w80/lb.png"),
    Country(name: "Lesotho", code: "LS", emoji: "https://flagcdn.com/w80/ls.png"),
    Country(name: "Liberia", code: "LR", emoji: "https://flagcdn.com/w80/lr.png"),
    Country(name: "Libya", code: "LY", emoji: "https://flagcdn.com/w80/ly.png"),
    Country(name: "Liechtenstein", code: "LI", emoji: "https://flagcdn.com/w80/li.png"),
    Country(name: "Lithuania", code: "LT", emoji: "https://flagcdn.com/w80/lt.png"),
    Country(name: "Luxembourg", code: "LU", emoji: "https://flagcdn.com/w80/lu.png"),
    Country(name: "Macao SAR China", code: "MO", emoji: "https://flagcdn.com/w80/mo.png"),
    Country(name: "Madagascar", code: "MG", emoji: "https://flagcdn.com/w80/mg.png"),
    Country(name: "Malawi", code: "MW", emoji: "https://flagcdn.com/w80/mw.png"),
    Country(name: "Malaysia", code: "MY", emoji: "https://flagcdn.com/w80/my.png"),
    Country(name: "Maldives", code: "MV", emoji: "https://flagcdn.com/w80/mv.png"),
    Country(name: "Mali", code: "ML", emoji: "https://flagcdn.com/w80/ml.png"),
    Country(name: "Malta", code: "MT", emoji: "https://flagcdn.com/w80/mt.png"),
    Country(name: "Marshall Islands", code: "MH", emoji: "https://flagcdn.com/w80/mh.png"),
    Country(name: "Martinique", code: "MQ", emoji: "https://flagcdn.com/w80/mq.png"),
    Country(name: "Mauritania", code: "MR", emoji: "https://flagcdn.com/w80/mr.png"),
    Country(name: "Mauritius", code: "MU", emoji: "https://flagcdn.com/w80/mu.png"),
    Country(name: "Mayotte", code: "YT", emoji: "https://flagcdn.com/w80/yt.png"),
    Country(name: "Mexico", code: "MX", emoji: "https://flagcdn.com/w80/mx.png"),
    Country(name: "Micronesia", code: "FM", emoji: "https://flagcdn.com/w80/fm.png"),
    Country(name: "Moldova", code: "MD", emoji: "https://flagcdn.com/w80/md.png"),
    Country(name: "Monaco", code: "MC", emoji: "https://flagcdn.com/w80/mc.png"),
    Country(name: "Mongolia", code: "MN", emoji: "https://flagcdn.com/w80/mn.png"),
    Country(name: "Montenegro", code: "ME", emoji: "https://flagcdn.com/w80/me.png"),
    Country(name: "Montserrat", code: "MS", emoji: "https://flagcdn.com/w80/ms.png"),
    Country(name: "Morocco", code: "MA", emoji: "https://flagcdn.com/w80/ma.png"),
    Country(name: "Mozambique", code: "MZ", emoji: "https://flagcdn.com/w80/mz.png"),
    Country(name: "Myanmar (Burma)", code: "MM", emoji: "https://flagcdn.com/w80/mm.png"),
    Country(name: "Namibia", code: "NA", emoji: "https://flagcdn.com/w80/na.png"),
    Country(name: "Nauru", code: "NR", emoji: "https://flagcdn.com/w80/nr.png"),
    Country(name: "Nepal", code: "NP", emoji: "https://flagcdn.com/w80/np.png"),
    Country(name: "Netherlands", code: "NL", emoji: "https://flagcdn.com/w80/nl.png"),
    Country(name: "New Caledonia", code: "NC", emoji: "https://flagcdn.com/w80/nc.png"),
    Country(name: "New Zealand", code: "NZ", emoji: "https://flagcdn.com/w80/nz.png"),
    Country(name: "Nicaragua", code: "NI", emoji: "https://flagcdn.com/w80/ni.png"),
    Country(name: "Niger", code: "NE", emoji: "https://flagcdn.com/w80/ne.png"),
    Country(name: "Nigeria", code: "NG", emoji: "https://flagcdn.com/w80/ng.png"),
    Country(name: "Niue", code: "NU", emoji: "https://flagcdn.com/w80/nu.png"), //
    Country(name: "Norfolk Island", code: "NF", emoji: "https://flagcdn.com/w80/nf.png"), //
    Country(name: "North Korea", code: "KP", emoji: "https://flagcdn.com/w80/kp.png"), //
    Country(name: "North Macedonia", code: "MK", emoji: "https://flagcdn.com/w80/mk.png"),
    Country(name: "Northern Mariana Islands", code: "MP", emoji: "https://flagcdn.com/w80/mp.png"), //
    Country(name: "Norway", code: "NO", emoji: "https://flagcdn.com/w80/no.png"),
    Country(name: "Oman", code: "OM", emoji: "https://flagcdn.com/w80/om.png"),
    Country(name: "Pakistan", code: "PK", emoji: "https://flagcdn.com/w80/pk.png"),
    Country(name: "Palau", code: "PW", emoji: "https://flagcdn.com/w80/pw.png"), //
    Country(name: "Palestinian Territories", code: "PS", emoji: "https://flagcdn.com/w80/ps.png"), //
    Country(name: "Panama", code: "PA", emoji: "https://flagcdn.com/w80/pa.png"),
    Country(name: "Papua New Guinea", code: "PG", emoji: "https://flagcdn.com/w80/pg.png"),
    Country(name: "Paraguay", code: "PY", emoji: "https://flagcdn.com/w80/py.png"),
    Country(name: "Peru", code: "PE", emoji: "https://flagcdn.com/w80/pe.png"),
    Country(name: "Philippines", code: "PH", emoji: "https://flagcdn.com/w80/ph.png"),
    Country(name: "Pitcairn Islands", code: "PN", emoji: "https://flagcdn.com/w80/pn.png"),
    Country(name: "Poland", code: "PL", emoji: "https://flagcdn.com/w80/pl.png"),
    Country(name: "Portugal", code: "PT", emoji: "https://flagcdn.com/w80/pt.png"),
    Country(name: "Puerto Rico", code: "PR", emoji: "https://flagcdn.com/w80/pr.png"), //
    Country(name: "Qatar", code: "QA", emoji: "https://flagcdn.com/w80/qa.png"),
    Country(name: "Romania", code: "RO", emoji: "https://flagcdn.com/w80/ro.png"),
    Country(name: "Russia", code: "RU", emoji: "https://flagcdn.com/w80/ru.png"),
    Country(name: "Rwanda", code: "RW", emoji: "https://flagcdn.com/w80/rw.png"),
    Country(name: "Réunion", code: "RE", emoji: "https://flagcdn.com/w80/re.png"), //
    Country(name: "Samoa", code: "WS", emoji: "https://flagcdn.com/w80/ws.png"),
    Country(name: "San Marino", code: "SM", emoji: "https://flagcdn.com/w80/sm.png"),
    Country(name: "Saudi Arabia", code: "SA", emoji: "https://flagcdn.com/w80/sa.png"),
    Country(name: "Senegal", code: "SN", emoji: "https://flagcdn.com/w80/sn.png"),
    Country(name: "Serbia", code: "RS", emoji: "https://flagcdn.com/w80/rs.png"),
    Country(name: "Seychelles", code: "SC", emoji: "https://flagcdn.com/w80/sc.png"),
    Country(name: "Sierra Leone", code: "SL", emoji: "https://flagcdn.com/w80/sl.png"),
    Country(name: "Singapore", code: "SG", emoji: "https://flagcdn.com/w80/sg.png"),
    Country(name: "Sint Maarten", code: "SX", emoji: "https://flagcdn.com/w80/sx.png"), //
    Country(name: "Slovakia", code: "SK", emoji: "https://flagcdn.com/w80/sk.png"),
    Country(name: "Slovenia", code: "SI", emoji: "https://flagcdn.com/w80/si.png"),
    Country(name: "Solomon Islands", code: "SB", emoji: "https://flagcdn.com/w80/sb.png"),
    Country(name: "Somalia", code: "SO", emoji: "https://flagcdn.com/w80/so.png"),
    Country(name: "South Africa", code: "ZA", emoji: "https://flagcdn.com/w80/za.png"),
    Country(name: "South Georgia & South Sandwich Islands", code: "GS", emoji: "https://flagcdn.com/w80/gs.png"), //
    Country(name: "South Korea", code: "KR", emoji: "https://flagcdn.com/w80/kr.png"),
    Country(name: "South Sudan", code: "SS", emoji: "https://flagcdn.com/w80/ss.png"), //
    Country(name: "Spain", code: "ES", emoji: "https://flagcdn.com/w80/es.png"),
    Country(name: "Sri Lanka", code: "LK", emoji: "https://flagcdn.com/w80/lk.png"),
    Country(name: "St. Barthélemy", code: "BL", emoji: "https://flagcdn.com/w80/bl.png"), //
    Country(name: "St. Helena", code: "SH", emoji: "https://flagcdn.com/w80/sh.png"), //
    Country(name: "St. Kitts & Nevis", code: "KN", emoji: "https://flagcdn.com/w80/kn.png"),
    Country(name: "St. Lucia", code: "LC", emoji: "https://flagcdn.com/w80/lc.png"),
    Country(name: "St. Martin", code: "MF", emoji: "https://flagcdn.com/w80/mf.png"), //
    Country(name: "St. Pierre & Miquelon", code: "PM", emoji: "https://flagcdn.com/w80/pm.png"), //
    Country(name: "St. Vincent & Grenadines", code: "VC", emoji: "https://flagcdn.com/w80/vc.png"), //
    Country(name: "Sudan", code: "SD", emoji: "https://flagcdn.com/w80/sd.png"), //
    Country(name: "Suriname", code: "SR", emoji: "https://flagcdn.com/w80/sr.png"),
    Country(name: "Svalbard & Jan Mayen", code: "SJ", emoji: "https://flagcdn.com/w80/sj.png"), //
    Country(name: "Sweden", code: "SE", emoji: "https://flagcdn.com/w80/se.png"),
    Country(name: "Switzerland", code: "CH", emoji: "https://flagcdn.com/w80/ch.png"),
    Country(name: "Syria", code: "SY", emoji: "https://flagcdn.com/w80/sy.png"), //
    Country(name: "São Tomé & Príncipe", code: "ST", emoji: "https://flagcdn.com/w80/st.png"), //
    Country(name: "Taiwan", code: "TW", emoji: "https://flagcdn.com/w80/tw.png"),
    Country(name: "Tajikistan", code: "TJ", emoji: "https://flagcdn.com/w80/tj.png"),
    Country(name: "Tanzania", code: "TZ", emoji: "https://flagcdn.com/w80/tz.png"),
    Country(name: "Thailand", code: "TH", emoji: "https://flagcdn.com/w80/th.png"),
    Country(name: "Timor-Leste", code: "TL", emoji: "https://flagcdn.com/w80/tl.png"), //
    Country(name: "Togo", code: "TG", emoji: "https://flagcdn.com/w80/tg.png"),
    Country(name: "Tokelau", code: "TK", emoji: "https://flagcdn.com/w80/tk.png"), //
    Country(name: "Tonga", code: "TO", emoji: "https://flagcdn.com/w80/to.png"),
    Country(name: "Trinidad & Tobago", code: "TT", emoji: "https://flagcdn.com/w80/tt.png"),
    Country(name: "Tunisia", code: "TN", emoji: "https://flagcdn.com/w80/tn.png"),
    Country(name: "Turkmenistan", code: "TM", emoji: "https://flagcdn.com/w80/tm.png"),
    Country(name: "Turks & Caicos Islands", code: "TC", emoji: "https://flagcdn.com/w80/tc.png"),
    Country(name: "Tuvalu", code: "TV", emoji: "https://flagcdn.com/w80/tv.png"), //
    Country(name: "Türkiye", code: "TR", emoji: "https://flagcdn.com/w80/tr.png"),
    Country(name: "U.S. Outlying Islands", code: "UM", emoji: "https://flagcdn.com/w80/um.png"), //
    Country(name: "U.S. Virgin Islands", code: "VI", emoji: "https://flagcdn.com/w80/vi.png"), //
    Country(name: "Uganda", code: "UG", emoji: "https://flagcdn.com/w80/ug.png"),
    Country(name: "Ukraine", code: "UA", emoji: "https://flagcdn.com/w80/ua.png"),
    Country(name: "United Arab Emirates", code: "AE", emoji: "https://flagcdn.com/w80/ae.png"),
    Country(name: "United Kingdom", code: "GB", emoji: "https://flagcdn.com/w80/gb.png"),
    Country(name: "United States", code: "US", emoji: "https://flagcdn.com/w80/us.png"),
    Country(name: "Uruguay", code: "UY", emoji: "https://flagcdn.com/w80/uy.png"),
    Country(name: "Uzbekistan", code: "UZ", emoji: "https://flagcdn.com/w80/uz.png"),
    Country(name: "Vanuatu", code: "VU", emoji: "https://flagcdn.com/w80/vu.png"),
    Country(name: "Vatican City", code: "VA", emoji: "https://flagcdn.com/w80/va.png"),
    Country(name: "Venezuela", code: "VE", emoji: "https://flagcdn.com/w80/ve.png"),
    Country(name: "Vietnam", code: "VN", emoji: "https://flagcdn.com/w80/vn.png"),
    Country(name: "Wallis & Futuna", code: "WF", emoji: "https://flagcdn.com/w80/wf.png"), //
    Country(name: "Western Sahara", code: "EH", emoji: "https://flagcdn.com/w80/eh.png"), //
    Country(name: "Yemen", code: "YE", emoji: "https://flagcdn.com/w80/ye.png"),
    Country(name: "Zambia", code: "ZM", emoji: "https://flagcdn.com/w80/zm.png"),
    Country(name: "Zimbabwe", code: "ZW", emoji: "https://flagcdn.com/w80/zw.png"),
    Country(name: "Åland Islands", code: "AX", emoji: "https://flagcdn.com/w80/ax.png"), //
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
            Container(
              width: 22,height: 15,
              decoration: BoxDecoration(
                  // border: Border.all(color: AppColors.whiteColor,width: 1.5),
                  borderRadius: BorderRadius.circular(2)

              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(2),
                child: Image.network(country!.emoji,fit: BoxFit.cover),
              ),),
            addWidth(10),
            addText500(country.name,fontSize: 16,height: 22)
          ],
        ),
      ),
    );
  }
}


