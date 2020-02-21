*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     json
Library     OperatingSystem
Library     UUID.py
Library     BuiltIn
Resource    json_handler.robot
Resource    ../search_bn_servers_testdata.robot

*** Variables ***
${portfolio_template}    ${CURDIR}${/}../templates/create_ad_portfolio.json
${campaign_template}     ${CURDIR}${/}../templates/create_ad_campaign.json
${adGroup_template}      ${CURDIR}${/}../templates/create_ad_group.json
${productAd_template}    ${CURDIR}${/}../templates/create_ProductAd.json

*** Keywords ***
generate_auth_token
    [Documentation]     To generate a auth token to access the seller account as a third party developer
    [Arguments]         ${client_id}    ${refresh_token}    ${client_secret}

    Create Session      generate_auth_token     ${amazon_oauth_url}    verify=True
	${params}=          Create Dictionary       grant_type=refresh_token  
    ...                                         client_id=${client_id}  
    ...                                         refresh_token=${refresh_token}  
    ...                                         client_secret=${client_secret}
    ${headers}=         Create Dictionary       Content-Type=application/x-www-form-urlencoded
    ...                                         charset=UTF-8

    ${resp}=            Post Request     generate_auth_token    /token    data=${params}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    Log                 ${resp.json()}
    Log                 Authentication token created successfully.
    ${amazon_auth_token}=   Get From Dictionary     ${resp.json()}      access_token
    [Return]            ${amazon_auth_token}


get_seller_profiles
    [Documentation]     To GET the list of active seller profiles under the seller account.

    ${auth_token}=      generate_auth_token  ${client_id}  ${refresh_token}  ${client_secret}
    Set Global Variable  ${auth_token}
    ${UUID}=       generate_UUID
    ${random}=     Evaluate    str("${uuid}")[:8]
    Set Global Variable  ${random}
    Create Session      fetch_profiles     ${amazon_url}    verify=true
    ${headers}=         Create Dictionary   Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    
    ${resp}=            Get Request  fetch_profiles  /profiles  headers=${headers}
    Log                 ${resp.content}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${country_code}=     Get From Dictionary    ${resp.json()[0]}      countryCode
    ${scope_id_temp}=    Run Keyword If  "${country_code}"=="US"    Get From Dictionary    ${resp.json()[0]}      profileId
    ${scope_id}=         Convert To String  ${scope_id_temp}
    Set Global Variable  ${scope_id}
    [Return]             ${scope_id}
    Log                  All existing profiles are fetched successfully.

create_ad_portfolio
    [Documentation]     To create a new ad portfolio

    Create Session      create_portfolio    ${amazon_url}   verify=True
    ${headers}=         Create Dictionary   Accept=*/*
    ...                                     Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    ${map}=        Create Dictionary        name=portfolio_${random}    amount=20      state=enabled
    ${data}=       Fill JSON Template File  ${portfolio_template}      ${map}
    Log            ${data}
    ${resp}=       Post Request     create_portfolio     /portfolios      headers=${headers}      data=${data}
    Should Be Equal As Strings  ${resp.status_code}         207
    Log                  Portfolio posted successfully.
    ${code}=             Get From Dictionary    ${resp.json()[0]}      code
    ${portfolioId_temp}=  Run Keyword If  "${code}"=="SUCCESS"    Get From Dictionary    ${resp.json()[0]}      portfolioId
    ${portfolioId}=       Convert To String  ${portfolioId_temp}
    Set Global Variable  ${portfolioId}
    [Return]             ${portfolioId}
    Log                  Created portfolio successfully.

create_ad_campaign
    [Documentation]     To create a new ad campaign under the provided scope

    Create Session      create_campaign     ${amazon_url}   verify=True
    ${headers}=         Create Dictionary   Accept=*/*
    ...                                     Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    ${map}=        Create Dictionary        campaign_name=campaign_${random}      campaign_type=auto
    ${data}=       Fill JSON Template File  ${campaign_template}      ${map}
    Log            ${data}
    ${resp}=       Post Request     create_campaign     /campaigns      headers=${headers}      data=${data}
    Should Be Equal As Strings  ${resp.status_code}         207
    Log                  Ad campaign posted successfully.
    ${code}=             Get From Dictionary    ${resp.json()[0]}      code
    ${campaignId_temp}=  Run Keyword If  "${code}"=="SUCCESS"    Get From Dictionary    ${resp.json()[0]}      campaignId
    ${campaignId}=       Convert To String  ${campaignId_temp}
    Set Global Variable  ${campaignId}
    [Return]             ${campaignId}
    Log                  Created campaign successfully.

create_ad_group
    [Documentation]     To create multiple new ad groups under the provided scope
    [Arguments]         ${no_of_adGroups}
    Create Session      create_adGroup      ${amazon_url}   verify=True
    ${headers}=         Create Dictionary   Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    @{adGroupId_list}=    Create List
    :FOR    ${i}    IN RANGE    1    ${no_of_adGroups}
    \   ${map}=         Create Dictionary       name=adGroup_${random}${i}    campaignId=${campaignId}    state=enabled
    \   ${data}=        Fill JSON Template File  ${adGroup_template}  ${map}
    \   Log             ${data}
    \   ${resp}=        Post Request    create_adGroup      /adGroups       headers=${headers}      data=${data}
    \   Should Be Equal As Strings  ${resp.status_code}         207
    \   Log             Ad Group posted successfully.
    \   ${code}=             Get From Dictionary    ${resp.json()[0]}      code
    \   ${adGroupId_temp}=  Run Keyword If  "${code}"=="SUCCESS"    Get From Dictionary    ${resp.json()[0]}      adGroupId
    \   ${adGroupId}=       Convert To String  ${adGroupId_temp}
    \   Append To List      ${adGroupId_list}  ${adGroupId}
    Set Global Variable     ${adGroupId_list}
    [Return]                ${adGroupId_list}

