*** Settings ***
Library  SeleniumLibrary

*** Variables ***
   # ----- Login page locators ----- #
${signIn_form}             xpath://form[@name="signInForm"]
${username_textbox}        xpath://input[@id="email"]
${password_textbox}        xpath://input[@id="password"]
${signIn_button}           xpath://button[@value="Sign In"]
${bn_logo}                 xpath://div[@class="productLogo"]
${signIn_error_msg}         xpath://div[contains(text(),"Your email/password combination was not recognized")]
#//*[@id="sign-in-form"]/div[5]/div

   # ----- Landing page locators ----- #
${Ads_dropDown}            xpath://a[text()="Ads "]
${amazon_from_Ads}         xpath://a[contains(text(),"Amazon") and contains(@href,"https://search.bnservers.com/ads/amazon?")]
${landing_page_logo}       xpath://div/a[@class="productLogo" and @href="/#/home"]
${user_profile_grid}       xpath://div[contains(@class, "userName rightFloat")]
${signOut_button}          xpath://li//a[text()='Logout']

   # ----- Amazon tab locators ----- #
${accounts_tab_label}      xpath://a[text()='Accounts']
${portfolio_tab_label}     xpath://a[text()='Portfolio']
${campaigns_tab_label}     xpath://a[text()='Campaigns']
${adset_tab_label}         xpath://a[text()='AdSet']
${ads_tab_label}           xpath://a[text()='Ads']
${target_tab_label}        xpath://a[text()='Target']
${keywords_tab_label}      xpath://a[text()='Keywords']
${myjobs_tab_label}        xpath://a[text()='My Jobs']

   # ----- iris webpage locators ----- #
${iris_logo}               xpath://div[@class="iris-logo"]
${iris_username_textbox}   xpath://input[@id="email"]
${iris_passsword_textbox}  xpath://input[@id="password"]
${iris_signIn_button}      xpath://button[@value="Sign In"]
${iris_monitor_button}     xpath://a[@analytics-label="Monitor"]
${iris_landing_logo}       xpath://div[@class="iris-logo"]
${iris_refresh_button}    xpath://div[@class="button refresh"]
${iris_user_pane}          xpath://div[@shift-avatar="context.currentUser"]
${iris_signOut_button}     xpath://div[text()="Log Out"]