//
//  WhatsNew.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/27/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct WhatsNew: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    @State private var selectedVersion: VersionInformation? = nil
    
    @State private var showArchives: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                SmallIconButton(symbol: "archivebox\(showArchives ? ".fill" : "")", textColor: color(settings.theme.color1), smallerLarge: true) {
                    showArchives.toggle()
                }
                .padding(.top, size == .large ? -5 : 0)
                
                Text("News")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                
                XButton{}.opacity(0)
            }
            .frame(height: size.smallerLargeSize+15)
            .padding(.horizontal, 7.5)
            
            Divider()
                .padding(.horizontal, 10)
            
            if showArchives {
            
                ScrollView(.horizontal) {
                    
                    HStack(spacing: 0) {
                        
                        ForEach(VersionInformation.data, id: \.id) { version in
                            
                            Button(action: {
                                self.selectedVersion = version
                            }) {
                                Text(version.number)
                                    .font(Font.system(.headline, design: .rounded).weight(.bold))
                                    .foregroundColor(selectedVersion == version ? .white : color(settings.theme.color1))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background((selectedVersion == version ? color(settings.theme.color1) : Color.init(white: 0.3)).cornerRadius(20))
                            }
                            .padding(5)
                        }
                    }
                }
                .background(Color.init(white: 0.25))
                .cornerRadius(20)
                .padding(10)
            }
            
            ScrollView {
                
                VStack(spacing: 10) {
                    
                    if let version = selectedVersion {
                        
                        VStack {
                            HStack(spacing: 5) {
                                Text("Version")
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                Text(version.number)
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                            }
                            .foregroundColor(Color.init(white: 0.8))
                            
                            Text(version.title)
                                .font(Font.system(.title, design: .rounded).weight(.bold))
                            
                            Text(dateString(version.changelogs.first?.date, style: .long))
                                .font(Font.system(.headline, design: .rounded).weight(.bold))
                                .foregroundColor(Color.init(white: 0.5))
                        }
                        .padding(.bottom, 10)
                        
//                        Text(version.description)
//                            .font(Font.system(.caption, design: .rounded))
//                            .multilineTextAlignment(.leading)
//                            .foregroundColor(Color.init(white: 0.7))
                        
                        ForEach(version.changelogs.reversed(), id: \.id) { changelog in
                            
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text("Changes in Version \("\(version.number).\(changelog.number)")")
                                        .font(Font.system(.title3, design: .rounded).weight(.bold))
                                    Spacer()
                                    Text(dateString(changelog.date, style: .short))
                                        .font(Font.system(.caption, design: .rounded).weight(.bold))
                                        .foregroundColor(Color.init(white: 0.7))
                                }
                                
                                if let changes = changelog.changes {
                                    
                                    ForEach(changes, id: \.self) { change in
                                        HStack {
                                            Circle()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color.blue)
                                            Text(change)
                                                .font(Font.system(.body, design: .rounded))
                                                .foregroundColor(Color.init(white: 0.9))
                                            Spacer()
                                        }
                                    }
                                }
                                
                                if let changes = changelog.proChanges {
                                    
                                    Text("Pro Changes")
                                        .font(Font.system(.body, design: .rounded).weight(.bold))
                                        .padding(.top, 10)
                                    
                                    ForEach(changes, id: \.self) { change in
                                        HStack {
                                            Circle()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color.green.lighter(by: 0.4))
                                            Text(change)
                                                .font(Font.system(.body, design: .rounded))
                                                .foregroundColor(Color.init(white: 0.9))
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.init(white: 0.25).cornerRadius(10))
                            .padding(.top, 10)
                        }
                    }
                        
                    Spacer()
                        .frame(height: 30)
                }
                .padding(20)
                .animation(nil)
            }
        }
        .onAppear {
            self.selectedVersion = VersionInformation.data.first
        }
    }
    
    func dateString(_ date: Date?, style: DateFormatter.Style) -> String {
        
        if let date = date {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = style
            dateFormatter.timeStyle = .none
            
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}


class VersionInformation: Equatable {
    
    var id: UUID
    var number: String
    var title: String
    var description: String
    var changelogs: [VersionChangelog]
    
    init(number: String, title: String, description: String, changelogs: [VersionChangelog] = []) {
        self.id = UUID()
        self.number = number
        self.title = title
        self.description = description
        self.changelogs = changelogs
    }
    
    static let data: [VersionInformation] = [
        
        VersionInformation(
            number: "2.0",
            title: "The Pro Update",
            description: """
                THE TIME HAS COME! After year in the making, we have now released OMEGA VERSION TWO. This is an enormous update – the biggest update EVER to Omega Calculator. Along with other features, it introduces a new pro version to the app: Omega Calculator Pro, now available for purchase.

                Omega Pro gives you access to lots of great features. The text pointer allows you to edit anywhere on the input line and add or remove characters. We’ve introduced variables – you can assign a value to a variable and recall it later, or use an unknown variable and plug values into it for quick results. Graphs and tables give you visual representations of changing variable values. And you can access advanced calculus functions like derivatives and integrals, and summation/product notation.

                We’ve also added a lot of utility features to Omega Pro that will hopefully improve your calculator experience. Your past calculations will expire after 180 days instead of 14, and you can organize your saved calculations into folders. You can export any or all of your past calculations to a CSV file, which can be made into a spreadsheet in another program. Also, you can use an external keyboard in place of the calculator buttons.

                There are also some changes to the main app for everyone. Placeholders make it easier to input functions with multiple arguments. The new MAT menu allows you to access any function in either device orientation, and it cleans up the clunky 1st/2nd/3rd button system we used to have. There are also various new small math functions.

                Finally, we’ve tried to improve the interface of the app a lot. Every menu has been redone to be more beautiful and seamless. You can now change the shape of the buttons to be more circular if you prefer, and you can set your favorite themes for easy access. We’ve added a new theme set: Gemstones, a beautiful selection of the finest jewels to add to your theme collection. You can preview themes now so you can see what they look like before unlocking. Check out the full changelog below.
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2022/08/15",
                    changes: [
                        "Added placeholder squares on input line",
                        "Added MAT menu to easily access math functions",
                        "Added quick actions in calculation toolbar: copy, save, assign",
                        "Added new Gemstones theme series",
                        "Added favorite themes and theme previews",
                        "Completely redesigned all menu interfaces",
                        "Added separate saved calculation menu",
                        "Added multiple calculation selection to calculation lists",
                        "Added randint function",
                        "Added permille function",
                        "Added button shape setting",
                        "Added sound effects and more haptics",
                        "Added What’s New descriptions for past updates",
                        "Support for up to 12 decimal places",
                        "Support for enormous exponentials",
                        "Created new app website"
                    ],
                    proChanges: [
                        "Added input line text pointer",
                        "Added letter menu and variables",
                        "Added stored variables menu and assign button",
                        "Added variable expressions and plug-in menu",
                        "Added graphing",
                        "Added value tables",
                        "Unlimited saved calculations",
                        "Added saved calculation folders",
                        "Changed recent calculations to last 180 days before expiring",
                        "Added calculation export menu to CSV",
                        "Added keyboard support for external iPad/Mac keyboards",
                        "Added derivatives and integrals",
                        "Added summation and product notation",
                        "Added special graphs such as unit circle, tangent line, area under the curve"
                    ]
                ),
                VersionChangelog(
                    number: 1,
                    date: "2022/10/09",
                    changes: [
                        "Minor bug fixes"
                    ]
                ),
                VersionChangelog(
                    number: 2,
                    date: "2022/11/27",
                    changes: [
                        "Added all themes to Omega Pro and removed individual purchases",
                        "Menu interface changes",
                        "Minor bug fixes"
                    ]
                )
            ]
        ),
        
        VersionInformation(
            number: "1.7",
            title: "The iOS 15 Update",
            description: """
                iOS 15 is here, and to support it, we have released Omega Calculator version 1.7.0. This update primarily fixes critical issues with the interface in iOS 15.

                In other news, in a continuing effort to modify and adapt the user interface for the optimal performance, we have decided to add a fifth row of buttons into the landscape view, back to how it looked in version 1.2 and earlier. This adds more functionality to a single screen. You can now access more buttons beyond the five rows by clicking "1st" which is now located in the top left.

                This version also brought the foundation for a number of amazing things which will be added to Omega Calculator in the future. But unfortunately, most of that is not ready yet and is currently concealed in this version. But stay tuned ...
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2021/09/22",
                    changes: [
                        "Added a fifth row of buttons in landscape mode",
                        "Added full support for iOS 15",
                        "Adjusted past calculation interface"
                    ]
                )
            ]
        ),
        
        VersionInformation(
            number: "1.6",
            title: "The World Update",
            description: """
                We are now releasing version 1.6.0 of Omega Calculator, the World Update. The app is now available in 10 different languages: English, Spanish, French, Chinese, German, Russian, Arabic, Italian, Portuguese, and Greek. Omega Calculator is going worldwide.

                This update brings huge changes that users have been asking for. At the top of the list is the long-awaited maximum shrink setting, which will force text to scroll instead of shrink after a certain amount. This makes inputting really long calculations so much easier. You can also customize your font style to one of four options.

                Another change is a massive overhaul to past calculations -- they are stored in a completely new format, and your old ones will convert automatically. Instead of being able to store up to 50, you can now store as many as you want for up to 14 days, in addition to saved calculations. The list should respond much faster and be less glitchy, and the interface is redesigned to be much better. You can copy and paste calculations now too, another popular request.

                The update will roll out over the next 7 days, or you can directly download it right now. Enjoy!
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2021/08/02",
                    changes: [
                        "Added maximum shrink for text - scrollable if expression is too long",
                        "Completely redesigned past calculation system, now stored in new format",
                        "Added new past calculation actions - copy and paste",
                        "You can now store as many past calculations as you want - disappear after 14 days if unsaved",
                        "Added support for Spanish, French, Chinese, German, Russian, Arabic, Italian, Portuguese, and Greek",
                        "Completely redesigned Guide menu into Reference menu, with individual pages for each button",
                        "Tweaked Error presentation",
                        "Added customizable font",
                        "Added haptic feedback option for buttons",
                        "Darker theme colors no longer blend in with background",
                        "Added keyboard support for iPads with command+button",
                        "Fixed bugs with repeating decimals and large exponentials",
                    ]
                ),
                VersionChangelog(
                    number: 1,
                    date: "2021/08/07",
                    changes: [
                        "Fixed bugs in the World Update",
                        "Added new regional settings section",
                        "Improved language translations"
                    ]
                ),
                VersionChangelog(
                    number: 2,
                    date: "2021/08/10",
                    changes: [
                        "Added new Super Omega Theme Pack"
                    ]
                )
            ]
        ),
        
        VersionInformation(
            number: "1.5",
            title: "The New Life Update",
            description: """
                We are now releasing version 1.5.0 of Omega Calculator, the New Life Update. This update brings a massive overhaul to all of the menus within the app. This includes the main menu, Settings, Past Calculations, and Themes. Settings is now much more user-friendly; less of a mess and more clear. New light, medium, and bold text weight options are included in Settings. There is a new "About" section with links to app services and general info about the app.

                With this update, several groups of themes have become premium content. We have done this in order to allow Omega to continue having great content in the future. We hope you understand. All users will be able to access the Basic and Colorful theme rows. The rest of the theme rows will now be premium; each set of four themes can be purchased for $0.99. However, users who downloaded Omega Calculator before 1.5 will also retain three additional free theme sets which are premium for everyone else: The Land, The Sea, and The Sky. With this theme upgrade, there is one new theme in the colorful category, available for everyone. It is called "Life" and is a nice bright green, replacing the now discontinued "Vibrant" theme.

                We have updated the Omega Calculator website to go along with this update. There is now a new Support tab with information to contact us. We have also redesigned and updated our privacy policy, now visible on the website itself. Check it out here.
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2021/06/28",
                    changes: [
                        "Completely overhauled all menu interfaces",
                        "Redesigned Settings to be much more user-friendly",
                        "Added About tab",
                        "Added new theme: \"Life\" (replacing \"Vibrant\")",
                        "Added premium themes",
                        "Increased maximum length of text before shrinking in landscape mode",
                        "Added light, medium, and bold font weight options",
                        "Design improved for iOS text size accessibility settings",
                        "Updated privacy policy",
                        "Now supports iOS 15"
                    ]
                ),
                VersionChangelog(
                    number: 1,
                    date: "2021/07/01",
                    changes: [
                        "Bug fixes",
                    ]
                )
            ]
        ),
        
        VersionInformation(
            number: "1.4",
            title: "The Repeater Update",
            description: """
                We are now releasing version 1.4.0 of Omega Calculator, the Repeater Update. This update brings repeating decimals which are formatted now with vinculums over the repeating digits. Repeating decimals appear as extra results when a calculation is done. For example, 1 ÷ 9 will yield 0.11111111 with 0.1̅ as an extra result. You can also input your own repeating decimal through the vinculum button in the 2nd button tab in landscape mode. This adds a repeating vinculum over a decimal digit; press it multiple times to repeat multiple digits.

                Rounding has also been improved with the update. Previously, any repeating decimal would be chopped at a certain number of digits, so it would lose its repeating property if any further calculations were performed. Now, it will retain its repetition. If you do 1 ÷ 9 and get 0.11111111, then multiply it by 9 again, you will get 1, where previously you would have gotten 0.99999999.
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2021/05/30",
                    changes: [
                        "Added repeating decimals",
                        "Repeating decimals appear as extra results",
                        "Added vinculum button to create a repeating decimal",
                        "Improved rounding of results"
                    ]
                )
            ]
        ),
        
        VersionInformation(
            number: "1.3",
            title: "The Probability Update",
            description: """
                Today we are releasing the Omega Calculator Probability Update, version 1.3.0 for iOS. This is the largest update since Omega's release. Seven new operations have been added: permutations, combinations, modulo, random number, round, floor, and ceiling. Permutations and combinations are important operations in probability to determine the amount of outcomes of a situation. Modulo is used mostly in computer science to compute the remainder of division. Random number enters an unknown number between 0 and 1, and round obviously rounds a number. Floor rounds a number down always; ceiling (ceil) rounds a number up always.

                These new buttons can be found throughout the newly redesigned landscape calculator arrangement. The 1st, 2nd, 3rd... function buttons have been placed at the bottom of the screen for quick access, and the rest of the buttons have been rearranged for more convenient access. There is also now a main menu for the app, accessible through the four horizontal lines in the top left (this used to be the settings button). The main menu lets you navigate around different parts of the app. The main calculator is first, then your stored & saved calculations. The Guide tab (formerly Information tab) is there too with a new overhaul of content, including a generic guide and expanded information. The Theme Tab (formerly accessible through settings) and the rest of settings are accessible below this.

                Speaking of settings, they have been tweaked. Two new settings let you use light (non-bolded) text for calculations and for buttons. There is also a new setting to automatically add parentheses after a trig function or logarithm. Two settings which are not used anymore have been removed: the return to 1st always and the show next button settings; the landscape view has been redesigned so these are no longer required.
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2021/03/12",
                    changes: [
                        "Added new operations:",
                        "Permutations",
                        "Combinations",
                        "Modulo",
                        "Random Number",
                        "Floor/Ceiling/Rounding",
                        "Adjusted landscape arrangement and added slider at bottom to access different buttons",
                        "Added main menu accessible in the top left of the screen",
                        "Expanded Guide menu to include generic information",
                        "Separated themes from settings; new Themes menu",
                        "Added new light text/button options in settings"
                    ]
                )
            ]
        ),
        
        VersionInformation(
            number: "1.2",
            title: "The Information Update",
            description: """
                The first content update for Omega Calculator has now been released. Version 1.2.0 brings a new Information tab in settings which is essentially a user guide; it tells you about the buttons' purposes and functionalities. This tab will likely be expanded in the future.

                Also, the new version includes over 30 new app icons which will automatically update when the theme is changed. You will have to change your theme in the new update for the icon change to take effect, but the app icon should now match the interface theme. A few themes have been reworked as well: the "Coral" theme was renamed to "Classic Pink" and brought up to the top row. A new purple-blue "Coral" has been created for the "The Sea" category. To match the new "Classic Pink," the old "Classic" was also renamed to "Classic Blue."
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2020/11/22",
                    changes: [
                        "Added information tab in Settings to get info about different buttons' functionalities",
                        "Renamed \"Classic\" theme to \"Classic Blue\"; \"Coral\" theme to \"Classic Pink\"; new \"Coral\" theme created instead",
                        "Changing the theme of the interface will now also change the app icon to match it"
                    ]
                )
            ]
        ),
            
        VersionInformation(
            number: "1.1",
            title: "The iOS 14 Update",
            description: """
                Omega Calculator 1.1.0 has been released on the App Store. This is a minor update to fix glitches with the user interface on devices running iOS 14. The whole app should be back to its old self.
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2020/09/28",
                    changes: [
                        "Now supports iOS 14"
                    ]
                )
            ]
        ),
                
        VersionInformation(
            number: "1.0",
            title: "Omega Calculator",
            description: """
                Omega Calculator has officially been released on the App Store. The app has been gradually built over the past four months and is finally ready for use. It is a unique and innovative tool for making calculations in a sleek and beautiful way.
                """,
            changelogs: [
                VersionChangelog(
                    number: 0,
                    date: "2020/08/30",
                    changes: [
                        "Omega Calculator released"
                    ]
                )
            ]
        )
    ]
    
    static func == (lhs: VersionInformation, rhs: VersionInformation) -> Bool {
        return lhs.number == rhs.number
    }
}

class VersionChangelog {
    
    var id: UUID
    var number: Int
    var date: Date
    var changes: [String]?
    var proChanges: [String]?
    
    init(number: Int, date: String, changes: [String]? = nil, proChanges: [String]? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        self.id = UUID()
        self.number = number
        self.date = formatter.date(from: date) ?? Date()
        self.changes = changes
        self.proChanges = proChanges
    }
}
