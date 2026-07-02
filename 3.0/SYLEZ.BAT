@echo off
color f0
setlocal enabledelayedexpansion

:menu
cls
echo ==========================================================================
echo  WWW.ALANKING.PL     PROGRAM COMMANDER (PCD) Alan Makowski
echo ==========================================================================
echo GODANIYM PLYKAMI                     ^|  USTAWIENIA I OPCJE PROGRAMU
echo ==========================================================================
echo 1. Pokoz zawartosc katalogu          ^|
echo 2. Otworz w nowym oknie              ^|
echo 3. Zmyn katalog (DIR)                ^|
echo 4. ZAKONCZ                           ^|  p. Personalizacyjo interfejsu
echo 5. Stworz plyk                       ^|     Jezyk: Sylezyjski (Slaski)
echo 6. Stworz katalog (DIR)              ^|
echo 7. Zmyn nazwa                        ^|
echo 10. Historyjo robionych operacyji    ^|
echo 11. Wycyst historyjo operacyji       ^|
echo 12. Analizuj katalog (DIR)           ^|
echo 13. Kompresuj do archiwum (ZIP)      ^|=================================
echo 14. Szukej plyki                     ^| Program powstal 14.03.25,
echo 15. Nowy tekstowy plyk (.TXT)        ^|
echo 16. Obejrzij tekstowy plyk (.TXT)    ^| ostatnia aktualizacja 17.03.25.
echo ==========================================================================
set /p choice=Wybierz opcje: 

if "%choice%"=="1" goto list_dir
if "%choice%"=="2" goto open_item
if "%choice%"=="3" goto change_dir
if "%choice%"=="4" goto exit
if "%choice%"=="5" goto create_file
if "%choice%"=="6" goto create_dir
if "%choice%"=="7" goto rename_item
if "%choice%"=="10" goto view_history
if "%choice%"=="11" goto clear_history
if "%choice%"=="12" goto analyze_folder
if "%choice%"=="13" goto create_zip
if "%choice%"=="14" goto search_files
if "%choice%"=="15" goto create_new_file
if "%choice%"=="16" goto view_txt_files
echo Niepoprawny wybor. Sproboj jeszcze roz.
pause
goto menu

:list_dir
cls
echo ==========================================================================
echo                      ZAWARTOSC AKTUALNEGO KATALOGU
echo ==========================================================================
dir /b
call :log_action "Pokazano zawartosc katalogu %cd% (Data: %date% Godzina: %time%)"
pause
goto menu

:open_item
cls
set /p item=Podaj nazwa plyku abo katalogu do otwarcio: 
if exist "%item%" (
    start "" "%item%"
    call :log_action "Otworzono %item% (Data: %date% Godzina: %time%)"
    echo Otworzono %item%.
) else (
    echo Plyk abo katalog %item% niy istoje!
)
pause
goto menu

:change_dir
cls
set /p newdir=Podaj sciezka katalogu, do kerego chcesz przejsc: 
if exist "%newdir%" (
    cd /d "%newdir%"
    call :log_action "Zmiana katalogu na %newdir% (Data: %date% Godzina: %time%)"
    echo Zmieniono katalog na: %newdir%.
) else (
    echo Katalog %newdir% niy istoje!
)
pause
goto menu

:create_file
cls
set /p newfile=Podaj nazwa plyku do stworzenia (np. plyk.txt): 
if exist "%newfile%" (
    echo Plyk %newfile% juz istoje!
) else (
    echo. > "%newfile%"
    call :log_action "Stworzono plyk: %newfile% (Data: %date% Godzina: %time%)"
    echo Plyk %newfile% zostol stworzony.
)
pause
goto menu

:create_dir
cls
set /p newdir=Podaj nazwa katalogu do stworzenia: 
if exist "%newdir%" (
    echo Katalog %newdir% juz istoje!
) else (
    mkdir "%newdir%"
    call :log_action "Stworzono katalog: %newdir% (Data: %date% Godzina: %time%)"
    echo Katalog %newdir% zostol stworzony.
)
pause
goto menu

:rename_item
cls
set /p oldname=Podaj nazwa istojacego plyku/katalogu: 
if not exist "%oldname%" (
    echo Plyk abo katalog %oldname% niy istoje!
    pause
    goto menu
)
set /p newname=Podaj nowo nazwa: 
rename "%oldname%" "%newname%"
call :log_action "Zmyniono nazwa z %oldname% na %newname% (Data: %date% Godzina: %time%)"
echo Nazwa %oldname% zostala zmyniono na %newname%.
pause
goto menu

