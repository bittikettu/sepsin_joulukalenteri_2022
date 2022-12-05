*** Settings ***
Documentation       Sepsi joulkalenterinumerot
Library             RPA.Browser.Selenium
Library             String
Library             RPA.Notifier
Library             RPA.Robocorp.Vault

*** Variables ***
${URL}=         https://www.sepsi78.net/uutiset/131675/joulukalenteriarpa-2022

# Current date form at to 2.12 
${time} =       ${{ datetime.datetime.now().strftime("%d.%m").replace("0", "") }}
${xpathtoobj} =    xpath://*[@id="page-content"]/div/div/div[1]/div[1]/div[2]

*** Tasks ***
Hae ne voittonumerot
    Avaa nettiselain
    Ota kuvankaappaus
    TRY
        ${voittorivi}=    Ota voittorivi
    EXCEPT    Paivan numero ei julkinen
        Fail    Päivän numeroa ei ole vielä arvottu
    END
    Laheta telegram viesti    ${voittorivi}
    ${voittonumero}=    Poimi voittonumero    ${voittorivi}
    Log    ${voittonumero}    console=yes

*** Keywords ***
Avaa nettiselain
    Open Available Browser    ${URL}

Ota kuvankaappaus
    Capture Element Screenshot    	${xpathtoobj}   voittotaulukko-${time}.png

Ota voittorivi
    ${osio missa numerot} =    Get Text    ${xpathtoobj}
    ${voittorivi}=     Get Lines Containing String    ${osio missa numerot}    ${time}
    Should Not Be Empty    ${voittorivi}    msg=Paivan numero ei julkinen
    Log    ${voittorivi}    console=yes
    [Return]    ${voittorivi}

Laheta telegram viesti
    [Arguments]    ${voittorivi}
    ${secret}=    Get Secret    telegram
    Notify Telegram    ${voittorivi}    ${secret}[chid]    ${secret}[apikey]

Poimi voittonumero
    [Arguments]    ${voittorivi}
    ${viimeisinvoittonumero}=    Get Regexp Matches      ${voittorivi}     \d{1,2}\.12\..+?(\d{1,4}).+    1
    [Return]    ${viimeisinvoittonumero}

