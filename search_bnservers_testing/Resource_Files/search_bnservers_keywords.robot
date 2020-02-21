*** Settings ***
Library  SeleniumLibrary
Resource  ../search_bn_servers_locators.robot
Resource  ../search_bn_servers_testdata.robot

*** Variables ***


*** Keywords ***
    #KEYWORD                        #LOCATORS                   #ARGUEMENTS

signIn_to_iris
    [Documentation]                 This is to validate signIn behavior when supplied login credentials.
    [Arguments]                     ${iris_username}  ${iris_password}
    Go To                           ${iris_url}
    Maximize Browser Window
    Page Should Contain Element     ${iris_logo}
    Input Text                      ${iris_username_textbox}    ${iris_username}
    Input Password                  ${iris_passsword_textbox}   ${iris_password}
    Click Element                   ${iris_signIn_button}   
    Wait Until Page Contains Element  ${iris_monitor_button}        30s
    sleep    5s
    Page Should Contain Element     ${iris_landing_logo}
    # Wait Until Page Contains Element  ${iris_refresh_button}         30s
    Log                             iris SignIn is successfully validated.

signOut_iris
    [Documentation]                 This is to validate the singOut
    Click Element                   ${iris_user_pane}
    Click Element                   ${iris_signOut_button}
    Wait Until Page Contains Element  ${iris_username_textbox}      30s
    Page Should Contain Element     ${iris_logo}
    Page Should Contain Element     ${iris_passsword_textbox}
    Log                             iris SignOut is successful.

signIn_to_search_bn_servers
    [Arguments]                     ${driver}  ${username}  ${password}
    Maximize Browser Window
    Wait Until Page Contains Element  ${signIn_form}                30s
    Page Should Contain Element     ${bn_logo}
    Input Text                      ${username_textbox}         ${username}
    Input Password                  ${password_textbox}         ${password}
    Click Element                   ${signIn_button}
    Log                             Able to perform login action.

validate_landing_page
    Wait Until Page Contains Element  ${landing_page_logo}          30s
    Log                             Login is successful.
    Mouse Over                      ${Ads_dropDown}
    Page Should Contain Element     ${amazon_from_Ads}
    Log                             Home page looks fine.

validate_amazon_grid_ui
    Mouse Over                      ${Ads_dropDown}
    Page Should Contain Element     ${amazon_from_Ads}
    Click Element                   ${amazon_from_Ads}
    Wait Until Page Contains Element  ${accounts_tab_label}         30s
    Click Element                   ${portfolio_tab_label}
    Click Element                   ${campaigns_tab_label}
    Click Element                   ${adset_tab_label}
    Click Element                   ${ads_tab_label}
    Click Element                   ${target_tab_label}
    Click Element                   ${keywords_tab_label}
    Click Element                   ${myjobs_tab_label}
    Log                             Able to locate and click all the tabs in the amazon grid.

validate_invalid_signIn
    [Arguments]                     ${driver}  ${bad_username}  ${bad_password}

    signIn_to_search_bn_servers     ${driver}  ${bad_username}  ${bad_password}
    Wait Until Page Contains Element  ${signIn_error_msg}           30s
    Log                             As the above supplied credentials are not created in iris, user cannot log into search.bnservers.com

signOut_search_bn_servers
    Click Element                   ${user_profile_grid}
    Click Element                   ${signOut_button}
    Wait Until Page Contains Element  ${signIn_button}              30s
    Page Should Contain Element     ${signIn_form}
    Log                             Logout is successful.

close_session
    signOut_search_bn_servers
    Close Browser
    Log                             Browser session terminated successfully.

close_all_sessions
    Close All Browsers
    Log                             All sessions are terminated successfully.