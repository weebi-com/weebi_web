// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Lang {
  Lang();

  static Lang? _current;

  static Lang get current {
    assert(
      _current != null,
      'No instance of Lang was loaded. Try to initialize the Lang delegate before accessing Lang.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Lang> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Lang();
      Lang._current = instance;

      return instance;
    });
  }

  static Lang of(BuildContext context) {
    final instance = Lang.maybeOf(context);
    assert(
      instance != null,
      'No instance of Lang present in the widget tree. Did you add Lang.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static Lang? maybeOf(BuildContext context) {
    return Localizations.of<Lang>(context, Lang);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Blog`
  String get aboutBlog {
    return Intl.message('Blog', name: 'aboutBlog', desc: '', args: []);
  }

  /// `Historical Partners`
  String get aboutPartners {
    return Intl.message(
      'Historical Partners',
      name: 'aboutPartners',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Admin Portal Login`
  String get adminPortalLogin {
    return Intl.message(
      'Admin Portal Login',
      name: 'adminPortalLogin',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `I have read and accept the Terms and Conditions of Sale for the Enterprise license.`
  String get billingAcceptEnterpriseTerms {
    return Intl.message(
      'I have read and accept the Terms and Conditions of Sale for the Enterprise license.',
      name: 'billingAcceptEnterpriseTerms',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the terms and conditions to continue.`
  String get billingAcceptTermsToContinue {
    return Intl.message(
      'Please accept the terms and conditions to continue.',
      name: 'billingAcceptTermsToContinue',
      desc: '',
      args: [],
    );
  }

  /// `All users already have a license assigned.`
  String get billingAllUsersAlreadyAssigned {
    return Intl.message(
      'All users already have a license assigned.',
      name: 'billingAllUsersAlreadyAssigned',
      desc: '',
      args: [],
    );
  }

  /// `Assign the license to a user`
  String get billingAssignSeatDialogTitle {
    return Intl.message(
      'Assign the license to a user',
      name: 'billingAssignSeatDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Assign the license to a user`
  String get billingAssignSeats {
    return Intl.message(
      'Assign the license to a user',
      name: 'billingAssignSeats',
      desc: '',
      args: [],
    );
  }

  /// `Assign your new licenses to users below.`
  String get billingAssignSeatsCta {
    return Intl.message(
      'Assign your new licenses to users below.',
      name: 'billingAssignSeatsCta',
      desc: '',
      args: [],
    );
  }

  /// `Attributed to`
  String get billingAttributedTo {
    return Intl.message(
      'Attributed to',
      name: 'billingAttributedTo',
      desc: '',
      args: [],
    );
  }

  /// `License(s)`
  String get billingLicenses {
    return Intl.message(
      'License(s)',
      name: 'billingLicenses',
      desc: '',
      args: [],
    );
  }

  /// `Lifetime`
  String get billingLifetime {
    return Intl.message(
      'Lifetime',
      name: 'billingLifetime',
      desc: '',
      args: [],
    );
  }

  /// `My licenses`
  String get billingMyLicenses {
    return Intl.message(
      'My licenses',
      name: 'billingMyLicenses',
      desc: '',
      args: [],
    );
  }

  /// `Not yet attributed`
  String get billingNotYetAttributed {
    return Intl.message(
      'Not yet attributed',
      name: 'billingNotYetAttributed',
      desc: '',
      args: [],
    );
  }

  /// `No users to assign. Add users in Users first.`
  String get billingNoUsersAvailable {
    return Intl.message(
      'No users to assign. Add users in Users first.',
      name: 'billingNoUsersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Payment received. We're confirming with Stripe — your license will appear shortly. If it doesn't, check your webhook configuration.`
  String get billingPaymentProcessing {
    return Intl.message(
      'Payment received. We\'re confirming with Stripe — your license will appear shortly. If it doesn\'t, check your webhook configuration.',
      name: 'billingPaymentProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Your payment was accepted. You now have an active license.`
  String get billingPaymentSuccess {
    return Intl.message(
      'Your payment was accepted. You now have an active license.',
      name: 'billingPaymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get billingPurchase {
    return Intl.message(
      'Purchase',
      name: 'billingPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Purchase a license`
  String get billingPurchaseLicense {
    return Intl.message(
      'Purchase a license',
      name: 'billingPurchaseLicense',
      desc: '',
      args: [],
    );
  }

  /// `Choose a license to use the advanced features of Weebi.`
  String get billingPurchaseLicenseDescription {
    return Intl.message(
      'Choose a license to use the advanced features of Weebi.',
      name: 'billingPurchaseLicenseDescription',
      desc: '',
      args: [],
    );
  }

  /// `No other user can receive this seat. Add a user or free a license seat elsewhere first.`
  String get billingReassignNoOtherUser {
    return Intl.message(
      'No other user can receive this seat. Add a user or free a license seat elsewhere first.',
      name: 'billingReassignNoOtherUser',
      desc: '',
      args: [],
    );
  }

  /// `Reassign`
  String get billingReassignSeat {
    return Intl.message(
      'Reassign',
      name: 'billingReassignSeat',
      desc: '',
      args: [],
    );
  }

  /// `Reassign this license seat to another user`
  String get billingReassignSeatDialogTitle {
    return Intl.message(
      'Reassign this license seat to another user',
      name: 'billingReassignSeatDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get billingRetry {
    return Intl.message('Retry', name: 'billingRetry', desc: '', args: []);
  }

  /// `license(s) attributed`
  String get billingSeatsAttributed {
    return Intl.message(
      'license(s) attributed',
      name: 'billingSeatsAttributed',
      desc: '',
      args: [],
    );
  }

  /// `users`
  String get billingUsers {
    return Intl.message('users', name: 'billingUsers', desc: '', args: []);
  }

  /// `Valid until`
  String get billingValidUntil {
    return Intl.message(
      'Valid until',
      name: 'billingValidUntil',
      desc: '',
      args: [],
    );
  }

  /// `View full document (new tab)`
  String get billingViewFullTerms {
    return Intl.message(
      'View full document (new tab)',
      name: 'billingViewFullTerms',
      desc: '',
      args: [],
    );
  }

  /// `Button Emphasis`
  String get buttonEmphasis {
    return Intl.message(
      'Button Emphasis',
      name: 'buttonEmphasis',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Button} other{Buttons}}`
  String buttons(num count) {
    return Intl.plural(
      count,
      one: 'Button',
      other: 'Buttons',
      name: 'buttons',
      desc: '',
      args: [count],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Change photo`
  String get changeProfilePhoto {
    return Intl.message(
      'Change photo',
      name: 'changeProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Close Navigation Menu`
  String get closeNavigationMenu {
    return Intl.message(
      'Close Navigation Menu',
      name: 'closeNavigationMenu',
      desc: '',
      args: [],
    );
  }

  /// `Color Palette`
  String get colorPalette {
    return Intl.message(
      'Color Palette',
      name: 'colorPalette',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Color} other{Colors}}`
  String colors(num count) {
    return Intl.plural(
      count,
      one: 'Color',
      other: 'Colors',
      name: 'colors',
      desc: '',
      args: [count],
    );
  }

  /// `Color Scheme`
  String get colorScheme {
    return Intl.message(
      'Color Scheme',
      name: 'colorScheme',
      desc: '',
      args: [],
    );
  }

  /// `Confirm delete this record?`
  String get confirmDeleteRecord {
    return Intl.message(
      'Confirm delete this record?',
      name: 'confirmDeleteRecord',
      desc: '',
      args: [],
    );
  }

  /// `Confirm submit this record?`
  String get confirmSubmitRecord {
    return Intl.message(
      'Confirm submit this record?',
      name: 'confirmSubmitRecord',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `This field requires a valid credit card number.`
  String get creditCardErrorText {
    return Intl.message(
      'This field requires a valid credit card number.',
      name: 'creditCardErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get crudBack {
    return Intl.message('Back', name: 'crudBack', desc: '', args: []);
  }

  /// `Delete`
  String get crudDelete {
    return Intl.message('Delete', name: 'crudDelete', desc: '', args: []);
  }

  /// `Detail`
  String get crudDetail {
    return Intl.message('Detail', name: 'crudDetail', desc: '', args: []);
  }

  /// `New`
  String get crudNew {
    return Intl.message('New', name: 'crudNew', desc: '', args: []);
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message('Dark Theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `This field requires a valid date string.`
  String get dateStringErrorText {
    return Intl.message(
      'This field requires a valid date string.',
      name: 'dateStringErrorText',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Dialog} other{Dialogs}}`
  String dialogs(num count) {
    return Intl.plural(
      count,
      one: 'Dialog',
      other: 'Dialogs',
      name: 'dialogs',
      desc: '',
      args: [count],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `This field requires a valid email address.`
  String get emailErrorText {
    return Intl.message(
      'This field requires a valid email address.',
      name: 'emailErrorText',
      desc: '',
      args: [],
    );
  }

  /// `This field value must be equal to {value}.`
  String equalErrorText(Object value) {
    return Intl.message(
      'This field value must be equal to $value.',
      name: 'equalErrorText',
      desc: '',
      args: [value],
    );
  }

  /// `Error 404`
  String get error404 {
    return Intl.message('Error 404', name: 'error404', desc: '', args: []);
  }

  /// `Sorry, the page you are looking for has been removed or not exists.`
  String get error404Message {
    return Intl.message(
      'Sorry, the page you are looking for has been removed or not exists.',
      name: 'error404Message',
      desc: '',
      args: [],
    );
  }

  /// `Page not found`
  String get error404Title {
    return Intl.message(
      'Page not found',
      name: 'error404Title',
      desc: '',
      args: [],
    );
  }

  /// `Example`
  String get example {
    return Intl.message('Example', name: 'example', desc: '', args: []);
  }

  /// `{count, plural, one{Extension} other{Extensions}}`
  String extensions(num count) {
    return Intl.plural(
      count,
      one: 'Extension',
      other: 'Extensions',
      name: 'extensions',
      desc: '',
      args: [count],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address to reset your password.`
  String get forgotPasswordMessage {
    return Intl.message(
      'Enter your email address to reset your password.',
      name: 'forgotPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Form} other{Forms}}`
  String forms(num count) {
    return Intl.plural(
      count,
      one: 'Form',
      other: 'Forms',
      name: 'forms',
      desc: '',
      args: [count],
    );
  }

  /// `General UI`
  String get generalUi {
    return Intl.message('General UI', name: 'generalUi', desc: '', args: []);
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Read the FAQ`
  String get helpReadFaq {
    return Intl.message(
      'Read the FAQ',
      name: 'helpReadFaq',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get helpResourcesTitle {
    return Intl.message(
      'Resources',
      name: 'helpResourcesTitle',
      desc: '',
      args: [],
    );
  }

  /// `The web console lets you manage tickets (view, filter, search). Articles, contacts and operations (sales, purchases, stock movements, etc.) are available in the mobile app for now.`
  String get helpScopeBody {
    return Intl.message(
      'The web console lets you manage tickets (view, filter, search). Articles, contacts and operations (sales, purchases, stock movements, etc.) are available in the mobile app for now.',
      name: 'helpScopeBody',
      desc: '',
      args: [],
    );
  }

  /// `What can I do from the web console?`
  String get helpScopeTitle {
    return Intl.message(
      'What can I do from the web console?',
      name: 'helpScopeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Watch video demos`
  String get helpWatchDemos {
    return Intl.message(
      'Watch video demos',
      name: 'helpWatchDemos',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message('Hi', name: 'hi', desc: '', args: []);
  }

  /// `Home`
  String get homePage {
    return Intl.message('Home', name: 'homePage', desc: '', args: []);
  }

  /// `IFrame Demo`
  String get iframeDemo {
    return Intl.message('IFrame Demo', name: 'iframeDemo', desc: '', args: []);
  }

  /// `This field requires a valid integer.`
  String get integerErrorText {
    return Intl.message(
      'This field requires a valid integer.',
      name: 'integerErrorText',
      desc: '',
      args: [],
    );
  }

  /// `This field requires a valid IP.`
  String get ipErrorText {
    return Intl.message(
      'This field requires a valid IP.',
      name: 'ipErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Conditions Générales de Vente`
  String get legalDocTitleCgvFr {
    return Intl.message(
      'Conditions Générales de Vente',
      name: 'legalDocTitleCgvFr',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions of Sale`
  String get legalDocTitleTermsEn {
    return Intl.message(
      'Terms and Conditions of Sale',
      name: 'legalDocTitleTermsEn',
      desc: '',
      args: [],
    );
  }

  /// `Document version ID`
  String get legalDocumentVersionId {
    return Intl.message(
      'Document version ID',
      name: 'legalDocumentVersionId',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message('Light Theme', name: 'lightTheme', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Login now!`
  String get loginNow {
    return Intl.message('Login now!', name: 'loginNow', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Lorem ipsum dolor sit amet, consectetur adipiscing elit`
  String get loremIpsum {
    return Intl.message(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      name: 'loremIpsum',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get mail {
    return Intl.message('E-mail', name: 'mail', desc: '', args: []);
  }

  /// `Value does not match pattern.`
  String get matchErrorText {
    return Intl.message(
      'Value does not match pattern.',
      name: 'matchErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Value must be less than or equal to {max}`
  String maxErrorText(Object max) {
    return Intl.message(
      'Value must be less than or equal to $max',
      name: 'maxErrorText',
      desc: '',
      args: [max],
    );
  }

  /// `Value must have a length less than or equal to {maxLength}`
  String maxLengthErrorText(Object maxLength) {
    return Intl.message(
      'Value must have a length less than or equal to $maxLength',
      name: 'maxLengthErrorText',
      desc: '',
      args: [maxLength],
    );
  }

  /// `Accesses`
  String get menuAccesses {
    return Intl.message('Accesses', name: 'menuAccesses', desc: '', args: []);
  }

  /// `Billing`
  String get menuBilling {
    return Intl.message('Billing', name: 'menuBilling', desc: '', args: []);
  }

  /// `My Boutiques`
  String get menuBoutiques {
    return Intl.message(
      'My Boutiques',
      name: 'menuBoutiques',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get menuDevices {
    return Intl.message('Devices', name: 'menuDevices', desc: '', args: []);
  }

  /// `My Firm`
  String get menuFirm {
    return Intl.message('My Firm', name: 'menuFirm', desc: '', args: []);
  }

  /// `Articles, contacts and operations (sales, purchases, stock movements, etc.) are available in the mobile app for now.`
  String get menuScopeDisclaimer {
    return Intl.message(
      'Articles, contacts and operations (sales, purchases, stock movements, etc.) are available in the mobile app for now.',
      name: 'menuScopeDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Tickets`
  String get menuTickets {
    return Intl.message('Tickets', name: 'menuTickets', desc: '', args: []);
  }

  /// `Users`
  String get menuUsers {
    return Intl.message('Users', name: 'menuUsers', desc: '', args: []);
  }

  /// `Value must be greater than or equal to {min}.`
  String minErrorText(Object min) {
    return Intl.message(
      'Value must be greater than or equal to $min.',
      name: 'minErrorText',
      desc: '',
      args: [min],
    );
  }

  /// `Value must have a length greater than or equal to {minLength}`
  String minLengthErrorText(Object minLength) {
    return Intl.message(
      'Value must have a length greater than or equal to $minLength',
      name: 'minLengthErrorText',
      desc: '',
      args: [minLength],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message('My Profile', name: 'myProfile', desc: '', args: []);
  }

  /// `{count, plural, one{New Order} other{New Orders}}`
  String newOrders(num count) {
    return Intl.plural(
      count,
      one: 'New Order',
      other: 'New Orders',
      name: 'newOrders',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, one{New User} other{New Users}}`
  String newUsers(num count) {
    return Intl.plural(
      count,
      one: 'New User',
      other: 'New Users',
      name: 'newUsers',
      desc: '',
      args: [count],
    );
  }

  /// `This field value must not be equal to {value}.`
  String notEqualErrorText(Object value) {
    return Intl.message(
      'This field value must not be equal to $value.',
      name: 'notEqualErrorText',
      desc: '',
      args: [value],
    );
  }

  /// `Value must be numeric.`
  String get numericErrorText {
    return Intl.message(
      'Value must be numeric.',
      name: 'numericErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Open in new tab`
  String get openInNewTab {
    return Intl.message(
      'Open in new tab',
      name: 'openInNewTab',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Page} other{Pages}}`
  String pages(num count) {
    return Intl.plural(
      count,
      one: 'Page',
      other: 'Pages',
      name: 'pages',
      desc: '',
      args: [count],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password not match.`
  String get passwordNotMatch {
    return Intl.message(
      'Password not match.',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Pending Issue} other{Pending Issues}}`
  String pendingIssues(num count) {
    return Intl.plural(
      count,
      one: 'Pending Issue',
      other: 'Pending Issues',
      name: 'pendingIssues',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, one{Recent Order} other{Recent Orders}}`
  String recentOrders(num count) {
    return Intl.plural(
      count,
      one: 'Recent Order',
      other: 'Recent Orders',
      name: 'recentOrders',
      desc: '',
      args: [count],
    );
  }

  /// `Record deleted successfully.`
  String get recordDeletedSuccessfully {
    return Intl.message(
      'Record deleted successfully.',
      name: 'recordDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Record saved successfully.`
  String get recordSavedSuccessfully {
    return Intl.message(
      'Record saved successfully.',
      name: 'recordSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Record submitted successfully.`
  String get recordSubmittedSuccessfully {
    return Intl.message(
      'Record submitted successfully.',
      name: 'recordSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Register a new account`
  String get registerANewAccount {
    return Intl.message(
      'Register a new account',
      name: 'registerANewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register now!`
  String get registerNow {
    return Intl.message(
      'Register now!',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `This field cannot be empty.`
  String get requiredErrorText {
    return Intl.message(
      'This field cannot be empty.',
      name: 'requiredErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Retype Password`
  String get retypePassword {
    return Intl.message(
      'Retype Password',
      name: 'retypePassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Chat with Weebi support`
  String get supportChatWhatsApp {
    return Intl.message(
      'Chat with Weebi support',
      name: 'supportChatWhatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Send us an email`
  String get supportEmailUs {
    return Intl.message(
      'Send us an email',
      name: 'supportEmailUs',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message('Text', name: 'text', desc: '', args: []);
  }

  /// `Text Emphasis`
  String get textEmphasis {
    return Intl.message(
      'Text Emphasis',
      name: 'textEmphasis',
      desc: '',
      args: [],
    );
  }

  /// `Text Theme`
  String get textTheme {
    return Intl.message('Text Theme', name: 'textTheme', desc: '', args: []);
  }

  /// `Filtering tickets by store require an active license seat assigned to your user. Open Billing to subscribe or ask your administrator to assign you a seat.`
  String get ticketsLicenseOnlyMultiBoutiqueDetail {
    return Intl.message(
      'Filtering tickets by store require an active license seat assigned to your user. Open Billing to subscribe or ask your administrator to assign you a seat.',
      name: 'ticketsLicenseOnlyMultiBoutiqueDetail',
      desc: '',
      args: [],
    );
  }

  /// `Store filter & grouping`
  String get ticketsLicenseOnlyMultiBoutiqueTitle {
    return Intl.message(
      'Store filter & grouping',
      name: 'ticketsLicenseOnlyMultiBoutiqueTitle',
      desc: '',
      args: [],
    );
  }

  /// `License seat required`
  String get ticketsLicenseOnlyShort {
    return Intl.message(
      'License seat required',
      name: 'ticketsLicenseOnlyShort',
      desc: '',
      args: [],
    );
  }

  /// `Today Sales`
  String get todaySales {
    return Intl.message('Today Sales', name: 'todaySales', desc: '', args: []);
  }

  /// `Typography`
  String get typography {
    return Intl.message('Typography', name: 'typography', desc: '', args: []);
  }

  /// `{count, plural, one{UI Element} other{UI Elements}}`
  String uiElements(num count) {
    return Intl.plural(
      count,
      one: 'UI Element',
      other: 'UI Elements',
      name: 'uiElements',
      desc: '',
      args: [count],
    );
  }

  /// `This field requires a valid URL address.`
  String get urlErrorText {
    return Intl.message(
      'This field requires a valid URL address.',
      name: 'urlErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Lang> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Lang> load(Locale locale) => Lang.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
