*** Settings ***
Documentation       Sepsi joulkalenterinumerot
Library             RPA.Browser.Selenium
Library             String

*** Variables ***
${URL}=         https://www.sepsi78.net/uutiset/131675/joulukalenteriarpa-2022

# Current date form at to 2.12 
${time} =       ${{ datetime.datetime.now().strftime("%d.%m").replace("0", "") }}
${xpathtoobj} =    xpath://*[@id="page-content"]/div/div/div[1]/div[1]/div[2]

*** Tasks ***
Hae ne voittonumerot
    Avaa nettiselain
    Ota kuvankaappaus
    ${voittonumero}=    Ota taulukko
    Log    ${voittonumero}    console=yes

*** Keywords ***
Avaa nettiselain
    Open Available Browser    ${URL}

Ota kuvankaappaus
    Capture Element Screenshot    	${xpathtoobj}   voittotaulukko-${time}.png

Ota taulukko
    ${osio missa numerot} =    Get Text    ${xpathtoobj}
    ${voittorivi} =	Get Lines Containing String    ${osio missa numerot}	${time}
    Log    ${voittorivi}    console=yes
    ${viimeisinvoittonumero} =  Get Regexp Matches      ${voittorivi}     [0-9]+\.12\..+?([0-9][0-9][0-9][0-9]).+    1
    [Return]    ${viimeisinvoittonumero}