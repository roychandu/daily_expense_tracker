import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Expense Tracker'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get data;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads - \$3.99'**
  String get removeAds;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get saveExpense;

  /// No description provided for @saveIncome.
  ///
  /// In en, this message translates to:
  /// **'Save Income'**
  String get saveIncome;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncome;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @internetRequired.
  ///
  /// In en, this message translates to:
  /// **'Internet Required'**
  String get internetRequired;

  /// No description provided for @reminderInternetRequirement.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder has been set successfully.'**
  String get reminderInternetRequirement;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to log your expenses for today! 📝'**
  String get reminderBody;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @awayFromBadge.
  ///
  /// In en, this message translates to:
  /// **'days away from a silver badge!'**
  String get awayFromBadge;

  /// No description provided for @youAre.
  ///
  /// In en, this message translates to:
  /// **'You are'**
  String get youAre;

  /// No description provided for @milestoneReached.
  ///
  /// In en, this message translates to:
  /// **'Milestone reached! Check your rewards.'**
  String get milestoneReached;

  /// No description provided for @daysStreak.
  ///
  /// In en, this message translates to:
  /// **'DAYS STREAK'**
  String get daysStreak;

  /// No description provided for @streakProgress.
  ///
  /// In en, this message translates to:
  /// **'STREAK PROGRESS'**
  String get streakProgress;

  /// No description provided for @daysToNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Days to next milestone'**
  String get daysToNextMilestone;

  /// No description provided for @todayCardTitle.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todayCardTitle;

  /// No description provided for @entriesToday.
  ///
  /// In en, this message translates to:
  /// **'Entries today'**
  String get entriesToday;

  /// No description provided for @moreThanYesterday.
  ///
  /// In en, this message translates to:
  /// **'more than yesterday'**
  String get moreThanYesterday;

  /// No description provided for @lessThanYesterday.
  ///
  /// In en, this message translates to:
  /// **'less than yesterday'**
  String get lessThanYesterday;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet!'**
  String get noExpensesYet;

  /// No description provided for @noIncomeYet.
  ///
  /// In en, this message translates to:
  /// **'No income yet!'**
  String get noIncomeYet;

  /// No description provided for @viewAllHistory.
  ///
  /// In en, this message translates to:
  /// **'View All History'**
  String get viewAllHistory;

  /// No description provided for @monthlySummaryText.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummaryText;

  /// No description provided for @netBalanceStr.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalanceStr;

  /// No description provided for @spendBreakdownHeadline.
  ///
  /// In en, this message translates to:
  /// **'Spending Breakdown'**
  String get spendBreakdownHeadline;

  /// No description provided for @topSpendBreakdownText.
  ///
  /// In en, this message translates to:
  /// **'Top Spending Breakdown'**
  String get topSpendBreakdownText;

  /// No description provided for @viewInfoText.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewInfoText;

  /// No description provided for @viewFullBreakdownTxt.
  ///
  /// In en, this message translates to:
  /// **'View Full Breakdown'**
  String get viewFullBreakdownTxt;

  /// No description provided for @smartInsightsHeader.
  ///
  /// In en, this message translates to:
  /// **'Smart Insights'**
  String get smartInsightsHeader;

  /// No description provided for @mostFrequentCardText.
  ///
  /// In en, this message translates to:
  /// **'Most Frequent'**
  String get mostFrequentCardText;

  /// No description provided for @categoryThisMonthCardText.
  ///
  /// In en, this message translates to:
  /// **'Category this month'**
  String get categoryThisMonthCardText;

  /// No description provided for @highestSpendDayHeader.
  ///
  /// In en, this message translates to:
  /// **'Highest Spend Day'**
  String get highestSpendDayHeader;

  /// No description provided for @dailyAverageMetrics.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverageMetrics;

  /// No description provided for @advanceInsightsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advance Insights'**
  String get advanceInsightsAnalytics;

  /// No description provided for @monthlyComparisonAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison Trend'**
  String get monthlyComparisonAnalytics;

  /// No description provided for @sixMonthIncomeAnalytics.
  ///
  /// In en, this message translates to:
  /// **'6-Month Income Trend'**
  String get sixMonthIncomeAnalytics;

  /// No description provided for @premiumExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Export & PDF Reports'**
  String get premiumExportTitle;

  /// No description provided for @unlockProfessionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Unlock professional reports and cloud\\nbackground permanently'**
  String get unlockProfessionalDetails;

  /// No description provided for @goPremiumBtn.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremiumBtn;

  /// No description provided for @unlockWatchFullInsights.
  ///
  /// In en, this message translates to:
  /// **'Unlock to watch full Insights'**
  String get unlockWatchFullInsights;

  /// No description provided for @upgradeNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNowBtn;

  /// No description provided for @watchAdsTxt.
  ///
  /// In en, this message translates to:
  /// **'Watch Ads'**
  String get watchAdsTxt;

  /// No description provided for @highest.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @detailedSpendingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Detailed spending breakdown'**
  String get detailedSpendingBreakdown;

  /// No description provided for @smartTailoredInsights.
  ///
  /// In en, this message translates to:
  /// **'Smart tailored insights'**
  String get smartTailoredInsights;

  /// No description provided for @weeklyIncVsExpTrend.
  ///
  /// In en, this message translates to:
  /// **'Weekly Inc vs Exp trend'**
  String get weeklyIncVsExpTrend;

  /// No description provided for @monthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly trend'**
  String get monthlyTrend;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @thisMonthActivity.
  ///
  /// In en, this message translates to:
  /// **'Based on this month\'s activity'**
  String get thisMonthActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewAll;

  /// No description provided for @exportTransactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Export Transaction History'**
  String get exportTransactionHistory;

  /// No description provided for @annualFinancialReport.
  ///
  /// In en, this message translates to:
  /// **'Annual Financial Report'**
  String get annualFinancialReport;

  /// No description provided for @csv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get csv;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @inc.
  ///
  /// In en, this message translates to:
  /// **'Inc'**
  String get inc;

  /// No description provided for @exp.
  ///
  /// In en, this message translates to:
  /// **'Exp'**
  String get exp;

  /// No description provided for @fileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get fileSaved;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving'**
  String get errorSaving;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @activityFor.
  ///
  /// In en, this message translates to:
  /// **'Activity for'**
  String get activityFor;

  /// No description provided for @stoneBadge.
  ///
  /// In en, this message translates to:
  /// **'stone badge'**
  String get stoneBadge;

  /// No description provided for @ironBadge.
  ///
  /// In en, this message translates to:
  /// **'iron badge'**
  String get ironBadge;

  /// No description provided for @bronzeBadge.
  ///
  /// In en, this message translates to:
  /// **'bronze badge'**
  String get bronzeBadge;

  /// No description provided for @silverBadge.
  ///
  /// In en, this message translates to:
  /// **'silver badge'**
  String get silverBadge;

  /// No description provided for @goldBadge.
  ///
  /// In en, this message translates to:
  /// **'gold badge'**
  String get goldBadge;

  /// No description provided for @platinumBadge.
  ///
  /// In en, this message translates to:
  /// **'platinum badge'**
  String get platinumBadge;

  /// No description provided for @titaniumBadge.
  ///
  /// In en, this message translates to:
  /// **'titanium badge'**
  String get titaniumBadge;

  /// No description provided for @diamondBadge.
  ///
  /// In en, this message translates to:
  /// **'diamond badge'**
  String get diamondBadge;

  /// No description provided for @nextMilestoneLabel.
  ///
  /// In en, this message translates to:
  /// **'next milestone'**
  String get nextMilestoneLabel;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'LONGEST STREAK'**
  String get longestStreak;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'ACCURACY'**
  String get accuracy;

  /// No description provided for @milestoneReachedStayAhead.
  ///
  /// In en, this message translates to:
  /// **'Milestone reached! Log tomorrow to stay ahead.'**
  String get milestoneReachedStayAhead;

  /// No description provided for @awayFromGeneric.
  ///
  /// In en, this message translates to:
  /// **'days away from a'**
  String get awayFromGeneric;

  /// No description provided for @stoneTitle.
  ///
  /// In en, this message translates to:
  /// **'STONE'**
  String get stoneTitle;

  /// No description provided for @ironTitle.
  ///
  /// In en, this message translates to:
  /// **'IRON'**
  String get ironTitle;

  /// No description provided for @bronzeTitle.
  ///
  /// In en, this message translates to:
  /// **'BRONZE'**
  String get bronzeTitle;

  /// No description provided for @silverTitle.
  ///
  /// In en, this message translates to:
  /// **'SILVER'**
  String get silverTitle;

  /// No description provided for @goldTitle.
  ///
  /// In en, this message translates to:
  /// **'GOLD'**
  String get goldTitle;

  /// No description provided for @platinumTitle.
  ///
  /// In en, this message translates to:
  /// **'PLATINUM'**
  String get platinumTitle;

  /// No description provided for @titaniumTitle.
  ///
  /// In en, this message translates to:
  /// **'TITANIUM'**
  String get titaniumTitle;

  /// No description provided for @diamondTitle.
  ///
  /// In en, this message translates to:
  /// **'DIAMOND'**
  String get diamondTitle;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @usageIntensity.
  ///
  /// In en, this message translates to:
  /// **'Usage Intensity'**
  String get usageIntensity;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'MON'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get sun;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY ACTIVITY'**
  String get weeklyActivity;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @dataManagementSection.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagementSection;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @premiumUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Premium Features Unlocked!'**
  String get premiumUnlocked;

  /// No description provided for @switchedToFree.
  ///
  /// In en, this message translates to:
  /// **'Switched to Free Version'**
  String get switchedToFree;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Remove all ads, unlock detailed analytics, and get pro insights to master your finances.'**
  String get premiumDescription;

  /// No description provided for @buildConsistentHabit.
  ///
  /// In en, this message translates to:
  /// **'Build a consistent tracking habit'**
  String get buildConsistentHabit;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM MEMBER'**
  String get premiumMember;

  /// No description provided for @upgradeToGold.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Gold'**
  String get upgradeToGold;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @selectCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategoryTitle;

  /// No description provided for @addNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNoteTitle;

  /// No description provided for @optionalField.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalField;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// No description provided for @createNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Create New Category'**
  String get createNewCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @chooseAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseAnIcon;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get createCategory;

  /// No description provided for @pickAColor.
  ///
  /// In en, this message translates to:
  /// **'Pick a Color'**
  String get pickAColor;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @appAssets.
  ///
  /// In en, this message translates to:
  /// **'App Assets'**
  String get appAssets;

  /// No description provided for @materialIcons.
  ///
  /// In en, this message translates to:
  /// **'Material Icons'**
  String get materialIcons;

  /// No description provided for @cupertinoIcons.
  ///
  /// In en, this message translates to:
  /// **'Cupertino Icons'**
  String get cupertinoIcons;

  /// No description provided for @writeHere.
  ///
  /// In en, this message translates to:
  /// **'Write here..'**
  String get writeHere;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @fun.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get fun;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @dinning.
  ///
  /// In en, this message translates to:
  /// **'Dinning'**
  String get dinning;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @grocerry.
  ///
  /// In en, this message translates to:
  /// **'Grocerry'**
  String get grocerry;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @salaryIncome.
  ///
  /// In en, this message translates to:
  /// **'Salary Income'**
  String get salaryIncome;

  /// No description provided for @freelanceSideHustle.
  ///
  /// In en, this message translates to:
  /// **'Freelance/side hustle'**
  String get freelanceSideHustle;

  /// No description provided for @businessIncome.
  ///
  /// In en, this message translates to:
  /// **'Business Income'**
  String get businessIncome;

  /// No description provided for @investmentReturn.
  ///
  /// In en, this message translates to:
  /// **'Investment return'**
  String get investmentReturn;

  /// No description provided for @gifBonus.
  ///
  /// In en, this message translates to:
  /// **'Gif/bonus'**
  String get gifBonus;

  /// No description provided for @refundCashback.
  ///
  /// In en, this message translates to:
  /// **'Refund/cashback'**
  String get refundCashback;

  /// No description provided for @aboutNeelStudio.
  ///
  /// In en, this message translates to:
  /// **'About Neel Studio'**
  String get aboutNeelStudio;

  /// No description provided for @neelStudioSlogan1.
  ///
  /// In en, this message translates to:
  /// **'Neel Studio builds practical apps for real life.'**
  String get neelStudioSlogan1;

  /// No description provided for @neelStudioSlogan2.
  ///
  /// In en, this message translates to:
  /// **'We focus on tools that help people stay organized, make better daily decisions, and build consistency — without complexity or distraction.'**
  String get neelStudioSlogan2;

  /// No description provided for @productStandard.
  ///
  /// In en, this message translates to:
  /// **'Our product standard is simple:'**
  String get productStandard;

  /// No description provided for @fastActions.
  ///
  /// In en, this message translates to:
  /// **'Fast actions'**
  String get fastActions;

  /// No description provided for @clearOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Clear outcomes'**
  String get clearOutcomes;

  /// No description provided for @calmDesign.
  ///
  /// In en, this message translates to:
  /// **'Calm design'**
  String get calmDesign;

  /// No description provided for @respectForTime.
  ///
  /// In en, this message translates to:
  /// **'Respect for your time'**
  String get respectForTime;

  /// No description provided for @continuousImprovement.
  ///
  /// In en, this message translates to:
  /// **'Continuous improvement based on real feedback'**
  String get continuousImprovement;

  /// No description provided for @buildForRepeatValue.
  ///
  /// In en, this message translates to:
  /// **'We don’t build for hype. We build for repeat value.'**
  String get buildForRepeatValue;

  /// No description provided for @realProblemsRealPeople.
  ///
  /// In en, this message translates to:
  /// **'Real problems. Real people.'**
  String get realProblemsRealPeople;

  /// No description provided for @durableSolutions.
  ///
  /// In en, this message translates to:
  /// **'Durable solutions.'**
  String get durableSolutions;

  /// No description provided for @privacyAndTrust.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Trust'**
  String get privacyAndTrust;

  /// No description provided for @localFirstControl.
  ///
  /// In en, this message translates to:
  /// **'Local-first. You stay in control.'**
  String get localFirstControl;

  /// No description provided for @recordsStayOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Your records stay on your device. No account required. Clear permissions and transparent controls.'**
  String get recordsStayOnDevice;

  /// No description provided for @onDeviceStorage.
  ///
  /// In en, this message translates to:
  /// **'On-Device Storage'**
  String get onDeviceStorage;

  /// No description provided for @onDeviceStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'All records are saved on your device. We don’t upload your transactions to our servers.'**
  String get onDeviceStorageDesc;

  /// No description provided for @noAccountNeeded.
  ///
  /// In en, this message translates to:
  /// **'No Account Needed'**
  String get noAccountNeeded;

  /// No description provided for @noAccountNeededDesc.
  ///
  /// In en, this message translates to:
  /// **'You can use the app without signing up or sharing personal details.'**
  String get noAccountNeededDesc;

  /// No description provided for @notificationsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPrivacy;

  /// No description provided for @notificationsPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Used only for reminders you enable. You can turn them off anytime.'**
  String get notificationsPrivacyDesc;

  /// No description provided for @adsAndPremium.
  ///
  /// In en, this message translates to:
  /// **'Ads & Premium'**
  String get adsAndPremium;

  /// No description provided for @adsAndPremiumDesc.
  ///
  /// In en, this message translates to:
  /// **'Free version may show ads. Premium removes ads and unlocks advanced features.'**
  String get adsAndPremiumDesc;

  /// No description provided for @exportMyData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get exportMyData;

  /// No description provided for @exportMyDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Export your records anytime (CSV/PDF).'**
  String get exportMyDataDesc;

  /// No description provided for @deleteMyData.
  ///
  /// In en, this message translates to:
  /// **'Delete My Data'**
  String get deleteMyData;

  /// No description provided for @deleteMyDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all records from this device.'**
  String get deleteMyDataDesc;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @expenseSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully'**
  String get expenseSaved;

  /// No description provided for @incomeSaved.
  ///
  /// In en, this message translates to:
  /// **'Income saved successfully'**
  String get incomeSaved;

  /// No description provided for @searchExpenses.
  ///
  /// In en, this message translates to:
  /// **'Search expenses...'**
  String get searchExpenses;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No history found'**
  String get noHistoryFound;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @generatingCsv.
  ///
  /// In en, this message translates to:
  /// **'Generating CSV...'**
  String get generatingCsv;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found for selected range'**
  String get noDataFound;

  /// No description provided for @reportID.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get reportID;

  /// No description provided for @reportDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reportDate;

  /// No description provided for @reportCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportCategory;

  /// No description provided for @reportAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get reportAmount;

  /// No description provided for @reportType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get reportType;

  /// No description provided for @reportNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get reportNote;

  /// No description provided for @fileSavedTo.
  ///
  /// In en, this message translates to:
  /// **'File saved to:'**
  String get fileSavedTo;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @couldNotFindExportDir.
  ///
  /// In en, this message translates to:
  /// **'Could not find export directory'**
  String get couldNotFindExportDir;

  /// No description provided for @expenseReport.
  ///
  /// In en, this message translates to:
  /// **'Expense Report'**
  String get expenseReport;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @rawDatabaseViewer.
  ///
  /// In en, this message translates to:
  /// **'Raw Database Viewer'**
  String get rawDatabaseViewer;

  /// No description provided for @noDataFoundInDatabase.
  ///
  /// In en, this message translates to:
  /// **'No records found in database'**
  String get noDataFoundInDatabase;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @chooseBackupMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose Backup Method'**
  String get chooseBackupMethod;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @recommendedForAndroid.
  ///
  /// In en, this message translates to:
  /// **'Recommended for Android'**
  String get recommendedForAndroid;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @recommendedForIos.
  ///
  /// In en, this message translates to:
  /// **'Recommended for iOS'**
  String get recommendedForIos;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// No description provided for @privacyGuarantee.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY GUARANTEE'**
  String get privacyGuarantee;

  /// No description provided for @endToEndEncryption.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encryption'**
  String get endToEndEncryption;

  /// No description provided for @weNeverSeeData.
  ///
  /// In en, this message translates to:
  /// **'We never see your expense data'**
  String get weNeverSeeData;

  /// No description provided for @deleteCloudDataAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can delete cloud data anytime'**
  String get deleteCloudDataAnytime;

  /// No description provided for @gdprCompliant.
  ///
  /// In en, this message translates to:
  /// **'GDPR & privacy compliant'**
  String get gdprCompliant;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our Privacy Policy'**
  String get readPrivacyPolicy;

  /// No description provided for @setUpLater.
  ///
  /// In en, this message translates to:
  /// **'Set Up Later'**
  String get setUpLater;

  /// No description provided for @enableBackupAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can enable backup anytime from\n'**
  String get enableBackupAnytime;

  /// No description provided for @settingsCloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Settings → Cloud Backup'**
  String get settingsCloudBackup;

  /// No description provided for @protectFinancialData.
  ///
  /// In en, this message translates to:
  /// **'Protect Your\nFinancial Data'**
  String get protectFinancialData;

  /// No description provided for @cloudBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Your expenses are safely stored\non your device. Add cloud\nbackup for extra peace of mind.'**
  String get cloudBackupDescription;

  /// No description provided for @whyCloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Why Cloud Backup?'**
  String get whyCloudBackup;

  /// No description provided for @switchPhonesEasily.
  ///
  /// In en, this message translates to:
  /// **'Switch Phones Easily'**
  String get switchPhonesEasily;

  /// No description provided for @switchPhonesDesc.
  ///
  /// In en, this message translates to:
  /// **'Move to a new device without losing any data'**
  String get switchPhonesDesc;

  /// No description provided for @automaticSync.
  ///
  /// In en, this message translates to:
  /// **'Automatic Sync'**
  String get automaticSync;

  /// No description provided for @automaticSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Data backed up daily, no manual exports needed'**
  String get automaticSyncDesc;

  /// No description provided for @enableCloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Enable Cloud Backup'**
  String get enableCloudBackup;

  /// No description provided for @partOfPremium.
  ///
  /// In en, this message translates to:
  /// **'PART OF PREMIUM (\$3.99 ONE-TIME)'**
  String get partOfPremium;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @localStorageActive.
  ///
  /// In en, this message translates to:
  /// **'Local storage: Active'**
  String get localStorageActive;

  /// No description provided for @dataSafeOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Data safe on your device'**
  String get dataSafeOnDevice;

  /// No description provided for @expensesLogged24x7.
  ///
  /// In en, this message translates to:
  /// **'24x7  expenses logged'**
  String get expensesLogged24x7;

  /// No description provided for @notEnabled.
  ///
  /// In en, this message translates to:
  /// **'NOT ENABLED'**
  String get notEnabled;

  /// No description provided for @dataSync.
  ///
  /// In en, this message translates to:
  /// **'Data Sync'**
  String get dataSync;

  /// No description provided for @activeAndSyncing.
  ///
  /// In en, this message translates to:
  /// **'Active & syncing'**
  String get activeAndSyncing;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {time}'**
  String lastBackup(String time);

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Account: {email}'**
  String accountEmail(String email);

  /// No description provided for @storageUsed.
  ///
  /// In en, this message translates to:
  /// **'Storage used: {size}'**
  String storageUsed(String size);

  /// No description provided for @manageBackup.
  ///
  /// In en, this message translates to:
  /// **'Manage Backup >'**
  String get manageBackup;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @syncFrequency.
  ///
  /// In en, this message translates to:
  /// **'Sync frequency'**
  String get syncFrequency;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @downloadAllData.
  ///
  /// In en, this message translates to:
  /// **'Download all data'**
  String get downloadAllData;

  /// No description provided for @disconnectDeleteCloud.
  ///
  /// In en, this message translates to:
  /// **'Disconnect & delete cloud data'**
  String get disconnectDeleteCloud;

  /// No description provided for @cloudSecureDesc.
  ///
  /// In en, this message translates to:
  /// **'Your financial data is encrypted and secure in your personal cloud storage.'**
  String get cloudSecureDesc;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logInSmall.
  ///
  /// In en, this message translates to:
  /// **'log in'**
  String get logInSmall;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address you used to sign up to reset your password'**
  String get forgotPasswordDesc;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get sendEmail;

  /// No description provided for @weWillSendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a password reset email.'**
  String get weWillSendResetEmail;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get repeatPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @woohoo.
  ///
  /// In en, this message translates to:
  /// **'Woohoo!'**
  String get woohoo;

  /// No description provided for @friendJoined.
  ///
  /// In en, this message translates to:
  /// **'Friend joined!'**
  String get friendJoined;

  /// No description provided for @referralSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'{name} downloaded the app using\nyour link. You both just earned 15\ndays of premium access!'**
  String referralSuccessDesc(String name);

  /// No description provided for @premiumActivated.
  ///
  /// In en, this message translates to:
  /// **'Premium activated'**
  String get premiumActivated;

  /// No description provided for @validFor15Days.
  ///
  /// In en, this message translates to:
  /// **'Valid for 15 days'**
  String get validFor15Days;

  /// No description provided for @allFeaturesUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All features unlocked'**
  String get allFeaturesUnlocked;

  /// No description provided for @explorePremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Explore premium features'**
  String get explorePremiumFeatures;

  /// No description provided for @inviteMoreFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite More Friends'**
  String get inviteMoreFriends;

  /// No description provided for @invitesStatus.
  ///
  /// In en, this message translates to:
  /// **'{used} INVITES USED • {remaining} INVITE REMAINING'**
  String invitesStatus(int used, int remaining);

  /// No description provided for @welcomeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nPremium'**
  String get welcomeToPremium;

  /// No description provided for @upgradeActive.
  ///
  /// In en, this message translates to:
  /// **'Your upgrade is now active'**
  String get upgradeActive;

  /// No description provided for @allAdsRemoved.
  ///
  /// In en, this message translates to:
  /// **'All ads Removed'**
  String get allAdsRemoved;

  /// No description provided for @allInsightsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All insights unlocked'**
  String get allInsightsUnlocked;

  /// No description provided for @unlimitedExportsActivated.
  ///
  /// In en, this message translates to:
  /// **'Unlimited exports activated'**
  String get unlimitedExportsActivated;

  /// No description provided for @premiumFeaturesReady.
  ///
  /// In en, this message translates to:
  /// **'Premium features ready'**
  String get premiumFeaturesReady;

  /// No description provided for @byPurchasingAgree.
  ///
  /// In en, this message translates to:
  /// **'By purchasing, you agree to our '**
  String get byPurchasingAgree;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// No description provided for @oneTimePayment.
  ///
  /// In en, this message translates to:
  /// **'One-time payment • Lifetime access'**
  String get oneTimePayment;

  /// No description provided for @noSubscriptionEver.
  ///
  /// In en, this message translates to:
  /// **'No subscription ever'**
  String get noSubscriptionEver;

  /// No description provided for @removeAdsForever.
  ///
  /// In en, this message translates to:
  /// **'Remove all ads forever'**
  String get removeAdsForever;

  /// No description provided for @unlockAllInsights.
  ///
  /// In en, this message translates to:
  /// **'Unlock all insights'**
  String get unlockAllInsights;

  /// No description provided for @unlimitedExports.
  ///
  /// In en, this message translates to:
  /// **'Unlimited exports'**
  String get unlimitedExports;

  /// No description provided for @advancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics'**
  String get advancedAnalytics;

  /// No description provided for @unlockPremiumPrice.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium \$3.99'**
  String get unlockPremiumPrice;

  /// No description provided for @watchAd24h.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad for 24h Access'**
  String get watchAd24h;

  /// No description provided for @insightsUnlockedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Insights unlocked for 2 minutes! 🔓'**
  String get insightsUnlockedSnackbar;

  /// No description provided for @inviteEarnPremium.
  ///
  /// In en, this message translates to:
  /// **'Invite & Earn Premium'**
  String get inviteEarnPremium;

  /// No description provided for @shareLoveEarnPremium.
  ///
  /// In en, this message translates to:
  /// **'Share the love, Earn Premium'**
  String get shareLoveEarnPremium;

  /// No description provided for @helpFriendTrackBetter.
  ///
  /// In en, this message translates to:
  /// **'Help friend track expense better and both get rewarded'**
  String get helpFriendTrackBetter;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @shareYourLink.
  ///
  /// In en, this message translates to:
  /// **'Share Your Link'**
  String get shareYourLink;

  /// No description provided for @sendToFriendsViaApp.
  ///
  /// In en, this message translates to:
  /// **'Send to friends via any app'**
  String get sendToFriendsViaApp;

  /// No description provided for @friendDownloadsOpens.
  ///
  /// In en, this message translates to:
  /// **'Friend Downloads & Opens'**
  String get friendDownloadsOpens;

  /// No description provided for @installFromStore.
  ///
  /// In en, this message translates to:
  /// **'They install from Play/App Store'**
  String get installFromStore;

  /// No description provided for @bothGet15Days.
  ///
  /// In en, this message translates to:
  /// **'Both Get 15 Days Premium'**
  String get bothGet15Days;

  /// No description provided for @unlockedInstantly.
  ///
  /// In en, this message translates to:
  /// **'Unlocked instantly, no catch!'**
  String get unlockedInstantly;

  /// No description provided for @statusHeader.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusHeader;

  /// No description provided for @daysEarned.
  ///
  /// In en, this message translates to:
  /// **'{days} days earned'**
  String daysEarned(int days);

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String expires(String date);

  /// No description provided for @friendsInvited.
  ///
  /// In en, this message translates to:
  /// **'Friends invited: {count} / {max}'**
  String friendsInvited(int count, int max);

  /// No description provided for @maxInvitesReached.
  ///
  /// In en, this message translates to:
  /// **'You have reached the maximum invites!'**
  String get maxInvitesReached;

  /// No description provided for @inviteMoreToMax.
  ///
  /// In en, this message translates to:
  /// **'Invite {count} more friend{s} to max out!'**
  String inviteMoreToMax(int count, String s);

  /// No description provided for @yourReferralLink.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Link'**
  String get yourReferralLink;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @shareVia.
  ///
  /// In en, this message translates to:
  /// **'Share via...'**
  String get shareVia;

  /// No description provided for @programTerms.
  ///
  /// In en, this message translates to:
  /// **'Program Terms'**
  String get programTerms;

  /// No description provided for @termNewUser.
  ///
  /// In en, this message translates to:
  /// **'Each friend must be a new user who hasn\'t installed the app before.'**
  String get termNewUser;

  /// No description provided for @termMaxInvites.
  ///
  /// In en, this message translates to:
  /// **'Maximum of 3 successful invites allowed per user.'**
  String get termMaxInvites;

  /// No description provided for @termInstantActivation.
  ///
  /// In en, this message translates to:
  /// **'Premium rewards are activated immediately after the friend opens the app using your link.'**
  String get termInstantActivation;

  /// No description provided for @termReserveRight.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to cancel rewards for suspicious activity.'**
  String get termReserveRight;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