:view_history
cls
echo ==========================================================================
echo                       HISTORYJO WYKONANYCH OPERACYJI
echo ==========================================================================
if not exist log.txt (
    echo Brak zapisanych operacyji.
    pause
    goto menu
)
type log.txt
pause
goto menu

:clear_history
cls
echo Czyszczy historyjo operacyji...
timeout /t 2 > nul
del log.txt
echo Historyjo zostala wyczyszczono!
pause
goto menu

:log_action
rem Funkcyjo dodajonco wpis do logu
echo %~1 >> log.txt
exit /b

:customize_colors
cls
echo ==========================================================================
echo                     PERSONALIZACYJO INTERFEJSU
echo ==========================================================================
echo Wybierz szymat kolorow:          0. Wlasny - sam podoj kolory
echo 1. Domyslny - jasnozolte tlo, czerwony tekst
echo 2. Kontrastowy - czorne tlo, jasnozolty tekst
echo 3. Nocny - czorne tlo, bioły tekst
echo 4. Dzienny - biołe tlo, czorny tekst
echo 5. Czerwone tlo, zolty tekst (mniej polecane)
echo 6. Jasnozolte tlo, czorny tekst    
echo ==========================================================================
set /p choice=Wybierz opcje (1-5): 

if "%choice%"=="1" (color EC & call :save_color "EC" & goto menu)
if "%choice%"=="2" (color 0E & call :save_color "0E" & goto menu)
if "%choice%"=="3" (color 07 & call :save_color "07" & goto menu)
if "%choice%"=="4" (color F0 & call :save_color "F0" & goto menu)
if "%choice%"=="5" (color CE & call :save_color "CE" & goto menu)
if "%choice%"=="6" (color E0 & call :save_color "E0" & goto menu)
if "%choice%"=="0" goto custom_color
echo Niypoprawny wybór. Sproboj ponownie.
pause
goto customize_colors

:search_files
cls
echo ==========================================================================
echo                        SZUKANIY PLYKOW
echo ==========================================================================
echo Podoj wzor szukaniy, np.:
echo - *.txt  (wszystkie tekstowe plyki)
echo - *nazwa* (plyki co majom "nazwa" w nazwi)
echo - *       (wszystkie plyki)
echo Wpisz 'menu', coby wrócic do menu glownego.
echo ==========================================================================
set /p search=Podoj wzor: 

:: Opcja powrotu do menu glownego
if /i "%search%"=="menu" goto menu

:: Szukaniy plykow
echo Szukom plykow co pasujom do wzorca: %search%
dir %search% /s /b

:: Opcja zapisu wynikow do plyku
echo ==========================================================================
echo Chcesz zapisac wyniki szukaniy do plyku? (t/n)
set /p save_to_file=
if /i "%save_to_file%"=="t" (
    dir %search% /s /b > search_results.txt
    echo Wyniki zapisano w plyku search_results.txt
)

:: Powrot do menu glownego
echo ==========================================================================
echo Nacisnij jaki kolwiek klawisz, coby wrócic do menu glownego.
pause
goto menu

:reset_colors
cls
if exist color_config.txt (
    set /p default_color=<color_config.txt
    color %default_color%
    call :log_action "Kolory ustawiylismy na domyslne: %default_color% (Data: %date% Godzina: %time%)"
    echo Przywrócylismy kolory do domyslnych z plyku color_config.txt: %default_color%.
) else (
    echo Plyk color_config.txt niy istoje! Upewnij sie, ze plyk zawiyro domyslny kod koloru.
)
pause
goto menu


:save_color
echo %1>color_config.txt
call :log_action "Zapisano kolor interfejsu: %1 (Data: %date% Godzina: %time%)"
exit /b

:custom_color
cls
echo ==========================================================================
echo                  USTAWIYNIE WLASNEGO SCHEMATU KOLOROW
echo ==========================================================================
echo Podoj kolor tla i tekstu we formacie XY:
echo X - kolor tla, Y - kolor tekstu.
echo Dostympne kolory:
echo 0 - Czorny, 1 - Niebieski, 2 - Zielony, 3 - Turkusowy
echo 4 - Czerwony, 5 - Fioletowy, 6 - Zolty, 7 - Bioly
echo 8 - Szary, 9 - Jasnoniebieski, A - Jasnozielony
echo B - Jasnoturkysowy, C - Jasnoczerwony, D - Jasnofioletowy
echo E - Jasnozolty, F - Intensywnie bioly
echo ==========================================================================
set /p custom=Podoj kod koloru: 
color %custom%
call :save_color "%custom%"
goto menu

