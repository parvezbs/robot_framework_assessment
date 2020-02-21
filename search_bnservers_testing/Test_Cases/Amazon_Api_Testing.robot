*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../Resource_Files/Amazon_Ad_API_keywords.robot
Resource    ../search_bn_servers_testdata.robot

*** Test Cases ***

E2E flow of creation of all entities on amazon advertisement
    [Documentation]     To generate access token, create campaign, adgroup, ads, keywords
    ${scope_id}=        get_seller_profiles
    Log                 ${\n} Successfully fetched profile with Id: ${scope_id}
    ${portfolioId}=     create_ad_portfolio
    Log                 ${\n} Successfully created adGroup with Id: ${portfolioId}
    ${campaignId}=      create_ad_campaign
    Log                 ${\n} adCampaign created successfully with Id: ${campaignId}
    ${adGroups}=        create_ad_group     10
    Log                 ${\n} Successfully created requested number of adGroups with Ids: ${adGroups}
    ${productAds}=      create_prodcutAd  20
    Log                 ${\n} Successfully created requested number of productAds with Ids: ${productAds}
    
E2E flow to get all entities from amazon advertisement
    [Documentation]     To get all the created data under the provided account
    ${portfolioId_list}=    get_portfolios_by_params    name
    Log                     ${\n} Successfully Collected all the existing portfolioIds: ${portfolioId_list}
    ${campaignId_list}=     get_campaigns_by_params     name
    Log                     ${\n} Successfully Collected all the existing campaignIds: ${campaignId_list}
    ${adGroupId_list}=      get_adGroups_by_params      name
    Log                     ${\n} Successfully Collected all the existing adGroupIds: ${adGroupId_list}
    ${ProductAdId_list}=    get_productAds_by_params    sku
    Log                     ${\n} Successfully Collected all the existing ProductAdIds: ${ProductAdId_list}

E2E get all the active/enabled entities
    [Documentation]     To list all the active and enabled entities for the provided account



# Create dummy ad-campaign

# Create dummy ad-group

# Create dummy ad
