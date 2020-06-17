// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum LocalString {

  public enum Login {
    public enum Error {
      /// Invalid login details, please check your username and password and try again!
      public static let invalidLoginDetails = LocalString.tr("Localizable", "login.error.invalid_login_details")
    }
  }

  public enum Profile {
    /// ABOUT
    public static let about = LocalString.tr("Localizable", "profile.about")
    /// Welcome to your awesome profile
    public static let greetingMessage = LocalString.tr("Localizable", "profile.greeting_message")
  }

  public enum Reg {
    /// Cancel
    public static let cancel = LocalString.tr("Localizable", "reg.cancel")
    /// City
    public static let city = LocalString.tr("Localizable", "reg.city")
    /// Country
    public static let country = LocalString.tr("Localizable", "reg.country")
    /// Email
    public static let email = LocalString.tr("Localizable", "reg.email")
    /// Female
    public static let female = LocalString.tr("Localizable", "reg.female")
    /// Gender
    public static let gender = LocalString.tr("Localizable", "reg.gender")
    /// Welcome to Awesome Profile\nThis step will take less than a minute to finish.
    public static let greetingMessage = LocalString.tr("Localizable", "reg.greeting_message")
    /// Male
    public static let male = LocalString.tr("Localizable", "reg.male")
    /// Nickname
    public static let nickname = LocalString.tr("Localizable", "reg.nickname")
    /// NO
    public static let no = LocalString.tr("Localizable", "reg.no")
    /// Other
    public static let other = LocalString.tr("Localizable", "reg.other")
    /// Password
    public static let password = LocalString.tr("Localizable", "reg.password")
    /// Registration
    public static let registration = LocalString.tr("Localizable", "reg.registration")
    /// Username
    public static let username = LocalString.tr("Localizable", "reg.username")
    /// Year Of Birth
    public static let yearOfBirth = LocalString.tr("Localizable", "reg.year_of_birth")
    /// YES
    public static let yes = LocalString.tr("Localizable", "reg.yes")
    public enum Error {
      /// Never heard of this city!!? 😜\nCity name cannot contain emojis, please enter a valid city name!
      public static let cityNameEmojiError = LocalString.tr("Localizable", "reg.error.city_name_emoji_error")
      /// Please enter a valid city name!
      public static let cityNameError = LocalString.tr("Localizable", "reg.error.city_name_error")
      /// Invalid email, please check your email and try again
      public static let emailGeneral = LocalString.tr("Localizable", "reg.error.email_general")
      /// Nice try, but currently nickname can't contain emojis!\nPlease try different one.
      public static let nicknameEmoji = LocalString.tr("Localizable", "reg.error.nickname_emoji")
      /// Nickname has to be at least 2 characters length, and can only contains alphabetical characters.\nPlease try again
      public static let nicknameGeneral = LocalString.tr("Localizable", "reg.error.nickname_general")
      /// Please make sure you have Internet connection to continue the registration.
      public static let notConnected = LocalString.tr("Localizable", "reg.error.not_connected")
      /// Please make sure you have Internet connection before you can continue
      public static let notConnectedGeneral = LocalString.tr("Localizable", "reg.error.not_connected_general")
      /// Valid password can only contains alphanumeric characters and minimum 6 characters!\nPlease retry again!
      public static let passwordIncorrect = LocalString.tr("Localizable", "reg.error.password_incorrect")
      /// We love ❤️ emojis too, but currently nickname can't contain emojis\nPlease try different one!
      public static let usernameContainsEmoji = LocalString.tr("Localizable", "reg.error.username_contains_emoji")
      /// Username can only contains alphanumeric characters, starts with a letter and minimum 4 characters\nPlease try again!
      public static let usernameGeneral = LocalString.tr("Localizable", "reg.error.username_general")
    }
    public enum Message {
      /// Please a moment, I'm checking your username availability 🤞
      public static let checkUsername = LocalString.tr("Localizable", "reg.message.check_username")
      /// Hmm, if you couldn't find your city on Google places, please just type it
      public static let citySearchCanceled = LocalString.tr("Localizable", "reg.message.city_search_canceled")
      /// Please enter the city name
      public static let citySearchError = LocalString.tr("Localizable", "reg.message.city_search_error")
      /// Here is your answers:
      public static let completedAnswers = LocalString.tr("Localizable", "reg.message.completed_answers")
      /// Please a moment, I'm checking your email
      public static let emailAvailabilityCheck = LocalString.tr("Localizable", "reg.message.email_availability_check")
      /// All good 👍
      public static let emailAvailable = LocalString.tr("Localizable", "reg.message.email_available")
      /// This email is already in use!\nIf you have forgotten your password you can go back to the login screen and try to retrieve your password, or simply enter another email.
      public static let emailUnavailable = LocalString.tr("Localizable", "reg.message.email_unavailable")
      /// Great, Wellcome to Awesome Profile
      public static let userConfirmQuestions = LocalString.tr("Localizable", "reg.message.user_confirm_questions")
      /// Great, your username is available 🥳
      public static let usernameAvailable = LocalString.tr("Localizable", "reg.message.username_available")
      /// Sorry, %@ is already taken 😔\nPlease try a different one!
      public static func usernameUnavailable(_ p1: String) -> String {
        return LocalString.tr("Localizable", "reg.message.username_unavailable", p1)
      }
    }
    public enum Question {
      /// Please let me know your year of birth!
      public static let birthYearQuestion = LocalString.tr("Localizable", "reg.question.birth_year_question")
      /// Please select your city!
      public static let cityQuestion = LocalString.tr("Localizable", "reg.question.city_question")
      /// Are you happy with all your answers?
      public static let conformationAnswers = LocalString.tr("Localizable", "reg.question.conformation_answers")
      /// Please select your country!
      public static let countryQuestion = LocalString.tr("Localizable", "reg.question.country_question")
      /// Now I need your email, just in case you forgot your password!
      public static let emailQuestion = LocalString.tr("Localizable", "reg.question.email_question")
      /// I need to know your gender, so other users can find you by gender! Please select one of the options
      public static let genderQuestion = LocalString.tr("Localizable", "reg.question.gender_question")
      /// What a nickname would you like to have, this will be used as your profile name. Valide nickname can only contains alphabetic characters and minimum 4 characters. Nickname can be changed at anytime later
      public static let nicknameQuestion = LocalString.tr("Localizable", "reg.question.nickname_question")
      /// New you need a password. Valid password can only contains alphanumeric characters and minimum 6 characters!
      public static let passwordQuestion = LocalString.tr("Localizable", "reg.question.password_question")
      /// Okey, which question, would you like to amend?
      public static let selectingToEditQuestion = LocalString.tr("Localizable", "reg.question.selecting_to_edit_question")
      /// What is your username would you like to be, a valid username can only contains alphanumeric characters
      public static let usernameQuestion = LocalString.tr("Localizable", "reg.question.username_question")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension LocalString {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
