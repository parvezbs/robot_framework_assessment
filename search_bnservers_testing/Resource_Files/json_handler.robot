*** Settings ***
Documentation     This resource is filling out json string templates and returning the json back
Library 	      RequestsLibrary
Library           StringTemplater.py
Library           json_reader.py
Library           OperatingSystem

*** Keywords ***
Fill JSON Template
    [Documentation]    Runs substitution on json object to return a filled in json
    [Arguments]    ${json}    ${arguments}
    ${returned_string}=    template_string    ${json}    ${arguments}
    ${returned_json}=  To Json    ${returned_string}
    [Return]    ${returned_json}

Fill JSON Template File
    [Documentation]    Runs substitution on template to return a filled in json
    [Arguments]    ${json_file}    ${arguments}
    ${json}=    OperatingSystem.Get File    ${json_file}
    ${returned_json}=  Fill JSON Template    ${json}    ${arguments}
    [Return]    ${returned_json}

Get KeyList from Response
    [Documentation]    Fetches the reuqested key's values in a list from response json
    [Arguments]    ${response}     ${key}
    ${KeyList}=    get_values      ${response}     ${key}
    [Return]    ${KeyList}

Get NonArchived Response
    [Documentation]    Return response json object by removing the archived entities from it
    [Arguments]     ${response}
    ${updatedResponse}=  filter_archived_entities   ${response}
    Log         ${updatedResponse}
    [Return]    ${updatedResponse}

