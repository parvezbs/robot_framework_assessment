*** Settings ***
Library  SeleniumLibrary
Resource  ../search_bn_servers_locators.robot
Resource  ../search_bn_servers_testdata.robot
Resource  ../Resource_Files/search_bnservers_keywords.robot

Suite Setup       Open Browser      ${base_url}     ${driver}
Test Setup        Go To             ${base_url}
Suite Teardown    close_all_sessions

*** Test Cases ***

Validate user login across iris and clickable with same user credentials
    [Documentation]                 To validate login across iris and clickable happens with the same user credentials
    [Tags]                          amazon  amazon_sanity
    signIn_to_search_bn_servers     ${driver}  ${iris_username}  ${iris_password}
    validate_landing_page
    signOut_search_bn_servers
    signIn_to_iris                  ${iris_username}  ${iris_password}
    signOut_iris

Validate Login and amazon tab GUI on search.bnservers.com with valid credentials
    [Documentation]                 To validate login and page navigations to amazon tab are working as expected.
    [Tags]                          amazon    amazon_sanity
    signIn_to_search_bn_servers     ${driver}  ${username}  ${password}
    validate_landing_page
    validate_amazon_grid_ui
    signOut_search_bn_servers

Validate Login functionality of search.bnservers.com with bad credentials
    [Documentation]                 To validate credentials that are not created in iris cannot be used to login to this platform
    [Tags]                          amazon    amazon_sanity    amazon_negative_test
    validate_invalid_signIn         ${driver}  ${bad_username}  ${bad_password}

