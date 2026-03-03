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

  /// The title of the application
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

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

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

  /// No description provided for @totalExpensesToday.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses for today'**
  String get totalExpensesToday;

  /// No description provided for @totalIncomeToday.
  ///
  /// In en, this message translates to:
  /// **'Total Income for today'**
  String get totalIncomeToday;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'expenses'**
  String get expenses;

  /// No description provided for @logged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get logged;

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

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add note (optional)'**
  String get addNoteOptional;

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
  /// **'Expense saved ✓'**
  String get expenseSaved;

  /// No description provided for @incomeSaved.
  ///
  /// In en, this message translates to:
  /// **'Income saved ✓'**
  String get incomeSaved;

  /// No description provided for @loggingStreak.
  ///
  /// In en, this message translates to:
  /// **'LOGGING STREAK'**
  String get loggingStreak;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @keepItGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep it going!'**
  String get keepItGoing;

  /// No description provided for @startLoggingToday.
  ///
  /// In en, this message translates to:
  /// **'Start logging today!'**
  String get startLoggingToday;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY ACTIVITY'**
  String get weeklyActivity;

  /// No description provided for @daysLogged.
  ///
  /// In en, this message translates to:
  /// **'of 7 days logged'**
  String get daysLogged;

  /// No description provided for @consistentInsight.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been consistent! Keep tracking to see more trends.'**
  String get consistentInsight;

  /// No description provided for @startInsight.
  ///
  /// In en, this message translates to:
  /// **'Log more frequently to unlock personal spending insights.'**
  String get startInsight;

  /// No description provided for @monthlyTotal.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY TOTAL'**
  String get monthlyTotal;

  /// No description provided for @topCategory.
  ///
  /// In en, this message translates to:
  /// **'Top category'**
  String get topCategory;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get details;

  /// No description provided for @unlockFullBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Breakdown'**
  String get unlockFullBreakdown;

  /// No description provided for @categoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category breakdown'**
  String get categoryBreakdown;

  /// No description provided for @dailyAverageSpend.
  ///
  /// In en, this message translates to:
  /// **'Daily average spend'**
  String get dailyAverageSpend;

  /// No description provided for @highestSpendDay.
  ///
  /// In en, this message translates to:
  /// **'Highest spend day'**
  String get highestSpendDay;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @categoryBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY BREAKDOWN'**
  String get categoryBreakdownTitle;

  /// No description provided for @dailyAvg.
  ///
  /// In en, this message translates to:
  /// **'Daily Avg'**
  String get dailyAvg;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

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

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

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

  /// No description provided for @dateWiseLog.
  ///
  /// In en, this message translates to:
  /// **'DATE-WISE LOG'**
  String get dateWiseLog;

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

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

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

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

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

  /// No description provided for @fileSavedTo.
  ///
  /// In en, this message translates to:
  /// **'File saved to'**
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

  /// No description provided for @internetRequired.
  ///
  /// In en, this message translates to:
  /// **'Internet Required'**
  String get internetRequired;

  /// No description provided for @reminderInternetRequirement.
  ///
  /// In en, this message translates to:
  /// **'An active internet connection is required to enable and sync the daily reminder feature. Please check your connection and try again.'**
  String get reminderInternetRequirement;

  /// No description provided for @exportingCsv.
  ///
  /// In en, this message translates to:
  /// **'Exporting CSV...'**
  String get exportingCsv;

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

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @spendingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Spending Breakdown'**
  String get spendingBreakdown;

  /// No description provided for @topSpendingBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Top Spending Breakdown'**
  String get topSpendingBreakdown;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get viewAll;

  /// No description provided for @viewFullBreakdown.
  ///
  /// In en, this message translates to:
  /// **'View Full Breakdown'**
  String get viewFullBreakdown;

  /// No description provided for @smartInsights.
  ///
  /// In en, this message translates to:
  /// **'Smart Insights'**
  String get smartInsights;

  /// No description provided for @mostFrequent.
  ///
  /// In en, this message translates to:
  /// **'Most Frequent'**
  String get mostFrequent;

  /// No description provided for @categoryThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Category this month'**
  String get categoryThisMonth;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @advanceInsights.
  ///
  /// In en, this message translates to:
  /// **'Advance Insights'**
  String get advanceInsights;

  /// No description provided for @monthlyComparisonTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison Trend'**
  String get monthlyComparisonTrend;

  /// No description provided for @sixMonthIncomeTrend.
  ///
  /// In en, this message translates to:
  /// **'6-Month Income Trend'**
  String get sixMonthIncomeTrend;

  /// No description provided for @premiumExportPdfReports.
  ///
  /// In en, this message translates to:
  /// **'Premium Export & PDF Reports'**
  String get premiumExportPdfReports;

  /// No description provided for @unlockProfessionalReports.
  ///
  /// In en, this message translates to:
  /// **'Unlock professional reports and cloud\\nbackground permanently'**
  String get unlockProfessionalReports;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @unlockToWatchFullInsights.
  ///
  /// In en, this message translates to:
  /// **'Unlock to watch full Insights'**
  String get unlockToWatchFullInsights;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

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

  /// No description provided for @chooseAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseAnIcon;

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

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @daysToNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'Days to next milestone'**
  String get daysToNextMilestone;

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

  /// No description provided for @rawDatabaseViewer.
  ///
  /// In en, this message translates to:
  /// **'Raw Database Viewer'**
  String get rawDatabaseViewer;

  /// No description provided for @noDataFoundInDatabase.
  ///
  /// In en, this message translates to:
  /// **'No data found in database'**
  String get noDataFoundInDatabase;

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

  /// No description provided for @thisMonthActivity.
  ///
  /// In en, this message translates to:
  /// **'Based on this month\'s activity'**
  String get thisMonthActivity;

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