:info
cls
echo ==========================================================================
echo         INFO Ô PROGRAMIE
echo ==========================================================================
echo Jek chcesz zmynić kolor domyslny, wejdz do plyku config_colors.txt
echo tam zmynisz kolor na domyslny.
call :log_action "Wjyncie do 'info': %1 (Data: %date% Godzina: %time%)"
pause
goto menu

:exit
cls
echo ==========================================================================
echo                 DZIYNKUJEMY ZA SKORZISTANIE Z PROGRAM COMMANDER!
echo ==========================================================================
pause
exit

:analyze_folder
cls
echo ==========================================================================
echo                      ANALIZA KATALOGU
echo ==========================================================================
set /p folder=Podoj sciezka katalogu do analizy: 

:: Sprawdzynie, czy katalog istoje
if not exist "%folder%" (
    echo Podany katalog niy istoje! Sprawdz sciezka i sproboj ponownie.
    pause
    goto menu
)

echo Analizuja katalog: %folder%
set "file_count=0"
set "total_size=0"

:: Liczynie liczby plykow
for /f "tokens=5*" %%A in ('dir "%folder%" /a:-d /s ^| findstr "plikow Plyk"') do (
    set /a file_count+=%%A
)

:: Ôbycza calkowity rozmiar plykow
for /f "tokens=3" %%A in ('dir "%folder%" /a:-d /s ^| findstr "bajtow Ogolnie"') do (
    set /a total_size+=%%A
)

:: Pokoz wyniki analizy
echo ==========================================================================
echo Wyniki analizy:
echo - Liczba plykow w katalogu: %file_count%
echo - Calkowity rozmiar plykow: %total_size% bajtow
echo ==========================================================================
echo Najwiyksze plyki w katalogu:
dir "%folder%" /a:-d /s /o:-s | findstr /V "katalog" | more
echo ==========================================================================
pause
goto menu

:create_zip
cls
echo ==========================================================================
echo                   TWORZENIE ARCHIWUM ZIP
echo ==========================================================================
set /p source=Podoj sciezka do plykow abo katalogu do spakowania: 

if not exist "%source%" (
    echo Podany plyk abo katalog niy istoje! Sprawdz sciezka i sproboj ponownie.
    pause
    goto menu
)

set /p zipname=Podoj nazwa plyku ZIP (np. archiwum.zip): 
if exist "%zipname%" (
    echo Plyk %zipname% juz istoje! Wybiyrz inno nazwa.
    pause
    goto create_zip
)

echo Tworza archiwum ZIP...
powershell Compress-Archive -Path "%source%" -DestinationPath "%zipname%"
if %errorlevel%==0 (
    echo Archiwum ZIP zostalo stworzone: %zipname%
    call :log_action "Stworzono archiwum ZIP: %zipname% ze zrodla %source% (Data: %date% Godzina: %time%)"
) else (
    echo Wystompol blad przi tworzeniu archiwum ZIP.
)
pause
goto menu

:create_new_file
cls
set /p newfile=Podoj nazwa nowego plyku (np. nowy.txt): 
set /p folder=Podoj sciezka katalogu, kaj zapisac plyk (np. C:\Dokumenty): 

:: Sprawdzynie, czy katalog istoje
if not exist "%folder%" (
    echo Podany katalog niy istoje! Sproboj ponownie.
    pause
    goto create_new_file
)

echo Wpisz swoj tekst ponizej. Aby zapisac i wyjsc, wpisz ,,ZAPISZ'' w nowyj liniji.
echo ==========================================================================
:write_new
set /p line=
if /i "%line%"=="ZAPISZ" goto save_new_file
echo %line% >> "%folder%\%newfile%"
goto write_new

:save_new_file
echo Plyk zostol zapisany w lokalizacyji: %folder%\%newfile%.
pause
goto menu

:view_txt_files
cls
echo ==========================================================================
echo                 PRZEGLONDA PLYKOW TEKSTOWYCH (.TXT)
echo ==========================================================================
echo Dostympne plyki tekstowe w aktualnym katalogu:
dir *.txt /b
echo ==========================================================================
set /p txtfile=Podoj nazwa plyku do przeglondanio (lub wpisz 'menu', coby wrocic): 

if /i "%txtfile%"=="menu" goto menu
if not exist "%txtfile%" (
    echo Podany plyk niy istoje! Sproboj ponownie.
    pause
    goto view_txt_files
)

echo ==========================================================================
echo ZAWARTOSC PLYKU: %txtfile%
echo ==========================================================================
type "%txtfile%"
echo ==========================================================================
echo Nacisnij jaki kolwiek klawisz, coby wrocic do menu glownego.
pause
goto menu