create_prodcutAd
    [Documentation]     To create mutiple ads under a specific adGroup
    [Arguments]         ${no_of_ads}
    Create Session      create_ad           ${amazon_url}   verify=True
    ${headers}=         Create Dictionary   Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    @{adsId_list}=    Create List
    ${adGroupId}=     Get From List  ${adGroupId_list}  0
    :FOR    ${i}    IN RANGE    1    ${no_of_ads}
    \   ${map}=         Create Dictionary   adGroupId=${adGroupId}    campaignId=${campaignId}  state=enabled  sku=${random}${i}
    \   ${data}=        Fill JSON Template File  ${productAd_template}  ${map}
    \   Log             ${data}
    \   ${resp}=        Post Request    create_ad      /productAds      headers=${headers}      data=${data}
    \   Should Be Equal As Strings  ${resp.status_code}         207
    \   Log             Product Ad posted successfully.
    \   ${code}=        Get From Dictionary    ${resp.json()[0]}      code
    \   ${ad_Id_temp}=  Run Keyword If  "${code}"=="SUCCESS"    Get From Dictionary    ${resp.json()[0]}      adId
    \   ${ad_Id}=       Convert To String  ${ad_Id_temp}
    \   Append To List      ${adsId_list}  ${ad_Id}
    Set Global Variable     ${adsId_list}
    [Return]                ${adsId_list}

get_portfolios_by_params
    [Documentation]     To get all the portfolios that are created for the selected account by parsed parameter from test case page
    [Arguments]         ${param}
    Create Session      get_portfolios      ${amazon_url}    verify=True
    ${headers}=         Create Dictionary   Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    @{portfolio_list}=  Create List
    ${resp}=            Get Request  get_portfolios  /portfolios  headers=${headers}
    Log                 ${resp.content}
    Should Be Equal As Strings  ${resp.status_code}  200

    ${portfolioId_list}=    Get KeyList from Response   ${resp.content}     ${param}
    Set Global Variable  ${portfolioId_list}
    [Return]             ${portfolioId_list}
    Log                  All existing portfolioIds are fetched successfully.

get_campaigns_by_params
    [Documentation]     To get all the campaigns that are created for the selected account by parsed parameter from test case page
    [Arguments]         ${param}
    Create Session      get_campaigns      ${amazon_url}    verify=True
    ${headers}=         Create Dictionary   Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    @{campaignId_list}=  Create List
    ${resp}=            Get Request  get_campaigns  /campaigns  headers=${headers}
    Log                 ${resp.content}
    Should Be Equal As Strings  ${resp.status_code}  200
    #####
    ${updatedResponse}=    Get NonArchived Response    ${resp.content}
    #####
    ${campaignId_list}=    Get KeyList from Response   ${updatedResponse}     ${param}
    Set Global Variable  ${campaignId_list}
    [Return]             ${campaignId_list}
    Log                  All existing CampaignIds are fetched successfully.

get_adGroups_by_params
    [Documentation]     To get all the AdGroups that are created for the selected account by parsed parameter from test case page
    [Arguments]         ${param}
    Create Session      get_adGroups      ${amazon_url}    verify=True
    ${headers}=         Create Dictionary   Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    @{adGroupId_list}=  Create List
    ${resp}=            Get Request  get_adGroups  /adGroups  headers=${headers}
    Log                 ${resp.content}
    Should Be Equal As Strings  ${resp.status_code}  200
    #####
    ${adGroupId_list}=    Get KeyList from Response   ${resp.content}     ${param}
    Set Global Variable  ${adGroupId_list}
    [Return]             ${adGroupId_list}
    Log                  All existing AdGroupIds are fetched successfully.

get_productAds_by_params
    [Documentation]     To get all the AdGroups that are created for the selected account by parsed parameter from test case page
    [Arguments]         ${param}
    Create Session      get_productAds    ${amazon_url}    verify=True
    ${headers}=         Create Dictionary   Content-Type=application/json
    ...                                     Authorization=${auth_token}
    ...                                     Amazon-Advertising-API-ClientId=${client_id}
    ...                                     Amazon-Advertising-API-Scope=${scope_id}
    @{ProdcutAdId_list}=  Create List
    ${resp}=            Get Request  get_productAds  /productAds  headers=${headers}
    Log                 ${resp.content}
    Should Be Equal As Strings  ${resp.status_code}  200
    #####
    ${ProdcutAdId_list}=    Get KeyList from Response   ${resp.content}     ${param}
    Set Global Variable  ${ProdcutAdId_list}
    [Return]             ${ProdcutAdId_list}
    Log                  All existing productAdIds are fetched successfully.


